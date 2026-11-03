local settings = require('config.settings')
local function configured(repo, module, opts)
  return {repo, main = module, opts = opts or {}}
end
return {
  {'catppuccin/nvim', name='catppuccin', priority=1000, config=function()
    require('catppuccin').setup({flavour='mocha', transparent_background=true, term_colors=true,
      integrations={cmp=true, noice=true, gitsigns=true, which_key=true, nvimtree=true,
        treesitter=true, telescope={enabled=true}, native_lsp={enabled=true,
          inlay_hints={background=true}, underlines={errors={'underline'}, hints={'underline'},
            information={'underline'}, warnings={'underline'}}}}})
    vim.cmd.colorscheme('catppuccin-mocha')
  end},
  configured('nvim-tree/nvim-web-devicons', 'nvim-web-devicons'),
  {'nvim-lua/plenary.nvim'},
  {'MunifTanjim/nui.nvim'},
  configured('folke/which-key.nvim', 'which-key', {show_keys=true}),
  configured('folke/persistence.nvim', 'persistence'),
  {'direnv/direnv.vim'},
  configured('ethanholz/nvim-lastplace', 'nvim-lastplace'),
  configured('windwp/nvim-autopairs', 'nvim-autopairs'),
  configured('max397574/better-escape.nvim', 'better_escape', {timeout=200}),
  {'christoomey/vim-tmux-navigator', commit='e41c431a0c7b7388ae7ba341f01a0d217eb3a432'},
  {'ThePrimeagen/vim-be-good'},
  {'akinsho/bufferline.nvim', dependencies={'nvim-tree/nvim-web-devicons'}, opts=settings.bufferline},
  configured('nvim-lualine/lualine.nvim', 'lualine', settings.lualine),
  configured('yamatsum/nvim-cursorline', 'nvim-cursorline', settings.cursorline),
  configured('hat0uma/csvview.nvim', 'csvview', {view={display_mode='border'}}),
  configured('numToStr/Comment.nvim', 'Comment'),
  configured('folke/trouble.nvim', 'trouble'),
  {'lewis6991/gitsigns.nvim', opts=settings.git},
  {'nvim-tree/nvim-tree.lua', dependencies={'nvim-tree/nvim-web-devicons'}, opts=settings.nvimtree},
  {'folke/noice.nvim', dependencies={'MunifTanjim/nui.nvim'}, opts=settings.noice},
  {'akinsho/toggleterm.nvim', version='*', opts=settings.toggleterm},
  {'DrKJeff16/project.nvim', main='project', opts=settings.project},
  {'smoka7/hop.nvim', config=function()
    local hop = require('hop')
    hop.setup({case_insensitive=false, dim_unmatched=true, jump_on_sole_occurrence=true,
      quit_key='<Esc>', reverse_distribution=false, teasing=true, virtual_cursor=true, x_bias=10})
    local map = vim.keymap.set
    map({'n','x','o'}, '<leader>hw', hop.hint_words, {desc='Hop words'})
    map({'n','x','o'}, '<leader>hc', hop.hint_char2, {desc='Hop two characters'})
    map({'n','x','o'}, '<leader>hl', hop.hint_lines_skip_whitespace, {desc='Hop lines'})
    for key, spec in pairs({f={'AFTER_CURSOR',0}, F={'BEFORE_CURSOR',0},
        t={'AFTER_CURSOR',-1}, T={'BEFORE_CURSOR',1}}) do
      map({'n','x','o'}, '<leader>'..key, function()
        hop.hint_char1({direction=require('hop.hint').HintDirection[spec[1]],
          current_line_only=true, hint_offset=spec[2]})
      end, {desc='Hop character'})
    end
  end},
  {'luukvbaal/statuscol.nvim', config=function()
    local builtin = require('statuscol.builtin')
    require('statuscol').setup({relculright=true, segments={
      {text={builtin.foldfunc}, click='v:lua.ScFa'},
      {text={'%s'}, click='v:lua.ScSa'},
      {text={builtin.lnumfunc,' '}, click='v:lua.ScLa'}}})
  end},
  {'kevinhwang91/nvim-ufo', dependencies={'kevinhwang91/promise-async'}, config=function()
    local ufo = require('ufo')
    ufo.setup(settings.ufo)
    vim.keymap.set('n', 'zR', ufo.openAllFolds, {desc='Open all folds'})
    vim.keymap.set('n', 'zM', ufo.closeAllFolds, {desc='Close all folds'})
    vim.keymap.set('n', 'zK', function()
      if not ufo.peekFoldedLinesUnderCursor() then vim.lsp.buf.hover() end
    end, {desc='Peek fold'})
  end},
  {'iamcco/markdown-preview.nvim', ft={'markdown'}, build=function()
    vim.fn['mkdp#util#install']()
  end, init=function()
    vim.g.mkdp_auto_close = 1
    vim.g.mkdp_page_title = '「${name}」'
    vim.g.mkdp_port = '8080'
    vim.g.mkdp_theme = 'dark'
    vim.g.mkdp_preview_options = {disable_filename=1, disable_sync_scroll=1, sync_scroll_type='middle'}
  end},
  {'goolord/alpha-nvim', dependencies={'nvim-tree/nvim-web-devicons'}, config=function()
    local dashboard = require('alpha.themes.dashboard')
    dashboard.section.header.val = {
      '███╗   ██╗██╗   ██╗██╗███╗   ███╗',
      '████╗  ██║██║   ██║██║████╗ ████║',
      '██╔██╗ ██║██║   ██║██║██╔████╔██║',
      '██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║',
      '██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║',
      '╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝'}
    dashboard.section.buttons.val = {
      dashboard.button('SPC ff', '󰈞  Find file', '<Cmd>Telescope find_files<CR>'),
      dashboard.button('SPC fn', '  New file', '<Cmd>ene<CR><Cmd>startinsert<CR>'),
      dashboard.button('SPC fr', '󰊄  Recently used files', '<Cmd>Telescope oldfiles<CR>'),
      dashboard.button('SPC fg', '󰈬  Live grep', '<Cmd>Telescope live_grep<CR>'),
      dashboard.button('SPC rs', '  Restore session', '<Cmd>lua require("persistence").load()<CR>'),
      dashboard.button('SPC qq', '  Quit Neovim', '<Cmd>qa<CR>')}
    dashboard.section.footer.val = 'Neovim · plain Lua'
    require('alpha').setup(dashboard.config)
    vim.keymap.set('n', '<leader>fn', '<Cmd>ene<CR><Cmd>startinsert<CR>', {desc='New file'})
    vim.keymap.set('n', '<leader>rs', function() require('persistence').load() end, {desc='Restore session'})
  end},
}
