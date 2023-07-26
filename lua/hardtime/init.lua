local util = require("hardtime.util")

local last_time = util.get_time()
local last_notification = util.get_time()
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
   local curr_time = util.get_time()
   if curr_time - last_notification > config.max_time then
      util.reset_notification()
   end

   -- key disabled
   if config.disabled_keys[key] then
      if
         config.notification
         and curr_time - last_notification > config.max_time
      then
         vim.schedule(function()
            util.notify("The " .. key .. " key is disabled!")
         end)
         last_notification = util.get_time()
      end
      return ""
   end

   -- plugin disabled
   if is_disabled() then
      return get_return_key(key)
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
         util.reset_notification()
      else
         last_count = last_count + 1
      end

      last_time = util.get_time()
      last_key = key
      return get_return_key(key)
   end

   if config.notification then
      vim.schedule(function()
         util.notify("You pressed the " .. key .. " key too soon!")
      end)
      last_notification = util.get_time()
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
      if type(value) == "table" and #value == 0 then
         for k, v in pairs(value) do
            if next(value) == nil then
               config[option][k] = nil
            else
               config[option][k] = v
            end
         end
      else
         config[option] = value
      end
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
         if found then
            local keys = string.sub(last_keys, found, #last_keys)
            local text = hint.message(keys)
            util.notify(text)
         end
      end
   end)

   require("hardtime.command").setup()
end

return M
