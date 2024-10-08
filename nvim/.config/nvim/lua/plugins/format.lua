return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        lua = { "stylua" },
        bash = { "shfmt" },
        sh = { "shfmt" },
        html = { "prettierd" },
        css = { "prettierd" },
        json = { "prettier" },
        markdown = { "prettierd" },
        yaml = { "prettierd" },
        c = { "clang_format" },
        cpp = { "clang_format" },
        cmake = { "cmakelang" },
        tex = { "latexindent" },
        python = { "black" },
        javascript = { "prettierd" },
        typescript = { "prettierd" },
      },
      format_on_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        return { timeout_ms = 500, lsp_format = "fallback" }
      end,

      {
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      },
    })

    vim.api.nvim_create_user_command("FormatDisable", function(args)
      if args.bang then
        -- FormatDisable! will disable formatting just for this buffer
        vim.b.disable_autoformat = true
      else
        vim.g.disable_autoformat = true
      end
    end, {
        desc = "Disable autoformat-on-save",
        bang = true,
      })
    vim.api.nvim_create_user_command("FormatEnable", function()
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
    end, {
        desc = "Re-enable autoformat-on-save",
      })

    vim.keymap.set({ "n", "v" }, "<Leader>gf", function()
      conform.format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      })
    end, { desc = "Format file or range (in visual mode)" })
  end,
}
