return {
  {'mason-org/mason.nvim', opts={}},
  {'neovim/nvim-lspconfig', dependencies={'mason-org/mason.nvim','hrsh7th/cmp-nvim-lsp'},
    config=function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      capabilities.textDocument.foldingRange = {dynamicRegistration=false,lineFoldingOnly=true}
      vim.lsp.config('*', {capabilities=capabilities})
      vim.lsp.config('rust_analyzer', {settings={['rust-analyzer']={diagnostics={enable=true}}}})
      vim.api.nvim_create_autocmd('LspAttach', {callback=function(e)
        for key, action in pairs({gd='definition',gD='declaration',gi='implementation',gr='references',
          gt='type_definition',K='hover',['<leader>ca']='code_action',['<leader>rn']='rename',
          ['<leader>wa']='add_workspace_folder',['<leader>wr']='remove_workspace_folder'}) do
          vim.keymap.set('n', key, vim.lsp.buf[action], {buffer=e.buf,silent=true,desc=action})
        end
        -- Use insert mode for signature help so Ctrl-k still navigates tmux panes in normal mode.
        vim.keymap.set('i','<C-k>',vim.lsp.buf.signature_help,{buffer=e.buf,desc='Signature help'})
      end})
      vim.keymap.set('n','<leader>k',function() vim.diagnostic.jump({count=-1,float=true}) end,{desc='Previous diagnostic'})
      vim.keymap.set('n','<leader>j',function() vim.diagnostic.jump({count=1,float=true}) end,{desc='Next diagnostic'})
    end},
  {'mason-org/mason-lspconfig.nvim', dependencies={'mason-org/mason.nvim','neovim/nvim-lspconfig'},
    opts=function()
      local servers = {'rust_analyzer','lua_ls','yamlls','marksman','pyright','bashls',
        'clangd','cmake','gopls','jsonls','ts_ls','html'}
      -- Mason builds nil from source, which requires the Nix executable.
      if vim.fn.executable('nix') == 1 then table.insert(servers,'nil_ls') end
      return {ensure_installed=servers,automatic_enable=true}
    end},
  {'WhoIsSethDaniel/mason-tool-installer.nvim', dependencies={'mason-org/mason.nvim'},
    opts={ensure_installed={'alejandra','asmfmt','black','cmakelang','gofumpt','golines',
      'goimports','isort','prettier','prettierd','shfmt','stylua','eslint_d','luacheck',
      'markdownlint','commitlint','ruff','yamllint','codelldb','debugpy','delve'},
      auto_update=false, run_on_start=true, start_delay=1000}},
}
