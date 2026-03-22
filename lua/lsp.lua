-- ~/.config/nvim-new/lua/lsp.lua
vim.lsp.enable({
  "bashls",
  "gopls",
  "lua_ls",
  "pyright",
  "texlab",
  "ts_ls",
  "ocamllsp",
  "yamlls",
  "zls"
})
vim.diagnostic.config({ virtual_text = true })
