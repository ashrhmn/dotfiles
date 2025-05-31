# Neovim + VSCode Dual Configuration

This Neovim configuration supports both standalone Neovim and VSCode integration through conditional loading.

## Configuration Structure

```
nvim/.config/nvim/
├── init.lua                 # Main entry point with conditional branching
├── lua/
│   ├── vscode/             # 🆚 VSCode-specific configurations
│   │   ├── README.md       # Detailed VSCode documentation
│   │   ├── options.lua     # VSCode-optimized vim options
│   │   ├── keymaps.lua     # VSCode API integration keymaps
│   │   └── plugins.lua     # Motion-focused plugins only
│   ├── keymaps.lua         # 🏠 Regular Neovim keymaps
│   ├── options.lua         # 🏠 Regular Neovim options
│   └── plugins/            # 🏠 Full Neovim plugin suite
└── VSCODE_INTEGRATION.md   # This file
```

## How It Works

The main `init.lua` detects the environment:

```lua
if vim.g.vscode then
    -- VSCode extension mode: load minimal motion-focused config
    require("vscode.options")
    require("vscode.keymaps")
    require("vscode.plugins")
else
    -- Regular Neovim: load full configuration
    require("options")
    require("keymaps")
    require("lazy").setup("plugins", { change_detection = { notify = false } })
end
```

## VSCode Mode Features

### ✅ What's Included

- **Enhanced motions**: Leap, surround, substitute
- **Text objects**: Targets.vim for advanced text manipulation
- **VSCode integration**: All your keybindings call VSCode APIs
- **Motion plugins**: Only plugins that enhance vim motions

### ❌ What's Excluded

- LSP (VSCode handles this)
- File explorers (VSCode has excellent built-in)
- Color schemes (VSCode themes)
- Completion engines (VSCode IntelliSense)
- Syntax highlighting (VSCode handles this)
- Git plugins (VSCode git integration)

## Key Benefits

1. **Best of both worlds**: VSCode's ecosystem + Vim's editing power
2. **No conflicts**: Separate plugin sets avoid interference
3. **Consistent keybindings**: Same muscle memory, different backends
4. **Optimized performance**: Minimal plugins in VSCode mode

## Usage Examples

### In Regular Neovim

```
<leader>ff  →  Telescope find files
<leader>rn  →  LSP rename symbol
<leader>mp  →  LSP format document
gd          →  LSP go to definition
```

### In VSCode + Neovim

```
<leader>ff  →  VSCode quick open
<leader>rn  →  VSCode rename symbol
<leader>mp  →  VSCode format document
gd          →  VSCode go to definition
```

### Shared Motions (Work in Both)

```
f           →  Leap forward motion
ysiw"       →  Surround word with quotes
cs"'        →  Change surrounding quotes
s{motion}   →  Substitute with motion
gcc         →  Comment line
```

## Installation

1. **Install VSCode Neovim extension**:

   ```
   ext install asvetliakov.vscode-neovim
   ```

2. **Configure VSCode settings**:

   ```json
   {
     "vscode-neovim.neovimExecutablePaths.darwin": "/opt/homebrew/bin/nvim",
     "editor.lineNumbers": "relative",
     "editor.cursorSurroundingLines": 8
   }
   ```

3. **Use your existing Neovim config**: The conditional loading handles everything automatically.

## Maintenance

- **Regular Neovim plugins**: Add to `lua/plugins/`
- **VSCode motion plugins**: Add to `lua/vscode/plugins.lua`
- **Shared keybindings**: Update both `lua/keymaps.lua` and `lua/vscode/keymaps.lua`
- **VSCode-specific bindings**: Update `vscode/keybindings.json`

## Philosophy

> Use VSCode for **project management** and **language features**.  
> Use Neovim for **precise text editing** and **motion workflows**.

This hybrid approach maximizes productivity by leveraging each tool's strengths.
