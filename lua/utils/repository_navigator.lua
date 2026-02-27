local M = {}

local DOMAIN_BASE = 'packages/marketplace-domain/src/domain'
local PERSISTENCE_BASE = 'packages/marketplace-domain/src/application/persistence'
local MONOREPO_MARKER = 'packages/marketplace-domain'

--- Walks up from `filepath` until it finds a directory containing the monorepo marker.
---@param filepath string absolute file path
---@return string|nil root absolute path to the monorepo root
local function find_monorepo_root(filepath)
  local dir = vim.fn.fnamemodify(filepath, ':h')
  while dir ~= '/' do
    if vim.fn.isdirectory(dir .. '/' .. MONOREPO_MARKER) == 1 then
      return dir
    end
    dir = vim.fn.fnamemodify(dir, ':h')
  end
  return nil
end

--- Strips "Drizzle" prefix and "Repository" suffix from a drizzle directory name,
--- then checks the filesystem to find the matching domain directory.
--- Handles both single-segment (PatientAccess) and multi-segment (DocumentManagement/DocumentRequirements).
---@param drizzle_dir_name string e.g. "DrizzlePatientAccessRepository"
---@param root string absolute path to the monorepo root
---@return string|nil segments e.g. "PatientAccess" or "DocumentManagement/DocumentRequirements"
local function resolve_drizzle_to_segments(drizzle_dir_name, root)
  local name = drizzle_dir_name:match '^Drizzle(.+)Repository$'
  if not name then
    return nil
  end

  -- Try single segment first (most common)
  local single = root .. '/' .. DOMAIN_BASE .. '/' .. name .. '/Repository'
  if vim.fn.isdirectory(single) == 1 then
    return name
  end

  -- Try splitting PascalCase into two segments
  -- e.g. "DocumentManagementDocumentRequirements" -> "DocumentManagement/DocumentRequirements"
  local domain_dir = root .. '/' .. DOMAIN_BASE
  local entries = vim.fn.readdir(domain_dir)
  for _, dir in ipairs(entries) do
    if name:sub(1, #dir) == dir then
      local remainder = name:sub(#dir + 1)
      if #remainder > 0 then
        local nested = domain_dir .. '/' .. dir .. '/' .. remainder .. '/Repository'
        if vim.fn.isdirectory(nested) == 1 then
          return dir .. '/' .. remainder
        end
      end
    end
  end

  return nil
end

--- Extracts the portion of the path after `base_path/`, or nil if not found.
---@param filepath string
---@param base_path string
---@return string|nil
local function strip_base(filepath, base_path)
  local pos = filepath:find(base_path, 1, true)
  if not pos then
    return nil
  end
  return filepath:sub(pos + #base_path + 1) -- +1 for the trailing /
end

--- Detects which file type we're in and extracts the aggregate segments.
---@param filepath string absolute file path
---@param root string absolute path to the monorepo root
---@return string|nil segments e.g. "PatientAccess" or "DocumentManagement/DocumentRequirements"
function M.parse_current_file(filepath, root)
  local expanded = vim.fn.expand(filepath)

  -- Try domain-based paths (Interface, InMemory)
  local rel = strip_base(expanded, DOMAIN_BASE)
  if rel then
    -- Interface: {segments}/Repository/Repository.ts
    local segments = rel:match '^(.+)/Repository/Repository%.ts$'
    if segments then
      return segments
    end

    -- InMemory flat: {segments}/Repository/InMemoryRepository.ts
    segments = rel:match '^(.+)/Repository/InMemoryRepository%.ts$'
    if segments then
      return segments
    end

    -- InMemory nested: {segments}/Repository/InMemory/InMemoryRepository.ts
    segments = rel:match '^(.+)/Repository/InMemory/InMemoryRepository%.ts$'
    if segments then
      return segments
    end
  end

  -- Drizzle: persistence/Drizzle{Name}Repository/repository.ts
  rel = strip_base(expanded, PERSISTENCE_BASE)
  if rel then
    local drizzle_dir = rel:match '^(Drizzle%w+Repository)/repository%.ts$'
    if drizzle_dir then
      return resolve_drizzle_to_segments(drizzle_dir, root)
    end
  end

  return nil
end

--- Constructs paths to the 3 repository files for a given aggregate.
---@param segments string e.g. "PatientAccess"
---@param root string absolute path to the monorepo root
---@return { label: string, path: string }[]
function M.build_repository_paths(segments, root)
  -- Build the PascalCase name by removing slashes for the Drizzle directory name
  local name = segments:gsub('/', '')

  local candidates = {
    {
      label = 'Interface',
      path = root .. '/' .. DOMAIN_BASE .. '/' .. segments .. '/Repository/Repository.ts',
    },
    {
      label = 'InMemory',
      path = root .. '/' .. DOMAIN_BASE .. '/' .. segments .. '/Repository/InMemoryRepository.ts',
    },
    {
      label = 'InMemory (nested)',
      path = root .. '/' .. DOMAIN_BASE .. '/' .. segments .. '/Repository/InMemory/InMemoryRepository.ts',
    },
    {
      label = 'Drizzle',
      path = root .. '/' .. PERSISTENCE_BASE .. '/Drizzle' .. name .. 'Repository/repository.ts',
    },
  }

  local results = {}
  for _, c in ipairs(candidates) do
    if vim.fn.filereadable(c.path) == 1 then
      table.insert(results, c)
    end
  end

  return results
end

--- Main entry point. Gets cursor word + current path, resolves repository files,
--- and opens Telescope grep_string scoped to those files.
function M.navigate_to_implementations()
  local word = vim.fn.expand '<cword>'
  local filepath = vim.fn.expand '%:p'

  local root = find_monorepo_root(filepath)
  if not root then
    vim.notify('Not inside an inato-marketplace clone', vim.log.levels.WARN)
    return
  end

  local segments = M.parse_current_file(filepath, root)
  if not segments then
    vim.notify('Could not detect repository aggregate from current file', vim.log.levels.WARN)
    return
  end

  local paths = M.build_repository_paths(segments, root)
  if #paths == 0 then
    vim.notify('No repository files found for: ' .. segments, vim.log.levels.WARN)
    return
  end

  local search_dirs = {}
  local label_by_path = {}
  for _, p in ipairs(paths) do
    table.insert(search_dirs, p.path)
    label_by_path[p.path] = p.label
  end

  require('telescope.builtin').grep_string {
    search = word,
    initial_mode = 'normal',
    search_dirs = search_dirs,
    prompt_title = 'Repository implementations: ' .. word,
    path_display = function(_, path)
      return label_by_path[path] or vim.fn.fnamemodify(path, ':t')
    end,
  }
end

return M
