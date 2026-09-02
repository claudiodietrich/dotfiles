return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        projects = {
          recent = false,
          dev = { "~/projects" },
          projects = {},
          patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "package.json", "Makefile", "go.mod" },
          matcher = {
            frecency = false,
            sort_empty = true,
            cwd_bonus = false,
          },
          sort = { fields = { "score:desc", "idx" } },
          format = function(item, picker)
            if not item.file then
              return {}
            end
            local ret = {}
            if picker.opts.icons.files.enabled ~= false then
              local icon, hl = Snacks.util.icon(item.file, "directory", { fallback = picker.opts.icons.files })
              icon = Snacks.picker.util.align(icon, picker.opts.formatters.file.icon_width or 2)
              ret[#ret + 1] = { icon, hl, virtual = true }
            end
            ret[#ret + 1] = { " " }
            local home = vim.fn.expand("~")
            local path = item.file
            if path:sub(1, #home) == home then
              path = "~" .. path:sub(#home + 1)
            end
            local dir, name = path:match("^(.*/)(.+)$")
            if dir and name then
              ret[#ret + 1] = { dir, "SnacksPickerDir", field = "file" }
              ret[#ret + 1] = { name, "SnacksPickerDirectory", field = "file" }
            else
              ret[#ret + 1] = { path, "SnacksPickerDirectory", field = "file" }
            end
            return ret
          end,
        },
      },
    },
  },
}
