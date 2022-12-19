return {
  "mrjones2014/smart-splits.nvim",
  lazy = false, -- must load at startup to register @pane-is-vim with tmux before any keypress
  -- Navigation: C-h/j/k/l moves seamlessly between nvim splits and tmux panes
  -- Resize: use tmux prefix + h/j/k/l (Alt+key won't work — AeroSpace consumes Alt globally)
  config = function()
    local ss = require("smart-splits")
    vim.keymap.set("n", "<C-h>", ss.move_cursor_left,  { desc = "Move to left split/pane" })
    vim.keymap.set("n", "<C-j>", ss.move_cursor_down,  { desc = "Move to lower split/pane" })
    vim.keymap.set("n", "<C-k>", ss.move_cursor_up,    { desc = "Move to upper split/pane" })
    vim.keymap.set("n", "<C-l>", ss.move_cursor_right, { desc = "Move to right split/pane" })
  end,
}
