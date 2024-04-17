local report = require("hardtime.ui.state")
local util = require("hardtime.util")

local M = {}

local function sort_hints(hints)
   local sorted_hints = {}

   for hint, count in pairs(hints) do
      table.insert(sorted_hints, { hint, count })
   end

   table.sort(sorted_hints, function(a, b)
      return a[2] > b[2]
   end)

   return sorted_hints
end

function M.report()
   local file_path = vim.api.nvim_call_function("stdpath", { "log" })
       .. "/hardtime.nvim.log"

   local file = io.open(file_path, "r")

   if file == nil then
      print("Error: Unable to open", file_path)
      return
   end

   local all_hints = {}
   local daily_hints = {}
   local weekly_hints = {}
   local monthly_hints = {}

   for line in file:lines() do
      local time_info = string.match(line, "%[(.-)%]")
      time_info = string.gsub(time_info, "INFO", "")

      local day, month, year =
          string.match(time_info, "(%d+).(%d+).(%d+). (%d+):(%d+):(%d+)")

      local date = os.time({
         year = year,
         month = month,
         day = day,
      })

      local hint = string.gsub(line, "%[.-%] ", "")
      all_hints[hint] = all_hints[hint] and all_hints[hint] + 1 or 1

      if util.is_today(date) then
         daily_hints[hint] = daily_hints[hint] and daily_hints[hint] + 1 or 1
      end

      if util.is_this_week(date) then
         weekly_hints[hint] = weekly_hints[hint] and weekly_hints[hint] + 1 or 1
      end

      if util.is_this_month(date) then
         monthly_hints[hint] = monthly_hints[hint] and monthly_hints[hint] + 1
             or 1
      end
   end

   file:close()

   local ReportModel = require("hardtime.ui.report_model")

   local content = {
      ReportModel.new("All Time (A)", sort_hints(all_hints), "A"),
      ReportModel.new("Daily (D)", sort_hints(daily_hints), "D"),
      ReportModel.new("Weekly (W)", sort_hints(weekly_hints), "W"),
      ReportModel.new("Monthly (M)", sort_hints(monthly_hints), "M"),
   }

   local inital_tab = 1

   report.open(content, inital_tab)
end

return M
