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
- Print hints about better commands eg: Use `C` instead of `c$`
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

Learn more in this [blog post](https://m4xshen.me/posts/vim-command-workflow/)

## ⚡ Requirements

- Neovim >= [v0.7.0](https://github.com/neovim/neovim/releases/tag/v0.7.0)

## 📦 Installation

1. Install via your favorite package manager.

- [lazy.nvim](https://github.com/folke/lazy.nvim)
```Lua
{
  "m4xshen/hardtime.nvim",
  event = "VeryLazy",
  opts = {}
},
```

> ❗️make sure your custom keymaps related to restricted keys are set before the plugin loads

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
   disabled_keys = {
      ["<UP>"] = { "", "i" },
      ["<DOWN>"] = { "", "i" },
      ["<LEFT>"] = { "", "i" },
      ["<RIGHT>"] = { "", "i" }
   },
   disabled_filetypes = { "qf", "netrw", "NvimTree", "lazy", "mason" },
}
```
