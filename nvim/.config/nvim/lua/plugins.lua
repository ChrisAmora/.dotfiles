return require('packer').startup(function()
  use 'wbthomason/packer.nvim'
  use {'dracula/vim', as = 'dracula'}
  use 'nvim-lua/plenary.nvim'
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  use 'nvim-telescope/telescope.nvim'
  use 'neovim/nvim-lspconfig' -- Configurations for Nvim LSP

  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'


 -- For luasnip users.
  use 'L3MON4D3/LuaSnip'
  use 'saadparwaiz1/cmp_luasnip'
end)
