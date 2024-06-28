--- @class ReportModel
--- @field tab string
--- @field report table<string , string>
--- @field keybind string
local ReportModel = {
   tab = "",
   report = {},
   keybind = "",
}

function ReportModel.new(tab, report, keybind)
   local self = setmetatable({}, ReportModel)

   self.tab = tab
   self.report = report
   self.keybind = keybind

   return self
end

return ReportModel
