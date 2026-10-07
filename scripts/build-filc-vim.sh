#!/bin/sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
VIM_VERSION=${VIM_VERSION:-v9.1.0000}
SRC_DIR="$ROOT/build/src/vim"
PREFIX=${PREFIX:-"$ROOT/build/nuvim"}
JOBS=${JOBS:-$(getconf _NPROCESSORS_ONLN 2>/dev/null || printf 2)}

require() {
  if ! command -v "$1" >/dev/null 2>&1; then
    printf 'error: required command not found: %s\n' "$1" >&2
    exit 1
  fi
}

require git
require make
require filcc
require fil++

mkdir -p "$ROOT/build/src"

if [ -d "$SRC_DIR/.git" ]; then
  git -C "$SRC_DIR" fetch --tags origin
else
  git clone https://github.com/vim/vim.git "$SRC_DIR"
fi

git -C "$SRC_DIR" checkout "$VIM_VERSION"

cd "$SRC_DIR"

CC=filcc \
CXX=fil++ \
./configure \
  --prefix="$PREFIX" \
  --with-features=huge \
  --enable-multibyte \
  --enable-terminal \
  --enable-cscope \
  --enable-autoservername \
  --disable-gui \
  --without-x \
  --disable-netbeans \
  --enable-fail-if-missing

make -j "$JOBS"
make install

mkdir -p "$PREFIX/share/nuvim"
cp -R "$ROOT/config/nuvim/." "$PREFIX/share/nuvim/"

cat > "$PREFIX/bin/nuvim" <<'WRAPPER'
#!/bin/sh
SELF=$0
BIN_DIR=$(CDPATH= cd -- "$(dirname -- "$SELF")" && pwd)
PREFIX=$(CDPATH= cd -- "$BIN_DIR/.." && pwd)
NUVIM_RUNTIME=${NUVIM_RUNTIME:-"$PREFIX/share/nuvim"}
export NUVIM_RUNTIME
export VIMINIT="source $NUVIM_RUNTIME/vimrc"
exec "$BIN_DIR/vim" "$@"
WRAPPER

chmod +x "$PREFIX/bin/nuvim"

printf 'nuvim built at %s\n' "$PREFIX/bin/nuvim"
