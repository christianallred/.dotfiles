local attachGroup = vim.api.nvim_create_augroup("lsp-attach", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
  group = attachGroup,
  callback = function(event)
    local map = function(mode, keys, func, desc)
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
    end

    local tele_builtin = require("telescope.builtin")

    map("n", "gd", tele_builtin.lsp_definitions, "[g]oto [d]efinition")
    map("n", "gr", function()
      tele_builtin.lsp_references({ show_line = false })
    end, "[g]oto [r]eferences")
    map("n", "gi", tele_builtin.lsp_implementations, "[g]oto [i]mplementation")
    map("n", "<leader>D", tele_builtin.lsp_type_definitions, "Type [D]efinition")
    map("n", "<leader>ds", tele_builtin.lsp_document_symbols, "[d]ocument [s]ymbols")
    map("n", "<leader>ws", tele_builtin.lsp_dynamic_workspace_symbols, "[w]orkspace [s]ymbols")
    map("n", "<leader>rn", vim.lsp.buf.rename, "[r]e[n]ame")
    map("n", "<leader>lh", vim.lsp.buf.signature_help, "[l]sp [h]elp")
    map("n", "K", vim.lsp.buf.hover, "Hover Documentation")
    map("n", "gD", vim.lsp.buf.declaration, "[g]oto [D]eclaration")

    map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "[c]ode [a]ction")
    map("n", "<leader>rs", function()
      local bufnr = vim.api.nvim_get_current_buf()
      local clients = vim.lsp.get_clients({ bufnr = bufnr })
      for _, client in ipairs(clients) do
        vim.lsp.stop_client(client.id)
      end
      -- Re-fire FileType so enabled servers reattach, without reloading the
      -- buffer (avoids E37 on unsaved changes). Wait for clients to exit first.
      vim.defer_fn(function()
        vim.api.nvim_exec_autocmds("FileType", { buffer = bufnr })
      end, 300)
    end, "Restart LSP")

    map("n", "[d", function()
      vim.diagnostic.jump({ count = -1, float = true })
    end, "Go to previous diagnostic")
    map("n", "]d", function()
      vim.diagnostic.jump({ count = 1, float = true })
    end, "Go to next diagnostic")
    map("n", "<leader>d", vim.diagnostic.open_float, "Show line diagnostics")

    -- Native completion (vim.lsp.completion is auto-enabled in lsp.lua)
    map("i", "<C-Space>", function()
      vim.lsp.completion.get()
    end, "Trigger completion")
  end,
})
