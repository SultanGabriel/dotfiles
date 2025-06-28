---@type MappingsTable
local M = {}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
  },
  v = {
    [">"] = { ">gv", "indent" },
  },
}

M.copilot = {
  i = {
    ["<C-l>"] = {
      function()
        vim.fn.feedkeys(vim.fn["copilot#Accept"](), "")
      end,
      "Copilot Accept",
      {
        replace_keycodes = true,
        nowait = true,
        silent = true,
        expr = true,
        noremap = true,
      },
    },
  },
}

M.harpoon = {
  n = {
    ["<leader>ha"] = {
      function()
        local harpoon = require "harpoon"
        harpoon:list():add()
      end,
      "?? Harpoon Add file",
    },
    ["<leader>ta"] = { "<CMD>Telescope harpoon marks<CR>", "?? Toggle quick menu" },
    ["<leader>hb"] = {
      function()
        local harpoon = require "harpoon"
        harpoon.ui:toggle_quick_menu(harpoon:list(), {
          title = "Harpoon btw",
          title_pos = "center",
          border = "rounded",
          ui_width_ratio = 0.40,
        })
      end,
      "?? Harpoon Menu",
    },
    ["<leader>1"] = {
      function()
        local harpoon = require "harpoon"
        harpoon:list():select(1)
      end,
      "?? Navigate to file 1",
    },
    ["<leader>2"] = {
      function()
        local harpoon = require "harpoon"
        harpoon:list():select(2)
      end,
      "?? Navigate to file 2",
    },
    ["<leader>3"] = {
      function()
        local harpoon = require "harpoon"
        harpoon:list():select(3)
      end,
      "?? Navigate to file 3",
    },
    ["<leader>4"] = {
      function()
        local harpoon = require "harpoon"
        harpoon:list():select(4)
      end,
      "?? Navigate to file 4",
    },
    -- ["<leader>hn"] = {}
  },
}
-- vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
-- vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)

M.diagnostics = {
  n = {
    ["<leader>t"] = { "<CMD>Trouble diagnostics toggle<CR>", "?? Toggle warnings" },
    ["<leader>td"] = { "<CMD>Trouble qflist toggle<CR>", "? Todo/Fix/Fixme" },
    ["<leader>el"] = { "<CMD>ErrorLensToggle<CR>", "?? Toggle error lens" },
    ["<leader>ft"] = { "<CMD>TodoTelescope<CR>", "? Telescope TODO" },
    ["<Leader>ll"] = {
      function()
        require("lsp_lines").toggle()
      end,
      "? Toggle lsp_lines",
    },
  },
}

-- more keybinds!

return M
