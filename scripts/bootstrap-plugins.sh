#!/bin/sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
PACK_DIR="$ROOT/config/nuvim/pack/nuvim/start"

mkdir -p "$PACK_DIR"

clone_or_update() {
  name=$1
  url=$2
  dest="$PACK_DIR/$name"

  if [ -d "$dest/.git" ]; then
    printf 'Updating %s\n' "$name"
    git -C "$dest" pull --ff-only
  else
    printf 'Installing %s\n' "$name"
    git clone --depth 1 "$url" "$dest"
  fi
}

clone_or_update vim-lsp https://github.com/prabirshrestha/vim-lsp.git
clone_or_update async.vim https://github.com/prabirshrestha/async.vim.git
clone_or_update asyncomplete.vim https://github.com/prabirshrestha/asyncomplete.vim.git
clone_or_update asyncomplete-lsp.vim https://github.com/prabirshrestha/asyncomplete-lsp.vim.git
clone_or_update ale https://github.com/dense-analysis/ale.git
clone_or_update vim-polyglot https://github.com/sheerun/vim-polyglot.git
clone_or_update fzf https://github.com/junegunn/fzf.git
clone_or_update fzf.vim https://github.com/junegunn/fzf.vim.git
clone_or_update nerdtree https://github.com/preservim/nerdtree.git
clone_or_update vim-fugitive https://github.com/tpope/vim-fugitive.git
clone_or_update vim-gitgutter https://github.com/airblade/vim-gitgutter.git
clone_or_update vim-surround https://github.com/tpope/vim-surround.git
clone_or_update vim-commentary https://github.com/tpope/vim-commentary.git
clone_or_update auto-pairs https://github.com/jiangmiao/auto-pairs.git
clone_or_update lightline.vim https://github.com/itchyny/lightline.vim.git
clone_or_update onedark.vim https://github.com/joshdick/onedark.vim.git
clone_or_update editorconfig-vim https://github.com/editorconfig/editorconfig-vim.git

printf 'Plugin bootstrap complete: %s\n' "$PACK_DIR"
