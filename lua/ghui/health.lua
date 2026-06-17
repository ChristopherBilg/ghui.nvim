local config = require("ghui.config")

local M = {}

---@param cmd string|string[]
---@return string
local function cmd_name(cmd)
  if type(cmd) == "table" then
    return cmd[1]
  end
  return cmd
end

---Return the trimmed first line of `<name> --version`, or "" if it produced none.
---@param name string
---@return string
local function version_line(name)
  local out = vim.fn.system({ name, "--version" }) or ""
  return vim.trim(vim.split(out, "\n", { plain = true })[1] or "")
end

function M.check()
  vim.health.start("ghui")

  if vim.fn.has("nvim-0.11") == 1 then
    vim.health.ok("Neovim >= 0.11")
  else
    vim.health.warn("Neovim 0.11+ is recommended; some features may be unavailable")
  end

  local name = cmd_name(config.options.cmd)
  if vim.fn.executable(name) == 1 then
    local version = version_line(name)
    vim.health.ok(("`%s` found (%s)"):format(name, version ~= "" and version or "version unknown"))
  else
    vim.health.error(("`%s` not found in PATH"):format(name), {
      "Install with Homebrew: brew install kitlangton/tap/ghui",
      "Install with npm: npm install -g @kitlangton/ghui",
      "See https://github.com/kitlangton/ghui",
    })
  end

  if vim.fn.executable("gh") == 1 then
    local version = version_line("gh")
    vim.health.ok(("`gh` found (%s)"):format(version ~= "" and version or "version unknown"))

    vim.fn.system({ "gh", "auth", "status" })
    if vim.v.shell_error == 0 then
      vim.health.ok("`gh` is authenticated")
    else
      vim.health.warn("`gh` is installed but not authenticated", { "Run: gh auth login" })
    end
  else
    vim.health.error("`gh` (GitHub CLI) not found in PATH; ghui requires it", {
      "Install gh: https://cli.github.com",
      "Then authenticate: gh auth login",
    })
  end
end

return M
