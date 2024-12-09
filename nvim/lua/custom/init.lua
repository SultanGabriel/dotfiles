-- local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window
-- autocmd("VimResized", {
--   pattern = "*",
--   command = "tabdo wincmd =",
-- })

vim.opt.colorcolumn = "80"

vim.g.python3_host_prog = '/mnt/c/ProgramData/chocolatey/bin/python3.12.exe'

vim.g.clipboard = {
name = 'WslClipboard',
copy = {
  ['+'] = 'clip.exe',
  ['*'] = 'clip.exe',
},
paste = {
  ['+'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
  ['*'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
},
cache_enabled = 0,
}

