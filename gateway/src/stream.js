const http = require('node:http');

const HOP_BY_HOP = new Set(['connection', 'keep-alive', 'transfer-encoding', 'proxy-connection']);

function proxyStream(balancer, serviceName, req, res, pathPrefix, timeoutMs) {
  const requestId = req.get('x-request-id') || require('node:crypto').randomUUID();
  res.set('x-request-id', requestId);
  const target = balancer.acquire(serviceName);
  if (!target) {
    return res.status(503).json({ error: 'No healthy replicas', service: serviceName, requestId });
  }

  const incomingPath = req.originalUrl.slice(pathPrefix.length) || '/';
  const url = new URL(incomingPath, `${target.baseUrl}/`);
  const headers = { ...req.headers };
  for (const name of HOP_BY_HOP) delete headers[name];
  headers['x-request-id'] = requestId;
  headers['x-forwarded-host'] = req.get('host') || 'unknown';
  headers['x-forwarded-proto'] = req.protocol;
  headers.host = url.host;

  let settled = false;
  let timedOut = false;
  const finish = (result) => {
    if (settled) return;
    settled = true;
    target.release(result);
  };

  const proxyReq = http.request({
    hostname: url.hostname,
    port: url.port,
    method: req.method,
    path: `${url.pathname}${url.search}`,
    headers,
    timeout: timeoutMs,
  }, (proxyRes) => {
    finish('ok');
    res.status(proxyRes.statusCode || 502);
    for (const [name, value] of Object.entries(proxyRes.headers)) {
      if (value === undefined || HOP_BY_HOP.has(name.toLowerCase())) continue;
      res.setHeader(name, value);
    }
    res.setHeader('x-upstream-replica', target.address);
    proxyRes.pipe(res);
  });

  const fail = (error) => {
    finish(timedOut ? 'timeout' : 'down');
    console.error(JSON.stringify({
      level: 'error',
      requestId,
      serviceName,
      replica: target.address,
      message: error.message,
    }));
    if (res.headersSent) {
      res.end();
      return;
    }
    const status = timedOut ? 504 : 502;
    res.status(status).json({
      error: timedOut ? 'Upstream timeout' : 'Bad gateway',
      service: serviceName,
      requestId,
    });
  };

  proxyReq.on('timeout', () => {
    timedOut = true;
    proxyReq.destroy(new Error('Upstream timeout'));
  });
  proxyReq.on('error', fail);
  req.on('aborted', () => proxyReq.destroy());
  req.pipe(proxyReq);
}

function proxyUpgrade(balancer, serviceName, req, socket) {
  const requestUrl = req.url || '/';
  if (!requestUrl.startsWith('/socket.io')) {
    socket.destroy();
    return;
  }

  const target = balancer.acquire(serviceName);
  if (!target) {
    socket.write('HTTP/1.1 503 Service Unavailable\r\nConnection: close\r\n\r\n');
    socket.destroy();
    return;
  }

  const upstream = new URL(target.baseUrl);
  const headers = { ...req.headers, host: upstream.host };
  const proxyReq = http.request({
    hostname: upstream.hostname,
    port: upstream.port,
    method: req.method || 'GET',
    path: requestUrl,
    headers,
  });

  proxyReq.on('upgrade', (proxyRes, proxySocket, proxyHead) => {
    target.release('ok');
    const lines = [`HTTP/1.1 ${proxyRes.statusCode} ${proxyRes.statusMessage || 'Switching Protocols'}`];
    for (const [name, value] of Object.entries(proxyRes.headers)) {
      if (Array.isArray(value)) {
        for (const item of value) lines.push(`${name}: ${item}`);
      } else if (value !== undefined) {
        lines.push(`${name}: ${value}`);
      }
    }
    socket.write(`${lines.join('\r\n')}\r\n\r\n`);
    if (proxyHead && proxyHead.length) socket.write(proxyHead);
    proxySocket.pipe(socket);
    socket.pipe(proxySocket);
    proxySocket.on('error', () => socket.destroy());
    socket.on('error', () => proxySocket.destroy());
  });

  proxyReq.on('error', (error) => {
    target.release('down');
    console.error(JSON.stringify({
      level: 'error',
      serviceName,
      replica: target.address,
      message: error.message,
    }));
    socket.destroy();
  });
  proxyReq.end();
}

module.exports = { proxyStream, proxyUpgrade };
