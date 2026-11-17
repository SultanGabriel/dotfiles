local capabilities = vim.lsp.protocol.make_client_capabilities()

local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")

if ok then
  capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

-- ---------------------------------------------------------
-- Shared configuration
-- ---------------------------------------------------------

local servers = {
  "lua_ls",
  "html",
  "cssls",
  "ts_ls",
  "tailwindcss",
  "bashls",
  "pyright",
  "clangd",
  "yamlls",
  "jsonls",
  "astro",
  "eslint",
}

-- Not installed unused yet
local optional_servers = {
  "angularls",
  "solargraph", -- Ruby lol why was this in my config
}

for _, server in ipairs(servers) do
  vim.lsp.config(server, {
    capabilities = capabilities,
  })
end

-- ---------------------------------------------------------
-- Python
-- ---------------------------------------------------------

vim.lsp.config("pyright", {
  capabilities = capabilities,

  settings = {
    python = {
      analysis = {
        typeCheckingMode = "standard",
        useLibraryCodeForTypes = true,
      },
    },
  },
})

-- ---------------------------------------------------------
-- C / C++
-- ---------------------------------------------------------

vim.lsp.config("clangd", {
  capabilities = capabilities,

  cmd = {
    "clangd",
    "--background-index",
  },

  filetypes = {
    "c",
    "cpp",
    "objc",
    "objcpp",
  },

  root_markers = {
    "compile_commands.json",
    "compile_flags.txt",
    ".git",
  },
})

-- ---------------------------------------------------------
-- Enable
-- ---------------------------------------------------------

vim.lsp.enable(servers)
