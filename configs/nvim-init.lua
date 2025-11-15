-- ============================================================================
-- Neovim Configuration - Clean & Simple with QoL features
-- ============================================================================

-- ============================================================================
-- Basic Settings
-- ============================================================================
vim.opt.number = true              -- Show line numbers
vim.opt.relativenumber = true      -- Show relative line numbers
vim.opt.mouse = 'a'                -- Enable mouse support
vim.opt.ignorecase = true          -- Case insensitive search
vim.opt.smartcase = true           -- Unless uppercase is used
vim.opt.hlsearch = true            -- Highlight search results
vim.opt.incsearch = true           -- Incremental search
vim.opt.wrap = true                -- Wrap lines
vim.opt.breakindent = true         -- Preserve indentation in wrapped text
vim.opt.tabstop = 2                -- Tab width
vim.opt.shiftwidth = 2             -- Indent width
vim.opt.expandtab = true           -- Use spaces instead of tabs
vim.opt.smartindent = true         -- Smart auto-indenting
vim.opt.smarttab = true            -- Smart tab behavior
vim.opt.clipboard = 'unnamedplus'  -- Use system clipboard
vim.opt.scrolloff = 8              -- Keep 8 lines above/below cursor
vim.opt.sidescrolloff = 8          -- Keep 8 columns left/right of cursor
vim.opt.signcolumn = 'yes'         -- Always show sign column
vim.opt.cursorline = true          -- Highlight current line
vim.opt.termguicolors = true       -- Enable 24-bit colors
vim.opt.updatetime = 250           -- Faster completion
vim.opt.timeoutlen = 300           -- Faster which-key popup
vim.opt.undofile = true            -- Enable persistent undo
vim.opt.backup = false             -- Disable backup files
vim.opt.writebackup = false        -- Disable backup before writing
vim.opt.swapfile = false           -- Disable swap files
vim.opt.splitright = true          -- Vertical splits go right
vim.opt.splitbelow = true          -- Horizontal splits go below
vim.opt.showmode = false           -- Don't show mode (we have statusline)

-- Set leader key to space
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

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

-- Buffer navigation
vim.keymap.set('n', '{', ':bprevious<CR>', { desc = 'Previous buffer' })
vim.keymap.set('n', '}', ':bnext<CR>', { desc = 'Next buffer' })
vim.keymap.set('n', '<leader>bd', ':bdelete<CR>', { desc = 'Delete buffer' })

-- Better indenting
vim.keymap.set('v', '<', '<gv', { desc = 'Indent left' })
vim.keymap.set('v', '>', '>gv', { desc = 'Indent right' })

-- Move lines up and down
vim.keymap.set('n', '<A-j>', ':m .+1<CR>==', { desc = 'Move line down' })
vim.keymap.set('n', '<A-k>', ':m .-2<CR>==', { desc = 'Move line up' })
vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })

-- Clear search highlighting
vim.keymap.set('n', '<Esc>', ':nohlsearch<CR>', { desc = 'Clear search highlight' })

-- Quick save
vim.keymap.set('n', '<leader>w', ':w<CR>', { desc = 'Save file' })
vim.keymap.set('n', '<leader>q', ':q<CR>', { desc = 'Quit' })

-- Split windows
vim.keymap.set('n', '<leader>sv', ':vsplit<CR>', { desc = 'Split vertically' })
vim.keymap.set('n', '<leader>sh', ':split<CR>', { desc = 'Split horizontally' })

-- File explorer (netrw)
vim.keymap.set('n', '<leader>e', ':Explore<CR>', { desc = 'Open file explorer' })

-- ============================================================================
-- Netrw (Built-in File Explorer) Configuration
-- ============================================================================
vim.g.netrw_banner = 0          -- Disable banner
vim.g.netrw_liststyle = 3       -- Tree style listing
vim.g.netrw_browse_split = 0    -- Open in same window
vim.g.netrw_winsize = 25        -- Window size

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

-- ============================================================================
-- Statusline (Simple & Clean)
-- ============================================================================
-- Simple statusline using Vim's built-in format strings
vim.opt.statusline = ' %{toupper(mode())} | %f%m%r | %y | %l:%c | %p%% '

-- ============================================================================
-- Colors & Appearance
-- ============================================================================
vim.cmd([[
  " Use a simple color scheme
  colorscheme habamax

  " Make background transparent
  highlight Normal guibg=NONE ctermbg=NONE
  highlight NormalNC guibg=NONE ctermbg=NONE
  highlight SignColumn guibg=NONE ctermbg=NONE
  highlight EndOfBuffer guibg=NONE ctermbg=NONE
]])

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
