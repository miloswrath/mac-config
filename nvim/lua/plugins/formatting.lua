return {
  {'stevearc/conform.nvim', config=function()
    local opts = require('config.settings').format
    -- Use the first available JS formatter instead of formatting twice.
    for _, ft in ipairs({'css','html','javascript','typescript','yaml'}) do
      opts.formatters_by_ft[ft].stop_after_first = true
    end
    require('conform').setup(opts)
    _G.format_with_conform = function()
      require('conform').format({lsp_format='fallback',async=false,timeout_ms=2000})
    end
    vim.keymap.set('n','<leader>fm',function()
      require('conform').format({async=true,lsp_format='fallback'})
    end,{desc='Format buffer'})
  end},
  {'mfussenegger/nvim-lint', config=function()
    local lint = require('lint')
    lint.linters_by_ft = {markdown={'markdownlint'},gitcommit={'commitlint'},
      javascript={'eslint_d'},javascriptreact={'eslint_d'},lua={'luacheck'},python={'ruff'},
      typescript={'eslint_d'},typescriptreact={'eslint_d'},yaml={'yamllint'}}
    -- Nix lint needs a Nix installation; keep it optional on this imperative setup.
    if vim.fn.executable('nix') == 1 then lint.linters_by_ft.nix = {'nix'} end
    local function run()
      local available = {}
      for _, name in ipairs(lint.linters_by_ft[vim.bo.filetype] or {}) do
        local linter = lint.linters[name]
        local cmd = type(linter)=='table' and linter.cmd or nil
        if type(cmd)=='function' then cmd=cmd() end
        if cmd and vim.fn.executable(cmd)==1 then table.insert(available,name) end
      end
      if #available>0 then lint.try_lint(available) end
    end
    vim.api.nvim_create_autocmd({'BufEnter','BufWritePost','InsertLeave'}, {
      group=vim.api.nvim_create_augroup('lint',{clear=true}),callback=run})
    vim.keymap.set('n','<leader>l',run,{desc='Lint current file'})
  end},
}
