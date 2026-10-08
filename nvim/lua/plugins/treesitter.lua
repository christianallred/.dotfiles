-- nvim-treesitter `main` branch: the plugin only installs parsers now,
-- highlighting/indent are turned on per buffer with the built-in vim.treesitter.
-- Needs the `tree-sitter` CLI and a C compiler to build parsers.
local parsers = {
  "javascript",
  "typescript",
  "tsx",
  "lua",
  "go",
}

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",
  lazy = false,

  config = function()
    local ts = require("nvim-treesitter")
    ts.setup({
      install_dir = vim.fn.stdpath("data") .. "/site",
    })
    ts.install(parsers)

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("treesitter-start", { clear = true }),
      callback = function(args)
        -- pcall: no-op for filetypes without an installed parser
        if pcall(vim.treesitter.start, args.buf) then
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
