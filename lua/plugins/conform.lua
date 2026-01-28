-- Profiling toggle (set to false to disable profiling)
vim.g.conform_profiling = true

return { -- Autoformat
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format { async = true, lsp_format = 'fallback' }
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
    {
      '<leader>tp',
      function()
        vim.g.conform_profiling = not vim.g.conform_profiling
        vim.notify('[conform] Profiling: ' .. (vim.g.conform_profiling and 'ON' or 'OFF'), vim.log.levels.INFO)
      end,
      desc = '[T]oggle format [P]rofiling',
    },
  },
  config = function(_, opts)
    require('conform').setup(opts)
    -- Setup :ConformProfile command
    require('utils.format_profiler').setup()
  end,
  opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
      local disable_filetypes = { c = true, cpp = true }
      if disable_filetypes[vim.bo[bufnr].filetype] then
        return nil
      end

      local base_opts = {
        timeout_ms = 500,
        lsp_format = 'fallback',
      }

      -- Use profiler if enabled
      if vim.g.conform_profiling then
        return require('utils.format_profiler').format_with_profiling(bufnr, base_opts)
      end

      return base_opts
    end,
    formatters_by_ft = {
      lua = { 'stylua' },
      typescript = { 'ast-grep', 'biome', 'biome-organize-imports' },
      typescriptreact = { 'ast-grep', 'biome', 'biome-organize-imports' },
      json = { 'biome' },
    },
    formatters = {
      ['ast-grep'] = {
        command = function(self, ctx)
          local root = vim.fs.root(ctx.buf, { '.git', 'package.json' })
          local bin = root and root .. '/packages/ast-grep-rules/node_modules/.bin/ast-grep'
          if bin and vim.fn.executable(bin) == 1 then
            return bin
          end
          return 'ast-grep'
        end,
        args = function(self, ctx)
          local root = vim.fs.root(ctx.buf, { '.git', 'package.json' })
          local base_args = { 'scan', '--update-all' }
          local config = root and root .. '/packages/ast-grep-rules/sgconfig.yml'
          if config and vim.fn.filereadable(config) == 1 then
            table.insert(base_args, '--config')
            table.insert(base_args, config)
          end
          table.insert(base_args, ctx.filename)
          return base_args
        end,
        stdin = false,
        exit_codes = { 0, 5 },
      },
    },
  },
}
