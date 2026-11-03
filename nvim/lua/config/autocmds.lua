-- Upstream autocmds, with directory names passed safely to :cd.
vim.api.nvim_create_augroup("YankHighlight", { ["clear"] = true })
vim.api.nvim_create_augroup("bufcheck", { ["clear"] = true })
vim.api.nvim_create_augroup("large_buf", { ["clear"] = true })
vim.api.nvim_create_augroup("close-with-q", { ["clear"] = true })
vim.api.nvim_create_augroup("auto_open_nvimtree", { ["clear"] = true })
vim.api.nvim_create_augroup("alpha_autostart", { ["clear"] = true })
vim.api.nvim_create_augroup("wrap_spell", { ["clear"] = true })
vim.api.nvim_create_augroup("terminal_settings", { ["clear"] = true })
vim.api.nvim_create_augroup("UserLspConfig", {  })
vim.api.nvim_create_autocmd("TextYankPost", { ["group"] = "YankHighlight", ["pattern"] = "*", ["callback"] = 
          function()
            vim.highlight.on_yank({
              higroup = 'IncSearch',
              timeout = 40,
            })
          end
         })
vim.api.nvim_create_autocmd({ "TermOpen", "TermEnter" }, { ["group"] = "terminal_settings", ["pattern"] = "term://*", ["command"] = "startinsert!" })
vim.api.nvim_create_autocmd("Filetype", { ["group"] = "close-with-q", ["pattern"] = { "PlenaryTestPopup", "help", "lspinfo", "man", "notify", "qf", "query", "spectre_panel", "startuptime", "tsplayground", "neotest-output", "checkhealth", "neotest-summary", "neotest-output-panel" }, ["callback"] = 
          function(data)
            vim.bo[data.buf].buflisted = false
            vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = data.buf, silent = true })
          end
         })
vim.api.nvim_create_autocmd("FileType", { ["group"] = "wrap_spell", ["pattern"] = { "gitcommit", "markdown" }, ["callback"] = 
          function()
            vim.opt_local.wrap = true
            vim.opt_local.spell = true
          end
         })
vim.api.nvim_create_autocmd("VimEnter", { ["group"] = "auto_open_nvimtree", ["callback"] = function(data)
 if vim.fn.isdirectory(data.file) == 1 then
   vim.api.nvim_set_current_dir(data.file)
   require('nvim-tree.api').tree.open()
 end
end })

