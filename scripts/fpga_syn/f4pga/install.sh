#!/usr/bin/env bash
# Reproducible legacy XC7 runtime/device setup in an isolated, user-owned prefix.
set -euo pipefail
HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
PREFIX=${1:?Usage: install.sh ABSOLUTE_PREFIX [CONDA_EXECUTABLE]}
CONDA_COMMAND=${2:-conda}
[[ $PREFIX == /* && $PREFIX != / ]] || { echo 'Use an absolute dedicated installation prefix' >&2; exit 2; }
mkdir -p "$PREFIX/xc7"
BASE=https://storage.googleapis.com/symbiflow-arch-defs/artifacts/prod/foss-fpga-tools/symbiflow-arch-defs/continuous/install/20220907-210059
fetch() {
    local package=$1 digest=$2 archive="$PREFIX/$1.tar.xz"
    if [[ ! -f $archive ]]; then
        curl --fail --location --retry 3 --output "$archive.part" "$BASE/symbiflow-arch-defs-$package-66a976d.tar.xz"
        mv "$archive.part" "$archive"
    fi
    echo "$digest  $archive" | sha256sum --check -
    tar -xJf "$archive" -C "$PREFIX/xc7"
}
fetch install-xc7 8fa1aa9cfc033c9fef59c2ac19d4ff18568a66bc8ce15c3385cd9ec1d1901274
fetch xc7a100t_test 49b355e8a442e46652c7b089c23dc020d4babb8009d8f4494e09d72e37b2e5ef
export CONDA_PKGS_DIRS="$PREFIX/conda-pkgs"
export CONDA_CHANNEL_PRIORITY=disabled
if [[ ! -x $PREFIX/xc7/conda/bin/python ]]; then
    "$CONDA_COMMAND" env create --yes --prefix "$PREFIX/xc7/conda" --file "$HERE/environment.yml"
else
    "$CONDA_COMMAND" env update --prefix "$PREFIX/xc7/conda" --file "$HERE/environment.yml"
fi
REVISION=0723f9ca4ea4b686ff9c2e32c9cec56d40de1a62
if [[ ! -d $PREFIX/source/.git ]]; then
    git init "$PREFIX/source"
    git -C "$PREFIX/source" remote add origin https://github.com/chipsalliance/f4pga.git
    git -C "$PREFIX/source" fetch --depth 1 origin "$REVISION"
    git -C "$PREFIX/source" checkout --detach FETCH_HEAD
fi
[[ $(git -C "$PREFIX/source" rev-parse HEAD) == "$REVISION" ]] || { echo 'Unexpected F4PGA source revision' >&2; exit 2; }
"$PREFIX/xc7/conda/bin/python" -m pip install -r "$PREFIX/xc7/xc7_env/xc7_requirements.txt" "$PREFIX/source/f4pga"
# Resolve this script dynamically so moving the installation updates its environment.
cat > "$PREFIX/env.sh" <<'ENV'
export F4PGA_INSTALL_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
export F4PGA_SHARE_DIR=$F4PGA_INSTALL_DIR/xc7/share/f4pga
export FPGA_FAM=xc7
export PATH=$F4PGA_INSTALL_DIR/xc7/conda/bin:$PATH
ENV
"$CONDA_COMMAND" list --prefix "$PREFIX/xc7/conda" --explicit > "$PREFIX/conda-explicit.txt"
"$PREFIX/xc7/conda/bin/python" -m pip freeze > "$PREFIX/pip-freeze.txt"
echo "Set FPGA_SYN_F4PGA_ENV_SCRIPT=$PREFIX/env.sh"
