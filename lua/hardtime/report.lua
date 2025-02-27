local M = {}

function M.report()
   local file_path = vim.api.nvim_call_function("stdpath", { "log" })
      .. "/hardtime.nvim.log"
   local file = io.open(file_path, "r")
   if file == nil then
      print("Error: Unable to open", file_path)
      return
   end

   local hints = {}
   for line in file:lines() do
      local hint = string.gsub(line, "%[.-%] ", "")
      hints[hint] = hints[hint] and hints[hint] + 1 or 1
   end
   file:close()

   local sorted_hints = {}
   for hint, count in pairs(hints) do
      table.insert(sorted_hints, { hint, count })
   end

   table.sort(sorted_hints, function(a, b)
      return a[2] > b[2]
   end)

   local Popup = require("nui.popup")
   local event = require("nui.utils.autocmd").event
   local config = require("hardtime.config").config

   local popup = Popup(config.ui)

   popup:mount()
   popup:on(event.BufLeave, function()
      popup:unmount()
   end)

   for i, pair in ipairs(sorted_hints) do
      local content = string.format("%d. %s (%d times)", i, pair[1], pair[2])

      vim.api.nvim_buf_set_lines(popup.bufnr, i - 1, i - 1, false, { content })
      vim.api.nvim_win_set_cursor(0, { 1, 0 })
   end
end

return M
