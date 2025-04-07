local M = {}

M.config = {
   max_time = 1000,
   max_count = 3,
   disable_mouse = true,
   hint = true,
   timeout = 3000,
   notification = true,
   allow_different_key = true,
   enabled = true,
   force_exit_insert_mode = false,
   max_insert_idle_ms = 5000,
   resetting_keys = {
      ["1"] = { "n", "x" },
      ["2"] = { "n", "x" },
      ["3"] = { "n", "x" },
      ["4"] = { "n", "x" },
      ["5"] = { "n", "x" },
      ["6"] = { "n", "x" },
      ["7"] = { "n", "x" },
      ["8"] = { "n", "x" },
      ["9"] = { "n", "x" },
      ["c"] = { "n" },
      ["C"] = { "n" },
      ["d"] = { "n" },
      ["x"] = { "n" },
      ["X"] = { "n" },
      ["y"] = { "n" },
      ["Y"] = { "n" },
      ["p"] = { "n" },
      ["P"] = { "n" },
      ["gp"] = { "n" },
      ["gP"] = { "n" },
      ["."] = { "n" },
      ["="] = { "n" },
      ["<"] = { "n" },
      [">"] = { "n" },
      ["J"] = { "n" },
      ["gJ"] = { "n" },
      ["~"] = { "n" },
      ["g~"] = { "n" },
      ["gu"] = { "n" },
      ["gU"] = { "n" },
      ["gq"] = { "n" },
      ["gw"] = { "n" },
      ["g?"] = { "n" },
   },
   restriction_mode = "block", -- block or hint
   restricted_keys = {
      ["h"] = { "n", "x" },
      ["j"] = { "n", "x" },
      ["k"] = { "n", "x" },
      ["l"] = { "n", "x" },
      ["+"] = { "n", "x" },
      ["gj"] = { "n", "x" },
      ["gk"] = { "n", "x" },
      ["<C-M>"] = { "n", "x" },
      ["<C-N>"] = { "n", "x" },
      ["<C-P>"] = { "n", "x" },
   },
   disabled_keys = {
      ["<Up>"] = { "", "i" },
      ["<Down>"] = { "", "i" },
      ["<Left>"] = { "", "i" },
      ["<Right>"] = { "", "i" },
   },
   disabled_filetypes = {
      "aerial",
      "alpha",
      "Avante",
      "checkhealth",
      "dapui*",
      "db*",
      "Diffview*",
      "Dressing*",
      "fugitive",
      "help",
      "httpResult",
      "lazy",
      "lspinfo",
      "mason",
      "minifiles",
      "Neogit*",
      "neo%-tree*",
      "neotest%-summary",
      "netrw",
      "noice",
      "notify",
      "NvimTree",
      "oil",
      "prompt",
      "qf",
      "query",
      "TelescopePrompt",
      "Trouble",
      "trouble",
      "VoltWindow",
      "undotree",
   },
   ui = {
      enter = true,
      focusable = true,
      border = {
         style = "rounded",
         text = {
            top = "Hardtime Report",
            top_align = "center",
         },
      },
      position = "50%",
      size = {
         width = "40%",
         height = "60%",
      },
   },
   hints = {
      ["[kj][%^_]"] = {
         message = function(key)
            return "Use "
               .. (key:sub(1, 1) == "k" and "-" or "<CR> or +")
               .. " instead of "
               .. key
         end,
         length = 2,
      },
      ["%$a"] = {
         message = function()
            return "Use A instead of $a"
         end,
         length = 2,
      },
      ["d%$"] = {
         message = function()
            return "Use D instead of d$"
         end,
         length = 2,
      },
      ["y%$"] = {
         message = function()
            return "Use Y instead of y$"
         end,
         length = 2,
      },
      ["c%$"] = {
         message = function()
            return "Use C instead of c$"
         end,
         length = 2,
      },
      ["%^i"] = {
         message = function()
            return "Use I instead of ^i"
         end,
         length = 2,
      },
      ["%D[j+]O"] = {
         message = function(keys)
            return "Use o instead of " .. keys:sub(2)
         end,
         length = 3,
      },
      ["[^fFtT]li"] = {
         message = function()
            return "Use a instead of li"
         end,
         length = 3,
      },
      ["2([dcy=<>])%1"] = {
         message = function(key)
            return "Use " .. key:sub(3) .. "j instead of " .. key
         end,
         length = 3,
      },

      -- hints for f/F/t/T
      ["[^dcy=]f.h"] = {
         message = function(keys)
            return "Use t" .. keys:sub(3, 3) .. " instead of " .. keys:sub(2)
         end,
         length = 4,
      },
      ["[^dcy=]F.l"] = {
         message = function(keys)
            return "Use T" .. keys:sub(3, 3) .. " instead of " .. keys:sub(2)
         end,
         length = 4,
      },
      ["[^dcy=]T.h"] = {
         message = function(keys)
            return "Use F" .. keys:sub(3, 3) .. " instead of " .. keys:sub(2)
         end,
         length = 4,
      },
      ["[^dcy=]t.l"] = {
         message = function(keys)
            return "Use f" .. keys:sub(3, 3) .. " instead of " .. keys:sub(2)
         end,
         length = 4,
      },

      -- hints for delete + insert
      ["d[bBwWeE%^%$]i"] = {
         message = function(keys)
            return "Use " .. "c" .. keys:sub(2, 2) .. " instead of " .. keys
         end,
         length = 3,
      },
      ["dg[eE]i"] = {
         message = function(keys)
            return "Use " .. "c" .. keys:sub(2, 3) .. " instead of " .. keys
         end,
         length = 4,
      },
      ["d[tTfF].i"] = {
         message = function(keys)
            return "Use " .. "c" .. keys:sub(2, 3) .. " instead of " .. keys
         end,
         length = 4,
      },
      ["d[ia][\"'`{}%[%]()<>bBwWspt]i"] = {
         message = function(keys)
            return "Use " .. "c" .. keys:sub(2, 3) .. " instead of " .. keys
         end,
         length = 4,
      },

      -- hints for unnecessary visual mode
      ["Vgg[dcy=<>]"] = {
         message = function(keys)
            return "Use " .. keys:sub(4, 4) .. "gg instead of " .. keys
         end,
         length = 4,
      },
      ['Vgg".[dy]'] = {
         message = function(keys)
            return "Use " .. keys:sub(4, 6) .. "gg instead of " .. keys
         end,
         length = 6,
      },
      ["VG[dcy=<>]"] = {
         message = function(keys)
            return "Use " .. keys:sub(3, 3) .. "G instead of " .. keys
         end,
         length = 3,
      },
      ['VG".[dy]'] = {
         message = function(keys)
            return "Use " .. keys:sub(3, 5) .. "G instead of " .. keys
         end,
         length = 5,
      },
      ["V%d[kj][dcy=<>]"] = {
         message = function(keys)
            return "Use "
               .. keys:sub(4, 4)
               .. keys:sub(2, 3)
               .. " instead of "
               .. keys
         end,
         length = 4,
      },
      ['V%d[kj]".[dy]'] = {
         message = function(keys)
            return "Use "
               .. keys:sub(4, 6)
               .. keys:sub(2, 3)
               .. " instead of "
               .. keys
         end,
         length = 6,
      },
      ["V%d%d[kj][dcy=<>]"] = {
         message = function(keys)
            return "Use "
               .. keys:sub(5, 5)
               .. keys:sub(2, 4)
               .. " instead of "
               .. keys
         end,
         length = 5,
      },
      ['V%d%d[kj]".[dy]'] = {
         message = function(keys)
            return "Use "
               .. keys:sub(5, 7)
               .. keys:sub(2, 4)
               .. " instead of "
               .. keys
         end,
         length = 7,
      },
      ["[vV][eE][dcy]"] = {
         message = function(keys)
            return "Use "
               .. keys:sub(3, 3)
               .. keys:sub(2, 2)
               .. " instead of "
               .. keys
         end,
         length = 3,
      },
      ['[vV][eE]".[dy]'] = {
         message = function(keys)
            return "Use "
               .. keys:sub(3, 5)
               .. keys:sub(2, 2)
               .. " instead of "
               .. keys
         end,
         length = 5,
      },
      ["[vV]g[eE][dcy]"] = {
         message = function(keys)
            return "Use "
               .. keys:sub(4, 4)
               .. keys:sub(2, 3)
               .. " instead of "
               .. keys
         end,
         length = 4,
      },
      ['[vV]g[eE]".[dy]'] = {
         message = function(keys)
            return "Use "
               .. keys:sub(4, 6)
               .. keys:sub(2, 3)
               .. " instead of "
               .. keys
         end,
         length = 6,
      },
      ["[vV][tTfF].[dcy]"] = {
         message = function(keys)
            return "Use "
               .. keys:sub(4, 4)
               .. keys:sub(2, 3)
               .. " instead of "
               .. keys
         end,
         length = 4,
      },
      ['[vV][tTfF].".[dy]'] = {
         message = function(keys)
            return "Use "
               .. keys:sub(4, 6)
               .. keys:sub(2, 3)
               .. " instead of "
               .. keys
         end,
         length = 6,
      },
      ["[vV][ia][\"'`{}%[%]()<>bBwWspt][dcy=<>]"] = {
         message = function(keys)
            return "Use "
               .. keys:sub(4, 4)
               .. keys:sub(2, 3)
               .. " instead of "
               .. keys
         end,
         length = 4,
      },
      ['[vV][ia]["\'`{}%[%]()<>bBwWspt]".[dy]'] = {
         message = function(keys)
            return "Use "
               .. keys:sub(4, 6)
               .. keys:sub(2, 3)
               .. " instead of "
               .. keys
         end,
         length = 6,
      },
   },
   ---@type function
   callback = function(text)
      vim.notify(
         text,
         vim.log.levels.WARN,
         { title = "hardtime", timeout = M.config.timeout }
      )
   end,
}

function M.set_defaults(user_config)
   for option, value in pairs(user_config) do
      if type(value) == "table" and #value == 0 then
         for k, v in pairs(value) do
            if next(v) == nil then
               M.config[option][k] = nil
            else
               M.config[option][k] = v
            end
         end
      else
         M.config[option] = value
      end
   end
end

return M
