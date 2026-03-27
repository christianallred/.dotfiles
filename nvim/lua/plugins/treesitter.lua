return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  lazy = false,

  config = function()
    require("nvim-treesitter.config").setup({
      install_dir = vim.fn.stdpath('data') .. '/site',
      ensure_installed = {
        "javascript",
        "typescript",
        "lua",
        "go",
      },
      auto_install = true,
      highlight = {
        enable = true,
      },
      indent = {
        enable = true,
      },
    })
  end,
}
