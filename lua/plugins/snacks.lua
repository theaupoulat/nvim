return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    bigfile = { enabled = true },
    dashboard = {
      preset = {
        header = [[
  .,;::clllcc:,'.
  'oOK000K0OOOOOOOOOOOxo;
    'x000OOOOOOOOOOOOOOOOOOOxl.
   c00OOOkkkkkkkkkkOOOOOOOOkool.
        .kxddooolllllloooooddxxxdoooc;,.
        col:;;,'''''''',,;;::clooooc;;;;;.
        ;,'''''';dkkoc,''''''''',;;;;;;;;;.
        .''''''lKKKOOko,'''''''''';;;;;;;;;
         ;clooxKK0OOkoo:;cloddoc;',;;;;;;;;
         xkOkd0KOOOxoc;:odkO00OOOd;;;;;;;;;.
       .OKOOkK0OOOdo:;;ookO0OOOOOl;;;;;;;;;.
      ,OOOO0K0OOkdc;;;;coxOOOOOOk;;;;;;;;;;.
      OOO0KKOOOkoooddoc;coxOOOOOo;;;;;;;;;;.
   oOO000OOkxooxOOkxdl;;odkOOO:;;;;;;;;;;.
   OOxolcc::::cloooooo:;coodkx;;;;;;;;;;;.
   OOl;',;;,''',;:ccc:;;looooc;;;;;;;;;;;.
  .OOOOxoolllc:;::::::cloooooc;;;;;;;;;;;'
  'OOO00OOOOOOOkdoooooooooooo:;;;;;;;;;;;;
  ;Oxocc:::::cclodooooooooooo:;;;;;;;;;;;.
  ;kcccccccccccclcc:loooooooo:;;;;;;;;;;
  ;Okdlc:;;;;:clodxxxooooooooc;;;;;;.
  ;OOOxoooooooooxOOOOkoooooooc;;;;;;,
  :OOOOkdooooodkOOOOOOoooooooc;;;;;;;
  kOOOOOOOkkkOOOOOOOOOxoooooo:;;;;;;;
  OOOOOO00OOOOOOOOOOOOkoooooo:;;;;;;;
 .dkkOOO00OOOOOOOOOOOkxoooool;;;;;;;.
   .ooddddxxxddddddooooooolc;;;,
					]],
      },

      sections = {
        { section = 'header' },

        { section = 'keys', gap = 1, padding = 1 },
        { section = 'startup', icon = '' },
        function()
          local cwd = vim.fn.getcwd()
          local parent_dir, project_name = string.match(cwd, '(.-)/([^/]+)$')

          if parent_dir == nil then
            -- Handle the case where there's no slash (e.g., if cwd is just "/")
            parent_dir = ''
            project_name = cwd
          end

          return {
            align = 'center',
            text = {
              { 'at ' .. parent_dir .. '/', hl = 'footer' },
              { project_name, hl = 'special' },
              -- { cwd,                        hl = "special" },
            },
          }
        end,
      },
    },
    explorer = { enabled = false },
    indent = { enabled = true },
    input = { enabled = true },
    git,
    rowse = { enabled = true },
    picker = { enabled = true },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
  },
  keys = {
    -- git
    {
      '<leader>gb',
      function()
        Snacks.picker.git_branches()
      end,
      desc = 'Git Branches',
    },
    {
      '<leader>gl',
      function()
        Snacks.picker.git_log()
      end,
      desc = 'Git Log',
    },
    {
      '<leader>gs',
      function()
        Snacks.picker.git_status()
      end,
      desc = 'Git Status',
    },
    {
      '<leader>gS',
      function()
        Snacks.picker.git_stash()
      end,
      desc = 'Git Stash',
    },
    {
      '<leader>gd',
      function()
        Snacks.picker.git_diff()
      end,
      desc = 'Git Diff (Hunks)',
    },
    {
      '<leader>gB',
      function()
        Snacks.gitbrowse { branch = 'main' }
      end,
      desc = 'Git Browse',
      mode = { 'n', 'v' },
    },
  },
}
