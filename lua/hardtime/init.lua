local util = require("hardtime.util")

local last_time = util.get_time()
local key_count = 0
local last_keys = ""
local last_key = ""
local mappings

local config = require("hardtime.config").config

local function get_return_key(key)
   for _, mapping in ipairs(mappings) do
      if mapping.lhs == key then
         return util.try_eval(mapping.rhs)
      end
   end
   return key
end

local function handler(key)
   if vim.tbl_contains(config.disabled_filetypes, vim.bo.ft) then
      return get_return_key(key)
   end

   local curr_time = util.get_time()
   local should_reset_notification = require("hardtime.util").should_reset()

   if should_reset_notification then
      util.reset_notification()
   end

   -- key disabled
   if config.disabled_keys[key] then
      if config.notification and should_reset_notification then
         vim.schedule(function()
            util.notify("The " .. key .. " key is disabled!")
         end)
      end
      return ""
   end

   -- reset
   if config.resetting_keys[key] then
      key_count = 0
   end

   if config.restricted_keys[key] == nil then
      return get_return_key(key)
   end

   -- restrict
   local should_reset_key_count = curr_time - last_time > config.max_time
   local is_different_key = config.allow_different_key and key ~= last_key
   if
      key_count < config.max_count
      or should_reset_key_count
      or is_different_key
   then
      if should_reset_key_count or is_different_key then
         key_count = 1
         util.reset_notification()
      else
         key_count = key_count + 1
      end

      last_time = util.get_time()
      return get_return_key(key)
   end

   if config.notification then
      vim.schedule(function()
         util.notify("You pressed the " .. key .. " key too soon!")
      end)
   end
   return ""
end

local M = {}
local enabled = false

local keys_groups = {
   config.resetting_keys,
   config.restricted_keys,
   config.disabled_keys,
}

function M.enable()
   if enabled then
      return
   end

   enabled = true
   mappings = vim.api.nvim_get_keymap("n")

   if config.disable_mouse then
      vim.opt.mouse = ""
   end

   for _, keys in ipairs(keys_groups) do
      for key, mode in pairs(keys) do
         vim.keymap.set(mode, key, function()
            return handler(key)
         end, { noremap = true, expr = true })
      end
   end
end

function M.disable()
   if not enabled then
      return
   end

   enabled = false
   vim.opt.mouse = "nvi"

   for _, keys in ipairs(keys_groups) do
      for key, mode in pairs(keys) do
         pcall(vim.keymap.del, mode, key)
      end
   end
end

function M.toggle()
   (enabled and M.disable or M.enable)()
end

function M.setup(user_config)
   user_config = user_config or {}

   require("hardtime.config").set_defaults(user_config)

   if config.enabled then
      vim.api.nvim_create_autocmd(
         "BufEnter",
         { once = true, callback = M.enable }
      )
   end

   vim.on_key(function(k)
      if (not config.hint) or not enabled then
         return
      end

      local mode = vim.fn.mode()
      if mode == "i" or mode == "c" or mode == "R" then
         return
      end

      local key = vim.fn.keytrans(k)
      if k == "<" then
         key = "<"
      end

      last_keys = last_keys .. key
      last_key = key
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
