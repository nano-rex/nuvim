#!/bin/sh
set -eu

install_npm() {
  if command -v npm >/dev/null 2>&1; then
    npm install -g \
      pyright \
      typescript \
      typescript-language-server \
      vscode-langservers-extracted \
      bash-language-server \
      intelephense \
      yaml-language-server \
      dockerfile-language-server-nodejs
  else
    printf 'Skipping npm language servers: npm not found\n' >&2
  fi
}

install_pipx() {
  if command -v pipx >/dev/null 2>&1; then
    pipx install python-lsp-server || true
    pipx install cmake-language-server || true
  else
    printf 'Skipping pipx language servers: pipx not found\n' >&2
  fi
}

install_go() {
  if command -v go >/dev/null 2>&1; then
    go install golang.org/x/tools/gopls@latest
  else
    printf 'Skipping gopls: go not found\n' >&2
  fi
}

install_rust() {
  if command -v rustup >/dev/null 2>&1; then
    rustup component add rust-analyzer rustfmt
  else
    printf 'Skipping rust-analyzer: rustup not found\n' >&2
  fi
}

install_npm
install_pipx
install_go
install_rust

cat <<'NOTE'

Manual recommendations:
  clangd                 install via your system package manager or LLVM release
  lua-language-server    install via your system package manager
  solargraph             gem install solargraph
  jdtls                  install Eclipse JDT Language Server
  kotlin-language-server install from fwcd/kotlin-language-server
  marksman               install from marksman releases

NOTE
