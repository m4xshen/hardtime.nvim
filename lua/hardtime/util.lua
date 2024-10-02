local M = {}

local config = require("hardtime.config").config

local logger = require("hardtime.log").new({
   plugin = "hardtime.nvim",
   level = "info",
   use_console = false,
})

function M.stopinsert()
   vim.cmd("stopinsert")
end

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

local last_notification_text
local last_notification_time = M.get_time()

function M.notify(text)
   if text ~= last_notification_text then
      logger.info(text)
      config.callback(text)
   end
   last_notification_text = text
   last_notification_time = M.get_time()
end

function M.should_reset()
   return M.get_time() - last_notification_time
      > require("hardtime.config").config.max_time
end

function M.reset_notification()
   last_notification_text = nil
end

return M
