# Tests to run while DNS / HTTPS finishes propagating

## Quick local suite (run anytime)

```bash
# Website static checks
cd ~/Development/assoc-partners
./scripts/verify-local.sh

# Live DNS + hosting checks (HTTPS warnings OK until cert issues)
./scripts/verify-live.sh

# Strict HTTPS gate (use after GitHub cert is ready)
./scripts/verify-live.sh --require-https

# Operations assistant API tests
cd ~/Development/operations-assistant
source .venv/bin/activate
PYTEST_DISABLE_PLUGIN_AUTOLOAD=1 python -m pytest -q
```

## Pass criteria

### Website / domain
- [x] Apex A → GitHub Pages IPs
- [ ] `www` CNAME → `associated-partners.github.io` everywhere (may still be propagating)
- [x] Site content is Associated Partners GitHub Pages site
- [x] MX still points at Outlook
- [ ] TLS cert is for `assocpartners.com` (not `*.github.io`)
- [ ] Enforce HTTPS enabled in GitHub Pages settings
- [ ] `https://assocpartners.com` and `https://www.assocpartners.com` verify cleanly

### Operations assistant
- [x] `/health`
- [x] inquiry → draft → approved send flow (stub)
- [x] calendar propose → approved create flow (stub)
- [ ] Real OAuth to Microsoft 365 **or** Google Workspace

## Next build after HTTPS is green

1. Enforce HTTPS in GitHub Pages
2. Decide mail provider (Outlook keep vs Google migrate)
3. Wire OAuth into `operations-assistant`
4. Connect first real inquiry workflow with Melanie approval
