-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

vim.cmd([[ highlight NvimTreeIndentMarker guifg=#3FC5FF ]])

-- require("nvim-tree").setup({
--   sort_by = "case_sensitive",
--   view = {
--     adaptive_size = true,
--     mappings = {
--       list = {
--         { key = "u", action = "dir_up" },
--       },
--     },
--   },
--   renderer = {
--     group_empty = true,
--   },
--   filters = {
--     custom = {
--       "^\\.git"
--     }
--     -- dotfiles = true,
--   },
--   -- disable window_picker for
--   -- explorer to work well with
--   -- window splits
--   actions = {
--     open_file = {
--       window_picker = {
--         enable = false,
--       },
--     },
--   },
-- })
