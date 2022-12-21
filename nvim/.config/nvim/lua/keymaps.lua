local builtin = require('telescope.builtin')
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, {desc = '[P]re[V]iews'})
vim.keymap.set('n', '<leader>gf', builtin.git_files, {desc = '[G]it [F]ind'})
vim.keymap.set('n', '<leader>km', builtin.keymaps, {desc = '[K]ey[M]aps'})

