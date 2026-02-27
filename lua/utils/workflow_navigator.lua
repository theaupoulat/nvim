local M = {}

local monorepo = require 'utils.monorepo'
local WORKFLOWS_BASE = 'packages/ehr-integration/src/workflows'

function M.navigate_to_workflow_definition()
  local word = vim.fn.expand '<cword>'

  -- Strip Resume/Discard suffix
  local name = word:match '^(.+)Resume$' or word:match '^(.+)Discard$' or word

  local root = monorepo.find_monorepo_root(vim.fn.expand '%:p')
  if not root then
    vim.notify('Not inside an inato-marketplace clone', vim.log.levels.WARN)
    return
  end

  local live_path = root .. '/' .. WORKFLOWS_BASE .. '/' .. name .. '/' .. name .. 'Live.ts'
  if vim.fn.filereadable(live_path) == 1 then
    vim.cmd('edit ' .. vim.fn.fnameescape(live_path))
    vim.fn.search(name .. 'Live', 'cw')
  else
    vim.notify('No workflow definition found for: ' .. name, vim.log.levels.WARN)
  end
end

return M
