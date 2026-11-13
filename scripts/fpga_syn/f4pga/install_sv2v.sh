#!/usr/bin/env bash
# Optional CVA5 frontend, from the upstream sv2v release (BSD-3-Clause).
set -euo pipefail
PREFIX=${1:?Usage: install_sv2v.sh INSTALL_DIRECTORY}
mkdir -p "$PREFIX"
archive="$PREFIX/sv2v-Linux-v0.0.13.zip"
curl --fail --location --retry 3 https://github.com/zachjs/sv2v/releases/download/v0.0.13/sv2v-Linux.zip -o "$archive"
echo "552799a1d76cd177b9b4cc63a3e77823a3d2a6eb4ec006569288abeff28e1ff8  $archive" | sha256sum --check -
unzip -o "$archive" -d "$PREFIX"
"$PREFIX/sv2v-Linux/sv2v" --version
