#!/bin/sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
VIM_VERSION=${VIM_VERSION:-v9.1.0000}
SRC_DIR="$ROOT/build/src/vim"
PREFIX=${PREFIX:-"$ROOT/build/nuvim"}
JOBS=${JOBS:-$(getconf _NPROCESSORS_ONLN 2>/dev/null || printf 2)}
FILC_ROOT=${FILC_ROOT:-}
FILC_PREFIX=${FILC_PREFIX:-}

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

rm -f src/auto/config.cache

if [ -n "$FILC_ROOT" ] && [ -z "$FILC_PREFIX" ]; then
  FILC_PREFIX="$FILC_ROOT/pizfix"
fi

if [ -n "$FILC_PREFIX" ]; then
  CPPFLAGS="-I$FILC_PREFIX/include -I$FILC_PREFIX/include/ncurses ${CPPFLAGS:-}"
  LDFLAGS="-L$FILC_PREFIX/lib -Wl,-rpath,$FILC_PREFIX/lib ${LDFLAGS:-}"
  PATH="$FILC_PREFIX/bin:$PATH"
  export CPPFLAGS LDFLAGS PATH
fi

ac_cv_func_sigaltstack=no
export ac_cv_func_sigaltstack

CC=filcc \
CXX=fil++ \
./configure \
  --prefix="$PREFIX" \
  --with-features=huge \
  --enable-multibyte \
  --enable-terminal \
  --enable-cscope \
  --enable-autoservername \
  --with-tlib=ncurses \
  --disable-gui \
  --without-x \
  --disable-netbeans \
  --enable-fail-if-missing

make -j "$JOBS"
make install

if [ -n "$FILC_PREFIX" ]; then
  mkdir -p "$PREFIX/lib/filc"
  cp -a \
    "$FILC_PREFIX/lib/ld-fil1-x86_64.so" \
    "$FILC_PREFIX/lib/libncurses.so"* \
    "$FILC_PREFIX/lib/libc.so" \
    "$FILC_PREFIX/lib/libpizlo.so" \
    "$FILC_PREFIX/lib/libyoloc.so" \
    "$PREFIX/lib/filc/"
  if command -v patchelf >/dev/null 2>&1; then
    patchelf --set-rpath '$ORIGIN/../lib/filc' "$PREFIX/bin/vim"
  fi
fi

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
FILC_LIB="$PREFIX/lib/filc"
FILC_LOADER="$FILC_LIB/ld-fil1-x86_64.so"
if [ -x "$FILC_LOADER" ]; then
  export LD_LIBRARY_PATH="$FILC_LIB:${LD_LIBRARY_PATH:-}"
  exec "$FILC_LOADER" "$BIN_DIR/vim" "$@"
fi
exec "$BIN_DIR/vim" "$@"
WRAPPER

chmod +x "$PREFIX/bin/nuvim"

printf 'nuvim built at %s\n' "$PREFIX/bin/nuvim"
