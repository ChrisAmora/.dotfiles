-- Using selimacerbas/markdown-preview.nvim instead of the canonical iamcco/markdown-preview.nvim
-- because it renders Mermaid diagrams inline via a live-server backend.
-- If this fork disappears, fall back to iamcco and add a separate mermaid renderer.
return {
  -- Disable LazyVim's default previewer to avoid conflicts
  { "iamcco/markdown-preview.nvim", enabled = false },

  {
    "selimacerbas/markdown-preview.nvim",
    name = "my_custom_mermaid_previewer", -- unique name to bypass Lazy's dedup/merging
    dependencies = { "selimacerbas/live-server.nvim" },
    cmd = { "MarkdownPreview", "MarkdownPreviewStop" },
    keys = {
      { "<leader>cp", "<cmd>MarkdownPreview<cr>", desc = "Mermaid Preview" },
    },
    config = function()
      require("markdown_preview").setup({})
    end,
  },
}
