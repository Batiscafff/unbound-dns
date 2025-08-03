# Docker image unbound-dns
DNS server on unbound with logging and Promtail and Loki installed.
## Functionality
- DNS name resolution
- Logging of resolved domain names
- Sending logs to Loki (on port 3100)
## Security
- DNS over TLS (DoT) when using a DNS server as a forwarder
- DNSSEC in any case
## Example usage
### Custom build
```bash
git clone git@github.com:Batiscafff/unbound-dns.git
docker compose up -d unbound-dns
```
### Pulling from DockerHub
Minimal docker-compose.yml:
```yaml
---
services:
  unbound-dns:
    image: 0legch/image-unbound-dns
    ports:
      - "3100:3100"
      - "5335:53/tcp"
      - "5335:53/udp"
```
## Notes
- The container must be periodically rebuilt (approximately once a week to renew certificates).
- Name of Loki job - `unbound-dns`
