# Fil-C Build Notes

`scripts/build-filc-vim.sh` expects these compiler commands in `PATH`:

- `filcc`
- `fil++`

The script builds upstream Vim with:

```sh
CC=filcc CXX=fil++ ./configure --with-features=huge --enable-terminal
```

If a platform-specific Vim feature does not compile under Fil-C yet, prefer disabling that feature in the build script rather than patching upstream Vim in this distribution repo. The intent is to keep `nuvim` close to upstream Vim and make Fil-C compatibility issues easy to isolate.

Use a pinned Vim tag through:

```sh
VIM_VERSION=v9.1.0000 ./scripts/build-filc-vim.sh
```

The installed wrapper is:

```text
build/nuvim/bin/nuvim
```
