local util = require("hardtime.util")

local key_count = 0
local last_key = ""
local last_keys = ""
local last_time = util.get_time()
local mappings
local old_mouse_state = vim.o.mouse
local timer = nil
local hardtime_group = vim.api.nvim_create_augroup("HardtimeGroup", {})

local config = require("hardtime.config")

local function disable_mouse()
   old_mouse_state = vim.o.mouse ~= "" and vim.o.mouse or old_mouse_state
   vim.o.mouse = ""
end

local function restore_mouse()
   vim.o.mouse = old_mouse_state
end

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
   for filetype, is_disabled in pairs(config.config.disabled_filetypes) do
      if filetype == ft and is_disabled then
         return true
      end
      local matcher = "^" .. filetype .. (filetype:sub(-1) == "*" and "" or "$")
      if ft:match(matcher) and is_disabled then
         return true
      end
   end

   return false
end

local function should_disable_hardtime()
   return match_filetype(vim.bo.ft)
      or vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "terminal"
      or vim.fn.reg_executing() ~= ""
      or vim.fn.reg_recording() ~= ""
end

local function handler(key)
   if should_disable_hardtime() then
      return get_return_key(key)
   end

   local curr_time = util.get_time()
   local should_reset_notification = require("hardtime.util").should_reset()

   if should_reset_notification then
      util.reset_notification()
   end

   -- key disabled
   if config.config.disabled_keys[key] then
      if config.config.notification and should_reset_notification then
         vim.schedule(function()
            util.notify("The " .. key .. " key is disabled!")
         end)
      end
      return ""
   end

   -- reset
   if config.config.resetting_keys[key] then
      key_count = 0
   end

   if config.config.restricted_keys[key] == nil then
      return get_return_key(key)
   end

   -- restrict
   local should_reset_key_count = curr_time - last_time > config.config.max_time
   local is_different_key = config.config.allow_different_key
      and key ~= last_key
   if
      key_count < config.config.max_count
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

   if config.config.notification then
      vim.schedule(function()
         local message = "You pressed the " .. key .. " key too soon!"
         if key == "k" then
            message = message .. " Use [count]k or CTRL-U to scroll up."
         elseif key == "j" then
            message = message .. " Use [count]j or CTRL-D to scroll down."
         elseif key == "h" then
            message = message .. " Use b/B/ge/gE/F/T/0 to move left."
         elseif key == "l" then
            message = message .. " Use w/W/e/E/f/t/$ to move right."
         end
         util.notify(message)
      end)
   end

   if config.config.restriction_mode == "hint" then
      return get_return_key(key)
   end
   return ""
end

local function reset_timer()
   if timer then
      timer:stop()
   end

   if
      not should_disable_hardtime() and config.config.force_exit_insert_mode
   then
      timer = vim.defer_fn(util.stopinsert, config.config.max_insert_idle_ms)
   end
end

local M = {}
M.is_plugin_enabled = false

local function setup_autocmds()
   vim.api.nvim_create_autocmd("InsertEnter", {
      group = hardtime_group,
      callback = function()
         reset_timer()
      end,
   })

   if config.config.disable_mouse then
      vim.api.nvim_create_autocmd({ "BufEnter", "TermEnter" }, {
         group = hardtime_group,
         callback = function()
            if should_disable_hardtime() then
               restore_mouse()
               return
            end
            disable_mouse()
         end,
      })
   end
end

local clear_autocmds = function()
   vim.api.nvim_clear_autocmds({ group = hardtime_group })
end

function M.enable()
   if M.is_plugin_enabled then
      return
   end

   M.is_plugin_enabled = true
   mappings = vim.api.nvim_get_keymap("n")

   setup_autocmds()

   if config.config.disable_mouse then
      disable_mouse()
   end

   local keys_groups = {
      config.config.resetting_keys,
      config.config.restricted_keys,
      config.config.disabled_keys,
   }

   for _, keys in ipairs(keys_groups) do
      for key, mode in pairs(keys) do
         if mode then
            vim.keymap.set(mode, key, function()
               return handler(key)
            end, {
               noremap = true,
               expr = true,
               desc = "which_key_ignore",
            })
         end
      end
   end
end

function M.disable()
   if not M.is_plugin_enabled then
      return
   end

   M.is_plugin_enabled = false
   restore_mouse()
   clear_autocmds()

   local keys_groups = {
      config.config.resetting_keys,
      config.config.restricted_keys,
      config.config.disabled_keys,
   }

   for _, keys in ipairs(keys_groups) do
      for key, mode in pairs(keys) do
         pcall(vim.keymap.del, mode, key)
      end
   end
end

function M.toggle()
   (M.is_plugin_enabled and M.disable or M.enable)()
end

local function setup(user_config)
   if vim.fn.has("nvim-0.10.0") == 0 then
      return vim.notify("hardtime.nvim requires Neovim >= v0.10.0")
   end

   config.migrate_old_config(user_config or {})
   config.config = vim.tbl_deep_extend("force", config.config, user_config)

   if config.config.enabled then
      M.enable()
   end

   local max_keys_size = util.get_max_keys_size()

   vim.on_key(function(_, k)
      local mode = vim.fn.mode()
      if k == "" or mode == "c" or mode == "R" then
         return
      end

      if mode == "i" then
         reset_timer()
         return
      end

      -- ignore key if it is triggering which-key.nvim
      local has_wk, wk = pcall(require, "which-key.state")
      if has_wk and wk.state ~= nil then
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

      if
         not config.config.hint
         or not M.is_plugin_enabled
         or should_disable_hardtime()
      then
         return
      end

      for pattern, hint in pairs(config.config.hints) do
         if hint then
            local len = hint.length or #pattern
            local found = string.find(last_keys, pattern, -len)
            if found then
               local keys = string.sub(last_keys, found, #last_keys)
               local text = hint.message(keys)
               util.notify(text)
            end
         end
      end
   end)

   require("hardtime.command").setup()
end

function M.setup(user_config)
   local setup_timer = (vim.uv or vim.loop).new_timer()
   setup_timer:start(
      500,
      0,
      vim.schedule_wrap(function()
         setup(user_config)
      end)
   )
end

return M
