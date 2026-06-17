local eq = MiniTest.expect.equality

local T = MiniTest.new_set()

T["checkhealth ghui reports the plugin's own diagnostics"] = function()
  vim.cmd("checkhealth ghui")
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local report = table.concat(lines, "\n")
  -- Section is present...
  eq(report:find("ghui", 1, true) ~= nil, true)
  -- ...and it contains OUR Neovim-version diagnostic, which the "no provider
  -- found" message does not, so this genuinely fails without health.lua.
  eq(report:find("Neovim", 1, true) ~= nil, true)
end

return T
