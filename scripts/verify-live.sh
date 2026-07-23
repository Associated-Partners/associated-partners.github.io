#!/usr/bin/env bash
# Live readiness checks for Associated Partners website + DNS.
# Usage:
#   ./scripts/verify-live.sh
#   ./scripts/verify-live.sh --require-https

set -euo pipefail

REQUIRE_HTTPS=0
if [[ "${1:-}" == "--require-https" ]]; then
  REQUIRE_HTTPS=1
fi

PASS=0
FAIL=0
WARN=0

ok() { echo "PASS  $*"; PASS=$((PASS + 1)); }
bad() { echo "FAIL  $*"; FAIL=$((FAIL + 1)); }
warn() { echo "WARN  $*"; WARN=$((WARN + 1)); }

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || { echo "Missing required command: $1"; exit 2; }
}

need_cmd dig
need_cmd curl
need_cmd rg

EXPECTED_IPS=(
  185.199.108.153
  185.199.109.153
  185.199.110.153
  185.199.111.153
)

echo "== DNS =="
# Prefer public resolvers so local TTL cache does not fail a finished cutover.
APEX_IPS="$(dig +short assocpartners.com A @8.8.8.8 | sort -u)"
for ip in "${EXPECTED_IPS[@]}"; do
  if printf '%s\n' "$APEX_IPS" | rg -qx "$ip"; then
    ok "apex A includes $ip"
  else
    bad "apex A missing $ip (got: $(echo "$APEX_IPS" | tr '\n' ' '))"
  fi
done

WWW_CNAME="$(dig +short www.assocpartners.com CNAME @8.8.8.8 | tr -d '\r')"
if [[ "$WWW_CNAME" == "associated-partners.github.io." ]]; then
  ok "www CNAME -> associated-partners.github.io"
else
  bad "www CNAME expected associated-partners.github.io. got: ${WWW_CNAME:-<empty>}"
fi

MX="$(dig +short assocpartners.com MX @8.8.8.8 | tr -d '\r')"
if printf '%s\n' "$MX" | rg -q "outlook\\.com|google\\.com|googlemail\\.com"; then
  ok "MX present ($MX)"
else
  warn "MX unexpected or empty: ${MX:-<empty>}"
fi

echo
echo "== Content / hosting =="
TMP="$(mktemp)"
HTTP_CODE="$(curl -sL --max-time 20 -o "$TMP" -w '%{http_code}' http://assocpartners.com/ || true)"
if [[ "$HTTP_CODE" == "200" ]] && rg -q "Bringing people together" "$TMP" && rg -q "info@assocpartners.com" "$TMP"; then
  SERVER="$(curl -sI --max-time 20 http://assocpartners.com/ | rg -i '^server:' | tr -d '\r')"
  if printf '%s' "$SERVER" | rg -qi 'GitHub'; then
    ok "http://assocpartners.com serves GitHub Pages content"
  else
    bad "http://assocpartners.com content ok but server is not GitHub ($SERVER)"
  fi
else
  bad "http://assocpartners.com did not return expected site (code=$HTTP_CODE)"
fi

if rg -qi "Your Success, Our Strategy|WebsiteBuilder|GoDaddy Website" "$TMP"; then
  bad "old GoDaddy placeholder content still detected"
else
  ok "old GoDaddy placeholder content not detected"
fi

for asset in assets/css/main.css assets/js/main.js assets/images/hero.jpg; do
  CODE="$(curl -sI --max-time 20 "http://assocpartners.com/$asset" | head -1 | tr -d '\r')"
  if printf '%s' "$CODE" | rg -q '200'; then
    ok "asset $asset reachable"
  else
    bad "asset $asset not OK ($CODE)"
  fi
done

echo
echo "== HTTPS =="
CERT_CN="$(echo | openssl s_client -servername assocpartners.com -connect assocpartners.com:443 2>/dev/null | openssl x509 -noout -subject 2>/dev/null || true)"
if printf '%s' "$CERT_CN" | rg -q 'assocpartners\\.com'; then
  ok "TLS certificate is for assocpartners.com"
elif printf '%s' "$CERT_CN" | rg -q 'github\\.io'; then
  msg="TLS still using *.github.io placeholder cert (GitHub custom cert pending)"
  if [[ "$REQUIRE_HTTPS" == "1" ]]; then
    bad "$msg"
  else
    warn "$msg"
  fi
else
  warn "could not inspect TLS certificate: ${CERT_CN:-<empty>}"
fi

HTTPS_CODE="$(curl -sI --max-time 20 https://assocpartners.com/ 2>/dev/null | head -1 | tr -d '\r' || true)"
if printf '%s' "$HTTPS_CODE" | rg -q '200|301|302'; then
  ok "https://assocpartners.com responds ($HTTPS_CODE)"
else
  msg="https://assocpartners.com not verifying yet ($HTTPS_CODE)"
  if [[ "$REQUIRE_HTTPS" == "1" ]]; then
    bad "$msg"
  else
    warn "$msg"
  fi
fi

WWW_HTTPS="$(curl -sI --max-time 20 https://www.assocpartners.com/ 2>/dev/null | tr -d '\r' || true)"
if printf '%s' "$WWW_HTTPS" | rg -qi '^HTTP/.* (200|301|302)'; then
  ok "https://www.assocpartners.com responds"
  if printf '%s' "$WWW_HTTPS" | rg -qi '^location: https://assocpartners.com/?'; then
    ok "www redirects to apex https"
  fi
else
  msg="https://www.assocpartners.com not ready yet"
  if [[ "$REQUIRE_HTTPS" == "1" ]]; then
    bad "$msg"
  else
    warn "$msg"
  fi
fi

echo
echo "== Summary =="
echo "passed=$PASS  warnings=$WARN  failed=$FAIL"
rm -f "$TMP"

if [[ "$FAIL" -gt 0 ]]; then
  exit 1
fi
exit 0
