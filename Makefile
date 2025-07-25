.PHONY: all clean install bash-tools go-tools submodules update-submodules

# Directories
BIN_DIR := bin/.bin
BASH_DIR := tools/bash

# Platform-specific tools to ignore during build
DARWIN_IGNORE := pbcopy xdg-open
LINUX_IGNORE :=

# Go projects (as git submodules)
GO_PROJECTS := tools/ts-flatten tools/tsndexer tools/lctx

all: bash-tools go-tools

# Update git submodules
update-submodules:
	@echo "🔄 Updating git submodules..."
	@git submodule update --init --recursive 2>/dev/null || echo "⚠️  No submodules found or git not available"

# Bash tools - just copy and make executable
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

# Go tools - build each submodule project
go-tools: update-submodules
	@echo "🔧 Building Go tools..."
	@mkdir -p $(BIN_DIR)
	@for project in $(GO_PROJECTS); do \
		project_name=$$(basename "$$project"); \
		if [ -d "$$project" ] && [ -f "$$project/go.mod" ]; then \
			echo "  🔨 Building $$project_name..."; \
			cd "$$project" && \
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

# Build specific Go project
build-%:
	@project_name=$(subst build-,,$@); \
	project="tools/$$project_name"; \
	if [ -d "$$project" ] && [ -f "$$project/go.mod" ]; then \
		echo "🔨 Building $$project_name..."; \
		mkdir -p $(BIN_DIR); \
		cd "$$project" && \
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

# Development helpers
dev-go:
	@echo "🧪 Running Go development tasks..."
	@for project in $(GO_PROJECTS); do \
		project_name=$$(basename "$$project"); \
		if [ -d "$$project" ] && [ -f "$$project/go.mod" ]; then \
			echo "  📦 $$project_name: tidying and testing..."; \
			cd "$$project" && \
			go mod tidy && \
			go test ./... && \
			cd ../..; \
		fi \
	done

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

clean:
	@echo "🧹 Cleaning up..."
	@rm -rf $(BIN_DIR)/*

install: all
	@echo "📦 Tools built and ready for stow!"
	@echo "📋 Available binaries:"
	@ls -la $(BIN_DIR)/ 2>/dev/null || echo "  (none built)"

# Show what would be built
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
		project_name=$$(basename "$$project"); \
		if [ -d "$$project" ]; then \
			if [ -f "$$project/go.mod" ]; then \
				echo "    ✅ $$project_name (ready)"; \
			else \
				echo "    ⚠️  $$project_name (no go.mod)"; \
			fi; \
		else \
			echo "    ❌ $$project_name (submodule not initialized)"; \
		fi \
	done

# Submodule management
init-submodules:
	@echo "🔄 Initializing all submodules..."
	@git submodule update --init --recursive

clone-fresh:
	@echo "🆕 Setting up fresh clone (run this after 'git clone')..."
	@git submodule update --init --recursive
	@make all

# Help
help:
	@echo "🛠️  Dotfiles Tools Build System"
	@echo ""
	@echo "📋 Main targets:"
	@echo "  all              Build all tools (bash + go)"
	@echo "  bash-tools       Build only bash tools"
	@echo "  go-tools         Build only go tools"
	@echo "  clean            Remove all built binaries"
	@echo "  install          Build and show results"
	@echo ""
	@echo "🔧 Development:"
	@echo "  build-<project>  Build specific go project (e.g., build-ts-flatten)"
	@echo "  dev-go           Run tests and tidy for all go projects"
	@echo "  lint-bash        Lint bash scripts with shellcheck"
	@echo ""
	@echo "📦 Submodules:"
	@echo "  init-submodules  Initialize git submodules"
	@echo "  update-submodules Update existing submodules"
	@echo "  clone-fresh      Setup after fresh git clone"
	@echo ""
	@echo "📋 Info:"
	@echo "  show             Show available tools"
	@echo "  help             Show this help" 
