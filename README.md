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
  <img src="https://github.com/m4xshen/hardtime.nvim/assets/74842863/117a8d30-64ba-4ca9-8414-5c493cbe8a70" width="700" />
</p>

## 📃 Introduction

A Neovim plugin helping you establish good command workflow and habit

## ⚙️  Features

- Block repeated keys within a period of time
- Print hints about better commands eg: Use `ci"` instead of `di"i`
- Customizable options for restricted keys, disabled keys, etc.
- Get report for your most common bad habits for improvement

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

- [lazy.nvim](https://github.com/folke/lazy.nvim)
```Lua
{
   "m4xshen/hardtime.nvim",
   dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
   opts = {}
},
```

- [packer.nvim](https://github.com/wbthomason/packer.nvim)
```Lua
use {
   "m4xshen/hardtime.nvim",
   requires = { 'MunifTanjim/nui.nvim', "nvim-lua/plenary.nvim" }
}
```

2. Setup the plugin in your `init.lua`. This step is not needed with lazy.nvim if `opts` is set as above.
```Lua
require("hardtime").setup()
```

If you want to see the hint messages in insert and visual mode, set the `'showmode'` to false.

But if you want to see both the hint message and current mode you can setup with one of the following methods:
- Display the mode on status line and set `'showmode'` to false. You can do this with some statusline plugin such as lualine.nvim.
- Set the `'cmdheight'` to 2 so that the hint message won't be replaced by mode message.
- Use nvim-notify to display hint messages on the right top corner instead of commandline.
   
## 🚀 Usage

hardtime.nvim is enable by default. You can change its state through commands:

- `:Hardtime enable` enable hardtime.nvim
- `:Hardtime disable` disable hardtime.nvim
- `:Hardtime toggle` toggle hardtime.nvim

You can view the most frequently seen hints with `:Hardtime report`.

Your log file is at `~/.cache/nvim/hardtime.nvim.log`.

## 🔧 Configuration

You can pass your config table into the `setup()` function or `opts` if you use lazy.nvim.

If the option is a boolean, number, or array, your value will overwrite the default configuration.

Example:
```lua
-- Add "oil" to the disabled_filetypes
disabled_filetypes = { "qf", "netrw", "NvimTree", "lazy", "mason", "oil" },
```

If the option is a table with a `key = value` pair, your value will overwrite the default if the key exists, and the pair will be appended to the default configuration if the key doesn't exist. You can set `key = {}` to remove the default key-value pair.

Example:
```lua
-- Remove <Up> keys and append <Space> to the disabled_keys
disabled_keys = {
   ["<Up>"] = {},
   ["<Space>"] = { "n", "x" },
},
```

### Options

- `max_time` (number): Maximum time (in milliseconds) to consider key presses as repeated.
- `max_count` (number): Maximum count of repeated key presses allowed within the `max_time` period.
- `disable_mouse` (boolean): Disable mouse support.
- `hint` (boolean): Enable hint messages for better commands.
- `notification` (boolean): Enable notification messages for restricted and disabled keys.
- `allow_different_key` (boolean): Allow different keys to reset the count.
- `enabled` (boolean): Whether the plugin is enabled by default or not.
- `resetting_keys` (table of strings/table pair): Keys in what modes that reset the count.
- `restricted_keys` (table of strings/table pair): Keys in what modes triggering the count mechanism.
- `disabled_keys` (table of strings/table pair): Keys in what modes are disabled.
- `disabled_filetypes` (table of strings): hardtime.nvim is disabled under these filetypes.
- `hints` (table): key is a string pattern you want to match, value is a table of hint message and pattern length. (hardtime.nvim only supports hints in Normal mode and Visual mode currently)

Example:

```lua
hints = {
   ["k%^"] = {
      message = function()
         return "Use - instead of k^" -- return the hint message you want to display
      end,
      length = 2, -- the length of actual key strokes that matches this pattern
   },
   ["d[tTfF].i"] = { -- this matches d + {t/T/f/F} + {any character} + i
      message = function(keys) -- keys is a string of key strokes that matches the pattern
         return "Use " .. "c" .. keys:sub(2, 3) .. " instead of " .. keys
         -- example: Use ct( instead of dt(i
      end,
      length = 4,
   },
}
```

Learn more about [Lua string pattern](https://www.lua.org/pil/20.2.html).

### [Default config](https://github.com/m4xshen/hardtime.nvim/blob/main/lua/hardtime/config.lua)

## 🦾 Contributing

Please read [CONTRIBUTING.md](https://github.com/m4xshen/hardtime.nvim/blob/main/CONTRIBUTING.md).
