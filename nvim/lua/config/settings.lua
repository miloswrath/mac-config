-- Translated from nixvim-but-worse at 66d4eb08e9ffc6778b6cc93426da32463e3413c7.
return {
  ["bufferline"] = {
    ["options"] = {
      ["offsets"] = {
        {
          ["filetype"] = "NvimTree",
          ["text"] = "File Explorer",
          ["text_align"] = "left"
        }
      },
      ["separator_style"] = "thin",
      ["indicator"] = {
        ["icon"] = "▎"
      },
      ["modified_icon"] = "●",
      ["buffer_close_icon"] = "",
      ["close_icon"] = "",
      ["left_trunc_marker"] = "",
      ["right_trunc_marker"] = "",
      ["numbers"] = "ordinal",
      ["tab_size"] = 21,
      ["show_buffer_icons"] = true,
      ["show_buffer_close_icons"] = false
    }
  },
  ["cursorline"] = {
    ["cursorline"] = {
      ["enable"] = true,
      ["timeout"] = 0,
      ["number"] = true
    },
    ["cursorword"] = {
      ["enable"] = true,
      ["hl"] = {
        ["underline"] = true
      }
    }
  },
  ["csv-viewer"] = {
    ["display_mode"] = "border"
  },
  ["format"] = {
    ["formatters_by_ft"] = {
      ["asm"] = {
        "asmfmt"
      },
      ["c"] = {
        "astyle"
      },
      ["cpp"] = {
        "astyle"
      },
      ["css"] = {
        "prettierd",
        "prettier"
      },
      ["cmake"] = {
        "cmake_format"
      },
      ["go"] = {
        "goimports",
        "gofumpt",
        "golines"
      },
      ["html"] = {
        "prettierd",
        "prettier"
      },
      ["javascript"] = {
        "prettierd",
        "prettier"
      },
      ["javascriptreact"] = {
        "prettier"
      },
      ["json"] = {
        "prettier"
      },
      ["lua"] = {
        "stylua"
      },
      ["markdown"] = {
        "prettier"
      },
      ["nix"] = {
        "alejandra"
      },
      ["python"] = {
        "isort",
        "black"
      },
      ["rust"] = {
        "rustfmt"
      },
      ["sh"] = {
        "shfmt"
      },
      ["typescript"] = {
        "prettierd",
        "prettier"
      },
      ["typescriptreact"] = {
        "prettier"
      },
      ["yaml"] = {
        "prettierd",
        "prettier"
      }
    },
    ["formatters"] = {
      ["asmfmt"] = {
        ["command"] = "asmfmt",
        ["stdin"] = true
      }
    }
  },
  ["git"] = {
    ["trouble"] = true,
    ["current_line_blame"] = true,
    ["signs"] = {
      ["add"] = {
        ["text"] = "│"
      },
      ["change"] = {
        ["text"] = "│"
      },
      ["delete"] = {
        ["text"] = "_"
      },
      ["topdelete"] = {
        ["text"] = "‾"
      },
      ["changedelete"] = {
        ["text"] = "~"
      },
      ["untracked"] = {
        ["text"] = "│"
      }
    }
  },
  ["lualine"] = {
    ["extensions"] = {
      "nvim-tree",
      "nvim-dap-ui",
      "toggleterm",
      "quickfix"
    },
    ["options"] = {
      ["globalstatus"] = true,
      ["disabled_filetypes"] = {
        ["statusline"] = {
          "dashboard",
          "alpha"
        }
      },
      ["component_separators"] = {
        ["left"] = "",
        ["right"] = ""
      },
      ["section_separators"] = {
        ["left"] = "",
        ["right"] = ""
      },
      ["refresh"] = {
        ["statusline"] = 1000,
        ["tabline"] = 1000,
        ["winbar"] = 1000
      }
    },
    ["sections"] = {
      ["lualine_c"] = {
        "filename"
      },
      ["lualine_x"] = {
        "location"
      }
    },
    ["tabline"] = {},
    ["winbar"] = {},
    ["inactive_winbar"] = {}
  },
  ["noice"] = {
    ["notify"] = {
      ["enabled"] = false
    },
    ["messages"] = {
      ["enabled"] = true
    },
    ["lsp"] = {
      ["message"] = {
        ["enabled"] = true
      },
      ["progress"] = {
        ["enabled"] = false,
        ["view"] = "mini"
      }
    },
    ["popupmenu"] = {
      ["enabled"] = true,
      ["backend"] = "nui"
    },
    ["format"] = {
      ["filter"] = {
        ["pattern"] = {
          ":%s*%%s*s:%s*",
          ":%s*%%s*s!%s*",
          ":%s*%%s*s/%s*",
          "%s*s:%s*",
          ":%s*s!%s*",
          ":%s*s/%s*"
        },
        ["icon"] = "",
        ["lang"] = "regex"
      },
      ["replace"] = {
        ["pattern"] = {
          ":%s*%%s*s:%w*:%s*",
          ":%s*%%s*s!%w*!%s*",
          ":%s*%%s*s/%w*/%s*",
          "%s*s:%w*:%s*",
          ":%s*s!%w*!%s*",
          ":%s*s/%w*/%s*"
        },
        ["icon"] = "󱞪",
        ["lang"] = "regex"
      }
    }
  },
  ["nvimtree"] = {
    ["sync_root_with_cwd"] = false,
    ["respect_buf_cwd"] = false,
    ["update_focused_file"] = {
      ["enable"] = true,
      ["update_root"] = true
    },
    ["git"] = {
      ["enable"] = true
    },
    ["filters"] = {
      ["git_ignored"] = false
    },
    ["actions"] = {
      ["open_file"] = {
        ["quit_on_open"] = true
      }
    },
    ["view"] = {
      ["side"] = "left",
      ["signcolumn"] = "no",
      ["preserve_window_proportions"] = true,
      ["float"] = {
        ["open_win_config"] = {
          ["col"] = 1,
          ["row"] = 1,
          ["relative"] = "editor",
          ["border"] = "rounded"
        }
      }
    }
  },
  ["project"] = {
    ["telescope"] = {
      ["enabled"] = false
    },
    ["lsp"] = {
      ["enabled"] = true
    },
    ["use_pattern"] = true,
    ["exclude_dirs"] = {
      "~/.local/*",
      "~/.cache/*",
      "~/.cargo/*",
      "~/.node_modules/*",
      "~/.pnpm-store/*",
      "~/.local/share/pnpm/*"
    },
    ["patterns"] = {
      "flake.nix",
      "flake.lock",
      "LICENSE",
      "README.md",
      "CMakeLists.txt",
      "Makefile",
      "meson.build",
      "PKGBUILD",
      "Cargo.toml",
      "package.json",
      "composer.json",
      "lazy-lock.json",
      "!>home",
      "!=tmp",
      ".git",
      "*.sln",
      ".vs",
      ".vscode",
      ".hg",
      ".bzr",
      ".svn",
      "_darcs"
    }
  },
  ["toggleterm"] = {
    ["direction"] = "float",
    ["start_in_insert"] = true,
    ["open_mapping"] = "<M-f>",
    ["autochdir"] = true,
    ["size"] = 12,
    ["float_opts"] = {
      ["border"] = "rounded",
      ["width"] = 150,
      ["height"] = 33
    }
  },
  ["ufo"] = {
    ["provider_selector"] = function(bufnr, filetype, buftype)
          return { 'lsp', 'indent' }
        end,
    ["fold_virt_text_handler"] = function(virtText, lnum, endLnum, width, truncate)
            local newVirtText = {}
            local suffix = (' 󰁂 %d '):format(endLnum - lnum)
            local sufWidth = vim.fn.strdisplaywidth(suffix)
            local targetWidth = width - sufWidth
            local curWidth = 0
            for _, chunk in ipairs(virtText) do
                local chunkText = chunk[1]
                local chunkWidth = vim.fn.strdisplaywidth(chunkText)
                if targetWidth > curWidth + chunkWidth then
                    table.insert(newVirtText, chunk)
                else
                    chunkText = truncate(chunkText, targetWidth - curWidth)
                    local hlGroup = chunk[2]
                    table.insert(newVirtText, {chunkText, hlGroup})
                    chunkWidth = vim.fn.strdisplaywidth(chunkText)
                    -- str width returned from truncate() may less than 2nd argument, need padding
                    if curWidth + chunkWidth < targetWidth then
                        suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
                    end
                    break
                end
                curWidth = curWidth + chunkWidth
            end
            table.insert(newVirtText, {suffix, 'MoreMsg'})
            return newVirtText
        end
  }
}

