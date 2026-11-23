#!/usr/bin/env bash
# Runs once after the container is created.
# Invoked as:  tr -d '\r' < setup.sh | bash
# (the tr strips Windows CRLF, which otherwise breaks bash)
#
# The Dockerfile is the primary path -- it bakes the toolchains into the image.
# This script is a safety net: if the image was NOT built from that Dockerfile
# (for example the template was dropped into an existing workspace and never
# rebuilt), it installs whatever is missing so the template still works.

set -uo pipefail

say() { echo "[setup] $*"; }

# ---------------------------------------------------------------------------
# 1. Install any missing toolchain
# ---------------------------------------------------------------------------
NEED=""
command -v g++     >/dev/null 2>&1 || NEED="${NEED} build-essential"
command -v gdb     >/dev/null 2>&1 || NEED="${NEED} gdb"
command -v javac   >/dev/null 2>&1 || NEED="${NEED} default-jdk"
command -v python3 >/dev/null 2>&1 || NEED="${NEED} python3 python3-venv"
python3 -m pip --version >/dev/null 2>&1 || NEED="${NEED} python3-pip"

if [ -n "${NEED}" ]; then
  say "missing:${NEED}"
  say "(the image was probably not built from .devcontainer/Dockerfile)"

  SUDO=""
  if [ "$(id -u)" -ne 0 ]; then
    if command -v sudo >/dev/null 2>&1; then
      SUDO="sudo"
    else
      say "ERROR: not root and sudo is unavailable; cannot install."
      exit 1
    fi
  fi

  # -y matters: without it apt waits for confirmation and the step hangs.
  if $SUDO apt-get update -y \
     && $SUDO env DEBIAN_FRONTEND=noninteractive \
          apt-get install -y --no-install-recommends ${NEED}; then
    say "installed:${NEED}"
  else
    say "ERROR: install failed. Run it by hand to see why:"
    say "  sudo apt-get install -y${NEED}"
  fi
fi

# ---------------------------------------------------------------------------
# 2. Extensions, if the dev container did not provision them
# ---------------------------------------------------------------------------
# devcontainer.json installs these at container creation. If the image was not
# built from our config, that never happened -- so install them here too.
# Already-installed extensions are a no-op.
if command -v code >/dev/null 2>&1; then
  for EXT in ms-vscode.cpptools vscjava.vscode-java-pack \
             ms-python.python ms-python.debugpy; do
    code --install-extension "$EXT" --force >/dev/null 2>&1 \
      && say "extension ok: $EXT" \
      || say "extension skipped: $EXT"
  done
fi

# ---------------------------------------------------------------------------
# 3. Python packages (independent of everything above)
# ---------------------------------------------------------------------------
# Checked in both places, so this keeps working if the workspace root is moved
# one level deeper into student/ (see "Opening one level deeper" in README).
REQ=""
for CANDIDATE in requirements.txt ../requirements.txt; do
  if [ -f "$CANDIDATE" ] && grep -qEv '^[[:space:]]*(#|$)' "$CANDIDATE"; then
    REQ="$CANDIDATE"
    break
  fi
done

if [ -n "$REQ" ]; then
  say "installing Python packages from $REQ"
  python3 -m pip install --break-system-packages --no-input -r "$REQ" \
    || say "WARNING: pip install failed"
fi

# ---------------------------------------------------------------------------
# 4. Report
# ---------------------------------------------------------------------------
echo
echo "=== Toolchains ==="
report() {
  if command -v "$1" >/dev/null 2>&1; then
    echo "  $("$@" 2>&1 | head -n 1)"
  else
    echo "  $1: MISSING"
  fi
}
report g++     --version
report gdb     --version
report javac   -version
report python3 --version
echo "JAVA_HOME=${JAVA_HOME:-<unset>}"
if [ -L /usr/lib/jvm/current ]; then
  echo "image: built from .devcontainer/Dockerfile"
else
  echo "image: NOT built from .devcontainer/Dockerfile (toolchains installed at runtime)"
fi

echo
echo "=== Ready. Press F5 to build and debug. ==="
