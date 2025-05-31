# VSCode Neovim Configuration

This directory contains Neovim configurations specifically optimized for use with the [VSCode Neovim extension](https://github.com/vscode-neovim/vscode-neovim).

## Philosophy

This configuration focuses on **motion and editing enhancements** while leveraging VSCode's built-in features for:

- ✅ **LSP** (Language Server Protocol)
- ✅ **Debugging**
- ✅ **File exploration**
- ✅ **Git integration**
- ✅ **Syntax highlighting**
- ✅ **Auto-completion**
- ✅ **Snippets**
- ✅ **Multi-cursor**

## What's Included

### Core Motion Plugins

1. **Leap** (`ggandor/leap.nvim`)

   - Enhanced `f` and `F` motions for quick navigation
   - Jump to any visible location with 2-3 keystrokes

2. **Surround** (`kylechui/nvim-surround`)

   - Add/change/delete surrounding characters
   - `ys{motion}{char}`, `cs{old}{new}`, `ds{char}`

3. **Substitute** (`gbprod/substitute.nvim`)
   - Better substitute operations with motions
   - `s{motion}`, `ss` (line), `S` (to end of line)

### Text Objects & Motions

4. **Targets** (`wellle/targets.vim`)

   - Additional text objects: `cin)`, `da,`, etc.

5. **Matchup** (`andymass/vim-matchup`)

   - Enhanced `%` matching for brackets, tags, keywords

6. **Comment** (`numToStr/Comment.nvim`)
   - Vim-like commenting motions: `gcc`, `gc{motion}`

### Utilities

7. **Which-key** (`folke/which-key.nvim`)

   - Minimal keybinding help (complements VSCode command palette)

8. **Better Escape** (`max397574/better-escape.nvim`)

   - Enhanced `jk` escape sequence

9. **Visual Multi** (`mg979/vim-visual-multi`)
   - Vim motions for multi-cursor operations

## Key Bindings

### Essential Motions

- `f` / `F` → Leap forward/backward
- `jk` → Exit insert mode
- `s{motion}` → Substitute with motion
- `ys{motion}{char}` → Surround with character
- `cs{old}{new}` → Change surrounding
- `ds{char}` → Delete surrounding

### VSCode Integration

- `<leader>w` → Save file
- `<leader>mp` → Format document
- `<leader>rn` → Rename symbol
- `<leader>ca` → Code actions
- `gd` → Go to definition
- `gr` → Go to references
- `K` → Show hover
- `<leader>ff` → Find files
- `<leader>fg` → Find in files

### Window Management

- `<C-h/j/k/l>` → Navigate editor groups
- `<leader>sv/sh` → Split editor right/down
- `<leader>sx` → Close active editor

### Multi-cursor

- `<leader>md` → Add selection to next find match
- `<leader>ma` → Select all occurrences

## Configuration Structure

```
lua/vscode/
├── README.md     # This file
├── options.lua   # VSCode-specific vim options
├── keymaps.lua   # VSCode integration keymaps
└── plugins.lua   # Motion-focused plugin setup
```

## Installation

The configuration is automatically loaded when `vim.g.vscode` is true (when running in VSCode with the Neovim extension).

## What's Excluded

To avoid conflicts with VSCode's built-in features, the following are **not** included:

- ❌ LSP configurations
- ❌ Treesitter syntax highlighting
- ❌ Color schemes
- ❌ Status lines
- ❌ File explorers (neo-tree, oil)
- ❌ Fuzzy finders (telescope - VSCode has built-in)
- ❌ Git status plugins (VSCode has excellent git integration)
- ❌ Auto-pairs (VSCode handles this)
- ❌ Completion engines (VSCode handles this)

## Tips

1. **Use VSCode for project-wide operations** (find/replace, debugging, git)
2. **Use Neovim motions for precise editing** (leap, surround, text objects)
3. **Combine both** for maximum productivity

## VSCode Settings

For optimal experience, consider these VSCode settings:

```json
{
  "vscode-neovim.neovimInitVimPaths.darwin": "/path/to/your/init.lua",
  "vscode-neovim.neovimExecutablePaths.darwin": "/opt/homebrew/bin/nvim",
  "editor.lineNumbers": "relative",
  "editor.cursorSurroundingLines": 8
}
```

## Troubleshooting

1. **Plugins not loading**: Ensure Lazy.nvim can access the internet for downloads
2. **Conflicting keybindings**: Check VSCode keybindings and adjust if needed
3. **Performance issues**: Try disabling plugins one by one to identify conflicts

## Custom Extensions

If you need additional functionality, prioritize VSCode extensions over Neovim plugins when possible to maintain the hybrid approach philosophy.
