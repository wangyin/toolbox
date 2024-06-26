-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymap = vim.keymap.set
local opts = { silent = true }

keymap("n", "0", "^", opts)
keymap("n", "^", "0", opts)
keymap("n", "<Char-0xAA>", ":w<CR>", opts)
keymap("n", "<Char-0xAB>", function() require("mini.bufremove").wipeout(0, false) end, opts)
keymap("n", "m", "%", opts)
keymap("n", "<leader>fn", ":Telescope notify<CR>", opts)

keymap("i", "jj", "<ESC>", opts)
keymap("i", "jk", "<ESC>", opts)

keymap("v", "J", ":move '>+1<CR>gv-gv", opts)
keymap("v", "K", ":move '<-2<CR>gv-gv", opts)
keymap("v", "m", "%", opts)
