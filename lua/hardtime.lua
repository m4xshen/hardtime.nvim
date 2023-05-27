local hardtime = {}

local function get_time()
   return vim.fn.reltimefloat(vim.fn.reltime()) * 1000
end

local last_time = get_time()
local last_count = 0
local last_key

local config = {
   max_time = 1000,
   max_count = 2,
   disable_mouse = true,
   hint = true,
   allow_different_key = false,
   resetting_keys = { "1", "2", "3", "4", "5", "6", "7", "8", "9",
      "c", "C", "d", "x", "X", "y", "Y", "p", "P" },
   restricted_keys = { "h", "j", "k", "l", "-", "+" },
   hint_keys = { "k", "j", "^", "$", "a", "i", "d", "y", "c", "l" },
   disabled_keys = { "<UP>", "<DOWN>", "<LEFT>", "<RIGHT>" },
   disabled_filetypes = { "qf", "netrw", "NvimTree", "lazy", "mason" }
}

local function is_disabled()
   local current_filetype = vim.api.nvim_buf_get_option(0, "filetype")
   for _, filetype in pairs(config.disabled_filetypes) do
      if filetype == current_filetype then
         return true
      end
   end
   return false
end

local function contains(array, element)
   for _, val in ipairs(array) do
      if val == element then
         return true
      end
   end

   return false
end

local function display_hint(key)
   if last_key == "k" and key == "^" then
      print("Use - instead of k^")
   elseif last_key == "j" and key == "^" then
      print("Use + instead of j^")
   elseif last_key == "c" and key == "l" then
      print("Use s instead of cl")
   elseif last_key == "d" and key == "$" then
      print("Use D instead of d$")
   elseif last_key == "c" and key == "$" then
      print("Use C instead of c$")
   elseif last_key == "$" and key == "a" then
      print("Use A instead of $a")
   elseif last_key == "^" and key == "i" then
      print("Use I instead of ^i")
   end
end

local function handler(key)
   -- plugin disabled
   if is_disabled() then
      return key
   end

   -- key disabled
   if contains(config.disabled_keys, key) then
      print("Key " .. key .. " is disabled!")
      return ""
   end

   -- hint
   if contains(config.hint_keys, key) then
      display_hint(key)
   end

   -- reset
   if contains(config.resetting_keys, key) then
      last_count = 0
   end

   if not contains(config.restricted_keys, key) then
      last_key = key
      return key
   end

   -- restrict
   local curr_time = get_time()

   if last_count < config.max_count or
      curr_time - last_time > config.max_time or
      (config.allow_different_key and key ~= last_key) then
      if curr_time - last_time > config.max_time or
         (config.allow_different_key and key ~= last_key) then
         last_count = 1
      else
         last_count = last_count + 1
      end

      last_time = get_time()
      last_key = key
      return key
   end

   print("You press key " .. key .. " too soon!")
   last_key = key
   return ""
end

function hardtime.setup(user_config)
   user_config = user_config or {}

   for option, value in pairs(user_config) do
      config[option] = value
   end

   if config.disable_mouse then
      vim.opt.mouse = ""
   end

   for _, key in pairs(config.resetting_keys) do
      vim.keymap.set("n", key, function() return handler(key)
      end, { noremap = true, expr = true })
   end

   for _, key in pairs(config.restricted_keys) do
      vim.keymap.set({ "n", "v" }, key, function() return handler(key)
      end, { noremap = true, expr = true })
   end

   if config.hint then
      for _, key in pairs(config.hint_keys) do
         vim.keymap.set({ "n", "o", "v" }, key, function() return handler(key)
         end, { noremap = true, expr = true })
      end
   end

   for _, key in pairs(config.disabled_keys) do
      vim.keymap.set({ "", "i" }, key, function() return handler(key)
      end, { noremap = true })
   end
end

return hardtime
