.PHONY: all clean install bash-tools go-tools clone-go dev-go git-hooks submodules update-submodules help default sync-skills stow-agents t3-antigravity-links

# Set default target
.DEFAULT_GOAL := default

## default: update submodules, clean, and build all tools
default: update-submodules clean all

# Directories
BIN_DIR := bin/.bin
BASH_DIR := tools/bash
GIT_HOOKS_DIR := git/.config/git/hooks

# Shared agent skills and instructions
SKILLS_DIR := agent-skills
CLAUDE_SKILLS_DIR := claude/.claude/skills
AGENT_STOW_PACKAGES := agents gemini
T3_ANTIGRAVITY_DIR ?= $(HOME)/.t3/userdata/providers/antigravity

# Platform-specific tools to ignore during build
DARWIN_IGNORE := pbcopy xdg-open
LINUX_IGNORE :=

# Standalone Go projects
GO_PROJECTS_DIR ?= $(HOME)/clones/ashrhmn
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

## sync-skills: link every agent-skills/<name> into claude/.claude/skills and prune stale links
sync-skills:
	@set -eu; \
	mkdir -p "$(CLAUDE_SKILLS_DIR)"; \
	for link in "$(CLAUDE_SKILLS_DIR)"/*; do \
		if [ -L "$$link" ] && [ ! -e "$$link" ]; then \
			case "$$(readlink "$$link")" in \
				../../../$(SKILLS_DIR)/*) rm "$$link"; echo "  pruned: $$link";; \
			esac; \
		fi; \
	done; \
	for skill in "$(SKILLS_DIR)"/*/; do \
		name=$$(basename "$$skill"); \
		[ -f "$(SKILLS_DIR)/$$name/SKILL.md" ] || continue; \
		link="$(CLAUDE_SKILLS_DIR)/$$name"; \
		target="../../../$(SKILLS_DIR)/$$name"; \
		if [ -L "$$link" ] && [ "$$(readlink "$$link")" = "$$target" ]; then continue; fi; \
		if [ -e "$$link" ] || [ -L "$$link" ]; then \
			echo "  conflict: $$link exists and is not a managed skill link" >&2; \
			exit 1; \
		fi; \
		ln -s "$$target" "$$link"; \
		echo "  linked: $$link"; \
	done

## stow-agents: sync Claude skill links and stow the shared agent packages (agents, gemini) without folding
stow-agents: sync-skills
	@stow --no-folding -R -d "$(CURDIR)" -t "$(HOME)" $(AGENT_STOW_PACKAGES)
	@echo "  stowed: $(AGENT_STOW_PACKAGES)"

## t3-antigravity-links: link ~/.gemini/config skills and AGENTS.md into T3 Code Antigravity profiles
t3-antigravity-links:
	@set -eu; \
	for config in "$(T3_ANTIGRAVITY_DIR)"/*/config; do \
		[ -d "$$config" ] || continue; \
		for item in skills AGENTS.md; do \
			link="$$config/$$item"; \
			target="$(HOME)/.gemini/config/$$item"; \
			if [ -L "$$link" ] && [ "$$(readlink "$$link")" = "$$target" ]; then continue; fi; \
			if [ -e "$$link" ] || [ -L "$$link" ]; then \
				echo "  skipped: $$link already exists" >&2; \
				continue; \
			fi; \
			ln -s "$$target" "$$link"; \
			echo "  linked: $$link"; \
		done; \
	done

## clone-go: clone missing Go projects into GO_PROJECTS_DIR
clone-go:
	@set -eu; \
	mkdir -p "$(GO_PROJECTS_DIR)"; \
	for project in $(GO_PROJECTS); do \
		project_path="$(GO_PROJECTS_DIR)/$$project"; \
		if [ ! -e "$$project_path" ]; then \
			git clone "git@github.com:ashrhmn/$$project.git" "$$project_path"; \
		elif [ ! -d "$$project_path/.git" ] || [ ! -f "$$project_path/go.mod" ]; then \
			echo "Invalid Go clone: $$project_path" >&2; \
			exit 1; \
		fi; \
	done

## go-tools: build Go tools from standalone clones
go-tools: clone-go
	@set -eu; \
	for project in $(GO_PROJECTS); do \
		$(MAKE) -C "$(GO_PROJECTS_DIR)/$$project" build BIN_DIR="$(abspath $(BIN_DIR))"; \
	done

## build-%: build specific go project (e.g., build-ts-flatten)
build-%:
	@set -eu; \
	project_name=$(subst build-,,$@); \
	project_path="$(GO_PROJECTS_DIR)/$$project_name"; \
	if [ -d "$$project_path/.git" ] && [ -f "$$project_path/go.mod" ]; then \
		$(MAKE) -C "$$project_path" build BIN_DIR="$(abspath $(BIN_DIR))"; \
	else \
		echo "Project $$project_name not found in $(GO_PROJECTS_DIR); run 'make clone-go'." >&2; \
		exit 1; \
	fi

## dev-go: run tests and tidy for all go projects
dev-go: clone-go
	@set -eu; \
	for project in $(GO_PROJECTS); do \
		(cd "$(GO_PROJECTS_DIR)/$$project" && go mod tidy && go test ./...); \
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
	@echo "  Go tools ($(GO_PROJECTS_DIR)):"
	@for project in $(GO_PROJECTS); do \
		project_path="$(GO_PROJECTS_DIR)/$$project"; \
		project_name="$$project"; \
		if [ -d "$$project_path" ]; then \
			if [ -f "$$project_path/go.mod" ]; then \
				echo "    $$project_name (ready)"; \
			else \
				echo "    $$project_name (no go.mod)"; \
			fi; \
		else \
			echo "    $$project_name (run 'make clone-go')"; \
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
