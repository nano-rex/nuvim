# Language Support

`nuvim` uses `vim-lsp` and automatically registers servers when their executables are available in `PATH`.

| Language | Server command | Typical install source |
| --- | --- | --- |
| C, C++, Objective-C | `clangd` | LLVM or system packages |
| Rust | `rust-analyzer` | `rustup component add rust-analyzer` |
| Go | `gopls` | `go install golang.org/x/tools/gopls@latest` |
| Python | `pyright-langserver` | `npm install -g pyright` |
| JavaScript, TypeScript | `typescript-language-server` | `npm install -g typescript typescript-language-server` |
| HTML | `vscode-html-language-server` | `npm install -g vscode-langservers-extracted` |
| CSS, SCSS, Less | `vscode-css-language-server` | `npm install -g vscode-langservers-extracted` |
| JSON | `vscode-json-language-server` | `npm install -g vscode-langservers-extracted` |
| Bash | `bash-language-server` | `npm install -g bash-language-server` |
| Lua | `lua-language-server` | system package or upstream release |
| PHP | `intelephense` | `npm install -g intelephense` |
| Ruby | `solargraph` | `gem install solargraph` |
| Java | `jdtls` | Eclipse JDT Language Server |
| Kotlin | `kotlin-language-server` | upstream release |
| Dart | `dart language-server` | Dart SDK |
| YAML | `yaml-language-server` | `npm install -g yaml-language-server` |
| Dockerfile | `docker-langserver` | `npm install -g dockerfile-language-server-nodejs` |
| Markdown | `marksman` | upstream release |

Linting and formatting are handled by ALE where matching tools exist.
