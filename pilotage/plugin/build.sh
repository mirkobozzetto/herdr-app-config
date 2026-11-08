#!/usr/bin/env bash
# Rebuilds pilote.zip, the file to upload in claude.ai: Customize > Plugins > Add > Upload plugin.
set -euo pipefail
cd "$(dirname "$0")/pilote"
rm -f ../pilote.zip
zip -qr ../pilote.zip .
echo "pilote.zip ready: $(cd .. && pwd)/pilote.zip"
