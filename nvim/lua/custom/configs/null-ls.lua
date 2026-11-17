local null_ls = require "null-ls"

local b = null_ls.builtins

local sources = {
  b.formatting.prettier.with {
    filetypes = {
      "html",
      "css",
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "markdown",
    },
  },

  b.formatting.stylua,
  b.formatting.clang_format,
  b.formatting.black,
}

null_ls.setup {
  debug = true,
  sources = sources,
}
