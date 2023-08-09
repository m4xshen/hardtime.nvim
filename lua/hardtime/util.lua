local M = {}
local previous_text

local logger = require("hardtime.log").new({
   plugin = "hardtime.nvim",
   level = "info",
   use_console = false,
})

function M.get_time()
   return vim.fn.reltimefloat(vim.fn.reltime()) * 1000
end

function M.try_eval(expression)
   local success, result = pcall(vim.api.nvim_eval, expression)
   if success then
      return result
   end
   return expression
end

function M.notify(text)
   if text ~= previous_text then
      logger.info(text)
      vim.notify(text, vim.log.levels.WARN, { title = "hardtime" })
   end
   previous_text = text
end

function M.reset_notification()
   previous_text = nil
end

return M
