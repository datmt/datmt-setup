-- ~/.config/nvim/init.lua
-- init.lua
-- This is a basic Neovim configuration file in Lua.

-- Enable Syntax Highlighting
vim.cmd('syntax enable')

-- Line Numbers
vim.opt.number = true         -- Show line numbers
vim.opt.relativenumber = true -- Show relative line numbers for easier navigation

-- Vertical Bar (Color Column)
-- This adds a grey vertical line at the 80th character column.
vim.opt.colorcolumn = '80'
-- To make the vertical bar transparent grey, we need to set the highlight group.
-- This command sets the background of the ColorColumn to a dark grey.
-- Your terminal's transparency settings will determine how "transparent" it looks.
vim.api.nvim_set_hl(0, 'ColorColumn', { bg = '#404040' })

-- Current Line Highlight
vim.opt.cursorline = true
-- You can customize the highlight color if you wish.
-- For example, to set a light grey background for the cursor line:
-- vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#3c3836' })

-- Other useful settings you might like:
vim.opt.termguicolors = true -- Enable true color support
vim.opt.scrolloff = 8        -- Keep 8 lines of context around the cursor
vim.opt.sidescrolloff = 8    -- Keep 8 columns of context around the cursor
vim.opt.expandtab = true     -- Use spaces instead of tabs
vim.opt.shiftwidth = 2       -- Number of spaces for indentation
vim.opt.tabstop = 2          -- Number of spaces a tab character counts for
vim.opt.wrap = false         -- Disable line wrapping
vim.opt.clipboard = 'unnamedplus' -- Use system clipboard

print('Neovim config loaded!')


-- Setup lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)


require("lazy").setup({
  spec = {
    { import = "plugins" }, -- This imports everything in lua/plugins/
  },
})
-- Disable clipboard overwrite on delete/change
vim.keymap.set({"n", "v"}, "d", '"_d')
vim.keymap.set({"n", "v"}, "D", '"_D')
vim.keymap.set({"n", "v"}, "c", '"_c')
vim.keymap.set({"n", "v"}, "C", '"_C')
vim.keymap.set({"n", "v"}, "x", '"_x')
vim.keymap.set({"n", "v"}, "X", '"_X')
