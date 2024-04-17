local _ = require("hardtime.ui.report_model")
local tabs_renderer = require("hardtime.ui.tabs_renderer")
local content_renderer = require("hardtime.ui.content_renderer")

local M = {}

--- @param content table<ReportModel>
--- @param picked_tab integer
local function render_content(content, picked_tab, bufnr)
   vim.api.nvim_buf_set_option(bufnr, "modifiable", true)
   vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {})

   local tabs = {}

   for _, tab in ipairs(content) do
      table.insert(tabs, tab.tab)
   end

   content_renderer.render_title("Hardtime Report", bufnr)
   tabs_renderer.render_tabs(tabs, picked_tab, bufnr)
   content_renderer.spacer(bufnr)
   content_renderer.render_hints(content[picked_tab].content, bufnr)
   vim.api.nvim_buf_set_option(bufnr, "modifiable", false)
end

---@param content table<ReportModel>
local function add_keybinds(content, bufnr)
   vim.keymap.set("n", "q", function()
      vim.api.nvim_buf_delete(bufnr, { force = true })
   end, {
      buffer = bufnr,
      nowait = true,
      silent = true,
   })

   for i, con in ipairs(content) do
      vim.keymap.set("n", con.keybind, function()
         render_content(content, i, bufnr)
      end, {
         buffer = bufnr,
         nowait = true,
         silent = true,
      })
   end
end

local is_open = false

--- @param content table<ReportModel>
--- @param initial_tab integer
function M.open(content, initial_tab)
   if is_open then
      print("Report window is already open")
      return
   end

   local Popup = require("nui.popup")
   local event = require("nui.utils.autocmd").event

   local popup = Popup({
      enter = true,
      focusable = true,
      position = "50%",
      size = {
         width = "60%",
         height = "70%",
      },
      relative = "editor",
   })

   popup:mount()
   is_open = true

   add_keybinds(content, popup.bufnr)
   render_content(content, initial_tab, popup.bufnr)

   vim.api.nvim_buf_set_option(popup.bufnr, "modifiable", false)

   popup:on(event.BufLeave, function()
      popup:unmount()
      is_open = false
   end)
end

return M
