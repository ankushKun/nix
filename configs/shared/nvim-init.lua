-- ============================================================================
-- Neovim Configuration - Enhanced with Better LSP & QoL Features
-- ============================================================================

-- ============================================================================
-- Basic Settings
-- ============================================================================
vim.opt.number = true                         -- Show line numbers
vim.opt.relativenumber = true                 -- Show relative line numbers
vim.opt.mouse = 'a'                           -- Enable mouse support
vim.opt.ignorecase = true                     -- Case insensitive search
vim.opt.smartcase = true                      -- Unless uppercase is used
vim.opt.hlsearch = true                       -- Highlight search results
vim.opt.incsearch = true                      -- Incremental search
vim.opt.wrap = true                           -- Wrap lines
vim.opt.breakindent = true                    -- Preserve indentation in wrapped text
vim.opt.tabstop = 2                           -- Tab width
vim.opt.shiftwidth = 2                        -- Indent width
vim.opt.expandtab = true                      -- Use spaces instead of tabs
vim.opt.smartindent = true                    -- Smart auto-indenting
vim.opt.smarttab = true                       -- Smart tab behavior
vim.opt.clipboard = 'unnamedplus'             -- Use system clipboard
vim.opt.scrolloff = 8                         -- Keep 8 lines above/below cursor
vim.opt.sidescrolloff = 8                     -- Keep 8 columns left/right of cursor
vim.opt.signcolumn = 'yes'                    -- Always show sign column
vim.opt.cursorline = true                     -- Highlight current line
vim.opt.termguicolors = true                  -- Enable 24-bit colors
vim.opt.updatetime = 250                      -- Faster completion
vim.opt.timeoutlen = 300                      -- Faster which-key popup
vim.opt.undofile = true                       -- Enable persistent undo
vim.opt.backup = false                        -- Disable backup files
vim.opt.writebackup = false                   -- Disable backup before writing
vim.opt.swapfile = false                      -- Disable swap files
vim.opt.splitright = true                     -- Vertical splits go right
vim.opt.splitbelow = true                     -- Horizontal splits go below
vim.opt.showmode = false                      -- Don't show mode (we have statusline)
vim.opt.conceallevel = 0                      -- Don't hide characters (like in markdown)
vim.opt.pumheight = 10                        -- Popup menu height
vim.opt.completeopt = 'menu,menuone,noselect' -- Better completion experience

-- Set leader key to space
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Neovide specific settings
if vim.g.neovide then
  -- Font configuration (matching Kitty: MesloLGS NF, size 13)
  vim.o.guifont = "MesloLGS NF:h13"

  -- Padding (minimal, like Kitty)
  vim.g.neovide_padding_top = 5
  vim.g.neovide_padding_bottom = 5
  vim.g.neovide_padding_right = 5
  vim.g.neovide_padding_left = 5

  -- Opacity (matching Kitty: 0.90 opacity with blur)
  -- Note: neovide_transparency is deprecated, use neovide_background_color alpha channel instead
  vim.g.neovide_window_blurred = true

  -- Set background color with alpha channel for transparency
  -- Format: #RRGGBBAA where AA is alpha (00 = transparent, FF = opaque)
  -- 0.90 opacity = E6 in hex (230/255)
  vim.g.neovide_background_color = '#101015E6'

  -- Floating blur
  vim.g.neovide_floating_blur_amount_x = 2.0
  vim.g.neovide_floating_blur_amount_y = 2.0

  -- Hide mouse when typing
  vim.g.neovide_hide_mouse_when_typing = true

  -- Underline stroke scale
  vim.g.neovide_underline_stroke_scale = 1.0

  -- Theme (can be "auto", "light", or "dark")
  vim.g.neovide_theme = 'auto'

  -- Refresh rate
  vim.g.neovide_refresh_rate = 60

  -- Idle refresh rate (when not focused)
  vim.g.neovide_refresh_rate_idle = 5

  -- Confirm quit
  vim.g.neovide_confirm_quit = true

  -- Fullscreen
  vim.g.neovide_fullscreen = false

  -- Remember window size
  vim.g.neovide_remember_window_size = true

  -- Cursor settings
  vim.g.neovide_cursor_animation_length = 0.13
  vim.g.neovide_cursor_trail_size = 0.3
  vim.g.neovide_cursor_antialiasing = true
  vim.g.neovide_cursor_animate_in_insert_mode = true
  vim.g.neovide_cursor_animate_command_line = true
  vim.g.neovide_cursor_vfx_mode = "railgun" -- Options: "", "railgun", "torpedo", "pixiedust", "sonicboom", "ripple", "wireframe"

  -- Scroll animation
  vim.g.neovide_scroll_animation_length = 0.15

  -- Keyboard shortcuts for Neovide
  -- Cmd+V for paste (macOS style)
  vim.keymap.set({'n', 'v', 'i', 'c'}, '<D-v>', function()
    if vim.fn.mode() == 'i' or vim.fn.mode() == 'c' then
      return '<C-r>+'
    else
      return '"+p'
    end
  end, { expr = true, desc = 'Paste from system clipboard' })

  -- Cmd+C for copy (macOS style)
  vim.keymap.set('v', '<D-c>', '"+y', { desc = 'Copy to system clipboard' })

  -- Cmd+= to increase font size
  vim.keymap.set('n', '<D-=>', function()
    local current_font = vim.o.guifont
    local size = tonumber(string.match(current_font, ':h(%d+)'))
    if size then
      vim.o.guifont = string.gsub(current_font, ':h%d+', ':h' .. (size + 1))
    end
  end, { desc = 'Increase font size' })

  -- Cmd+- to decrease font size
  vim.keymap.set('n', '<D-->', function()
    local current_font = vim.o.guifont
    local size = tonumber(string.match(current_font, ':h(%d+)'))
    if size and size > 6 then
      vim.o.guifont = string.gsub(current_font, ':h%d+', ':h' .. (size - 1))
    end
  end, { desc = 'Decrease font size' })

  -- Cmd+0 to reset font size
  vim.keymap.set('n', '<D-0>', function()
    vim.o.guifont = "MesloLGS NF:h13"
  end, { desc = 'Reset font size' })
end

-- ============================================================================
-- Bootstrap lazy.nvim Plugin Manager
-- ============================================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)


-- ============================================================================
-- Keybindings
-- ============================================================================

-- Better window navigation
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Move to left window' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Move to bottom window' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Move to top window' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Move to right window' })

-- Resize windows
vim.keymap.set('n', '<C-Up>', ':resize +2<CR>', { desc = 'Increase window height' })
vim.keymap.set('n', '<C-Down>', ':resize -2<CR>', { desc = 'Decrease window height' })
vim.keymap.set('n', '<C-Left>', ':vertical resize -2<CR>', { desc = 'Decrease window width' })
vim.keymap.set('n', '<C-Right>', ':vertical resize +2<CR>', { desc = 'Increase window width' })

-- Buffer navigation (Shift+[ and Shift+] which are { and })
vim.keymap.set('n', '{', ':bprevious<CR>', { desc = 'Previous buffer' })
vim.keymap.set('n', '}', ':bnext<CR>', { desc = 'Next buffer' })

-- Buffer close - switch to last buffer then delete the previous one
vim.keymap.set('n', '<leader>c', function()
  local current_buf = vim.api.nvim_get_current_buf()
  -- Switch to alternate buffer (last opened)
  vim.cmd('buffer #')
  -- Delete the previous buffer
  vim.cmd('bdelete ' .. current_buf)
end, { desc = 'Close buffer and switch to last' })

-- Additional buffer operations
vim.keymap.set('n', '<leader>bd', ':bdelete<CR>', { desc = 'Delete buffer (simple)' })
vim.keymap.set('n', '<leader>ba', ':%bd|e#<CR>', { desc = 'Delete all buffers except current' })
vim.keymap.set('n', '<leader>bD', ':%bd!|e#|bd#<CR>', { desc = 'Force delete all buffers except current' })

-- Move lines up and down
vim.keymap.set('n', '<A-j>', ':m .+1<CR>==', { desc = 'Move line down' })
vim.keymap.set('n', '<A-k>', ':m .-2<CR>==', { desc = 'Move line up' })
vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })

-- Clear search highlighting (use <Esc><Esc> to avoid interfering with other Esc uses)
vim.keymap.set('n', '<Esc><Esc>', ':nohlsearch<CR>', { desc = 'Clear search highlight', silent = true })

-- Quick save
vim.keymap.set('n', '<leader>w', ':w<CR>', { desc = 'Save file' })
vim.keymap.set('n', '<leader>q', ':q<CR>', { desc = 'Quit' })
vim.keymap.set('n', '<leader>Q', ':qa!<CR>', { desc = 'Quit all without saving' })

-- Split windows (using | and - for intuitive vertical/horizontal split)
vim.keymap.set('n', '<leader>|', ':vsplit<CR>', { desc = 'Split vertically' })
vim.keymap.set('n', '<leader>-', ':split<CR>', { desc = 'Split horizontally' })

-- Better paste (don't yank replaced text)
vim.keymap.set('v', 'p', '"_dP', { desc = 'Paste without yanking' })

-- Select all (Note: This overrides increment number, use g<C-a> for that)
vim.keymap.set('n', '<C-a>', 'gg<S-v>G', { desc = 'Select all' })

-- Stay in visual mode when indenting
vim.keymap.set('v', '<', '<gv', { desc = 'Indent left (stay in visual)' })
vim.keymap.set('v', '>', '>gv', { desc = 'Indent right (stay in visual)' })

-- Better page up/down (keep cursor centered)
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Page down (centered)' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Page up (centered)' })

-- Keep search results centered
vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Next search result (centered)' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Previous search result (centered)' })

-- Join lines but keep cursor position
vim.keymap.set('n', 'J', 'mzJ`z', { desc = 'Join lines (keep cursor)' })

-- Better undo break points in insert mode
vim.keymap.set('i', ',', ',<C-g>u', { desc = 'Comma with undo break' })
vim.keymap.set('i', '.', '.<C-g>u', { desc = 'Period with undo break' })
vim.keymap.set('i', '!', '!<C-g>u', { desc = 'Exclamation with undo break' })
vim.keymap.set('i', '?', '?<C-g>u', { desc = 'Question mark with undo break' })

-- Quick access to common files
vim.keymap.set('n', '<leader>sn', ':e ~/.config/nvim/init.lua<CR>', { desc = 'Search/open Nvim config' })

-- Format buffer (main keybinding)
vim.keymap.set('n', '<leader>f', function()
  vim.lsp.buf.format({ async = true })
end, { desc = 'Format buffer' })

-- Toggle format on save for current buffer
vim.keymap.set('n', '<leader>tf', function()
  if vim.b.autoformat == nil then
    vim.b.autoformat = false
  else
    vim.b.autoformat = not vim.b.autoformat
  end
  local status = vim.b.autoformat and 'enabled' or 'disabled'
  vim.notify('Format on save ' .. status, vim.log.levels.INFO)
end, { desc = 'Toggle format on save' })

-- ============================================================================
-- Auto Commands
-- ============================================================================

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('highlight_yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end,
})

-- Remove trailing whitespace on save
vim.api.nvim_create_autocmd('BufWritePre', {
  group = vim.api.nvim_create_augroup('trim_whitespace', { clear = true }),
  pattern = '*',
  callback = function()
    local save_cursor = vim.fn.getpos('.')
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos('.', save_cursor)
  end,
})

-- Remember cursor position
vim.api.nvim_create_autocmd('BufReadPost', {
  group = vim.api.nvim_create_augroup('restore_cursor', { clear = true }),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Format on save (opt-in per filetype)
-- Enable globally with: vim.g.autoformat = true
-- Enable per buffer with: vim.b.autoformat = true
-- Disable per buffer with: vim.b.autoformat = false
vim.api.nvim_create_autocmd('BufWritePre', {
  group = vim.api.nvim_create_augroup('format_on_save', { clear = true }),
  pattern = { '*.lua', '*.js', '*.ts', '*.jsx', '*.tsx', '*.go', '*.py', '*.nix', '*.rs' },
  callback = function()
    -- Check buffer-local setting first, then global
    local autoformat = vim.b.autoformat
    if autoformat == nil then
      autoformat = vim.g.autoformat
    end
    -- Default to true if not set for these filetypes
    if autoformat ~= false then
      vim.lsp.buf.format({ timeout_ms = 2000 })
    end
  end,
})

-- ============================================================================
-- Plugin Configuration
-- ============================================================================
require("lazy").setup({
  -- Tokyo Night theme with transparent background
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "night", -- Tokyo Night theme (matches Kitty)
        transparent = vim.g.neovide and false or false, -- Don't use transparent bg (we handle it via window transparency)
        terminal_colors = true, -- Configure colors for terminal windows
        styles = {
          sidebars = "transparent",
          floats = "transparent",
          comments = { italic = true },
          keywords = { italic = false },
        },
        -- Override specific colors to match Kitty if needed
        on_colors = function(colors)
          -- Kitty uses these exact colors from Tokyo Night
          colors.bg = "#101015" -- Matches Kitty background
          colors.fg = "#c0caf5" -- Matches Kitty foreground
        end,
      })
      vim.cmd([[colorscheme tokyonight]])
    end,
  },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "tokyonight",
          icons_enabled = true,
          component_separators = { left = "|", right = "|" },
          section_separators = { left = "", right = "" },
          globalstatus = true,
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = {
            { "filename", path = 1 },
            {
              function()
                local navic_ok, navic = pcall(require, "nvim-navic")
                if navic_ok then
                  return navic.get_location()
                end
                return ""
              end,
              cond = function()
                local navic_ok, navic = pcall(require, "nvim-navic")
                return navic_ok and navic.is_available()
              end,
            }
          },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end,
  },

  -- Smooth scrolling
  {
    "karb94/neoscroll.nvim",
    config = function()
      require("neoscroll").setup({
        mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
        hide_cursor = true,
        stop_eof = true,
        respect_scrolloff = false,
        cursor_scrolls_alone = true,
        easing_function = "quadratic",
      })
    end,
  },

  -- Telescope fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      require("telescope").setup({
        defaults = {
          prompt_prefix = "🔍 ",
          selection_caret = "➜ ",
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = {
              preview_width = 0.55,
            },
          },
          file_ignore_patterns = { "node_modules", ".git/", "dist/", "build/" },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      })

      -- Load fzf extension
      pcall(require("telescope").load_extension, "fzf")

      -- Keybindings (using <leader>s for search to free up <leader>f for format)
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "Search files" })
      vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "Search grep" })
      vim.keymap.set("n", "<leader>sb", builtin.buffers, { desc = "Search buffers" })
      vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "Search help" })
      vim.keymap.set("n", "<leader>so", builtin.oldfiles, { desc = "Search old files" })
      vim.keymap.set("n", "<leader>sc", builtin.commands, { desc = "Search commands" })
      vim.keymap.set("n", "<leader>ss", builtin.lsp_document_symbols, { desc = "Search symbols" })
      vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "Search word under cursor" })
    end,
  },

  -- Which-key for keybinding hints
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("which-key").setup({
        win = {
          border = "rounded",
        },
      })
    end,
  },

  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      require("ibl").setup({
        indent = {
          char = "│",
        },
        scope = {
          enabled = true,
          show_start = true,
          show_end = false,
        },
      })
    end,
  },

  -- Git signs in gutter
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "│" },
          change = { text = "│" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
          untracked = { text = "┆" },
        },
        current_line_blame = false,
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map("n", "]c", function()
            if vim.wo.diff then
              return "]c"
            end
            vim.schedule(function()
              gs.next_hunk()
            end)
            return "<Ignore>"
          end, { expr = true, desc = "Next hunk" })

          map("n", "[c", function()
            if vim.wo.diff then
              return "[c"
            end
            vim.schedule(function()
              gs.prev_hunk()
            end)
            return "<Ignore>"
          end, { expr = true, desc = "Previous hunk" })

          -- Actions
          map("n", "<leader>hs", gs.stage_hunk, { desc = "Stage hunk" })
          map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset hunk" })
          map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
          map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview hunk" })
          map("n", "<leader>hb", function()
            gs.blame_line({ full = true })
          end, { desc = "Blame line" })
          map("n", "<leader>hd", gs.diffthis, { desc = "Diff this" })
        end,
      })
    end,
  },

  -- Neogit - Magit-like Git interface
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("neogit").setup({
        integrations = {
          telescope = true,
          diffview = true,
        },
        signs = {
          section = { "", "" },
          item = { "", "" },
          hunk = { "", "" },
        },
      })
      vim.keymap.set("n", "<leader>gg", ":Neogit<CR>", { desc = "Open Neogit" })
      vim.keymap.set("n", "<leader>gc", ":Neogit commit<CR>", { desc = "Git commit" })
      vim.keymap.set("n", "<leader>gp", ":Neogit push<CR>", { desc = "Git push" })
      vim.keymap.set("n", "<leader>gl", ":Neogit pull<CR>", { desc = "Git pull" })
    end,
  },

  -- Diffview for better diff visualization
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("diffview").setup({})
      vim.keymap.set("n", "<leader>gdo", ":DiffviewOpen<CR>", { desc = "Open Diffview" })
      vim.keymap.set("n", "<leader>gdc", ":DiffviewClose<CR>", { desc = "Close Diffview" })
      vim.keymap.set("n", "<leader>gdh", ":DiffviewFileHistory %<CR>", { desc = "File history" })
      vim.keymap.set("n", "<leader>gdf", ":DiffviewFileHistory<CR>", { desc = "Branch history" })
    end,
  },

  -- Bufferline for better buffer tabs
  {
    "akinsho/bufferline.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup({
        options = {
          mode = "buffers",
          separator_style = "thin",
          diagnostics = "nvim_lsp",
          show_buffer_close_icons = true,
          show_close_icon = false,
          offsets = {
            {
              filetype = "NvimTree",
              text = "File Explorer",
              text_align = "left",
              separator = true,
            },
          },
        },
      })
    end,
  },

  -- Alpha dashboard with cat ASCII art
  {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      -- Custom cat ASCII art
      dashboard.section.header.val = {
        [[                                                                   ]],
        [[            :\     /;               _                              ]],
        [[           ;  \___/  ;             ; ;                             ]],
        [[          ,:-"'   `"-:.            / ;                             ]],
        [[     _  /,---.   ,---.\  _       _; /                              ]],
        [[    _:>((  |  ) (  |  ))<:_ ,-""_,"                                ]],
        [[        \`````   `````/""""",-""                                   ]],
        [[         '-.._ v _..-'      )                                      ]],
        [[           / ___   ____,..  \                                      ]],
        [[          / /   | |   | ( \. \                                     ]],
        [[         / /    | |    | |  \ \                                    ]],
        [[         `"     `"     `"    `"                                    ]],
        [[                                                                   ]],
      }

      -- Menu buttons
      dashboard.section.buttons.val = {
        dashboard.button("f", "  Find file", ":Telescope find_files <CR>"),
        dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("r", "  Recent files", ":Telescope oldfiles <CR>"),
        dashboard.button("g", "  Search text", ":Telescope live_grep <CR>"),
        dashboard.button("p", "  Projects", ":Telescope projects <CR>"),
        dashboard.button("c", "  Config", ":e ~/.config/nvim/init.lua <CR>"),
        dashboard.button("q", "  Quit", ":qa<CR>"),
      }

      -- Footer
      dashboard.section.footer.val = ""

      -- Layout
      dashboard.config.layout = {
        { type = "padding", val = 2 },
        dashboard.section.header,
        { type = "padding", val = 2 },
        dashboard.section.buttons,
        { type = "padding", val = 1 },
        dashboard.section.footer,
      }

      -- Colors
      dashboard.section.header.opts.hl = "AlphaHeader"
      dashboard.section.buttons.opts.hl = "AlphaButtons"
      dashboard.section.footer.opts.hl = "AlphaFooter"

      alpha.setup(dashboard.config)

      -- Disable for nvim-tree
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "alpha",
        callback = function()
          vim.opt_local.foldenable = false
        end,
      })
    end,
  },

  -- File tree explorer
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons", -- File icons
    },
    config = function()
      -- Disable netrw (built-in file explorer)
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      require("nvim-tree").setup({
        view = {
          width = 30,
          side = "left",
        },
        renderer = {
          group_empty = true,
          icons = {
            show = {
              file = true,
              folder = true,
              folder_arrow = true,
              git = true,
            },
          },
        },
        filters = {
          dotfiles = false,
        },
        git = {
          enable = true,
          ignore = false,
        },
      })

      -- Keybindings for nvim-tree
      vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle file tree" })
      vim.keymap.set("n", "<leader>o", ":NvimTreeFocus<CR>", { desc = "Focus file tree" })
    end,
  },

  -- Treesitter for better syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      -- Check if nvim-treesitter.configs exists (for compatibility)
      local has_configs, ts_configs = pcall(require, "nvim-treesitter.configs")
      if has_configs then
        ts_configs.setup({
          -- Don't auto-install parsers (managed by lazy.nvim)
          ensure_installed = {
            "lua", "vim", "vimdoc", "query",
            "javascript", "typescript", "tsx", "json", "html", "css",
            "python", "go", "rust", "c",
            "nix", "bash", "markdown", "yaml", "toml"
          },
          -- Install parsers synchronously (only applied to `ensure_installed`)
          sync_install = false,
          -- Automatically install missing parsers when entering buffer
          auto_install = true,
          highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
          },
          indent = {
            enable = true,
          },
          incremental_selection = {
            enable = true,
            keymaps = {
              init_selection = "<C-space>",
              node_incremental = "<C-space>",
              scope_incremental = false,
              node_decremental = "<bs>",
            },
          },
        })
      end
    end,
  },

  -- Auto close HTML/JSX tags
  {
    "windwp/nvim-ts-autotag",
    dependencies = "nvim-treesitter/nvim-treesitter",
    event = "InsertEnter",
    config = function()
      local has_autotag, autotag = pcall(require, "nvim-ts-autotag")
      if has_autotag then
        autotag.setup()
      end
    end,
  },

  -- Comment toggling
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup({
        toggler = {
          line = "gcc",  -- Line-comment toggle
          block = "gbc", -- Block-comment toggle
        },
        opleader = {
          line = "gc",  -- Line-comment operator
          block = "gb", -- Block-comment operator
        },
        mappings = {
          basic = true,
          extra = true,
        },
      })
    end,
  },

  -- Surround text objects (cs"' to change " to ', ds" to delete ", ysiw" to surround word)
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({})
    end,
  },

  -- TODO/FIXME/NOTE highlighting
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("todo-comments").setup({
        signs = true,
        keywords = {
          FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
          TODO = { icon = " ", color = "info" },
          HACK = { icon = " ", color = "warning" },
          WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
          PERF = { icon = " ", color = "default", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
          NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
        },
      })

      -- Keybindings
      vim.keymap.set("n", "]t", function()
        require("todo-comments").jump_next()
      end, { desc = "Next todo comment" })
      vim.keymap.set("n", "[t", function()
        require("todo-comments").jump_prev()
      end, { desc = "Previous todo comment" })
      vim.keymap.set("n", "<leader>st", ":TodoTelescope<CR>", { desc = "Search todos" })
    end,
  },

  -- Better diagnostics UI
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("trouble").setup({})

      vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })
      vim.keymap.set("n", "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        { desc = "Buffer Diagnostics (Trouble)" })
      vim.keymap.set("n", "<leader>xl", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List (Trouble)" })
      vim.keymap.set("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List (Trouble)" })
    end,
  },

  -- DAP (Debug Adapter Protocol)
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- Setup dap-ui
      dapui.setup({
        icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
        mappings = {
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          edit = "e",
          repl = "r",
          toggle = "t",
        },
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.25 },
              { id = "breakpoints", size = 0.25 },
              { id = "stacks", size = 0.25 },
              { id = "watches", size = 0.25 },
            },
            size = 40,
            position = "left",
          },
          {
            elements = {
              { id = "repl", size = 0.5 },
              { id = "console", size = 0.5 },
            },
            size = 10,
            position = "bottom",
          },
        },
      })

      -- Setup virtual text
      require("nvim-dap-virtual-text").setup({
        enabled = true,
        enabled_commands = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = false,
        show_stop_reason = true,
        commented = false,
      })

      -- Auto open/close dap-ui
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- Keybindings
      vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Start/Continue" })
      vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Debug: Step Over" })
      vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Debug: Step Into" })
      vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Debug: Step Out" })
      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
      vim.keymap.set("n", "<leader>dB", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, { desc = "Debug: Conditional Breakpoint" })
      vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "Debug: Open REPL" })
      vim.keymap.set("n", "<leader>dl", dap.run_last, { desc = "Debug: Run Last" })
      vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Debug: Toggle UI" })
      vim.keymap.set("n", "<leader>dt", dap.terminate, { desc = "Debug: Terminate" })
    end,
  },

  -- Session persistence
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    config = function()
      require("persistence").setup({
        dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"),
        options = { "buffers", "curdir", "tabpages", "winsize" },
      })

      -- Keybindings
      vim.keymap.set("n", "<leader>qs", function()
        require("persistence").load()
      end, { desc = "Restore session" })
      vim.keymap.set("n", "<leader>ql", function()
        require("persistence").load({ last = true })
      end, { desc = "Restore last session" })
      vim.keymap.set("n", "<leader>qd", function()
        require("persistence").stop()
      end, { desc = "Don't save session on exit" })
    end,
  },

  -- Project management
  {
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup({
        detection_methods = { "pattern", "lsp" },
        patterns = { ".git", "Makefile", "package.json", "Cargo.toml", "go.mod" },
        silent_chdir = false,
      })

      -- Integrate with telescope
      require("telescope").load_extension("projects")
      vim.keymap.set("n", "<leader>sp", ":Telescope projects<CR>", { desc = "Search projects" })
    end,
  },

  -- Symbol outline (like VSCode's outline)
  {
    "hedyhli/outline.nvim",
    config = function()
      require("outline").setup({
        outline_window = {
          position = "right",
          width = 25,
          relative_width = true,
          auto_close = false,
        },
        symbol_folding = {
          autofold_depth = 1,
          auto_unfold_hover = true,
        },
      })

      vim.keymap.set("n", "<leader>cs", ":Outline<CR>", { desc = "Toggle code outline" })
    end,
  },

  -- Better code action menu
  {
    "weilbith/nvim-code-action-menu",
    cmd = "CodeActionMenu",
    config = function()
      vim.g.code_action_menu_show_diff = true
      vim.g.code_action_menu_show_details = true
      vim.g.code_action_menu_show_action_kind = true
    end,
  },

  -- Incremental rename with preview
  {
    "smjonas/inc-rename.nvim",
    config = function()
      require("inc_rename").setup()
      vim.keymap.set("n", "<leader>rn", function()
        return ":IncRename " .. vim.fn.expand("<cword>")
      end, { expr = true, desc = "Incremental rename" })
    end,
  },

  -- Better quickfix/location list
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    config = function()
      require("bqf").setup({
        auto_resize_height = true,
        preview = {
          win_height = 12,
          win_vheight = 12,
          delay_syntax = 80,
          border = "rounded",
        },
      })
    end,
  },
  -- Terminal integration
  {
    "akinsho/toggleterm.nvim",
    config = function()
      require("toggleterm").setup({
        size = function(term)
          if term.direction == "horizontal" then
            return 15
          elseif term.direction == "vertical" then
            return vim.o.columns * 0.4
          end
        end,
        open_mapping = [[<C-\>]],
        hide_numbers = true,
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        direction = "horizontal",
        close_on_exit = true,
        shell = vim.o.shell,
        float_opts = {
          border = "curved",
          winblend = 0,
        },
      })

      -- Terminal keybindings
      function _G.set_terminal_keymaps()
        local opts = { buffer = 0 }
        vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
        vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
        vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
        vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
        vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
      end

      vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

      -- Specific terminal commands
      vim.keymap.set("n", "<leader>th", ":ToggleTerm direction=horizontal<CR>", { desc = "Terminal horizontal" })
      vim.keymap.set("n", "<leader>tv", ":ToggleTerm direction=vertical<CR>", { desc = "Terminal vertical" })
      vim.keymap.set("n", "<leader>tF", ":ToggleTerm direction=float<CR>", { desc = "Terminal float" })
    end,
  },

  -- Better notification UI
  {
    "rcarriga/nvim-notify",
    config = function()
      local notify = require("notify")
      notify.setup({
        stages = "fade_in_slide_out",
        timeout = 3000,
        background_colour = "#000000",
        icons = {
          ERROR = "",
          WARN = "",
          INFO = "",
          DEBUG = "",
          TRACE = "✎",
        },
      })
      vim.notify = notify
    end,
  },

  -- UI components library (required by some plugins)
  {
    "MunifTanjim/nui.nvim",
  },

  -- Better vim.ui interfaces
  {
    "stevearc/dressing.nvim",
    config = function()
      require("dressing").setup({
        input = {
          enabled = true,
          default_prompt = "➤ ",
          win_options = {
            winblend = 0,
          },
        },
        select = {
          enabled = true,
          backend = { "telescope", "builtin" },
          telescope = require("telescope.themes").get_dropdown(),
        },
      })
    end,
  },

  -- Illuminate word under cursor
  {
    "RRethy/vim-illuminate",
    config = function()
      require("illuminate").configure({
        providers = {
          "lsp",
          "treesitter",
          "regex",
        },
        delay = 100,
        filetypes_denylist = {
          "dirvish",
          "fugitive",
          "alpha",
          "NvimTree",
          "lazy",
          "neogitstatus",
          "Trouble",
          "lir",
          "Outline",
          "spectre_panel",
          "toggleterm",
          "DressingSelect",
          "TelescopePrompt",
        },
        under_cursor = true,
      })
    end,
  },

  -- Breadcrumbs (show code context in winbar)
  {
    "SmiteshP/nvim-navic",
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
      require("nvim-navic").setup({
        icons = {
          File = " ",
          Module = " ",
          Namespace = " ",
          Package = " ",
          Class = " ",
          Method = " ",
          Property = " ",
          Field = " ",
          Constructor = " ",
          Enum = " ",
          Interface = " ",
          Function = " ",
          Variable = " ",
          Constant = " ",
          String = " ",
          Number = " ",
          Boolean = " ",
          Array = " ",
          Object = " ",
          Key = " ",
          Null = " ",
          EnumMember = " ",
          Struct = " ",
          Event = " ",
          Operator = " ",
          TypeParameter = " ",
        },
        highlight = true,
        separator = " > ",
        depth_limit = 0,
        depth_limit_indicator = "..",
        safe_output = true,
      })
    end,
  },

  -- Snippets
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets", -- Collection of common snippets
    },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()

      -- Jump forward/backward in snippets
      vim.keymap.set({"i", "s"}, "<C-k>", function()
        local ls = require("luasnip")
        if ls.expand_or_jumpable() then
          ls.expand_or_jump()
        end
      end, { desc = "Snippet jump forward" })

      vim.keymap.set({"i", "s"}, "<C-j>", function()
        local ls = require("luasnip")
        if ls.jumpable(-1) then
          ls.jump(-1)
        end
      end, { desc = "Snippet jump backward" })
    end,
  },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",     -- LSP completion source
      "hrsh7th/cmp-buffer",       -- Buffer completion source
      "hrsh7th/cmp-path",         -- Path completion source
      "hrsh7th/cmp-cmdline",      -- Command line completion
      "L3MON4D3/LuaSnip",         -- Snippet engine
      "saadparwaiz1/cmp_luasnip", -- Snippet completion source
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp", priority = 1000 },
          { name = "luasnip",  priority = 750 },
          { name = "buffer",   priority = 500 },
          { name = "path",     priority = 250 },
        }),
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        formatting = {
          format = function(entry, vim_item)
            -- Kind icons
            local kind_icons = {
              Text = "",
              Method = "󰆧",
              Function = "󰊕",
              Constructor = "",
              Field = "󰇽",
              Variable = "󰂡",
              Class = "󰠱",
              Interface = "",
              Module = "",
              Property = "󰜢",
              Unit = "",
              Value = "󰎠",
              Enum = "",
              Keyword = "󰌋",
              Snippet = "",
              Color = "󰏘",
              File = "󰈙",
              Reference = "",
              Folder = "󰉋",
              EnumMember = "",
              Constant = "󰏿",
              Struct = "",
              Event = "",
              Operator = "󰆕",
              TypeParameter = "󰅲",
            }
            vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)
            vim_item.menu = ({
              nvim_lsp = "[LSP]",
              luasnip = "[Snippet]",
              buffer = "[Buffer]",
              path = "[Path]",
            })[entry.source.name]
            return vim_item
          end,
        },
      })

      -- Command line completion
      cmp.setup.cmdline('/', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })

      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' }
        })
      })

      -- Integrate autopairs with cmp
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },

  -- Auto close brackets, quotes, etc.
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({
        check_ts = true, -- Enable treesitter integration
        ts_config = {
          lua = { "string" },
          javascript = { "template_string" },
        },
        fast_wrap = {
          map = "<M-e>",
          chars = { "{", "[", "(", '"', "'" },
          pattern = [=[[%'%"%)%>%]%)%}%,]]=],
          end_key = "$",
          keys = "qwertyuiopzxcvbnmasdfghjkl",
          check_comma = true,
          highlight = "Search",
          highlight_grey = "Comment",
        },
      })
    end,
  },



  -- Function signature help
  {
    "ray-x/lsp_signature.nvim",
    event = "VeryLazy",
    config = function()
      require("lsp_signature").setup({
        bind = true,
        handler_opts = {
          border = "rounded",
        },
        floating_window = true,
        floating_window_above_cur_line = true,
        hint_enable = true,
        hint_prefix = "→ ",
        hi_parameter = "LspSignatureActiveParameter",
        max_height = 12,
        max_width = 80,
        toggle_key = "<C-s>",
        select_signature_key = "<M-n>",
      })
    end,
  },

  -- LSP config
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- Configure diagnostics display
      vim.diagnostic.config({
        virtual_text = {
          prefix = '●',
          source = "if_many",
        },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
      })

      -- Diagnostic signs
      local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end

      -- Setup LSP keybindings when LSP attaches
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp_attach", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          -- Attach navic if available
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentSymbolProvider then
            local navic_ok, navic = pcall(require, "nvim-navic")
            if navic_ok then
              navic.attach(client, event.buf)
            end
          end

          -- Standard LSP keybindings (following Neovim conventions)
          map("gd", vim.lsp.buf.definition, "Go to definition")
          map("gD", vim.lsp.buf.declaration, "Go to declaration")
          map("gr", vim.lsp.buf.references, "Go to references")
          map("gI", vim.lsp.buf.implementation, "Go to implementation")
          map("gy", vim.lsp.buf.type_definition, "Go to type definition")
          map("K", vim.lsp.buf.hover, "Hover documentation")
          map("<leader>ca", vim.lsp.buf.code_action, "Code action")
          map("<leader>cr", vim.lsp.buf.rename, "Rename (simple)")
          -- Format is available globally via <leader>f

          -- Diagnostics navigation (standard bracket mappings)
          map("[d", vim.diagnostic.goto_prev, "Previous diagnostic")
          map("]d", vim.diagnostic.goto_next, "Next diagnostic")
          map("<leader>cd", vim.diagnostic.open_float, "Show diagnostic")
          map("<leader>cl", vim.diagnostic.setloclist, "Diagnostic loclist")
        end,
      })

      -- Default LSP capabilities with nvim-cmp support
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Helper function to setup LSP servers (compatible with both old and new API)
      local function setup_lsp(server, config)
        config = config or {}
        config.capabilities = capabilities

        -- Use new vim.lsp.config API if available (Neovim 0.11+)
        if vim.lsp.config then
          vim.lsp.config(server, config)
        else
          -- Fallback to old lspconfig API
          require("lspconfig")[server].setup(config)
        end
      end

      -- Configure all LSP servers installed via Nix
      -- Lua
      setup_lsp("lua_ls", {
        settings = {
          Lua = {
            diagnostics = {
              globals = { 'vim' },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = {
              enable = false,
            },
          },
        },
      })

      -- Nix
      setup_lsp("nil_ls", {
        settings = {
          ['nil'] = {
            formatting = {
              command = { "nixpkgs-fmt" },
            },
          },
        },
      })

      -- TypeScript/JavaScript
      setup_lsp("ts_ls")

      -- Python
      setup_lsp("pyright")

      -- Go
      setup_lsp("gopls")

      -- HTML/CSS/JSON
      setup_lsp("html")
      setup_lsp("cssls")
      setup_lsp("jsonls")
    end,
  },
})

-- ============================================================================
-- Quality of Life Improvements
-- ============================================================================

-- Disable annoying beeps
vim.opt.errorbells = false
vim.opt.visualbell = true

-- Better command line completion
vim.opt.wildmenu = true
vim.opt.wildmode = 'longest:full,full'

-- Make substitution preview live
vim.opt.inccommand = 'split'

-- Enable spell checking for certain file types
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'gitcommit', 'markdown', 'text' },
  callback = function()
    vim.opt_local.spell = true
  end,
})
