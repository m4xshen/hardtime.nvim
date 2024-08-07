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
local defer_timer

function M.notify(text)
   local hint_timeout = require("hardtime.config").config.hint_timeout

   if text ~= last_notification_text then
      logger.info(text)
      vim.notify(text, vim.log.levels.WARN, { title = "hardtime" })

      if defer_timer and hint_timeout > 0 then
         defer_timer:stop()
         defer_timer:close()
         defer_timer = nil
      end

      if hint_timeout > 0 then
         defer_timer = vim.loop.new_timer()
         defer_timer:start(
            hint_timeout,
            0,
            vim.schedule_wrap(function()
               vim.notify("", vim.log.levels.INFO, { title = "hardtime" })
               defer_timer:close()
               defer_timer = nil
            end)
         )
      end
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
