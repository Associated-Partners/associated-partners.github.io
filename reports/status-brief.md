# Associated Partners — Status Brief

**Date:** 2026-07-22  
**Org:** [Associated-Partners](https://github.com/Associated-Partners)  
**Domain:** [assocpartners.com](https://assocpartners.com)  
**Audience:** Melanie + technical operators

This brief mirrors the slide deck in `slides/associated-partners-status.tex`.

---

## 1. Goal

Make Associated Partners look legitimate and professional online, keep email working, and prepare a small private assistant that can help Melanie handle event inquiries — without overbuilding.

Architecture (three separate layers):

```text
assocpartners.com
        │
        ├── Website ──────────► GitHub Pages (public)
        ├── Email / Calendar ─► Microsoft 365 today (Phase C decision)
        └── Automation API ───► operations-assistant (private)
```

---

## 2. What has been accomplished

### Phase A — Public website

| Item | Status |
| --- | --- |
| GitHub org `Associated-Partners` | Done |
| Public repo `associated-partners.github.io` | Done |
| Single-page site (Home / About / Services / Contact) | Done |
| Spectral-inspired restrained design | Done |
| Local preview workflow | Done |
| Multi-account access (`jholomorphic`, `invasivejet`) | Done |

Live preview / production host:

- https://associated-partners.github.io/ (redirects to custom domain)
- http://assocpartners.com/ serving GitHub Pages content

### Phase B — Custom domain (mostly done)

| Item | Status |
| --- | --- |
| `CNAME` → `assocpartners.com` | Done |
| Apex A records → GitHub Pages IPs | Done |
| `www` CNAME → `associated-partners.github.io` | Done |
| Site content cutover off GoDaddy Website Builder | Done |
| MX preserved (Outlook / Microsoft 365) | Done |
| Custom HTTPS certificate for `assocpartners.com` | Pending (GitHub still provisioning) |
| Enforce HTTPS in Pages settings | Blocked until cert exists |

Verified GitHub Pages A records:

```text
185.199.108.153
185.199.109.153
185.199.110.153
185.199.111.153
```

### Verification tooling

| Item | Status |
| --- | --- |
| `scripts/verify-local.sh` | Done |
| `scripts/verify-live.sh` | Done |
| `TESTS.md` checklist | Done |
| GitHub Actions workflow file prepared locally | Waiting on `workflow` OAuth scope to push |

### Phase D — Operations assistant (scaffold)

| Item | Status |
| --- | --- |
| Private repo `operations-assistant` | Done |
| Local checkout in Cursor workspace | Done |
| FastAPI skeleton with `/health` | Done |
| Mail draft vs send separation | Done |
| Calendar propose vs create separation | Done |
| Unit tests (4 passing) | Done |
| Real OAuth / live send | Not started |

Workspace layout:

```text
assoc-partners/
├── assoc-partners.code-workspace
├── …website…
├── operations-assistant/     (private repo; gitignored from Pages)
└── reports/                  (this folder)
```

---

## 3. What still needs to be accomplished

### Finish Phase B (domain)

1. Wait for GitHub to issue the custom TLS certificate for `assocpartners.com`
2. Enable **Enforce HTTPS**
3. Confirm:
   - `https://assocpartners.com`
   - `https://www.assocpartners.com`
4. Re-run: `./scripts/verify-live.sh --require-https`
5. Optional: verify the domain at the GitHub org level (TXT record) to reduce takeover risk

### Phase C — Business identity / email

1. Decide Microsoft 365 vs Google Workspace (see §4)
2. Ensure `melanie@assocpartners.com` is the primary working mailbox
3. Create aliases (can all route to Melanie initially):
   - `info@assocpartners.com`
   - `events@assocpartners.com`
   - `contact@assocpartners.com`
4. Confirm SPF / DKIM / DMARC for the chosen provider
5. Test external send/receive

### Phase D — First useful automation

1. Wire OAuth for Melanie’s account only (no domain-wide delegation)
2. Connect inbox inquiry classification
3. Draft reply + calendar proposal
4. Require Melanie approval before send / create
5. Later: host API privately (Railway / Render / Cloud Run), optionally `api.assocpartners.com`

### Explicit non-goals (for now)

- No CRM
- No events database / booking system
- No CMS / React / Next.js for the public site
- No autonomous email sending
- No secrets in the public website repository

---

## 4. Outstanding decisions

These block the next meaningful build:

### Decision 1 — Mail platform

**Current DNS reality:** MX points to Outlook / Microsoft 365:

```text
assocpartners-com.mail.protection.outlook.com
```

| Option | Implication |
| --- | --- |
| **A. Keep Microsoft 365** | Use Graph API for mail/calendar; faster path if Melanie already uses Outlook |
| **B. Migrate to Google Workspace** | Matches original plan; requires careful MX / SPF / DKIM cutover |

**Recommendation:** decide before writing OAuth code. Website DNS and mail DNS are independent either way.

### Decision 2 — Public contact address on the website

Website currently shows `info@assocpartners.com`. Confirm whether public CTA should be:

- `info@`
- `events@`
- both

### Decision 3 — Melanie admin ownership

Confirm Melanie has admin access to:

- GoDaddy / DNS
- Mail tenant (Microsoft 365 or Google Workspace)
- GitHub org / repos

### Decision 4 — When to expose `api.assocpartners.com`

Not required for local assistant development. Defer until OAuth + approval flow works locally.

---

## 5. Recommended next sequence

```text
1. Finish HTTPS on assocpartners.com
2. Decide mail provider (M365 vs Google)
3. Stand up melanie@ + aliases
4. Wire operations-assistant OAuth
5. Ship inquiry → draft → approve → send
```

Immediate milestone:

> `assocpartners.com` live with HTTPS  
> \+ Melanie mailbox operational  
> \+ event inquiry → draft response + scheduling proposal (human-approved)

---

## 6. Quick commands

```bash
# Website checks
cd /home/joelasaucedo/Development/assoc-partners
./scripts/verify-local.sh
./scripts/verify-live.sh
./scripts/verify-live.sh --require-https

# Assistant tests
cd operations-assistant
source .venv/bin/activate
PYTEST_DISABLE_PLUGIN_AUTOLOAD=1 python -m pytest -q
```

---

## 7. Related docs

| Doc | Location |
| --- | --- |
| Architecture | `../ARCHITECTURE.md` |
| DNS cutover | `../DNS.md` |
| Test checklist | `../TESTS.md` |
| Slides (LaTeX) | `slides/associated-partners-status.tex` |
| Website README | `../README.md` |
| Assistant README | `../operations-assistant/README.md` |
