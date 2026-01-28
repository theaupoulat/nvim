local M = {}

local log_path = vim.fn.stdpath('state') .. '/conform_profile.log'

---Get relative path from cwd
---@param filepath string
---@return string
local function get_relative_path(filepath)
  local cwd = vim.fn.getcwd()
  if filepath:sub(1, #cwd) == cwd then
    return filepath:sub(#cwd + 2) -- +2 to skip the trailing slash
  end
  return filepath
end

---Append entry to log file
---@param entry string
local function write_log(entry)
  local file = io.open(log_path, 'a')
  if file then
    file:write(entry .. '\n')
    file:close()
  end
end

---Format milliseconds
---@param ns number nanoseconds
---@return string
local function format_ms(ns)
  return string.format('%.0fms', ns / 1e6)
end

---Run formatters with timing
---@param bufnr number
---@param opts table conform format options
---@return table|nil
function M.format_with_profiling(bufnr, opts)
  local conform = require('conform')
  local formatters = conform.list_formatters(bufnr)

  if #formatters == 0 then
    return opts
  end

  local results = {}
  local total_start = vim.loop.hrtime()

  for _, formatter in ipairs(formatters) do
    local start = vim.loop.hrtime()
    conform.format({
      bufnr = bufnr,
      formatters = { formatter.name },
      timeout_ms = opts.timeout_ms or 500,
      quiet = true,
    })
    local elapsed = vim.loop.hrtime() - start
    table.insert(results, { name = formatter.name, time = elapsed })
  end

  local total_time = vim.loop.hrtime() - total_start

  -- Build log entry
  local timestamp = os.date('%Y-%m-%d %H:%M:%S')
  local filepath = get_relative_path(vim.api.nvim_buf_get_name(bufnr))
  local parts = { timestamp, filepath }

  for _, r in ipairs(results) do
    table.insert(parts, r.name .. ': ' .. format_ms(r.time))
  end
  table.insert(parts, 'Total: ' .. format_ms(total_time))

  local log_entry = table.concat(parts, ' | ')

  -- Write to log file
  write_log(log_entry)

  -- Notify user
  local notify_parts = {}
  for _, r in ipairs(results) do
    table.insert(notify_parts, r.name .. ': ' .. format_ms(r.time))
  end
  table.insert(notify_parts, 'Total: ' .. format_ms(total_time))
  vim.notify('[conform] ' .. table.concat(notify_parts, ' | '), vim.log.levels.INFO)

  -- Return nil to prevent conform from running formatters again
  return nil
end

---Open log file in a split
---@param args table command arguments
function M.open_log(args)
  if args.args == 'clear' then
    local file = io.open(log_path, 'w')
    if file then
      file:close()
      vim.notify('[conform] Log cleared', vim.log.levels.INFO)
    end
    return
  end

  -- Check if log exists
  local file = io.open(log_path, 'r')
  if not file then
    vim.notify('[conform] No log file yet', vim.log.levels.WARN)
    return
  end
  file:close()

  -- Open in horizontal split
  vim.cmd('split ' .. log_path)
  -- Go to end of file
  vim.cmd('normal! G')
  -- Set buffer options
  vim.bo.bufhidden = 'wipe'
end

---Setup the :ConformProfile command
function M.setup()
  vim.api.nvim_create_user_command('ConformProfile', function(args)
    M.open_log(args)
  end, {
    nargs = '?',
    complete = function()
      return { 'clear' }
    end,
  })
end

return M
