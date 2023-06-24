local M = {}

M.config = {
   max_time = 1000,
   max_count = 2,
   disable_mouse = true,
   hint = true,
   allow_different_key = false,
   resetting_keys = {
      ["1"] = { "n", "v" },
      ["2"] = { "n", "v" },
      ["3"] = { "n", "v" },
      ["4"] = { "n", "v" },
      ["5"] = { "n", "v" },
      ["6"] = { "n", "v" },
      ["7"] = { "n", "v" },
      ["8"] = { "n", "v" },
      ["9"] = { "n", "v" },
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
      ["h"] = { "n", "v" },
      ["j"] = { "n", "v" },
      ["k"] = { "n", "v" },
      ["l"] = { "n", "v" },
      ["-"] = { "n", "v" },
      ["+"] = { "n", "v" },
      ["gj"] = { "n", "v" },
      ["gk"] = { "n", "v" },
      ["<CR>"] = { "n", "v" },
      ["<C-M>"] = { "n", "v" },
      ["<C-N>"] = { "n", "v" },
      ["<C-P>"] = { "n", "v" },
   },
   hint_keys = {
      ["k"] = { "n", "v" },
      ["j"] = { "n", "v" },
      ["^"] = { "n", "v" },
      ["$"] = { "n", "o" },
      ["a"] = { "n", "o" },
      ["i"] = { "n" },
      ["d"] = { "n" },
      ["c"] = { "n" },
      ["l"] = { "o" },
   },
   disabled_keys = { "<UP>", "<DOWN>", "<LEFT>", "<RIGHT>" },
   disabled_filetypes = { "qf", "netrw", "NvimTree", "lazy", "mason" },
}


M.hint_messages = {
   ["k^"] = "Use - instead of k^",
   ["j^"] = "Use + instead of j^",
   ["cl"] = "Use s instead of cl",
   ["d$"] = "Use D instead of d$",
   ["c$"] = "Use C instead of c$",
   ["$a"] = "Use A instead of $a",
   ["^i"] = "Use I instead of ^i",
}

return M
