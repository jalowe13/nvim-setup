--
-- Description: Configuration for the lsp config
-- Author: Jacob Lowe
-- Cababilities are used to make sure that the lsp config works with my project in the current UTF-16 encoding
--#region


local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.offsetEncoding = {" utf-16" }
return {
-- Coniguration to make sure lsp config works with C++ and especially my project
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "clangd","omnisharp", "powershell_es" },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      lspconfig.clangd.setup({
        capabilities = capabilities,
        cmd = {
          "clangd",
          "--background-index",
          --"--header-insertation=never",
          "-static-libstdc++",
          "--query-driver=C:\\msys64\\mingw64\\bin\\clangd.exe",
        },
        filetypes = { "c", "cpp", "objc", "objcpp" },
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    dependencies = { "clangd_extensions.nvim", "mason.nvim" },
    opts = function()
      local opts = {
        formatters_by_ft = {
          c = { "clang_format" },
          cpp = { "clang_format" },
          objc = { "clang_format" },
          objcpp = { "clang_format" },
          cuda = { "clang_format" },
          proto = { "clang_format" },
          cs = {"csharpier"},
        },
      }
      return opts
    end,
  },
}
