const express = require('express');
const { LoadBalancer } = require('./balancer');
const { proxyStream, proxyUpgrade } = require('./stream');

const app = express();
const PORT = Number(process.env.PORT || 8080);
const PROPULSE_TIMEOUT_MS = Number(process.env.PROPULSE_TIMEOUT_MS || 120000);
const SERVICES = {
  propulse: process.env.PROPULSE_URL || 'http://propulse:3001',
  streamapi: process.env.STREAMAPI_URL || 'http://streamapi:3010',
};
const balancer = new LoadBalancer(SERVICES, {
  strategy: process.env.LB_STRATEGY || 'round-robin',
  refreshMs: Number(process.env.REPLICA_REFRESH_MS || 5000),
});

const proxyReelsRead = (req, res) => proxyStream(balancer, 'streamapi', req, res, '/api/propulse', PROPULSE_TIMEOUT_MS);
app.get('/api/stream/health', (req, res) => proxyStream(balancer, 'streamapi', req, res, '/api/stream', PROPULSE_TIMEOUT_MS));
app.get('/api/propulse/reels', proxyReelsRead);
app.get('/api/propulse/reels/:id', proxyReelsRead);
app.use('/api/propulse', (req, res) => proxyStream(balancer, 'propulse', req, res, '/api/propulse', PROPULSE_TIMEOUT_MS));
app.use('/socket.io', (req, res) => proxyStream(balancer, 'propulse', req, res, '', PROPULSE_TIMEOUT_MS));
app.use(express.json({ limit: '1mb' }));

app.get('/health', (_req, res) => res.json({ status: 'UP', service: 'api-gateway' }));

app.get('/routes', (_req, res) => {
  const balance = balancer.snapshot();
  const replicas = {};
  for (const [name, info] of Object.entries(balance.services)) replicas[name] = info.replicas.length;
  res.json({
    routes: {
      'GET /api/stream/health': SERVICES.streamapi,
      'GET /api/propulse/reels': SERVICES.streamapi,
      'GET /api/propulse/reels/:id': SERVICES.streamapi,
      '/api/propulse/*': SERVICES.propulse,
      '/socket.io/*': SERVICES.propulse,
    },
    discovery: 'Docker DNS',
    strategy: balance.strategy,
    replicas,
  });
});

app.get('/balance', (_req, res) => res.json(balancer.snapshot()));

app.put('/balance', (req, res) => {
  try {
    const body = req.body ?? {};
    if (body.strategy === undefined && body.weights === undefined) {
      throw new Error('Provide strategy and/or weights');
    }
    if (body.strategy !== undefined) balancer.setStrategy(body.strategy);
    if (body.weights !== undefined) {
      if (!Array.isArray(body.weights)) throw new Error('weights must be an array');
      balancer.setWeights(body.weights);
    }
    console.log(JSON.stringify({ level: 'info', message: 'balance updated', strategy: balancer.strategy }));
    res.json(balancer.snapshot());
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

app.use((_req, res) => res.status(404).json({ error: 'Route not found' }));

async function main() {
  try {
    await balancer.refreshAll();
  } catch (error) {
    console.error(JSON.stringify({ level: 'error', message: 'initial replica discovery failed', detail: error.message }));
  }
  balancer.start();
  const server = app.listen(PORT, '0.0.0.0', () => {
    console.log(JSON.stringify({ message: 'API Gateway listening', port: PORT, strategy: balancer.strategy }));
  });
  server.on('upgrade', (req, socket) => proxyUpgrade(balancer, 'propulse', req, socket));
}

main();
