# 🛠️ Dotfiles Tools Build System

This directory contains the build system for all CLI tools used in this dotfiles repository. It supports both **Bash scripts** and **Go projects** (as git submodules).

## 📁 Structure

```
tools/
├── bash/              # Bash scripts
│   └── spf            # SSH Port Forwarder
├── ts-flatten/        # Go project (git submodule)
├── tsndexer/          # Go project (git submodule)
├── Makefile           # Unified build system
└── README.md          # This file
```

## 🚀 Quick Start

### First Time Setup (Fresh Clone)

```bash
cd tools
make clone-fresh    # Initialize submodules and build everything
```

### Regular Usage

```bash
# Build all tools
make all

# Build specific types
make bash-tools     # Only bash scripts
make go-tools       # Only Go projects

# Build specific Go project
make build-ts-flatten
make build-tsndexer

# Clean and rebuild
make clean
make install        # Build and show results
```

## 🔧 Available Commands

### 📋 Main Build Targets

| Command           | Description                 |
| ----------------- | --------------------------- |
| `make all`        | Build all tools (bash + go) |
| `make bash-tools` | Build only bash tools       |
| `make go-tools`   | Build only go tools         |
| `make clean`      | Remove all built binaries   |
| `make install`    | Build and show results      |

### 🔧 Development

| Command                | Description                            |
| ---------------------- | -------------------------------------- |
| `make build-<project>` | Build specific go project              |
| `make dev-go`          | Run tests and tidy for all go projects |
| `make lint-bash`       | Lint bash scripts with shellcheck      |

### 📦 Submodule Management

| Command                  | Description                 |
| ------------------------ | --------------------------- |
| `make init-submodules`   | Initialize git submodules   |
| `make update-submodules` | Update existing submodules  |
| `make clone-fresh`       | Setup after fresh git clone |

### 📋 Information

| Command     | Description                           |
| ----------- | ------------------------------------- |
| `make show` | Show available tools and their status |
| `make help` | Show comprehensive help               |

## 🔨 Adding New Tools

### Adding a Bash Script

1. Add your script to `tools/bash/`
2. Make sure it's executable
3. Run `make bash-tools`

### Adding a Go Project (as submodule)

1. Add the submodule:

   ```bash
   git submodule add git@github.com:your-username/your-tool.git your-tool
   ```

2. Update the Makefile:

   ```makefile
   # Add to GO_PROJECTS list
   GO_PROJECTS := ts-flatten tsndexer your-tool
   ```

3. Build:
   ```bash
   make go-tools
   ```

## 📦 Output

All built binaries are placed in `../bin/.bin/` and are ready for GNU Stow:

```bash
cd ..
stow bin    # This will symlink all tools to ~/.local/bin/
```

## 🔍 Built Tools

### 🐚 Bash Tools

- **spf** - SSH Port Forwarder with robust error handling

### 🔧 Go Tools

- **ts-flatten** - TypeScript file flattener by inlining imports
- **tsndexer** - TypeScript directory indexer

## 🛡️ Error Handling

The build system gracefully handles:

- ✅ Missing submodules (warns and skips)
- ✅ Failed builds (reports error, continues with others)
- ✅ Missing dependencies (shellcheck, go, etc.)
- ✅ Non-existent directories
- ✅ Invalid project structures

## 🔄 Workflow Examples

### Daily Development

```bash
# Work on bash tools
vim bash/spf
make bash-tools

# Work on Go tools
cd ts-flatten
# make changes...
cd ..
make build-ts-flatten

# Test everything
make lint-bash
make dev-go
```

### Setting up on New Machine

```bash
git clone <your-dotfiles-repo>
cd dotfiles/tools
make clone-fresh
cd ..
stow bin
```

### Adding a New Tool

```bash
# For Go projects
git submodule add git@github.com:username/new-tool.git new-tool
# Edit Makefile to add 'new-tool' to GO_PROJECTS
make build-new-tool

# For bash scripts
cp /path/to/script bash/new-script
make bash-tools
```

## 🎯 Design Philosophy

This build system follows these principles:

1. **Explicit over Implicit** - Projects are explicitly listed, not auto-discovered
2. **Fail Gracefully** - Missing tools don't break the entire build
3. **Single Source of Truth** - All tools build to the same `bin/.bin/` directory
4. **GNU Stow Ready** - Output is ready for symlinking
5. **Developer Friendly** - Clear error messages and helpful commands

## 🚨 Troubleshooting

### Submodule Issues

```bash
# Reset submodules
git submodule deinit --all
make init-submodules

# Update submodules
git submodule update --remote
make update-submodules
```

### Build Failures

```bash
# Check Go installation
go version

# Check tool status
make show

# Clean rebuild
make clean
make all
```

### Missing Dependencies

```bash
# Install shellcheck (for bash linting)
brew install shellcheck     # macOS
apt install shellcheck      # Ubuntu

# Install Go
# See https://golang.org/doc/install
```
