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

## 📃 Introduction

A Neovim plugin helping you establish good command workflow and habit

## ⚙️  Features

- Block repeated `k` `j` `h` `l` within a period of time
- Print hints about better commands eg: Use `C` instead of `c$`
- Disable arrow keys and mouse
- Provides customizable options for restricted keys, disabled keys, etc.

Recommended workflow:
1. Avoid using arrow keys and the mouse.
2. Use relative jump (eg: `5j` `12-`) for vertical movement within the screen.
3. Use `CTRL-U` `CTRL-D` `CTRL-B` `CTRL-F` `gg` `G` for vertical movement outside the screen.
4. Use word-motion (`w` `W` `b` `B` `e` `E` `ge` `gE`) for short-distance horizontal movement.
5. Use `f` `F` `t` `T` `,` `;` `0` `^` `$` for medium to long-distance horizontal movement.
6. Use operator + motion/text-object (eg: `ci{` `y5j` `dap`) whenever possible.
7. Use `%` and square bracket commands (see `:h [`) to jump between brackets.

Learn more in this [blog post](https://m4xshen.me/posts/vim-command-workflow/)

## ⚡ Requirements

- Neovim >= [v0.7.0](https://github.com/neovim/neovim/releases/tag/v0.7.0)

## 📦 Installation

1. Install via your favorite package manager.

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

## 🔧 Configuration

You can pass your config table into the `setup()` function or `opts` if you use lazy.nvim.

### Options

- `max_time` (number): Maximum time (in milliseconds) to consider key presses as repeated.
- `max_count` (number): Maximum count of repeated key presses allowed within the `max_time` period.
- `disable_mouse` (boolean): Disable mouse support.
- `hint` (boolean): Enable hint messages for better commands.
- `allow_different_key` (boolean): Allow different keys to reset the count.
- `resetting_keys` (table of strings): Keys that reset the count.
- `restricted_keys` (table of strings): Keys triggering the count mechanism.
- `hint_keys` (table of strings): Keys that trigger hint messages.

### Default config

```Lua
local config = {
   max_time = 1000,
   max_count = 2,
   disable_mouse = true,
   hint = true,
   allow_different_key = false,
   resetting_keys = { "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
      "c", "C", "d", "x", "X", "y", "Y", "p", "P" },
   restricted_keys = { "h", "j", "k", "l", "-", "+" },
   hint_keys = { "k", "j", "^", "$", "a", "i", "d", "y", "c", "l" },
   disabled_keys = { "<UP>", "<DOWN>", "<LEFT>", "<RIGHT>" },
   disabled_filetypes = { "qf", "netrw", "NvimTree", "lazy", "mason" }
}
```
