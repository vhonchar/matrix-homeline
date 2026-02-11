# SSL (Let's Encrypt) + Porkbun DDNS

This stack can automatically issue and renew TLS certificates using Porkbun DNS
and keep your A/AAAA records updated with your current IP address.

## 1) Create Porkbun API keys

Create an API key pair in Porkbun (Account → API Access). You will need both the
API key and the secret API key.

## 2) Configure environment variables

Create a `.env` file next to `docker-compose.yaml` with the following values:

```
# Primary/root domain and the Matrix FQDN to secure.
MATRIX_DOMAIN=example.com
MATRIX_FQDN=matrix.example.com

# Comma-separated list of DNS records to keep updated.
DDNS_DOMAINS=matrix.example.com
```

## 3) Configure secrets in GitHub

Create secrets in GitHub

```
# Let's Encrypt registration email.
ACME_EMAIL=you@example.com

# Porkbun API credentials used by both ACME and DDNS.
PORKBUN_API_KEY=pk1_...
PORKBUN_SECRET_API_KEY=sk1_...
```

## 4) Bring the stack up

```
docker compose up -d
```

The `matrix-acme` container will:
1) Register the ACME account (if needed).
2) Issue a certificate via the Porkbun DNS challenge.
3) Install the certificate in `./nginx/ssl`.
4) Renew and reload Nginx automatically via a Docker HUP signal.

The `matrix-ddns-updater` container will periodically update your Porkbun DNS
records so your domain always points at the current IP.

## Notes

- The ACME service uses the DNS-01 challenge, so your HTTP port does not need to
  be reachable for certificate issuance.
- If you change domains, update the `.env` file and restart the stack.
