local builtin = require('telescope.builtin')

local function map(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

local project_files = function()
    local opts = { show_untracked = true }
    vim.fn.system('git rev-parse --is-inside-work-tree')
    if vim.v.shell_error == 0 then
        require "telescope.builtin".git_files(opts)
    else
        require "telescope.builtin".find_files(opts)
    end
end


local diagnostics_active = true
local toggle_diagnostics = function()
  diagnostics_active = not diagnostics_active
  if diagnostics_active then
    vim.diagnostic.show()
  else
    vim.diagnostic.hide()
  end
end

vim.keymap.set('n', '<leader>tt', toggle_diagnostics)
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = '[P]re[V]iews' })
vim.keymap.set('n', '<leader>gf', builtin.git_files, { desc = '[G]it [F]ind' })
vim.keymap.set('n', '<leader>km', builtin.keymaps, { desc = '[K]ey[M]aps' })
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = 'Tr[ee]Toggle' }) -- toggle file explorer
vim.keymap.set("n", "<leader>ff", ":Format<CR>", { desc = '[F]ormat[F]ile' }) -- Format Files
vim.keymap.set("n", "<leader>lg", ":LazyGit<CR>", { desc = '[L]azy[G]it' }) -- Format Files
vim.keymap.set("n", "<leader>aff", ":write | edit | TSBufEnable highlight<CR>", { desc = 'FixTreeSitter' })
vim.keymap.set('n', '<leader>sf', project_files, { desc = '[S]earch [F]iles' })
-- For Splits on Windows
map("n", "<leader>w", "<C-w>", { silent = true })

map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

return {}