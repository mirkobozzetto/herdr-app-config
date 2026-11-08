if command -v claude >/dev/null 2>&1; then
  claude plugin marketplace add mirkobozzetto/arsenal || true
  for p in brief propose ship next trace issue review; do claude plugin install "$p@arsenal" || true; done
fi
