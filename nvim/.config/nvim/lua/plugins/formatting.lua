function toggle_autoformat(buf)
  return Snacks.toggle({
    name = 'Auto Format (' .. (buf and 'Buffer' or 'Global') .. ')',
    get = function()
      local baf = vim.b[vim.api.nvim_get_current_buf()].autoformat
      if buf ~= nil and baf ~= nil then
        return baf
      end

      return vim.g.autoformat == nil or vim.g.autoformat
    end,
    set = function(state)
      if state == nil then
        state = true
      end
      if buf then
        vim.b.autoformat = state
      else
        vim.g.autoformat = state
        vim.b.autoformat = nil
      end
    end,
  })
end

return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>gf',
      function() require('conform').format({ async = true, lsp_format = 'fallback' }) end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = function()
    -- add toggle for autoformat (global and buffer)
    toggle_autoformat():map('<leader>uf')
    toggle_autoformat(true):map('<leader>uF')

    return {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- don't format on save if disabled
        if not vim.g.autoformat and not vim.b[bufnr].autoformat then
          return
        end

        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style.
        local disable_filetypes = { c = true, cpp = true }
        local lsp_format_opt
        if disable_filetypes[vim.bo[bufnr].filetype] then
          lsp_format_opt = 'never'
        else
          lsp_format_opt = 'fallback'
        end

        return {
          timeout_ms = 500,
          lsp_format = lsp_format_opt,
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        bash = { 'shfmt' },
        sh = { 'shfmt' },
        html = { 'prettierd' },
        css = { 'prettierd' },
        json = { 'prettier' },
        markdown = { 'prettierd' },
        yaml = { 'prettierd' },
        c = { 'clang_format' },
        cpp = { 'clang_format' },
        cmake = { 'cmakelang' },
        tex = { 'latexindent' },
        python = { 'black' },
        javascript = { 'prettierd' },
        typescript = { 'prettierd' },
      },
    }
  end,
}
