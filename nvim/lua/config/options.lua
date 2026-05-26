local opt = vim.opt

opt.clipboard = "unnamedplus"
opt.completeopt = "menu,menuone,noselect"
opt.confirm = true
opt.cursorline = true
-- Bind the block cursor to the Cursor highlight group so Neovim renders its
-- own (visible) cursor color instead of falling through to the terminal's
-- cursor color, which doesn't reliably switch with the theme (esp. via tmux).
opt.guicursor = "n-v-c-sm:block-Cursor,i-ci-ve:ver25-Cursor,r-cr-o:hor20-Cursor"
opt.expandtab = true
opt.fillchars = { eob = " ", fold = " " }
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.ignorecase = true
opt.inccommand = "nosplit"
opt.laststatus = 3
opt.list = false
opt.mouse = "a"
opt.number = true
opt.relativenumber = false
opt.pumheight = 10
opt.scrolloff = 4
opt.shiftround = true
opt.shiftwidth = 2
opt.showmode = false
opt.sidescrolloff = 8
opt.signcolumn = "yes"
opt.smartcase = true
opt.smartindent = true
opt.splitbelow = true
opt.splitright = true
opt.tabstop = 2
opt.termguicolors = true
opt.timeoutlen = 300
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200
opt.virtualedit = "block"
opt.wildmode = "longest:full,full"
opt.wrap = true

vim.lsp.inlay_hint.enable(false, {})
