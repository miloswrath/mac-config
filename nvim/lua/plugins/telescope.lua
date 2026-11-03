return {
  'nvim-telescope/telescope.nvim',
  dependencies={'nvim-lua/plenary.nvim',
    {'nvim-telescope/telescope-fzf-native.nvim', build='make'},
    'nvim-telescope/telescope-ui-select.nvim'},
  config=function()
    local telescope, actions = require('telescope'), require('telescope.actions')
    telescope.setup({defaults={layout_strategy='horizontal', sorting_strategy='ascending',
      set_env={COLORTERM='truecolor'}, prompt_prefix='   ', selection_caret='  ', entry_prefix='  ',
      color_devicons=true, layout_config={horizontal={prompt_position='top'}},
      file_ignore_patterns={'^node_modules/','^%.devenv/','^%.direnv/','^%.git/'},
      borderchars={'─','│','─','│','╭','╮','╯','╰'},
      vimgrep_arguments={'rg','-L','--color=never','--no-heading','--with-filename',
        '--line-number','--column','--smart-case','--fixed-strings'},
      mappings={i={['<esc>']=actions.close, ['<S-j>']=actions.move_selection_next,
        ['<S-k>']=actions.move_selection_previous, ['<C-j>']=actions.move_selection_next,
        ['<C-k>']=actions.move_selection_previous}}},
      pickers={buffers={sort_lastused=true, previewer=false, layout_config={width=0.3,height=0.4},
        mappings={i={['<C-D>']=actions.delete_buffer}, n={dd=actions.delete_buffer}}}},
      extensions={['ui-select']={require('telescope.themes').get_dropdown({})}}})
    telescope.load_extension('fzf')
    telescope.load_extension('ui-select')
    for key, action in pairs({['<leader><space>']='find_files', ['<leader>/']='live_grep',
      ['<leader>:']='command_history', ['<leader>ff']='find_files', ['<leader>fr']='oldfiles',
      ['<leader>fR']='resume', ['<leader>fg']='live_grep', ['<leader>fb']='buffers',
      ['<C-p>']='git_files', ['<leader>gc']='git_commits', ['<leader>gs']='git_status',
      ['<leader>sa']='autocommands', ['<leader>sb']='current_buffer_fuzzy_find',
      ['<leader>sc']='command_history', ['<leader>sC']='commands', ['<leader>sD']='diagnostics',
      ['<leader>sh']='help_tags', ['<leader>sH']='highlights', ['<leader>sk']='keymaps',
      ['<leader>sM']='man_pages', ['<leader>sm']='marks', ['<leader>so']='vim_options',
      ['<leader>sR']='resume', ['<leader>cs']='colorscheme'}) do
      vim.keymap.set('n', key, function() require('telescope.builtin')[action]() end, {desc=action})
    end
  end,
}
