# Associated Partners Website

Official static website for [Associated Partners](https://assocpartners.com), hosted on GitHub Pages.

## Stack

- HTML, CSS, and minimal JavaScript
- GitHub Pages
- Custom domain: `assocpartners.com`
- GitHub Actions for validation

No React, CMS, or build toolchain. Design structure is inspired by [HTML5 UP Spectral](https://html5up.net/spectral) (Creative Commons Attribution), heavily simplified for a restrained business landing page.

## Local development

```bash
git clone https://github.com/Associated-Partners/associated-partners.github.io.git
cd associated-partners.github.io
python3 -m http.server 8000
```

Open [http://localhost:8000](http://localhost:8000).

## Site sections

Single-page layout:

1. Home (hero)
2. About
3. Services
4. Contact / Coming Soon

## Deployment

1. Push to `main`
2. GitHub Pages publishes from `main` / root
3. Preview at `https://associated-partners.github.io`
4. After DNS cutover, production is `https://assocpartners.com`

### Domain cutover checklist

See **[DNS.md](DNS.md)** for the exact GoDaddy record changes.

Preview first: https://associated-partners.github.io/

1. [x] Build and push website
2. [x] Enable GitHub Pages (`main` / `/`)
3. [x] Test `https://associated-partners.github.io`
4. [x] Set custom domain `assocpartners.com` (CNAME + Pages settings)
5. [ ] Update GoDaddy apex A records → GitHub Pages IPs
6. [ ] Update GoDaddy `www` CNAME → `associated-partners.github.io`
7. [ ] Wait for GitHub DNS verification
8. [ ] Enforce HTTPS
9. [ ] Verify `https://assocpartners.com` and `https://www.assocpartners.com`

Preserve existing **MX / mail TXT** records during the website cutover. Live mail is currently Microsoft 365 / Outlook, not Google Workspace — details in `DNS.md` and `ARCHITECTURE.md`.

## Validation

See **[TESTS.md](TESTS.md)** for the full checklist.

```bash
./scripts/verify-local.sh
./scripts/verify-live.sh
./scripts/verify-live.sh --require-https   # after custom TLS cert is ready
```

Manually verify these widths before calling the site finished:

`320`, `375`, `768`, `1024`, `1440`, `1920`

## License

Site code is MIT. Spectral design inspiration remains attributed to HTML5 UP.

## Architecture

See **[ARCHITECTURE.md](ARCHITECTURE.md)** for the three-layer model (website / email / private assistant).

## GitHub accounts

Both accounts can edit this repository:

- `jholomorphic` — organization admin
- `invasivejet` — repository admin collaborator

Switch with:

```bash
gh auth switch --user jholomorphic
# or
gh auth switch --user invasivejet
```

To push GitHub Actions workflow files, the active account needs the `workflow` OAuth scope:

```bash
gh auth refresh -h github.com -s workflow
```
