-- ~/.config/nvim-new/lua/lsp.lua
vim.lsp.enable({
  "bashls",
  "gopls",
  "lua_ls",
  "texlab",
  "pyright",
  "ts_ls",
  "rust-analyzer",
  "yamlls",
})
vim.diagnostic.config({ virtual_text = true })
