local M = {}

M.treesitter = {
  ensure_installed = {
    "vim",
    "lua",
    "html",
    "css",
    "javascript",
    "typescript",
    "tsx",
    "c",
    "markdown",
    "markdown_inline",
    "python",
    "astro"
  },
  indent = {
    enable = true,
  },
}

M.mason = {
  ensure_installed = {
    -- LSP
    "lua-language-server",
    "html-lsp",
    "css-lsp",
    "typescript-language-server",
    "tailwindcss-language-server",
    "bash-language-server",
    "pyright",
    "clangd",

    -- Formatters
    "stylua",
    "prettier",
    "black",
    "clang-format",

    -- Linters
    -- "flake8",
  },
}

M.nvimtree = {
  git = {
    enable = true,
  },
  renderer = {
    highlight_git = true,
    icons = {
      show = {
        git = true,
      },
    },
  },
}

return M

