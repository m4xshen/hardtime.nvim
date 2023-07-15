local util = require("hardtime.util")

local last_time = util.get_time()
local last_count = 0
local last_key
local last_keys = ""
local mappings

local config = require("hardtime.config").config

local function is_disabled()
   local current_filetype = vim.api.nvim_buf_get_option(0, "filetype")
   for _, filetype in pairs(config.disabled_filetypes) do
      if filetype == current_filetype then
         return true
      end
   end
   return false
end

local function get_return_key(key)
   for _, mapping in ipairs(mappings) do
      if mapping.lhs == key then
         return util.try_eval(mapping.rhs)
      end
   end
   return key
end

local function handler(key)
   -- plugin disabled
   if is_disabled() then
      return get_return_key(key)
   end

   -- key disabled
   if config.disabled_keys[key] then
      if config.notification then
         vim.schedule(function()
            util.notify("Key " .. key .. " is disabled!")
         end)
      end
      return ""
   end

   -- reset
   if config.resetting_keys[key] then
      last_count = 0
   end

   if config.restricted_keys[key] == nil then
      last_key = key
      return get_return_key(key)
   end

   -- restrict
   local curr_time = util.get_time()

   if
      last_count < config.max_count
      or curr_time - last_time > config.max_time
      or (config.allow_different_key and key ~= last_key)
   then
      if
         curr_time - last_time > config.max_time
         or (config.allow_different_key and key ~= last_key)
      then
         last_count = 1
      else
         last_count = last_count + 1
      end

      last_time = util.get_time()
      last_key = key
      return get_return_key(key)
   end

   if config.notification then
      vim.schedule(function()
         util.notify("You press key " .. key .. " too soon!")
      end)
   end
   last_key = key
   return ""
end

local M = {}
local enabled = false

function M.enable()
   if enabled then
      return
   end

   enabled = true
   mappings = vim.api.nvim_get_keymap("n")

   if config.disable_mouse then
      vim.opt.mouse = ""
   end

   for key, mode in pairs(config.resetting_keys) do
      vim.keymap.set(mode, key, function()
         return handler(key)
      end, { noremap = true, expr = true })
   end

   for key, mode in pairs(config.restricted_keys) do
      vim.keymap.set(mode, key, function()
         return handler(key)
      end, { noremap = true, expr = true })
   end

   for key, mode in pairs(config.disabled_keys) do
      vim.keymap.set(mode, key, function()
         return handler(key)
      end, { noremap = true })
   end
end

function M.disable()
   if not enabled then
      return
   end

   enabled = false
   vim.opt.mouse = "nvi"

   for key, mode in pairs(config.resetting_keys) do
      pcall(vim.keymap.del, mode, key)
   end

   for key, mode in pairs(config.restricted_keys) do
      pcall(vim.keymap.del, mode, key)
   end

   for key, mode in pairs(config.disabled_keys) do
      pcall(vim.keymap.del, mode, key)
   end
end

function M.toggle()
   (enabled and M.disable or M.enable)()
end

function M.setup(user_config)
   user_config = user_config or {}

   for option, value in pairs(user_config) do
      config[option] = value
   end

   vim.api.nvim_create_autocmd("BufEnter", { once = true, callback = M.enable })

   vim.on_key(function(key)
      if (not config.hint) or not enabled then
         return
      end

      local mode = vim.fn.mode()
      if mode == "i" or mode == "c" or mode == "R" then
         return
      end

      last_keys = last_keys .. key
      for pattern, hint in pairs(config.hints) do
         local len = hint.length or #pattern
         local found = string.find(last_keys, pattern, -len)
         local keys = string.sub(last_keys, #last_keys - len + 1, #last_keys)

         if found then
            local text = hint.message(keys)
            util.notify(text)
         end
      end
   end)

   require("hardtime.command").setup()
end

return M
