const dns = require('node:dns').promises;

const STRATEGIES = ['round-robin', 'least-connections', 'weighted'];

function freshReplica(address) {
  return {
    address,
    healthy: true,
    weight: 1,
    currentWeight: 0,
    inflight: 0,
    served: 0,
    failures: 0,
  };
}

class LoadBalancer {
  constructor(services, options = {}) {
    this.strategy = 'round-robin';
    this.refreshMs = options.refreshMs ?? 5000;
    this.healthTimeoutMs = options.healthTimeoutMs ?? 2000;
    this.pools = new Map();
    this.timer = null;
    this.setStrategy(options.strategy || 'round-robin');

    for (const [name, baseUrl] of Object.entries(services)) {
      const url = new URL(baseUrl);
      this.pools.set(name, {
        name,
        protocol: url.protocol,
        hostname: url.hostname,
        port: url.port,
        replicas: [],
        cursor: 0,
      });
    }
  }

  start() {
    const tick = () => {
      this.refreshAll().catch((error) => {
        console.error(JSON.stringify({ level: 'error', message: 'replica refresh failed', detail: error.message }));
      });
    };
    this.timer = setInterval(tick, this.refreshMs);
    if (typeof this.timer.unref === 'function') this.timer.unref();
  }

  stop() {
    if (this.timer) clearInterval(this.timer);
  }

  setStrategy(strategy) {
    if (!STRATEGIES.includes(strategy)) {
      throw new Error(`Unknown strategy "${strategy}". Use ${STRATEGIES.join(', ')}`);
    }
    this.strategy = strategy;
  }

  setWeights(items) {
    const pending = items.map((item) => {
      if (!item || typeof item.service !== 'string' || typeof item.address !== 'string') {
        throw new Error('Each weight needs service and address');
      }
      const pool = this.pools.get(item.service);
      if (!pool) throw new Error(`Unknown service: ${item.service}`);
      const replica = pool.replicas.find((candidate) => candidate.address === item.address);
      if (!replica) throw new Error(`Unknown replica ${item.address} for ${item.service}`);
      const weight = Number(item.weight);
      if (!Number.isInteger(weight) || weight < 0 || weight > 100) {
        throw new Error('Weight must be an integer from 0 to 100');
      }
      return { replica, weight };
    });
    for (const { replica, weight } of pending) {
      replica.weight = weight;
      replica.currentWeight = 0;
    }
  }

  replicaUrl(pool, replica) {
    return `${pool.protocol}//${replica.address}:${pool.port}`;
  }

  snapshot() {
    const services = {};
    for (const [name, pool] of this.pools) {
      const served = pool.replicas.reduce((sum, replica) => sum + replica.served, 0);
      services[name] = {
        hostname: pool.hostname,
        port: Number(pool.port),
        healthy: pool.replicas.filter((replica) => replica.healthy && replica.weight > 0).length,
        replicas: pool.replicas.map((replica) => ({
          address: replica.address,
          url: this.replicaUrl(pool, replica),
          healthy: replica.healthy,
          weight: replica.weight,
          inflight: replica.inflight,
          served: replica.served,
          share: served ? Number((replica.served / served).toFixed(3)) : 0,
          failures: replica.failures,
        })),
      };
    }
    return { strategy: this.strategy, strategies: STRATEGIES, services };
  }

  async refreshAll() {
    await Promise.all([...this.pools.values()].map((pool) => this.refreshPool(pool)));
  }

  async refreshPool(pool) {
    const addresses = await this.discover(pool);
    if (!addresses.length) return;

    const previous = new Map(pool.replicas.map((replica) => [replica.address, replica]));
    const before = new Set(previous.keys());
    const next = addresses.map((address) => previous.get(address) || freshReplica(address));
    await Promise.all(next.map((replica) => this.checkReplica(pool, replica)));
    pool.replicas = next;

    const changed = addresses.length !== before.size || addresses.some((address) => !before.has(address));
    if (changed) {
      console.log(JSON.stringify({
        level: 'info',
        service: pool.name,
        replicas: next.length,
        healthy: next.filter((replica) => replica.healthy).length,
      }));
    }
  }

  async discover(pool) {
    try {
      return [...new Set(await dns.resolve4(pool.hostname))];
    } catch (error) {
      try {
        const records = await dns.lookup(pool.hostname, { all: true, family: 4 });
        return [...new Set(records.map((record) => record.address))];
      } catch (lookupError) {
        console.error(JSON.stringify({
          level: 'error',
          service: pool.name,
          message: 'dns lookup failed',
          detail: lookupError.message || error.message,
        }));
        return [];
      }
    }
  }

  async checkReplica(pool, replica) {
    const controller = new AbortController();
    const timeout = setTimeout(() => controller.abort(), this.healthTimeoutMs);
    try {
      const response = await fetch(`${this.replicaUrl(pool, replica)}/health`, { signal: controller.signal });
      replica.healthy = response.ok;
    } catch {
      replica.healthy = false;
    } finally {
      clearTimeout(timeout);
    }
  }

  acquire(serviceName, exclude = new Set()) {
    const pool = this.pools.get(serviceName);
    if (!pool) return null;
    const replica = this.pick(pool, exclude);
    if (!replica) return null;
    replica.inflight += 1;
    let released = false;
    return {
      address: replica.address,
      baseUrl: this.replicaUrl(pool, replica),
      release: (result) => {
        if (released) return;
        released = true;
        replica.inflight = Math.max(0, replica.inflight - 1);
        if (result === 'ok') replica.served += 1;
        if (result === 'down') {
          replica.failures += 1;
          replica.healthy = false;
        }
      },
    };
  }

  pick(pool, exclude) {
    const usable = pool.replicas.filter((replica) => replica.healthy && replica.weight > 0 && !exclude.has(replica.address));
    if (!usable.length) return null;

    if (this.strategy === 'least-connections') {
      const min = Math.min(...usable.map((replica) => replica.inflight));
      const tied = usable.filter((replica) => replica.inflight === min);
      const chosen = tied[pool.cursor % tied.length];
      pool.cursor += 1;
      return chosen;
    }

    if (this.strategy === 'weighted') {
      let best = usable[0];
      let total = 0;
      for (const replica of usable) {
        replica.currentWeight += replica.weight;
        total += replica.weight;
        if (replica.currentWeight > best.currentWeight) best = replica;
      }
      best.currentWeight -= total;
      return best;
    }

    const chosen = usable[pool.cursor % usable.length];
    pool.cursor += 1;
    return chosen;
  }
}

module.exports = { LoadBalancer, STRATEGIES };
