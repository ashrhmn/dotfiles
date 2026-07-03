.PHONY: all clean install bash-tools go-tools git-hooks submodules update-submodules help default

# Set default target
.DEFAULT_GOAL := default

## default: update submodules, clean, and build all tools
default: update-submodules clean all

# Directories
BIN_DIR := bin/.bin
BASH_DIR := tools/bash
GIT_HOOKS_DIR := git/.config/git/hooks

# Platform-specific tools to ignore during build
DARWIN_IGNORE := pbcopy xdg-open
LINUX_IGNORE :=

# Go projects (as git submodules)
GO_PROJECTS := ts-flatten tsndexer lctx tgp-report

## help: show this help message
help:
	@echo "Usage:"
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' | sed -e 's/^/ /'

## confirm: confirmation prompt for destructive operations
confirm:
	@echo -n 'Are you sure? [y/N] ' && read ans && [ $${ans:-N} = y ]

## all: build all tools (bash + go) and prepare git hooks
all: bash-tools go-tools git-hooks

## update-submodules: update git submodules to latest remote changes
update-submodules:
	@echo "🔄 Updating git submodules..."
	@git submodule init 2>/dev/null
	@git submodule sync --recursive 2>/dev/null
	@git submodule foreach --recursive 'git fetch origin; git checkout $$(git rev-parse --abbrev-ref HEAD); git reset --hard origin/$$(git rev-parse --abbrev-ref HEAD); git submodule update --init --recursive; git clean -fdx'

## bash-tools: build only bash tools
bash-tools:
	@echo "📝 Installing bash tools..."
	@mkdir -p $(BIN_DIR)
	@if [ -d "$(BASH_DIR)" ]; then \
		for script in $(BASH_DIR)/*; do \
			if [ -f "$$script" ]; then \
				script_name=$$(basename "$$script"); \
				skip_script=false; \
				if [ "$$(uname)" = "Darwin" ]; then \
					for ignore in $(DARWIN_IGNORE); do \
						if [ "$$script_name" = "$$ignore" ]; then \
							skip_script=true; \
							echo "  ⏭️  Skipping $$script_name on Darwin/macOS"; \
							break; \
						fi; \
					done; \
				elif [ "$$(uname)" = "Linux" ]; then \
					for ignore in $(LINUX_IGNORE); do \
						if [ "$$script_name" = "$$ignore" ]; then \
							skip_script=true; \
							echo "  ⏭️  Skipping $$script_name on Linux"; \
							break; \
						fi; \
					done; \
				fi; \
				if [ "$$skip_script" = "false" ]; then \
					cp "$$script" $(BIN_DIR)/ && \
					chmod +x $(BIN_DIR)/$$script_name && \
					echo "  ✅ $$script_name"; \
				fi; \
			fi \
		done; \
	else \
		echo "  ⚠️  No bash tools directory found"; \
	fi

## git-hooks: make global git hooks executable
git-hooks:
	@echo "Preparing Git hooks..."
	@if [ -d "$(GIT_HOOKS_DIR)" ]; then \
		for hook in $(GIT_HOOKS_DIR)/*; do \
			if [ -f "$$hook" ]; then \
				chmod +x "$$hook" && echo "  ready: $$hook"; \
			fi; \
		done; \
	else \
		echo "  no Git hooks directory found"; \
	fi

## go-tools: build only go tools
go-tools: update-submodules
	@echo "🔧 Building Go tools..."
	@mkdir -p $(BIN_DIR)
	@for project in $(GO_PROJECTS); do \
		project_path="tools/$$project"; \
		project_name="$$project"; \
		if [ -d "$$project_path" ] && [ -f "$$project_path/go.mod" ]; then \
			echo "  🔨 Building $$project_name..."; \
			cd "$$project_path" && \
			if go build -ldflags="-s -w" -o "../../$(BIN_DIR)/$$project_name" . 2>/dev/null; then \
				echo "  ✅ $$project_name"; \
			else \
				echo "  ❌ Failed to build $$project_name"; \
			fi && \
			cd ../..; \
		elif [ -d "$$project" ]; then \
			echo "  ⚠️  $$project_name exists but no go.mod found - skipping"; \
		else \
			echo "  ⚠️  $$project_name submodule not found - run 'git submodule update --init'"; \
		fi \
	done

## build-%: build specific go project (e.g., build-ts-flatten)
build-%:
	@project_name=$(subst build-,,$@); \
	project_path="tools/$$project_name"; \
	if [ -d "$$project_path" ] && [ -f "$$project_path/go.mod" ]; then \
		echo "🔨 Building $$project_name..."; \
		mkdir -p $(BIN_DIR); \
		cd "$$project_path" && \
		if go build -ldflags="-s -w" -o "../../$(BIN_DIR)/$$project_name" .; then \
			echo "✅ $$project_name built successfully"; \
		else \
			echo "❌ Failed to build $$project_name"; \
			exit 1; \
		fi; \
	else \
		echo "❌ Project $$project_name not found or missing go.mod"; \
		exit 1; \
	fi

## dev-go: run tests and tidy for all go projects
dev-go:
	@echo "🧪 Running Go development tasks..."
	@for project in $(GO_PROJECTS); do \
		project_path="tools/$$project"; \
		project_name="$$project"; \
		if [ -d "$$project_path" ] && [ -f "$$project_path/go.mod" ]; then \
			echo "  📦 $$project_name: tidying and testing..."; \
			cd "$$project_path" && \
			go mod tidy && \
			go test ./... && \
			cd ../..; \
		fi \
	done

## lint-bash: lint bash scripts with shellcheck
lint-bash:
	@echo "🔍 Linting bash scripts..."
	@if [ -d "$(BASH_DIR)" ]; then \
		for script in $(BASH_DIR)/*; do \
			if [ -f "$$script" ]; then \
				if command -v shellcheck >/dev/null 2>&1; then \
					shellcheck "$$script" || true; \
				else \
					echo "  ⚠️  shellcheck not installed - skipping lint"; \
					break; \
				fi; \
			fi \
		done; \
	fi

## clean: clean up the build binaries
clean: confirm
	@echo "🧹 Cleaning up..."
	@rm -rf $(BIN_DIR)/*

## install: build and show results
install: all
	@echo "📦 Tools built and ready for stow!"
	@echo "📋 Available binaries:"
	@ls -la $(BIN_DIR)/ 2>/dev/null || echo "  (none built)"

## show: show available tools
show:
	@echo "📋 Available tools:"
	@echo "  🐚 Bash tools:"
	@if [ -d "$(BASH_DIR)" ]; then \
		ls -1 $(BASH_DIR)/ 2>/dev/null | sed 's/^/    /' || echo "    (none)"; \
	else \
		echo "    (directory not found)"; \
	fi
	@echo "  🔧 Go tools:"
	@for project in $(GO_PROJECTS); do \
		project_path="tools/$$project"; \
		project_name="$$project"; \
		if [ -d "$$project_path" ]; then \
			if [ -f "$$project_path/go.mod" ]; then \
				echo "    ✅ $$project_name (ready)"; \
			else \
				echo "    ⚠️  $$project_name (no go.mod)"; \
			fi; \
		else \
			echo "    ❌ $$project_name (submodule not initialized)"; \
		fi \
	done

## init-submodules: initialize all submodules
init-submodules:
	@echo "🔄 Initializing all submodules..."
	@git submodule update --init --recursive

## clone-fresh: setup after fresh git clone
clone-fresh:
	@echo "🆕 Setting up fresh clone (run this after 'git clone')..."
	@git submodule update --init --recursive
	@make all

  