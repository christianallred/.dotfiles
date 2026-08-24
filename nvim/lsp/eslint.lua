return {
  cmd = { "vscode-eslint-language-server", "--stdio" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
    "vue",
    "svelte",
  },
  -- Tiered root detection (earlier tables = higher priority). Like the upstream
  -- lspconfig config, we root at the lockfile so a single eslint instance serves
  -- the whole monorepo; `workingDirectory = "auto"` (below) makes the server
  -- resolve each file's nearest flat/eslintrc config itself. Fall back to a
  -- local eslint config, then package.json/.git, for standalone repos.
  root_markers = {
    { "pnpm-lock.yaml", "package-lock.json", "yarn.lock", "bun.lockb", "bun.lock" },
    { "nx.json" },
    {
      ".eslintrc",
      ".eslintrc.js",
      ".eslintrc.cjs",
      ".eslintrc.json",
      "eslint.config.js",
      "eslint.config.mjs",
      "eslint.config.cjs",
      "eslint.config.ts",
    },
    { "package.json", ".git" },
  },
  -- Refer to https://github.com/Microsoft/vscode-eslint#settings-options
  settings = {
    validate = "on",
    useESLintClass = false,
    experimental = {},
    codeActionOnSave = { enable = false, mode = "all" },
    format = true,
    quiet = false,
    onIgnoredFiles = "off",
    rulesCustomizations = {},
    run = "onType",
    problems = { shortenToSingleLine = false },
    nodePath = "",
    workingDirectory = { mode = "auto" },
    codeAction = {
      disableRuleComment = { enable = true, location = "separateLine" },
      showDocumentation = { enable = true },
    },
  },
  before_init = function(_, config)
    -- The "workspaceFolder" is a VSCode concept the server requires to locate
    -- the ESLint config. Without it the server crashes textDocument/diagnostic
    -- with: `The "path" argument must be of type string. Received undefined`.
    local root_dir = config.root_dir
    if root_dir then
      config.settings = config.settings or {}
      config.settings.workspaceFolder = {
        uri = vim.uri_from_fname(root_dir),
        name = vim.fn.fnamemodify(root_dir, ":t"),
      }
    end
  end,
  handlers = {
    ["eslint/openDoc"] = function(_, result)
      if result then
        vim.ui.open(result.url)
      end
      return {}
    end,
    ["eslint/confirmESLintExecution"] = function(_, result)
      if not result then
        return
      end
      return 4 -- approved
    end,
    ["eslint/probeFailed"] = function()
      vim.notify("[eslint] ESLint probe failed.", vim.log.levels.WARN)
      return {}
    end,
    ["eslint/noLibrary"] = function()
      vim.notify("[eslint] Unable to find ESLint library.", vim.log.levels.WARN)
      return {}
    end,
  },
}
