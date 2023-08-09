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
            return "Use <CR> or + instead of j^"
         end,
         length = 2,
      },
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
      ["2dd"] = {
         message = function()
            return "Use dj instead of 2dd"
         end,
      },
      ["2cc"] = {
         message = function()
            return "Use cj instead of 2cc"
         end,
      },
      ["2yy"] = {
         message = function()
            return "Use yj instead of 2yy"
         end,
      },
      ["2=="] = {
         message = function()
            return "Use =j instead of 2=="
         end,
      },
      ["2>>"] = {
         message = function()
            return "Use >j instead of 2>>"
         end,
      },
      ["2<<"] = {
         message = function()
            return "Use <j instead of 2<<"
         end,
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
      ["[vV][bBwWeE%^%$][dcy=<>]"] = {
         message = function(keys)
            return "Use "
               .. keys:sub(3, 3)
               .. keys:sub(2, 2)
               .. " instead of "
               .. keys
         end,
         length = 3,
      },
      ['[vV][bBwWeE%^%$]".[dy]'] = {
         message = function(keys)
            return "Use "
               .. keys:sub(3, 5)
               .. keys:sub(2, 2)
               .. " instead of "
               .. keys
         end,
         length = 5,
      },
      ["[vV]g[eE][dcy=<>]"] = {
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
      ["[vV][tTfF].[dcy=<>]"] = {
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
}

return M
