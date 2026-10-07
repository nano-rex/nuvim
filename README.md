# nuvim

`nuvim` is a Vim-based editor distribution inspired by Neovim's batteries-included feel while keeping Vim as the base editor. It is designed to be compiled with [Fil-C](https://github.com/pizlonator/fil-c) and to start with IDE-like defaults for many programming languages.

The project is intentionally small: upstream Vim provides the editor, Fil-C provides the hardened C/C++ toolchain, and `config/nuvim` provides the default plugin and language tooling layer.

## Goals

- Use Vim as the editor core.
- Build Vim with Fil-C by default.
- Enable an IDE-style plugin bundle out of the box.
- Support common languages through LSP, linting, formatting, completion, fuzzy search, Git integration, and project navigation.
- Keep everything inspectable shell scripts and Vimscript.

## Included Defaults

The default package set includes:

- LSP client: `vim-lsp`
- Completion: `asyncomplete.vim`, `asyncomplete-lsp.vim`
- Diagnostics and linting: `ale`
- Language syntax collection: `vim-polyglot`
- Fuzzy file search: `fzf`, `fzf.vim`
- File tree: `nerdtree`
- Git tools: `vim-fugitive`, `vim-gitgutter`
- Editing helpers: `vim-surround`, `vim-commentary`, `auto-pairs`
- Status line and theme: `lightline.vim`, `onedark.vim`
- Config consistency: `editorconfig-vim`

Language-server hooks are included for C/C++, Rust, Go, Python, TypeScript/JavaScript, HTML, CSS, JSON, Bash, Lua, PHP, Ruby, Java, Kotlin, Dart, YAML, Dockerfile, and Markdown. Install only the servers you need.

## Requirements

- POSIX shell utilities
- `git`
- `curl` or `wget`
- Fil-C compiler commands in `PATH`: `filcc` and `fil++`
- Build dependencies required by Vim on your platform
- Optional language server package managers: `npm`, `pipx`, `go`, `rustup`, or system packages

## Quick Start

```sh
git clone https://github.com/USER/nuvim.git
cd nuvim
./scripts/bootstrap-plugins.sh
./scripts/build-filc-vim.sh
./build/nuvim/bin/nuvim
```

The build script fetches upstream Vim, compiles it with Fil-C, and installs a wrapper named `nuvim` under `build/nuvim/bin`.

## Install Language Servers

```sh
./scripts/install-language-servers.sh
```

This helper installs a broad default set when the relevant package managers are available. You can also install language servers manually and `nuvim` will use whichever executables it finds in `PATH`.

## Repository Layout

```text
config/nuvim/          Default Vim runtime, vimrc, and package directory
docs/                  Design notes and language support matrix
packaging/             Packaging helpers and install notes
scripts/               Build, bootstrap, and tooling scripts
```

## Configuration

The launcher sets:

```sh
VIMINIT='source $NUVIM_RUNTIME/vimrc'
```

This keeps `nuvim` defaults separate from your normal `~/.vimrc`. User overrides can be placed in:

```text
~/.config/nuvim/after.vim
```

## Status

This is an initial distribution scaffold. The next milestones are CI builds, binary packaging, and deeper Fil-C compatibility testing against upstream Vim.
