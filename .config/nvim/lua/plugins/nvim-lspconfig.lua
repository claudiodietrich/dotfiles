return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      gopls = {
        settings = {
          gopls = {
            hints = {
              assignVariableTypes = false,
              compositeLiteralFields = false,
              compositeLiteralTypes = false,
              constantValues = false,
              functionTypeParameters = false,
              parameterNames = false,
              rangeVariableTypes = false,
            },
            analyses = {
              ST1000 = false, -- Checks for missing or malformed Go package comments.
            },
          },
        },
      },
      pyright = {
        on_init = function(client)
          local util = require("lspconfig.util")
          local root = util.find_git_ancestor(vim.fn.getcwd()) or vim.fn.getcwd()
          local venv = vim.fn.trim(vim.fn.system("poetry env info --path"))
          if vim.fn.isdirectory(venv) == 1 then
            client.config.settings.python = client.config.settings.python or {}
            client.config.settings.python.pythonPath = venv .. "/bin/python"
          end
        end,
      },
    },
  },
}
