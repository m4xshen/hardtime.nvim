<h1 align="center">
hardtime.nvim
</h1>

<p align="center">
<a href="https://github.com/m4xshen/hardtime.nvim/stargazers">
    <img
      alt="Stargazers"
      src="https://img.shields.io/github/stars/m4xshen/hardtime.nvim?style=for-the-badge&logo=starship&color=fae3b0&logoColor=d9e0ee&labelColor=282a36"
    />
  </a>
  <a href="https://github.com/m4xshen/hardtime.nvim/issues">
    <img
      alt="Issues"
      src="https://img.shields.io/github/issues/m4xshen/hardtime.nvim?style=for-the-badge&logo=gitbook&color=ddb6f2&logoColor=d9e0ee&labelColor=282a36"
    />
  </a>
  <a href="https://github.com/m4xshen/hardtime.nvim/contributors">
    <img
      alt="Contributors"
      src="https://img.shields.io/github/contributors/m4xshen/hardtime.nvim?style=for-the-badge&logo=opensourceinitiative&color=abe9b3&logoColor=d9e0ee&labelColor=282a36"
    />
  </a>
</p>

<p align="center">
  <img src="https://github.com/m4xshen/hardtime.nvim/assets/74842863/f7c797a0-3fe6-47b3-9c9a-5ec7d54de128" width="700" />
</p>

## 📃 Introduction

A Neovim plugin helping you establish good command workflow and habit

## ⚙️  Features

- Block repeated keys within a period of time
- Print hints about better commands eg: Use `ci"` instead of `di"i`
- Disable keys and mouse
- Customizable options for restricted keys, disabled keys, etc.

Recommended workflow:
1. Avoid using the mouse and arrow keys if they are not at the home row of your keyboard.
2. Use relative jump (eg: `5j` `12-`) for vertical movement within the screen.
3. Use `CTRL-U` `CTRL-D` `CTRL-B` `CTRL-F` `gg` `G` for vertical movement outside the screen.
4. Use word-motion (`w` `W` `b` `B` `e` `E` `ge` `gE`) for short-distance horizontal movement.
5. Use `f` `F` `t` `T` `,` `;` `0` `^` `$` for medium to long-distance horizontal movement.
6. Use operator + motion/text-object (eg: `ci{` `y5j` `dap`) whenever possible.
7. Use `%` and square bracket commands (see `:h [`) to jump between brackets.

Learn more in this [blog post](https://m4xshen.dev/posts/vim-command-workflow/)

## ⚡ Requirements

- Neovim >= [v0.7.0](https://github.com/neovim/neovim/releases/tag/v0.7.0)

## 📦 Installation

1. Install via your favorite package manager.

> ❗️You don't need to specify `event = "VeryLazy"` anymore.

- [lazy.nvim](https://github.com/folke/lazy.nvim)
```Lua
{
  "m4xshen/hardtime.nvim",
  opts = {}
},
```

- [packer.nvim](https://github.com/wbthomason/packer.nvim)
```Lua
use "m4xshen/hardtime.nvim"
```

- [vim-plug](https://github.com/junegunn/vim-plug)
```VimL
Plug "m4xshen/hardtime.nvim"
```

2. Setup the plugin in your `init.lua`. This step is not needed with lazy.nvim if `opts` is set as above.
```Lua
require("hardtime").setup()
```

If you want to see the hint messages in insert and visual mode, set the `'showmode'` to false.

But if you want to see both the hint message and mode you can setup with one of the following methods:
- Display the mode on status line and set `'showmode'` to false. You can do this with some statusline plugin such as lualine.nvim.
- Set the `'cmdheight'` to 2 so that the hint message won't be replaced by mode message.
- Use nvim-notify to display hint messages on the right top corner instead of commandline.
   
## 🚀 Usage

hardtime.nvim is enable by default. You can change its state through commands:

- `:Hardtime enable` enable hardtime.nvim
- `:Hardtime disable` disable hardtime.nvim
- `:Hardtime toggle` toggle hardtime.nvim

## 🔧 Configuration

You can pass your config table into the `setup()` function or `opts` if you use lazy.nvim.

### Options

- `max_time` (number): Maximum time (in milliseconds) to consider key presses as repeated.
- `max_count` (number): Maximum count of repeated key presses allowed within the `max_time` period.
- `disable_mouse` (boolean): Disable mouse support.
- `hint` (boolean): Enable hint messages for better commands.
- `notification` (boolean): Enable notification messages for restricted and disabled keys.
- `allow_different_key` (boolean): Allow different keys to reset the count.
- `resetting_keys` (table of strings/table pair): Keys in what modes that reset the count.
- `restricted_keys` (table of strings/table pair): Keys in what modes triggering the count mechanism.
- `disabled_keys` (table of strings/table pair): Keys in what modes are disabled.
- `disabled_filetypes` (table of strings): hardtime.nvim is disabled under these filetypes.
- `hints` (table): key is a string pattern you want to match, value is a table of hint message and pattern length.

See example:

```lua
hints = {
   ["k%^"] = {
      message = function()
         return "Use - instead of k^" -- return the hint message you want to display
      end,
      length = 2, -- the length of actual key strokes that matches this pattern
   },
   ["d[tTfF].i"] = { -- this matches d + {t/T/f/F} + {any character} + i
      message = function(keys) -- keys is the key strokes that matches the pattern
         return "Use " .. "c" .. keys:sub(2, 3) .. " instead of " .. keys
         -- example: Use ct( instead of dt(i
      end,
      length = 4,
   },
}
```

### Default config

```Lua
local config = {
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
      ["<RIGHT>"] = { "", "i" }
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
         length = 3,
      },
      ["2D"] = {
         message = function()
            return "Use dj instead of 2D"
         end,
         length = 2,
      },
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
      ["VG[dcy=<>]"] = {
         message = function(keys)
            return "Use " .. keys:sub(3, 3) .. "G instead of " .. keys
         end,
         length = 3,
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
   },
}
```
