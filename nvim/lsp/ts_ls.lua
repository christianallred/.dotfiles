return {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  -- Tiered root detection (earlier tables = higher priority, even if farther up
  -- the tree). In a monorepo we want ONE tsserver rooted at the workspace top so
  -- it loads tsconfig.base.json and resolves `paths`/project references across
  -- packages. Only fall back to per-project markers for standalone repos.
  root_markers = {
    { "nx.json", "pnpm-workspace.yaml", "lerna.json", "turbo.json" },
    { "tsconfig.base.json" },
    { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
  },
  init_options = {
    -- Headroom so tsserver doesn't OOM/SIGABRT while loading a large monorepo.
    maxTsServerMemory = 8192,
  },
}
