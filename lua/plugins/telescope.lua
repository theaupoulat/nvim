return {
  'nvim-telescope/telescope.nvim', -- Fuzzy Finder (files, lsp, etc)
  event = 'VimEnter',
  branch = '0.1.x',

  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
  },
  config = function()
    -- Two important keymaps to use while in Telescope are:
    --  - Insert mode: <c-/>
    --  - Normal mode: ?

    -- [[ Configure Telescope ]]
    -- See `:help telescope` and `:help telescope.setup()`
    require('telescope').setup {
      -- You can put your default mappings / updates / etc. in here
      --  All the info you're looking for is in `:help telescope.setup()`
      --
      defaults = {
        layout_strategy = 'vertical',
      },
      -- pickers = {}
      pickers = {
        lsp_references = {
          fname_width = 100,
        },
      },
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
      },
    }

    -- Enable Telescope extensions if they are installed
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')

    -- See `:help telescope.builtin`
    local builtin = require 'telescope.builtin'
    vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
    vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
    vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>sm', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
    vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
    vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })

    vim.keymap.set('n', '<leader>sps', function()
      builtin.live_grep {
        search_dirs = { '~/Code/inato-marketplace/packages/server' },
        prompt_title = 'Search string in server files',
      }
    end, { desc = '[S]earch in [p]ackage: [s]erver files' })

    vim.keymap.set('n', '<leader>spf', function()
      builtin.live_grep {
        search_dirs = { '~/Code/inato-marketplace/packages/marketplace' },
        prompt_title = 'Search string in marketplace files',
      }
    end, { desc = '[S]earch in [p]ackage: marketplace' })

    vim.keymap.set('n', '<leader>spd', function()
      builtin.live_grep {
        search_dirs = { '~/Code/inato-marketplace/packages/marketplace-domain' },
        prompt_title = 'Search string in marketplace-domain files',
      }
    end, { desc = '[S]earch in [p]ackage: marketplace-[d]omain' })

    vim.keymap.set('n', '<leader>s/', function()
      builtin.live_grep {
        cwd = vim.fn.expand '%:p:h', -- Set search directory to current buffer's dir
      }
    end, { desc = '[S]earch by [G]rep from CWD' })
    vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
    vim.keymap.set('n', '<leader>sq', builtin.quickfix, { desc = '[S]earch [Q]uickfix' })
    vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
    vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

    vim.keymap.set('n', '<leader>/', function()
      builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end, { desc = '[/] Fuzzily search in current buffer' })

    -- It's also possible to pass additional configuration options.
    --  See `:help telescope.builtin.live_grep()` for information about particular keys
    vim.keymap.set('n', '<leader>s.', function()
      builtin.live_grep {
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
      }
    end, { desc = '[S]earch [/] in Open Files' })

    -- Shortcut for searching your Neovim configuration files
    vim.keymap.set('n', '<leader>sn', function()
      builtin.find_files { cwd = vim.fn.stdpath 'config' }
    end, { desc = '[S]earch [N]eovim files' })
  end,
}
