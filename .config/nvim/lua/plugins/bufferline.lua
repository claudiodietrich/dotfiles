return {
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        always_show_bufferline = true,
        show_buffer_icons = false,
        middle_mouse_command = function(n)
          Snacks.bufdelete(n)
        end,
        right_mouse_command = "vertical sbuffer %d",
        separator_style = "thin",
        style_preset = {
          require("bufferline").style_preset.no_italic,
          require("bufferline").style_preset.no_bold,
        },
        hover = {
          enabled = true,
          delay = 50,
          reveal = { "close" },
        },
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(_, _, diag)
          local ret = (diag.error and "󰅚 " .. diag.error .. " " or "")
            .. (diag.warning and "󰀪 " .. diag.warning or "")
          return vim.trim(ret)
        end,
        groups = {
          items = {
            require("bufferline.groups").builtin.pinned:with({ icon = "󰐃" }),
          },
        },
      },
    },
  },
}
