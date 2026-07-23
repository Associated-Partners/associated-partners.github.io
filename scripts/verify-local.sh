#!/usr/bin/env bash
# Offline static checks for the website repo.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

echo "== Local static checks =="

test -f index.html
test -f assets/css/main.css
test -f assets/js/main.js
test -f assets/images/hero.jpg
test -f CNAME
test -f .nojekyll

grep -qx 'assocpartners.com' CNAME
rg -q 'Bringing people together' index.html
rg -q 'mailto:info@assocpartners.com' index.html
rg -q 'id="about"' index.html
rg -q 'id="services"' index.html
rg -q 'id="contact"' index.html
rg -q 'box-sizing:\s*border-box' assets/css/main.css

# Fragment targets referenced by nav must exist
for id in about services contact top; do
  rg -q "id=\"$id\"" index.html
done

# No obvious broken local asset refs
for path in $(rg -o 'assets/[^"'\'' ]+' index.html | sort -u); do
  test -f "$path" || { echo "Missing asset: $path"; exit 1; }
done

if command -v npx >/dev/null 2>&1; then
  npx --yes html-validate@9 index.html
  echo "PASS  html-validate"
else
  echo "WARN  npx unavailable; skipped html-validate"
fi

echo "PASS  local static checks"
