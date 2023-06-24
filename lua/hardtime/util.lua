local M = {}

function M.get_time()
   return vim.fn.reltimefloat(vim.fn.reltime()) * 1000
end

function M.contains_val(array, element)
   for _, val in ipairs(array) do
      if val == element then
         return true
      end
   end

   return false
end

function M.try_eval(expression)
   local success, result = pcall(vim.api.nvim_eval, expression)
   if success then
      return result
   end
   return expression
end

return M
