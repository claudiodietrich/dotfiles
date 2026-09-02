return {
  "nvim-lualine/lualine.nvim",
  opts = function()
    vim.api.nvim_set_hl(0, "pretty_path_filename", { fg = "#a9b1d6" })
    vim.api.nvim_set_hl(0, "pretty_path_modified", { fg = "#a9b1d6" })
    return {
      options = {
        theme = vim.g.colorscheme,
      },
      sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
          { "mode", fmt = string.lower },
          {
            "branch",
            icon = {
              "󰘬",
            },
          },
          { "diff", colored = false },
          {
            LazyVim.lualine.pretty_path({
              filename_hl = "pretty_path_filename",
              modified_hl = "pretty_path_modified",
            }),
          },
        },
        lualine_x = {
          -- stylua: ignore
          {
            function() return require("noice").api.status.command.get() end,
            cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
          },
				  -- stylua: ignore
          {
            function() return require("noice").api.status.mode.get() end,
            cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
          },
          -- stylua: ignore
          {
            function() return "  " .. require("dap").status() end,
            cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
          },
          {
            "diagnostics",
            colored = false,
            symbols = { error = "󰅚 ", warn = "󰀪 ", info = "󰋽 ", hint = "󰌶 " },
          },
          {
            "lsp_status",
            padding = { left = 0, right = 1 },
            icon = "",
            symbols = {
              spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
              done = "✓",
              separator = " ",
            },
            ignore_lsp = {},
          },
          {
            -- location
            function()
              local line = vim.fn.line(".")
              local col = vim.fn.col(".")

              return string.format("%d:%d", line, col)
            end,
            padding = { left = 1, right = 1 },
          },
          { "progress", padding = { left = 1, right = 1 } },
          -- stylua: ignore
          {
            require("lazy.status").updates,
            cond = require("lazy.status").has_updates,
          },
        },
        lualine_y = {},
        lualine_z = {},
      },
    }
  end,
}
