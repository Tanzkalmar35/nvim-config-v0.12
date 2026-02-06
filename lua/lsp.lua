-- ~/.config/nvim-new/lua/lsp.lua
vim.lsp.enable({
  "bashls",
  "gopls",
  "lua_ls",
  "texlab",
  "pyright",
  "ts_ls",
  "ocamllsp",
  "yamlls",
})
vim.diagnostic.config({ virtual_text = true })
