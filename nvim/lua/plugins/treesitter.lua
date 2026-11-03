-- Treesitter's new API supports current Homebrew Neovim; keep the legacy API for 0.11.
local modern = vim.fn.has('nvim-0.12') == 1
local languages = {'nix','bash','cmake','make','python','rust','c','cpp','regex','gitcommit',
  'gitignore','markdown','markdown_inline','json','lua','toml','yaml','zig','eex','heex',
  'javascript','typescript','tsx','html','css','vim','vimdoc','query'}
return {
  'nvim-treesitter/nvim-treesitter', branch=modern and 'main' or 'master', lazy=false,
  build=':TSUpdate', config=function()
    if not modern then
      require('nvim-treesitter.configs').setup({ensure_installed=languages,
        highlight={enable=true}, indent={enable=true}, incremental_selection={enable=true}})
      return
    end
    local ts = require('nvim-treesitter')
    ts.setup({})
    ts.install(languages)
    local function enable(buf)
      local ft = vim.bo[buf].filetype
      local lang = vim.treesitter.language.get_lang(ft)
      if lang and pcall(vim.treesitter.start, buf, lang) then
        vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
    end
    vim.api.nvim_create_autocmd('FileType', {callback=function(e) enable(e.buf) end})
    -- Retry after initial asynchronous parser downloads finish.
    vim.api.nvim_create_autocmd('BufEnter', {callback=function(e) enable(e.buf) end})
  end,
}
