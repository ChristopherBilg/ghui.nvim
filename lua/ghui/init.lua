local config = require("ghui.config")
local terminal = require("ghui.terminal")

local M = {}

---Apply user configuration. Optional, since the plugin works with defaults.
---@param opts? ghui.Config
function M.setup(opts)
  config.merge(opts)
end

---Open (or reveal) the ghui window.
function M.open()
  terminal.open()
end

---Hide the ghui window (the process keeps running).
function M.close()
  terminal.hide()
end

---Toggle the ghui window.
function M.toggle()
  terminal.toggle()
end

return M
