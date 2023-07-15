local M = {}

M.config = {
   max_time = 1000,
   max_count = 2,
   disable_mouse = true,
   hint = true,
   notification = true,
   allow_different_key = false,
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
   },
   restricted_keys = {
      ["h"] = { "n", "x" },
      ["j"] = { "n", "x" },
      ["k"] = { "n", "x" },
      ["l"] = { "n", "x" },
      ["-"] = { "n", "x" },
      ["+"] = { "n", "x" },
      ["gj"] = { "n", "x" },
      ["gk"] = { "n", "x" },
      ["<CR>"] = { "n", "x" },
      ["<C-M>"] = { "n", "x" },
      ["<C-N>"] = { "n", "x" },
      ["<C-P>"] = { "n", "x" },
   },
   disabled_keys = {
      ["<UP>"] = { "", "i" },
      ["<DOWN>"] = { "", "i" },
      ["<LEFT>"] = { "", "i" },
      ["<RIGHT>"] = { "", "i" },
   },
   disabled_filetypes = { "qf", "netrw", "NvimTree", "lazy", "mason" },
   hints = {
      ["k%^"] = {
         message = function()
            return "Use - instead of k^"
         end,
         length = 2,
      },
      ["j%^"] = {
         message = function()
            return "Use + instead of j^"
         end,
         length = 2,
      },
      -- BUG: vim.onkey() capture the synonym keys
      -- ["cl"] = {
      --    message = function()
      --       return "Use s instead of cl"
      --    end,
      --    length = 2,
      -- },
      -- ["d%$"] = {
      --    message = function()
      --       return "Use D instead of d$"
      --    end,
      --    length = 2,
      -- },
      -- ["c%$"] = {
      --    message = function()
      --       return "Use C instead of c$"
      --    end,
      --    length = 2,
      -- },
      ["%$a"] = {
         message = function()
            return "Use A instead of $a"
         end,
         length = 2,
      },
      ["%^i"] = {
         message = function()
            return "Use I instead of ^i"
         end,
         length = 2,
      },
      ["d[bBwWeE%^]i"] = {
         message = function(keys)
            return "Use "
               .. "c"
               .. string.sub(keys, 2, 2)
               .. " instead of "
               .. keys
         end,
         length = 3,
      },
      ["dg[eE]i"] = {
         message = function(keys)
            return "Use "
               .. "c"
               .. string.sub(keys, 2, 3)
               .. " instead of "
               .. keys
         end,
         length = 4,
      },
      ["d[tTfF].i"] = {
         message = function(keys)
            return "Use "
               .. "c"
               .. string.sub(keys, 2, 3)
               .. " instead of "
               .. keys
         end,
         length = 4,
      },
      ["d[ia][\"'{}%[%]()bBwWspt]i"] = {
         message = function(keys)
            return "Use "
               .. "c"
               .. string.sub(keys, 2, 3)
               .. " instead of "
               .. keys
         end,
         length = 4,
      },
   },
}

return M
