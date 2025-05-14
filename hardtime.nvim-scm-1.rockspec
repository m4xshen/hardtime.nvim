rockspec_format = "3.0"
package = "hardtime.nvim"
version = "scm-1"

test_dependencies = {
   "lua = 5.1",
   "nlua",
   "nui.nvim",
}

source = {
   url = "git://github.com/m4xshen/" .. package,
}

build = {
   type = "builtin",
}
