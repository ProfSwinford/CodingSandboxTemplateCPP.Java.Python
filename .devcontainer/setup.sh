#!/usr/bin/env bash
# Runs once after the container is created.
# Invoked as:  tr -d '\r' < setup.sh | bash
# (the tr strips Windows CRLF, which otherwise breaks bash)

set -euo pipefail

echo "=== Toolchains ==="
g++    --version 2>&1 | head -n 1
gdb    --version 2>&1 | head -n 1
javac  -version  2>&1 | head -n 1
python --version 2>&1 | head -n 1

if [ -f requirements.txt ] && grep -qEv '^[[:space:]]*(#|$)' requirements.txt; then
  echo
  echo "=== Installing Python packages ==="
  python3 -m pip install --break-system-packages --no-input -r requirements.txt
fi

echo
echo "=== Ready. Press F5 to build and debug. ==="
