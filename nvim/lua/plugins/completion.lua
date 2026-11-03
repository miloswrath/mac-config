return {
  {'L3MON4D3/LuaSnip', version='v2.*', build='make install_jsregexp'},
  {'hrsh7th/nvim-cmp', dependencies={'L3MON4D3/LuaSnip','hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-nvim-lua','hrsh7th/cmp-buffer','hrsh7th/cmp-path','saadparwaiz1/cmp_luasnip',
    'zbirenbaum/copilot-cmp','Saecki/crates.nvim'}, config=function()
      local cmp = require('cmp')
      cmp.setup({snippet={expand=function(args) require('luasnip').lsp_expand(args.body) end},
        experimental={ghost_text=true}, performance={debounce=60,fetching_timeout=200,max_view_entries=30},
        formatting={fields={'kind','abbr','menu'}},
        window={completion=cmp.config.window.bordered(), documentation=cmp.config.window.bordered()},
        sources={{name='copilot'},{name='nvim_lsp'},{name='luasnip'},
          {name='buffer'},{name='nvim_lua'},{name='path'}},
        mapping=cmp.mapping.preset.insert({
          ['<C-s>']=cmp.mapping.confirm({select=true}),
          ['<S-CR>']=cmp.mapping.confirm({behavior=cmp.ConfirmBehavior.Replace,select=true}),
          ['<C-Space>']=cmp.mapping.complete(), ['<C-j>']=cmp.mapping.select_next_item(),
          ['<C-k>']=cmp.mapping.select_prev_item(), ['<C-n>']=cmp.mapping.select_next_item(),
          ['<C-p>']=cmp.mapping.select_prev_item(), ['<C-e>']=cmp.mapping.close()})})
    end},
  {'Saecki/crates.nvim', dependencies={'nvim-lua/plenary.nvim'},
    opts={lsp={enabled=true,completion=true}}},
  {'LnL7/vim-nix'},
  {'zbirenbaum/copilot.lua', event='InsertEnter', opts={suggestion={enabled=false}, panel={enabled=false}}},
  {'zbirenbaum/copilot-cmp', dependencies={'zbirenbaum/copilot.lua'}, opts={}},
  {'CopilotC-Nvim/CopilotChat.nvim', cmd={'CopilotChat','CopilotChatExplain','CopilotChatOptimize'},
    dependencies={'nvim-lua/plenary.nvim','zbirenbaum/copilot.lua'},
    opts={window={layout='float',relative='editor',width=0.6,height=0.5,row=1,col=2}},
    keys={{'<leader>cc','<Cmd>CopilotChat<CR>',desc='Copilot chat'},
      {'<leader>ce','<Cmd>CopilotChatExplain<CR>',mode={'n','v'},desc='Copilot explain'},
      {'<leader>co','<Cmd>CopilotChatOptimize<CR>',mode={'n','v'},desc='Copilot optimize'}}},
}
