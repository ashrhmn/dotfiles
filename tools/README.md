# Dotfiles tools

This directory contains Bash scripts, PowerShell scripts, and supporting tools.
The Go tools are standalone repositories under `~/clones/ashrhmn/`:

| Repository | Purpose |
| --- | --- |
| [ts-flatten](https://github.com/ashrhmn/ts-flatten) | Flatten TypeScript files by inlining local imports |
| [tsndexer](https://github.com/ashrhmn/tsndexer) | Generate TypeScript directory indexes |
| [lctx](https://github.com/ashrhmn/lctx) | Manage shared context files for LLM tools |
| [tgp-report](https://github.com/ashrhmn/tgp-report) | Summarize TG Pro temperature and fan logs |

## Build and install

Run these commands from the dotfiles root:

```sh
make clone-go          # Clone missing Go repositories
make all               # Build Go tools, copy Bash scripts, prepare Git hooks
make go-tools          # Build only the Go tools
make bash-tools        # Copy only Bash scripts
make build-ts-flatten  # Build one Go tool from its standalone clone
make install           # Build and list the installed binaries
make show              # Show available tools and clone status
```

`make go-tools` and `make install` clone missing repositories automatically.
Existing clones are built as they are; builds do not reset or update their Git
branches. Pull changes within a clone when you want to update it.

The default clone directory is `$(HOME)/clones/ashrhmn`. Override it when needed:

```sh
make go-tools GO_PROJECTS_DIR=/path/to/clones/ashrhmn
```

Binaries go into `bin/.bin/`, ready for `stow bin` or adding that directory to
`PATH`. You can also build a project directly with `make build` in its clone;
the default output is that project's `bin/` directory.

## Development and releases

Edit Go projects in their standalone clones. Each project provides the same
tagging commands as `gh-agent`:

```sh
cd ~/clones/ashrhmn/ts-flatten
make test
make build
# Commit and push the changes you want to release, then:
make tag-patch          # v0.0.1 -> v0.0.2
make tag-minor          # v0.0.2 -> v0.1.0
make tag-major          # v0.1.0 -> v1.0.0
```

Each tagging command requires a clean working tree, fetches tags from `origin`,
increments the highest stable `vMAJOR.MINOR.PATCH` tag, and creates and pushes
the new tag. With no stable tags, the starting version is `v0.0.0`, so the first
`make tag-patch` publishes `v0.0.1`. These commands publish Git tags.

From the dotfiles root, `make dev-go` runs `go mod tidy` and `go test ./...` in
each standalone clone. `make lint-bash` checks Bash scripts with ShellCheck.

## Fresh setup and submodules

```sh
git clone git@github.com:ashrhmn/dotfiles.git ~/dotfiles
cd ~/dotfiles
make clone-fresh
```

`make clone-fresh` initializes the remaining Zsh plugin submodules and builds
the tools, cloning the standalone Go repositories as needed. `make
init-submodules` and `make update-submodules` manage only the remaining
submodules.

## Adding a tool

For a Bash script, add an executable file to `tools/bash/` and run `make
bash-tools`. For a Go tool, maintain a standalone repository under
`~/clones/ashrhmn/`, give it a Makefile with `build`, `test`, and `tag-*` targets
(`build` must honor `BIN_DIR`), and add its name to `GO_PROJECTS` in the root
Makefile.
