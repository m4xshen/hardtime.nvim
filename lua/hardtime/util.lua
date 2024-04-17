local M = {}

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

local last_notification_text
local last_notification_time = M.get_time()

function M.notify(text)
   if text ~= last_notification_text then
      logger.info(text)
      vim.notify(text, vim.log.levels.WARN, { title = "hardtime" })
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

function M.is_today(timestamp)
   local today = os.date("*t")
   local date = os.date("*t", timestamp)
   return today.year == date.year
       and today.month == date.month
       and today.day == date.day
end

function M.is_this_week(timestamp)
   local today = os.date("*t")
   today.day = today.day - today.wday
   local date = os.date("*t", timestamp)
   date.day = date.day - date.wday

   return today.day == date.day
       and today.year == date.year
       and today.month == date.month
end

function M.is_this_month(timestamp)
   local today = os.date("*t")
   local date = os.date("*t", timestamp)

   return today.year == date.year and today.month == date.month
end

return M
