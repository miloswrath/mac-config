return {
  {'mfussenegger/nvim-dap', dependencies={'rcarriga/nvim-dap-ui','nvim-neotest/nvim-nio',
    'theHamsta/nvim-dap-virtual-text','leoluz/nvim-dap-go','mfussenegger/nvim-dap-python',
    'mason-org/mason.nvim'}, config=function()
    local dap, ui = require('dap'), require('dapui')
    ui.setup({floating={mappings={close={'<ESC>','q'}}}})
    require('nvim-dap-virtual-text').setup({})
    require('dap-go').setup({})
    local mason = vim.fn.stdpath('data') .. '/mason'
    require('dap-python').setup(mason .. '/packages/debugpy/venv/bin/python')
    for _, sign in ipairs({{'DapBreakpoint','●'},{'DapBreakpointCondition','●'},{'DapLogPoint','◆'}}) do
      vim.fn.sign_define(sign[1],{text=sign[2],texthl=sign[1]})
    end
    dap.listeners.before.attach.dapui_config = function() ui.open(); dap.repl.close() end
    dap.listeners.before.launch.dapui_config = function() ui.open(); dap.repl.close() end
    dap.listeners.before.event_terminated.dapui_config = function() ui.close() end
    dap.listeners.before.event_exited.dapui_config = function() ui.close() end
    -- CodeLLDB runs natively on macOS; Linux GDB and /nix/store paths are replaced.
    dap.adapters.codelldb = {type='server',port='${port}',executable={
      command=mason..'/bin/codelldb',args={'--port','${port}'}}}
    local function executable() return vim.fn.input('Path of executable: ',vim.fn.getcwd()..'/','file') end
    for _, ft in ipairs({'c','cpp','zig'}) do
      dap.configurations[ft] = {{name='Launch',type='codelldb',request='launch',
        program=executable,cwd='${workspaceFolder}',stopOnEntry=false}}
    end
    dap.configurations.rust = {{name='Launch',type='codelldb',request='launch',
      program=function() return vim.fn.getcwd()..'/target/debug/'..vim.fn.fnamemodify(vim.fn.getcwd(),':t') end,
      cwd='${workspaceFolder}',stopOnEntry=false,args={}}}
    -- A Java adapter is supplied by a project's Java tooling, as in upstream.
    dap.configurations.java = {{type='java',request='attach',name='Attach remote Java',
      hostName='127.0.0.1',port=5005}}
    local map = vim.keymap.set
    map({'n','i','v','x','t'},'<F5>',function()
      vim.cmd.stopinsert()
      require('nvim-tree.api').tree.close()
      for _, term in pairs(require('toggleterm.terminal').get_all()) do term:close() end
      dap.continue()
    end,{desc='Debug continue'})
    for _, key in ipairs({'<S-F5>','<F17>'}) do
      map({'n','i','v','x'},key,function() vim.cmd.stopinsert(); dap.terminate() end,{desc='Stop debugging'})
    end
    for key, action in pairs({['<F10>']='step_over',['<F11>']='step_into',['<F12>']='step_out'}) do
      map({'n','i'},key,function() dap[action]() end,{desc=action})
    end
    map('n','<leader>dt',ui.toggle,{desc='Toggle debugger UI'})
    map('n','<leader>b',dap.toggle_breakpoint,{desc='Toggle breakpoint'})
    map('n','<leader>dr',dap.repl.open,{desc='Debug REPL'})
    map('n','<leader>dl',dap.run_last,{desc='Run last debug session'})
  end},
  -- Retain the upstream terminal debugger integration for :GdbStartLLDB.
  {'sakhnik/nvim-gdb', build='bash install.sh'},
}
