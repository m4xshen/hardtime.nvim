local M = {}

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
   vim.notify(text, vim.log.levels.WARN, { title = "hardtime" })
end

return M
