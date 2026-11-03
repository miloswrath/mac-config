-- Imperative translation of miloswrath/nix-conf's selected Nixvim input.
if vim.fn.has('nvim-0.11.3') ~= 1 then
  error('This configuration needs Neovim 0.11.3 or newer. Run: brew upgrade neovim')
end
require('config.core')
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local output = vim.fn.system({'git', 'clone', '--filter=blob:none', '--branch=stable',
    'https://github.com/folke/lazy.nvim.git', lazypath})
  if vim.v.shell_error ~= 0 then
    error('Could not download lazy.nvim. Check GitHub access and reopen nvim.\n' .. output)
  end
end
vim.opt.rtp:prepend(lazypath)
require('lazy').setup('plugins', {
  defaults = {lazy = false},
  install = {colorscheme = {'catppuccin'}},
  checker = {enabled = false},
  change_detection = {notify = false},
})
require('config.autocmds')
