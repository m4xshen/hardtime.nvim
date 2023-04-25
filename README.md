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

A Neovim plugin stopping you from repeating the basic movement keys

Recommended workflow:
1. Don’t use arrow keys and mouse.
2. Use relative jump (eg: `5k` `12j`) for vertical movement inside screen.
3. Use `CTRL-U` `CTRL-D` `CTRL-B` `CTRL-F` `gg` `G` for vertical movement outside screen.
4. Use word-motion (`w` `W` `b` `B` `e` `E` `ge` `gE`) for short distance horizontal movement.
5. Use `f` `F` `t` `T` `0` `^` `$` `,` `;` for mid long distance horizontal movement.
6. Use operator + motion/text-object (eg: `ci{` `d5j`) whenever possible.

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

### Default config

```Lua
local config = {
   options = {
      max_time = 1000,
      max_count = 2,
      disable_mouse = true,
      allow_different_key = false,
   },
   resetting_keys = { "0", "1", "2", "3", "4", "5", "6", "7", "8", "9" },
   restricted_keys = { "h", "j", "k", "l", "-", "+", "<UP>", "<DOWN>", "<LEFT>", "<RIGHT>" },
   disabled_keys = { "<UP>", "<DOWN>", "<LEFT>", "<RIGHT>" },
   disabled_filetypes = { "NvimTree", "qf" }
}
```
