-- Everyday defaults; project EditorConfig settings take precedence.
vim.opt.clipboard = "unnamedplus"
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.mouse = "a"
vim.opt.wrap = false
vim.opt.scrolloff = 6
vim.opt.sidescrolloff = 8
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.undofile = true
vim.opt.confirm = true
vim.opt.timeoutlen = 500
vim.opt.spelllang = { "en_us" }
vim.g.autoformat = true
vim.g.lazyvim_picker = "snacks"
vim.g.lazyvim_cmp = "blink.cmp"

-- GUI clients use guifont; terminal Neovim uses Kitty's matching font settings.
vim.opt.guifont = "JetBrainsMonoNL Nerd Font:h16"
vim.g.lazyvim_python_lsp = "pyright"
