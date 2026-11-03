-- Plain Lua translation of the upstream core options and mappings.
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
local options = { ["number"] = true, ["relativenumber"] = true, ["tabstop"] = 2, ["softtabstop"] = 2, ["showtabline"] = 2, ["expandtab"] = true, ["smartindent"] = true, ["shiftwidth"] = 2, ["breakindent"] = true, ["hlsearch"] = true, ["incsearch"] = true, ["wrap"] = false, ["splitbelow"] = true, ["splitright"] = true, ["mouse"] = "a", ["ignorecase"] = true, ["smartcase"] = true, ["grepprg"] = "rg --vimgrep", ["grepformat"] = "%f:%l:%c:%m", ["fillchars"] = "eob: ,fold: ,foldopen:,foldsep: ,foldclose:", ["updatetime"] = 50, ["completeopt"] = { "menuone", "noselect", "noinsert" }, ["undofile"] = true, ["termguicolors"] = true, ["signcolumn"] = "yes", ["cursorline"] = true, ["foldcolumn"] = "1", ["foldlevel"] = 99, ["foldlevelstart"] = 99, ["foldenable"] = true, ["scrolloff"] = 10, ["timeoutlen"] = 10, ["encoding"] = "utf-8", ["fileencoding"] = "utf-8", ["sessionoptions"] = "blank,buffers,curdir,folds,globals,help,options,tabpages,winsize,winpos,terminal,localoptions", ["clipboard"] = "unnamedplus" }
for name, value in pairs(options) do vim.opt[name] = value end
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
local map = vim.keymap.set
map("v", "p", "\"_dP", { ["desc"] = "Paste over currently selected text without yanking it", ["silent"] = true })
map("n", "<leader>sr", ":%s/<C-r><C-w>/<C-r><C-w>/gI<Left><Left><Left>", { ["desc"] = "Rename symbol with regex", ["silent"] = true })
map("n", "<C-s>", "<CMD>w<CR>", { ["desc"] = "Save file", ["silent"] = true })
map("n", "<leader>qq", "<CMD>quitall<CR>", { ["desc"] = "Quit all", ["silent"] = true })
map("n", "<leader>fy", "<CMD> %y <CR>", { ["desc"] = "Yank file contents", ["silent"] = true })
map("n", "<leader>fp", "<CMD> %d_<CR>Vp", { ["desc"] = "Paste file contents", ["silent"] = true })
map("n", "<ESC>", "<CMD>nohlsearch<CR>", { ["silent"] = true })
map("n", "<leader>bd", "<CMD>bdelete<CR>", { ["desc"] = "Delete buffer", ["silent"] = true })
map("n", "<A-k>", "<CMD>m .-2<CR>==", { ["desc"] = "Move text up", ["silent"] = true })
map("n", "<A-j>", "<CMD>m .+1<CR>==", { ["desc"] = "Move text down", ["silent"] = true })
map({ "v", "x" }, "<A-k>", "<CMD>m '<-2<CR>gv=gv", { ["desc"] = "Move text up", ["silent"] = true })
map({ "v", "x" }, "<A-j>", "<CMD>m '>+1<CR>gv=gv", { ["desc"] = "Move text down", ["silent"] = true })
map("x", "K", "<CMD>m '<-2<CR>gv=gv", { ["desc"] = "Move text up", ["silent"] = true })
map("x", "J", "<CMD>m '>+1<CR>gv=gv", { ["desc"] = "Move text down", ["silent"] = true })
map("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { ["desc"] = "Cycle to next buffer", ["silent"] = true })
map("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { ["desc"] = "Cycle to previous buffer", ["silent"] = true })
map("n", "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", { ["desc"] = "Delete other buffers", ["silent"] = true })
map("n", "<leader>br", "<cmd>BufferLineCloseRight<cr>", { ["desc"] = "Delete buffers to the right", ["silent"] = true })
map("n", "<leader>bl", "<cmd>BufferLineCloseLeft<cr>", { ["desc"] = "Delete buffers to the left", ["silent"] = true })
map("n", "<leader>bp", "<cmd>BufferLineTogglePin<cr>", { ["desc"] = "Toggle pin", ["silent"] = true })
map("n", "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", { ["desc"] = "Delete non-pinned buffers", ["silent"] = true })
map("n", "<C-n>", "<cmd>NvimTreeFindFileToggle<CR>", { ["silent"] = true })

map('n', '<leader>gg', function()
  if not vim.env.TMUX then return vim.notify('Open Neovim inside tmux to use Lazygit', vim.log.levels.WARN) end
  vim.system({'tmux', 'new-window', '-c', vim.fn.getcwd(), 'lazygit'})
end, {desc = 'Lazygit'})
map('n', '<leader>ac', function()
  if not vim.env.TMUX then return vim.notify('Open Neovim inside tmux to split a pane', vim.log.levels.WARN) end
  vim.system({'tmux', 'split-window', '-p', '42', '-v', '-c', vim.fn.getcwd()})
end, {desc = 'Tmux split'})
-- Keep Ctrl-h/j/k/l consistent across editor windows, terminals, and tmux panes.
for key, direction in pairs({h='Left', j='Down', k='Up', l='Right'}) do
  map({'n', 't'}, '<C-' .. key .. '>', '<Cmd>TmuxNavigate' .. direction .. '<CR>', {silent=true})
end

