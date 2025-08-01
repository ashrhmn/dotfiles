# Ash's Dotfiles

This repository contains my personal configuration files for various development tools and utilities. The setup is designed to be modular, portable, and easily managed across multiple machines using `make` and `stow`.

## Philosophy

The core idea is to separate configurations into self-contained modules (e.g., `nvim`, `git`, `zshrc`) that can be selectively installed using [GNU Stow](https://www.gnu.org/software/stow/). Custom scripts and tools are built from source using a unified `Makefile`, ensuring all binaries are located in a single, easily managed directory.

## What's Inside?

This repository includes:

-   **Application Configurations**: Settings for terminal emulators, shells, editors, and window managers.
-   **Custom CLI Tools**: A collection of bash scripts and Go programs to automate and enhance my workflow.
-   **Build System**: A `Makefile` to build all Go tools and install scripts.

---

## Prerequisites

Before you begin, ensure you have the following installed on your system:

-   **`git`**: For cloning the repository.
-   **`stow`**: For symlinking the configuration files.
-   **`make`**: For building the custom tools.
-   **`go`**: For compiling the Go programs.
-   The applications you intend to configure (e.g., `neovim`, `tmux`, `alacritty`, etc.).

## Installation

1.  **Clone the repository** to your home directory:
    ```bash
    git clone https://github.com/your-username/dotfiles.git ~/dotfiles
    ```

2.  **Navigate into the repository**:
    ```bash
    cd ~/dotfiles
    ```

3.  **Build and install all custom tools**:
    The `Makefile` will compile the Go programs and copy the bash scripts into the `bin/.bin` directory.
    ```bash
    make install
    ```

4.  **Stow the configurations**:
    Use `stow` to create symlinks from this repository to your home directory. You can stow configurations individually or all at once.

    ```bash
    # Example: Stow the Neovim configuration
    stow nvim

    # Example: Stow the Git and Zsh configurations
    stow git zshrc

    # Stow all configurations (use with caution, review directories first)
    stow *
    ```
    **Note**: `stow` will only create symlinks if there are no conflicting files in the target location (e.g., `~/.zshrc`).

---

## Tooling Breakdown

### Custom Scripts (`tools/`)

All scripts are built and placed in `bin/.bin/`, which should be added to your `PATH`.

| Script       | Description                                                                                                                            | Language |
| :----------- | :------------------------------------------------------------------------------------------------------------------------------------- | :------- |
| `aicommit`   | Generates a conventional commit message using Gemini, based on staged changes and recent commit history. Excludes lockfiles.             | Bash     |
| `ccd`        | A CLI tool to manage and switch between multiple configuration profiles for the Claude/Gemini CLI.                                       | Bash     |
| `cpg`        | (Copy Git) Copies the contents of one git repository to one or more target repositories, with options to prune and ignore files.         | Bash     |
| `lctx`       | (LLM Context) Manages context files for LLM tools by symlinking them from a central repo to project directories using `stow`.            | Go       |
| `pbcopy`     | A wrapper that enables copying to the system clipboard over an SSH session using OSC 52 escape codes.                                  | Bash     |
| `pm2logs`    | Streams logs for all applications defined in an `ecosystem.config.cjs` file, making it easy to monitor all `pm2` processes at once.      | Bash     |
| `spf`        | (SSH Port Forwarder) A robust manager for creating, naming, and persisting SSH tunnel configurations for easy reuse.                      | Bash     |
| `ts-flatten` | A CLI tool that flattens TypeScript files by recursively inlining all local imports while preserving external ones.                      | Go       |
| `tsndexer`   | A utility that recursively scans a TypeScript project and generates `index.ts` or `index.tsx` files for all directories.                 | Go       |
| `xdg-open`   | A wrapper for `xdg-open`. If used in an SSH session on a URL, it copies the URL to the clipboard instead of trying to open it remotely. | Bash     |

### Managed Configurations

These directories contain the configuration files for various applications. Use `stow <directory-name>` to install one.

| Directory      | Application                                                              |
| :------------- | :----------------------------------------------------------------------- |
| `aerospace`    | Tiling window manager for macOS.                                         |
| `alacritty`    | A fast, cross-platform, OpenGL terminal emulator.                        |
| `git`          | Version control system, includes `.gitconfig` and global `.gitignore`.   |
| `helix`        | A post-modern modal text editor.                                         |
| `hypr`         | Hyprland, a dynamic tiling Wayland compositor.                           |
| `kanata`       | A cross-platform keyboard remapper.                                      |
| `keyd`         | A key remapping daemon for Linux.                                        |
| `kitty`        | A fast, feature-rich, GPU-based terminal emulator.                       |
| `lazy-nvim`    | LazyVim starter template configuration.                                  |
| `nvim`         | Neovim, a hyperextensible Vim-based text editor (main configuration).    |
| `rofi`         | A window switcher, application launcher, and dmenu replacement.          |
| `skhd`         | A simple hotkey daemon for macOS.                                        |
| `tmux`         | A terminal multiplexer.                                                  |
| `vscode`       | Visual Studio Code `keybindings.json`.                                   |
| `waybar`       | A highly customizable Wayland bar for Sway and Wlroots-based compositors.|
| `wofi`         | A launcher/menu program for wlroots-based Wayland compositors.           |
| `yabai`        | A tiling window manager for macOS.                                       |
| `yazi`         | A terminal file manager.                                                 |
| `zed`          | A high-performance, multiplayer code editor.                             |
| `zshrc`        | Configuration for the Z shell (`.zshrc`).                                |

---

## Usage

### Updating

To update your local configurations after pulling changes from this repository:

1.  **Pull the latest changes**:
    ```bash
    cd ~/dotfiles
    git pull
    ```

2.  **Re-build the tools**:
    ```bash
    make install
    ```

3.  **Re-stow configurations**:
    Stow will automatically update any symlinks that have changed.
    ```bash
    # Example for a single updated config
    stow nvim

    # Or re-stow everything
    stow *
    ```

### Adding a New Configuration

1.  Create a new directory in `~/dotfiles` (e.g., `newapp`).
2.  Inside `newapp`, replicate the directory structure for the configuration file (e.g., `.config/newapp/config.toml`).
3.  Move your configuration file into that new structure.
4.  Run `stow newapp` to symlink it.

## License

This project is licensed under the MIT License.
