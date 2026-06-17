local M = {}

---@class ghui.WindowConfig
---@field width number Fraction (0<n<=1) of the editor, or absolute columns (>1)
---@field height number Fraction (0<n<=1) of the editor, or absolute rows (>1)
---@field border string|string[] Any nvim_open_win border value
---@field relative string nvim_open_win `relative` value
---@field title string Float title (Neovim 0.9+)
---@field title_pos string Title position ("left"|"center"|"right")
---@field zindex integer Float z-index
---@field winblend integer Window transparency (0-100)

---@class ghui.Keymaps
---@field close string|false Buffer-local "hide window" mapping, or false to disable

---@class ghui.Config
---@field cmd string|string[] Command used to launch ghui
---@field args string[] Extra args appended to `cmd`
---@field window ghui.WindowConfig
---@field start_insert boolean Enter terminal-mode on open
---@field keymaps ghui.Keymaps
---@field on_open? fun(term: ghui.Terminal)
---@field on_exit? fun(code: integer)

---@type ghui.Config
M.defaults = {
  cmd = "ghui",
  args = {},
  window = {
    width = 0.9,
    height = 0.9,
    border = "rounded",
    relative = "editor",
    title = " ghui ",
    title_pos = "center",
    zindex = 50,
    winblend = 0,
  },
  start_insert = true,
  keymaps = {
    close = false,
  },
}

---The active configuration (defaults until `merge()` is called).
---@type ghui.Config
M.options = vim.deepcopy(M.defaults)

local KNOWN = {
  cmd = true,
  args = true,
  window = true,
  start_insert = true,
  keymaps = true,
  on_open = true,
  on_exit = true,
}

---@param opts table
local function warn_unknown(opts)
  for key in pairs(opts) do
    if not KNOWN[key] then
      vim.notify(("ghui: unknown config key '%s'"):format(key), vim.log.levels.WARN)
    end
  end
end

---@param cfg ghui.Config
local function validate(cfg)
  local cmd_type = type(cfg.cmd)
  assert(cmd_type == "string" or cmd_type == "table", "ghui: `cmd` must be a string or string[]")
  assert(type(cfg.args) == "table", "ghui: `args` must be a table")
  assert(type(cfg.window) == "table", "ghui: `window` must be a table")
  assert(type(cfg.window.width) == "number", "ghui: `window.width` must be a number")
  assert(type(cfg.window.height) == "number", "ghui: `window.height` must be a number")
  assert(type(cfg.start_insert) == "boolean", "ghui: `start_insert` must be a boolean")
  assert(
    cfg.on_open == nil or type(cfg.on_open) == "function",
    "ghui: `on_open` must be a function"
  )
  assert(
    cfg.on_exit == nil or type(cfg.on_exit) == "function",
    "ghui: `on_exit` must be a function"
  )
end

---Merge user options over the defaults, validate, and store as the active options.
---@param opts? ghui.Config
---@return ghui.Config
function M.merge(opts)
  opts = opts or {}
  assert(type(opts) == "table", "ghui: config must be a table")
  warn_unknown(opts)
  local merged = vim.tbl_deep_extend("force", vim.deepcopy(M.defaults), opts) --[[@as ghui.Config]]
  -- `args` is a list; replace it wholesale rather than index-merging with defaults.
  if opts.args ~= nil then
    merged.args = vim.deepcopy(opts.args)
  end
  validate(merged)
  M.options = merged
  return merged
end

return M
