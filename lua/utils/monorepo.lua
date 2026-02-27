local M = {}

local MONOREPO_MARKER = 'packages/marketplace-domain'

--- Walks up from `filepath` until it finds a directory containing the monorepo marker.
---@param filepath string absolute file path
---@return string|nil root absolute path to the monorepo root
function M.find_monorepo_root(filepath)
  local dir = vim.fn.fnamemodify(filepath, ':h')
  while dir ~= '/' do
    if vim.fn.isdirectory(dir .. '/' .. MONOREPO_MARKER) == 1 then
      return dir
    end
    dir = vim.fn.fnamemodify(dir, ':h')
  end
  return nil
end

return M
