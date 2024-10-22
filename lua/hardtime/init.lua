local util = require("hardtime.util")

local last_time = util.get_time()
local key_count = 0
local last_keys = ""
local last_key = ""
local mappings
local timer = nil

local config = require("hardtime.config").config

local function get_return_key(key)
   for _, mapping in ipairs(mappings) do
      if mapping.lhs == key then
         if mapping.callback then
            local success, result = pcall(mapping.callback)
            if success then
               return result
            end

            return vim.schedule(mapping.callback)
         end
         return util.try_eval(mapping.rhs)
      end
   end
   return key
end

local function match_filetype(ft)
   for _, value in pairs(config.disabled_filetypes) do
      local matcher = "^" .. value .. (value:sub(-1) == "*" and "" or "$")
      if ft:match(matcher) then
         return true
      end
   end

   return false
end

local function should_disable()
   return vim.tbl_contains(config.disabled_filetypes, vim.bo.ft)
      or match_filetype(vim.bo.ft)
      or vim.api.nvim_buf_get_option(0, "buftype") == "terminal"
      or vim.fn.reg_executing() ~= ""
      or vim.fn.reg_recording() ~= ""
end

local function handler(key)
   if should_disable() then
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
         local message = "You pressed the " .. key .. " key too soon!"
         if key == "k" then
            message = message .. " Use [count]k or CTRL-U to scroll up."
         elseif key == "j" then
            message = message .. " Use [count]j or CTRL-D to scroll down."
         end
         util.notify(message)
      end)
   end

   if config.restriction_mode == "hint" then
      return get_return_key(key)
   end
   return ""
end

local function reset_timer()
   if timer then
      timer:stop()
   end

   if not should_disable() and config.force_exit_insert_mode then
      timer = vim.defer_fn(util.stopinsert, config.max_insert_idle_ms)
   end
end

local function get_max_keys_size()
   local max_len = 0
   for pattern, hint in pairs(config.hints) do
      local len = hint.length or #pattern
      if len > max_len then
         max_len = len
      end
   end
   return max_len
end

local M = {}
M.is_plugin_enabled = false

local keys_groups = {
   config.resetting_keys,
   config.restricted_keys,
   config.disabled_keys,
}

function M.enable()
   if M.is_plugin_enabled then
      return
   end

   M.is_plugin_enabled = true
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
   if not M.is_plugin_enabled then
      return
   end

   M.is_plugin_enabled = false
   vim.opt.mouse = "nvi"

   for _, keys in ipairs(keys_groups) do
      for key, mode in pairs(keys) do
         pcall(vim.keymap.del, mode, key)
      end
   end
end

function M.toggle()
   (M.is_plugin_enabled and M.disable or M.enable)()
end

function M.setup(user_config)
   if vim.fn.has("nvim-0.10.0") == 0 then
      return vim.notify("hardtime.nvim requires Neovim >= v0.10.0")
   end

   user_config = user_config or {}

   require("hardtime.config").set_defaults(user_config)

   if config.enabled then
      vim.api.nvim_create_autocmd(
         "BufEnter",
         { once = true, callback = M.enable }
      )

      vim.api.nvim_create_autocmd("InsertEnter", {
         group = vim.api.nvim_create_augroup("HardtimeGroup", {}),
         callback = function()
            reset_timer()
         end,
      })
   end

   local max_keys_size = get_max_keys_size()

   vim.on_key(function(_, k)
      local mode = vim.fn.mode()
      if k == "" or mode == "c" or mode == "R" then
         return
      end

      if mode == "i" then
         reset_timer()
         return
      end

      local key = vim.fn.keytrans(k)
      if key == "<MouseMove>" then
         return
      end

      if k == "<" then
         key = "<"
      end

      last_keys = last_keys .. key
      last_key = key

      if #last_keys > max_keys_size then
         last_keys = last_keys:sub(-max_keys_size)
      end

      if not config.hint or not M.is_plugin_enabled or should_disable() then
         return
      end

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
