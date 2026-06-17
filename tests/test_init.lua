local ghui = require("ghui")
local config = require("ghui.config")
local eq = MiniTest.expect.equality

local T = MiniTest.new_set({
  hooks = {
    pre_case = function()
      config.options = vim.deepcopy(config.defaults)
    end,
  },
})

T["setup() merges and stores options"] = function()
  ghui.setup({ start_insert = false, window = { width = 0.7 } })
  eq(config.options.start_insert, false)
  eq(config.options.window.width, 0.7)
  eq(config.options.window.height, 0.9)
end

T["exposes open/close/toggle functions"] = function()
  eq(type(ghui.open), "function")
  eq(type(ghui.close), "function")
  eq(type(ghui.toggle), "function")
end

T["plugin file registers the :Ghui command"] = function()
  vim.cmd("runtime plugin/ghui.lua")
  eq(vim.fn.exists(":Ghui"), 2)
end

return T
