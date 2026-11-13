#!/bin/bash
# Renders every src/screens/*.html to tasks/<task>/screens/<name>.png with headless Chrome.
# File name pattern: <task-folder>__<screen-name>.html
# Optional height: add <meta name="shot-height" content="1400"> to the HTML.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CHROME="${CHROME_PATH:-/Applications/Google Chrome.app/Contents/MacOS/Google Chrome}"
for f in "$ROOT"/src/screens/*__*.html; do
  base="$(basename "$f" .html)"
  task="${base%%__*}"
  name="${base#*__}"
  h="$(sed -n 's/.*name="shot-height" content="\([0-9]*\)".*/\1/p' "$f" | head -1)"
  h="${h:-900}"
  out="$ROOT/tasks/$task/screens"
  mkdir -p "$out"
  "$CHROME" --headless=new --disable-gpu --hide-scrollbars --force-device-scale-factor=1 \
    --window-size=1440,"$h" --screenshot="$out/$name.png" "file://$f" >/dev/null 2>&1
  echo "rendered tasks/$task/screens/$name.png (1440x$h)"
done
