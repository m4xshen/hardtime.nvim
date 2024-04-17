---@class ReportModel
---@field tab string
---@field content table<string , string>
---@field keybind string
local ReportModel = {
   tab = "",
   content = {},
   keybind = "",
}

--- @param tab string?
--- @param content table<string, string>
--- @param keybind string
function ReportModel.new(tab, content, keybind)
   local self = setmetatable({}, ReportModel)

   self.tab = tab
   self.content = content
   self.keybind = keybind

   return self
end

return ReportModel
