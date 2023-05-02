-- custom/configs/null-ls.lua

local null_ls = require "null-ls"

local formatting = null_ls.builtins.formatting
local lint = null_ls.builtins.diagnostics
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local sources = {
  formatting.prettier,
  formatting.stylua,
  formatting.yapf,

  --  lint.shellcheck,
  -- lint.checkstyle,
  -- lint.codespell.with { filetypes = { "python" } },
  -- lint.flake8.with {
  --   extra_args = { "--ignore", "e501", "--select", "e126" },
  -- },
}

null_ls.setup {
  debug = true,
  sources = sources,
  on_attach = function(client, bufnr)
    if client.supports_method "textDocument/formatting" then
      vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
          vim.lsp.buf.format { bufnr = bufnr }
          --vim.lsp.buf.formatting_sync()
        end,
      })
    end
  end,
}
