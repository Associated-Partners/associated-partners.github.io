# Domain & DNS cutover — Phase B

This document is the source of truth for pointing `assocpartners.com` at GitHub Pages **without breaking email**.

## Current state (captured 2026-07-22)

| Item | Current value | Notes |
| --- | --- | --- |
| Registrar / DNS | GoDaddy (`ns31/ns32.domaincontrol.com`) | Website Builder / DPS currently serving the site |
| Apex A | `13.248.243.5`, `76.223.105.230` | GoDaddy hosting — replace with GitHub Pages |
| `www` | CNAME → `assocpartners.com` | Keep as CNAME, retarget to GitHub |
| MX | `assocpartners-com.mail.protection.outlook.com` | **Microsoft 365 / Outlook today** |
| TXT | `NETORGFT20954118.onmicrosoft.com`, SPF `include:secureserver.net` | Leave mail-related TXT alone during web cutover |
| GitHub Pages preview | https://associated-partners.github.io/ | Verified working |
| Custom domain in repo | `CNAME` → `assocpartners.com` | Enabled in Phase B |

> Important: the earlier plan assumed Google Workspace MX records. Live DNS currently uses **Outlook / Microsoft 365**. Do not delete those MX records during the website cutover. Phase C (business email identity) should decide whether to keep Microsoft 365 or migrate to Google Workspace.

## Target architecture

```text
assocpartners.com
│
├── A / AAAA (apex) ─────────► GitHub Pages
├── www CNAME ───────────────► associated-partners.github.io
├── MX ──────────────────────► current mail provider (Outlook today)
└── TXT ─────────────────────► verification / SPF / DKIM (mail + GitHub)
```

Website and email use different DNS record types and can coexist.

## Exact DNS changes in GoDaddy

GoDaddy → Domain → assocpartners.com → DNS.

### 1. Apex A records (replace website hosting IPs)

Delete the existing apex `A` records that point to:

- `13.248.243.5`
- `76.223.105.230`

Add these four apex `A` records ([GitHub Docs](https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/managing-a-custom-domain-for-your-github-pages-site)):

| Type | Name | Value | TTL |
| --- | --- | --- | --- |
| A | `@` | `185.199.108.153` | 600 (or default) |
| A | `@` | `185.199.109.153` | 600 |
| A | `@` | `185.199.110.153` | 600 |
| A | `@` | `185.199.111.153` | 600 |

Optional IPv6 (`AAAA`):

| Type | Name | Value |
| --- | --- | --- |
| AAAA | `@` | `2606:50c0:8000::153` |
| AAAA | `@` | `2606:50c0:8001::153` |
| AAAA | `@` | `2606:50c0:8002::153` |
| AAAA | `@` | `2606:50c0:8003::153` |

### 2. `www` CNAME

Set:

| Type | Name | Value |
| --- | --- | --- |
| CNAME | `www` | `associated-partners.github.io` |

Do **not** point `www` at the apex domain once GitHub is the publisher; point it at the org Pages host as above.

### 3. Do not touch during web cutover

Leave these alone:

- All `MX` records (Outlook / Microsoft 365)
- Microsoft 365 verification TXT (`NETORGFT…onmicrosoft.com`)
- Existing SPF / DKIM / DMARC records related to mail

If GoDaddy Website Builder also created forwarding or “domain forward” rules for the apex, disable website forwarding so DNS A records control the site.

## GitHub side checklist

1. [x] Site live at https://associated-partners.github.io/
2. [x] `CNAME` file contains `assocpartners.com`
3. [x] Pages custom domain set to `assocpartners.com`
4. [ ] GoDaddy apex A records updated
5. [ ] GoDaddy `www` CNAME updated
6. [ ] GitHub DNS check passes (Pages settings)
7. [ ] Enforce HTTPS enabled
8. [ ] Verify https://assocpartners.com
9. [ ] Verify https://www.assocpartners.com
10. [ ] Org domain verification TXT added in GitHub (recommended)

### Enforce HTTPS

After DNS propagates and GitHub shows the domain as verified:

Repository → Settings → Pages → **Enforce HTTPS**

### Org domain verification (recommended)

In the GitHub organization settings, verify `assocpartners.com` with the TXT record GitHub provides. This helps prevent custom-domain takeover. See [Verifying your custom domain for GitHub Pages](https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/verifying-your-custom-domain-for-github-pages).

## Verification commands

After DNS changes:

```bash
dig +short assocpartners.com A
# expect the four 185.199.10x.153 addresses

dig +short www.assocpartners.com CNAME
# expect associated-partners.github.io.

curl -sI https://assocpartners.com | head
curl -sI https://www.assocpartners.com | head
curl -s https://assocpartners.com | rg -n "Bringing people together"
```

Confirm mail still works (send a test to an existing Outlook mailbox) before changing any MX / SPF records in Phase C.

## Rollback

If the GitHub site has a problem, restore the previous apex A records:

- `13.248.243.5`
- `76.223.105.230`

Or re-enable GoDaddy Website Builder hosting. MX records should still be untouched.
