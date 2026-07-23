# Associated Partners — system architecture

Three deliberately separate layers:

```text
assocpartners.com
        │
        ├── Website ──────────► GitHub Pages (public)
        ├── Email / Calendar ─► Workspace provider (private business identity)
        └── Automation API ───► operations-assistant (private backend)
```

Do **not** put email/calendar orchestration inside the public GitHub Pages site.

## Repositories

```text
Associated-Partners/
├── associated-partners.github.io   # public website
└── operations-assistant            # private Gmail/Calendar assistant (Phase D)
```

## Current progress

| Phase | Status | Notes |
| --- | --- | --- |
| A — Website on GitHub Pages | Done | https://associated-partners.github.io/ |
| B — Custom domain + HTTPS | In progress | See `DNS.md` |
| C — Melanie business identity | Blocked on decision | DNS currently uses **Microsoft 365 / Outlook**, not Google Workspace |
| D — Operations assistant | Not started | Human-in-the-loop Gmail + Calendar only |

## Phase C decision required

Live MX:

```text
assocpartners-com.mail.protection.outlook.com
```

Choose one before building aliases / assistant OAuth:

1. **Keep Microsoft 365** and use `melanie@assocpartners.com` there, or
2. **Migrate to Google Workspace** as originally planned, then move MX / SPF / DKIM carefully.

Either way, website DNS (A / CNAME) and mail DNS (MX / SPF / DKIM) stay independent.

## Phase D target (later)

Private service with human approval:

```text
GET  /health
GET  /mail/inbox
GET  /mail/inquiries
POST /mail/draft
POST /mail/send          # approval required
GET  /calendar/availability
GET  /calendar/upcoming
POST /calendar/propose
POST /calendar/create    # approval required
```

No domain-wide delegation initially. No secrets in the public website repo.
