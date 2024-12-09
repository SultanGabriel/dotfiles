local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"

local servers = { "html", "cssls", "clangd", "bashls", "pylsp", "pyright" }

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

-- Specific configurations for individual servers if needed
lspconfig.pyright.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "standard",
        useLibraryCodeForTypes = true,
      },
    },
  },
}

lspconfig.pylsp.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    pylsp = {
      plugins = {
        pyflakes = { enabled = true },
        pycodestyle = { enabled = true },
        mccabe = { enabled = true },
        pylsp_mypy = { enabled = true, live_mode = false },
        pylsp_rope = { enabled = true },
      },
    },
  },
}

lspconfig.clangd.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "clangd", "--background-index", "--suggest-missing-includes" },
  filetypes = { "c", "cpp", "objc", "objcpp" },
  root_dir = lspconfig.util.root_pattern("compile_commands.json", "compile_flags.txt", ".git"),
}

lspconfig.angularls.setup {
  on_attach = on_attach,
  -- on_init = on_init,
  capabilities = capabilities,
}

lspconfig.tsserver.setup {
  capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities),
  on_attach = on_attach,
}
