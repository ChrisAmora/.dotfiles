local builtin = require('telescope.builtin')

local function map(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, {desc = '[P]re[V]iews'})
vim.keymap.set('n', '<leader>gf', builtin.git_files, {desc = '[G]it [F]ind'})
vim.keymap.set('n', '<leader>km', builtin.keymaps, {desc = '[K]ey[M]aps'})
-- vim.keymap.set('n', '<leader>lg', builtin.live_grep, {desc = '[L]ive[Grep]'})
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>") -- toggle file explorer
vim.keymap.set("n", "<leader>ff", ":Format<CR>") -- Format Files
vim.keymap.set("n", "<leader>lg", ":LazyGit<CR>") -- Format Files

-- For Splits on Windows
map("n", "<leader>w", "<C-w>", { silent = true})

map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
