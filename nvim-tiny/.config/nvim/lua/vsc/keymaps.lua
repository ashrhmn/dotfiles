-- VSCode-specific keymaps
-- Focus on motions and actions that VSCode doesn't provide or need enhancement

vim.g.mapleader = " "

local keymap = vim.keymap
local vscode = require('vscode')

-- ============================================
-- BASIC MOTIONS & EDITING (VSCode Integration)
-- ============================================

-- Essential escape mappings
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- Save and quit (use VSCode commands)
keymap.set("n", "<C-s>", function() vscode.action("workbench.action.files.save") end, { desc = "Save File" })
keymap.set("n", "<leader>w", function() vscode.action("workbench.action.files.save") end, { desc = "Save File" })
keymap.set("n", "<leader>wa", function() vscode.action("workbench.action.files.saveAll") end, { desc = "Save All Files" })

-- Close/quit (use VSCode commands)
keymap.set("n", "<C-q>", function() vscode.action("workbench.action.closeWindow") end, { desc = "Close Window" })
keymap.set("n", "<leader>q", function() vscode.action("workbench.action.closeActiveEditor") end, { desc = "Close Current Buffer" })
keymap.set("n", "<leader>bd", function() vscode.action("workbench.action.closeActiveEditor") end, { desc = "Close Current Buffer" })

-- Reload buffer
keymap.set("n", "<leader>rl", function() vscode.action("workbench.action.files.revert") end, { desc = "Reload Current Buffer" })

-- Clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- ============================================
-- WINDOW/PANE NAVIGATION (VSCode Integration)
-- ============================================

-- Navigate between editor groups (VSCode equivalent of vim panes)
keymap.set("n", "<C-h>", function() vscode.action("workbench.action.focusLeftGroup") end, { desc = "Focus Left Editor Group" })
keymap.set("n", "<C-l>", function() vscode.action("workbench.action.focusRightGroup") end, { desc = "Focus Right Editor Group" })
keymap.set("n", "<C-k>", function() vscode.action("workbench.action.focusAboveGroup") end, { desc = "Focus Above Editor Group" })
keymap.set("n", "<C-j>", function() vscode.action("workbench.action.focusBelowGroup") end, { desc = "Focus Below Editor Group" })

-- Split management (VSCode integration)
keymap.set("n", "<leader>sv", function() vscode.action("workbench.action.splitEditorRight") end, { desc = "Split Editor Right" })
keymap.set("n", "<leader>sh", function() vscode.action("workbench.action.splitEditorDown") end, { desc = "Split Editor Down" })
keymap.set("n", "<leader>se", function() vscode.action("workbench.action.evenEditorWidths") end, { desc = "Even Editor Widths" })
keymap.set("n", "<leader>sx", function() vscode.action("workbench.action.closeActiveEditor") end, { desc = "Close Active Editor" })

-- ============================================
-- TAB MANAGEMENT (VSCode Integration)
-- ============================================

keymap.set("n", "<leader>to", function() vscode.action("workbench.action.files.newUntitledFile") end, { desc = "New File" })
keymap.set("n", "<leader>tx", function() vscode.action("workbench.action.closeActiveEditor") end, { desc = "Close Current Tab" })
keymap.set("n", "<leader>tn", function() vscode.action("workbench.action.nextEditor") end, { desc = "Next Tab" })
keymap.set("n", "<leader>tp", function() vscode.action("workbench.action.previousEditor") end, { desc = "Previous Tab" })
keymap.set("n", "gt", function() vscode.action("workbench.action.nextEditor") end, { desc = "Next Tab" })
keymap.set("n", "gT", function() vscode.action("workbench.action.previousEditor") end, { desc = "Previous Tab" })

-- ============================================
-- LSP-LIKE ACTIONS (VSCode Integration)
-- ============================================

-- Formatting
keymap.set("n", "<leader>mp", function() vscode.action("editor.action.formatDocument") end, { desc = "Format Document" })
keymap.set("x", "<leader>mp", function() vscode.action("editor.action.formatSelection") end, { desc = "Format Selection" })

-- LSP actions
keymap.set("n", "<leader>rn", function() vscode.action("editor.action.rename") end, { desc = "Rename Symbol" })
keymap.set("n", "<leader>ca", function() vscode.action("editor.action.quickFix") end, { desc = "Code Actions" })
keymap.set("n", "gd", function() vscode.action("editor.action.revealDefinition") end, { desc = "Go to Definition" })
keymap.set("n", "gD", function() vscode.action("editor.action.revealDeclaration") end, { desc = "Go to Declaration" })
keymap.set("n", "gr", function() vscode.action("editor.action.goToReferences") end, { desc = "Go to References" })
keymap.set("n", "gi", function() vscode.action("editor.action.goToImplementation") end, { desc = "Go to Implementation" })
keymap.set("n", "gt", function() vscode.action("editor.action.goToTypeDefinition") end, { desc = "Go to Type Definition" })

-- Hover and peek
keymap.set("n", "K", function() vscode.action("editor.action.showHover") end, { desc = "Show Hover" })
keymap.set("n", "<leader>pd", function() vscode.action("editor.action.peekDefinition") end, { desc = "Peek Definition" })
keymap.set("n", "<leader>pr", function() vscode.action("editor.action.peekReferences") end, { desc = "Peek References" })

-- Diagnostics
keymap.set("n", "<leader>e", function() vscode.action("editor.action.showHover") end, { desc = "Show Line Diagnostics" })
keymap.set("n", "[d", function() vscode.action("editor.action.marker.prevInFiles") end, { desc = "Previous Diagnostic" })
keymap.set("n", "]d", function() vscode.action("editor.action.marker.nextInFiles") end, { desc = "Next Diagnostic" })

-- ============================================
-- SEARCH AND NAVIGATION (VSCode Integration)
-- ============================================

-- File searching
keymap.set("n", "<leader><leader>", function() vscode.action("workbench.action.quickOpen") end, { desc = "Find Files" })
keymap.set("n", "<leader>fg", function() vscode.action("workbench.action.findInFiles") end, { desc = "Find in Files" })
keymap.set("n", "<leader>fb", function() vscode.action("workbench.action.showAllEditors") end, { desc = "Find Buffers" })
keymap.set("n", "<leader>fr", function() vscode.action("workbench.action.openRecent") end, { desc = "Recent Files" })

-- Symbol searching
keymap.set("n", "<leader>fs", function() vscode.action("workbench.action.gotoSymbol") end, { desc = "Find Symbols" })
keymap.set("n", "<leader>fS", function() vscode.action("workbench.action.showAllSymbols") end, { desc = "Find Symbols in Workspace" })

-- Command palette
keymap.set("n", "<leader>fc", function() vscode.action("workbench.action.showCommands") end, { desc = "Command Palette" })

-- ============================================
-- EXPLORER/SIDEBAR (VSCode Integration)
-- ============================================

keymap.set("n", "<leader>e", function() vscode.action("workbench.action.toggleSidebarVisibility") end, { desc = "Toggle Sidebar" })
keymap.set("n", "<leader>o", function() vscode.action("workbench.files.action.focusFilesExplorer") end, { desc = "Focus File Explorer" })

-- ============================================
-- UTILITY FUNCTIONS
-- ============================================

-- Increment/decrement numbers
keymap.set("n", "<leader>=", "<C-a>", { desc = "Increment number" })
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

-- Better indenting in visual mode
keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })

-- Move lines up/down
keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- ============================================
-- TERMINAL (VSCode Integration)
-- ============================================

keymap.set("n", "<leader>t", function() vscode.action("workbench.action.terminal.toggleTerminal") end, { desc = "Toggle Terminal" })
keymap.set("t", "<ESC>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- ============================================
-- GIT INTEGRATION (VSCode Integration)
-- ============================================

keymap.set("n", "<leader>gg", function() vscode.action("workbench.view.scm") end, { desc = "Open Source Control" })
keymap.set("n", "<leader>gp", function() vscode.action("git.push") end, { desc = "Git Push" })
keymap.set("n", "<leader>gc", function() vscode.action("git.commit") end, { desc = "Git Commit" })
keymap.set("n", "<leader>gs", function() vscode.action("git.stage") end, { desc = "Git Stage" })

-- ============================================
-- DEBUGGING (VSCode Integration)
-- ============================================

keymap.set("n", "<F5>", function() vscode.action("workbench.action.debug.start") end, { desc = "Start Debugging" })
keymap.set("n", "<F9>", function() vscode.action("editor.debug.action.toggleBreakpoint") end, { desc = "Toggle Breakpoint" })
keymap.set("n", "<F10>", function() vscode.action("workbench.action.debug.stepOver") end, { desc = "Step Over" })
keymap.set("n", "<F11>", function() vscode.action("workbench.action.debug.stepInto") end, { desc = "Step Into" })

-- ============================================
-- MULTI-CURSOR (VSCode Integration)
-- ============================================

-- Add cursors (using different bindings to avoid conflict with scroll)
keymap.set("n", "<leader>md", function() vscode.action("editor.action.addSelectionToNextFindMatch") end, { desc = "Add Selection to Next Find Match" })
keymap.set("n", "<leader>mD", function() vscode.action("editor.action.addSelectionToPreviousFindMatch") end, { desc = "Add Selection to Previous Find Match" })
keymap.set("n", "<leader>ma", function() vscode.action("editor.action.selectHighlights") end, { desc = "Select All Occurrences" })

-- ============================================
-- FOLDING (VSCode Integration)
-- ============================================

keymap.set("n", "za", function() vscode.action("editor.toggleFold") end, { desc = "Toggle Fold" })
keymap.set("n", "zc", function() vscode.action("editor.fold") end, { desc = "Close Fold" })
keymap.set("n", "zo", function() vscode.action("editor.unfold") end, { desc = "Open Fold" })
keymap.set("n", "zC", function() vscode.action("editor.foldRecursively") end, { desc = "Close Fold Recursively" })
keymap.set("n", "zO", function() vscode.action("editor.unfoldRecursively") end, { desc = "Open Fold Recursively" })
keymap.set("n", "zM", function() vscode.action("editor.foldAll") end, { desc = "Close All Folds" })
keymap.set("n", "zR", function() vscode.action("editor.unfoldAll") end, { desc = "Open All Folds" })

-- ============================================
-- MISC HELPFUL MAPPINGS
-- ============================================

-- Center cursor when jumping
keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })
keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down (centered)" })
keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up (centered)" })

-- Prevent x from overriding clipboard
keymap.set("n", "x", '"_x', { desc = "Delete char without yanking" })

-- Better paste in visual mode
keymap.set("v", "p", '"_dP', { desc = "Paste without overriding register" }) 