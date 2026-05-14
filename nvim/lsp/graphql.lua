return {
  cmd = { "graphql-lsp", "server", "-m", "stream" },
  filetypes = { "graphql", "typescriptreact", "javascriptreact" },
  root_markers = {
    ".graphqlrc",
    ".graphqlrc.json",
    ".graphqlrc.yaml",
    ".graphqlrc.yml",
    ".graphqlrc.toml",
    ".graphqlrc.js",
    ".graphqlrc.ts",
    "graphql.config.json",
    "graphql.config.js",
    "graphql.config.ts",
    ".git",
  },
}
