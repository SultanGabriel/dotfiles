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


vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp" },
  callback = function()
    vim.bo.tabstop = 4
    vim.bo.shiftwidth = 4
    vim.bo.softtabstop = 4
    vim.bo.expandtab = true
  end,
})


vim.opt.foldmethod = "manual"
-- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = true
vim.opt.foldlevel = 99 -- don't auto-fold everything when opening a file

