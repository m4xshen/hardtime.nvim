local commands = {
   enable = require("hardtime").enable,
   disable = require("hardtime").disable,
   toggle = require("hardtime").toggle,
   report = require("hardtime.report").report,
}

local M = {}

function M.setup()
   vim.api.nvim_create_user_command("Hardtime", function(args)
      if commands[args.args] then
         commands[args.args]()
      end
   end, {
      nargs = 1,
      complete = function()
         return { "enable", "disable", "toggle", "report" }
      end,
   })
end

return M
