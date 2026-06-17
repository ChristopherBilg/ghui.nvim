if vim.g.loaded_ghui then
  return
end
vim.g.loaded_ghui = true

vim.api.nvim_create_user_command("Ghui", function()
  require("ghui").toggle()
end, { desc = "Toggle the ghui TUI" })
