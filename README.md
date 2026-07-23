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

Do **not** change DNS until the GitHub Pages preview looks correct.

1. Build and test locally
2. Push to GitHub
3. Enable GitHub Pages (`main` / `/`)
4. Test `https://associated-partners.github.io`
5. Confirm custom domain in Pages settings (`assocpartners.com`)
6. Update DNS apex + `www` records for GitHub Pages
7. Wait for DNS verification
8. Enable HTTPS
9. Verify `assocpartners.com` and `www.assocpartners.com`

Preserve Google Workspace **MX records** when editing DNS. Website and email use different DNS record types and can coexist.

## Validation

Pull requests and pushes to `main` run:

- HTML validation (`html-validate`)
- Broken-link check (`lychee`)

Manually verify these widths before merge:

`320`, `375`, `768`, `1024`, `1440`, `1920`

## License

Site code is MIT. Spectral design inspiration remains attributed to HTML5 UP.

## Custom domain (deferred)

`CNAME.example` contains `assocpartners.com`. Keep it as `.example` until the GitHub Pages preview is verified.

When ready for DNS cutover:

```bash
mv CNAME.example CNAME
git add CNAME
git commit -m "Enable assocpartners.com custom domain"
git push
```

Then update DNS apex/`www` records for GitHub Pages **without removing Google Workspace MX records**.

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
