-- ============================================================================
-- LunarVim Enhanced Configuration
-- ============================================================================
-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim

-- ============================================================================
-- General Settings
-- ============================================================================
vim.opt.relativenumber = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.background = "dark"
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.wrap = true
vim.opt.scrolloff = 8        -- Keep 8 lines above/below cursor
vim.opt.sidescrolloff = 8    -- Keep 8 columns left/right of cursor
vim.opt.signcolumn = "yes"   -- Always show sign column
vim.opt.updatetime = 250     -- Faster completion
vim.opt.timeoutlen = 300     -- Faster which-key popup

-- ============================================================================
-- Keybindings
-- ============================================================================

-- Buffer navigation
lvim.keys.normal_mode["{"] = ":BufferLineCyclePrev<CR>"
lvim.keys.normal_mode["}"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-x>"] = ":BufferKill<CR>"

-- NvimTree focus
lvim.keys.normal_mode["<leader>o"] = ":NvimTreeFocus<CR>"

-- ToggleTerm
lvim.keys.normal_mode["<leader>th"] = ":ToggleTerm direction=horizontal<CR>"
lvim.keys.normal_mode["<leader>tf"] = ":ToggleTerm direction=float<CR>"

-- Indentation (stay in visual mode)
lvim.keys.normal_mode["<"] = "v<"
lvim.keys.normal_mode[">"] = "v>"
lvim.keys.visual_mode["<"] = "<gv"
lvim.keys.visual_mode[">"] = ">gv"

-- Move lines
lvim.keys.normal_mode["<C-j>"] = ":m .+1<CR>=="
lvim.keys.normal_mode["<C-k>"] = ":m .-2<CR>=="
lvim.keys.visual_mode["<C-j>"] = ":m '>+1<CR>gv=gv"
lvim.keys.visual_mode["<C-k>"] = ":m '<-2<CR>gv=gv"

-- Terminal mode escape
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>:ToggleTerm<CR>]], {})

-- Better window navigation
lvim.keys.normal_mode["<C-h>"] = "<C-w>h"
lvim.keys.normal_mode["<C-l>"] = "<C-w>l"

-- ============================================================================
-- LSP Configuration
-- ============================================================================

-- Mason configuration for persistent LSP management
lvim.builtin.mason.setup = {
  ui = {
    border = "rounded",
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  },
  install_root_dir = vim.fn.stdpath("data") .. "/mason",
  PATH = "append", -- Append Mason binaries to PATH
}

-- Enable automatic installation of LSP servers
lvim.lsp.installer.setup.automatic_installation = {
  exclude = {} -- Don't exclude any servers from auto-installation
}

-- List of LSP servers to automatically install via Mason
lvim.lsp.automatic_configuration.skipped_servers = {}

-- Ensure these LSP servers are installed
local mason_ensure_installed = {
  "nil_ls",           -- Nix
  "lua_ls",           -- Lua
  "tsserver",         -- TypeScript/JavaScript
  "pyright",          -- Python
  "rust_analyzer",    -- Rust
  "gopls",            -- Go
  "html",             -- HTML
  "cssls",            -- CSS
  "jsonls",           -- JSON
  "yamlls",           -- YAML
}

-- Auto-install LSP servers on startup
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    local registry = require("mason-registry")
    for _, server in ipairs(mason_ensure_installed) do
      local ok, pkg = pcall(registry.get_package, server)
      if ok then
        if not pkg:is_installed() then
          vim.notify("Installing " .. server, vim.log.levels.INFO)
          pkg:install()
        end
      end
    end
  end,
})

-- ============================================================================
-- UI Settings
-- ============================================================================
lvim.transparent_window = true
lvim.colorscheme = "tokyonight"

-- Built-in LunarVim components configuration
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = true

-- BufferLine configuration
lvim.builtin.bufferline.options.diagnostics = "nvim_lsp"
lvim.builtin.bufferline.options.show_buffer_close_icons = true
lvim.builtin.bufferline.options.show_close_icon = false
lvim.builtin.bufferline.options.separator_style = "slant"
lvim.builtin.bufferline.options.offsets = {
  {
    filetype = "NvimTree",
    text = "File Explorer",
    highlight = "Directory",
    text_align = "left"
  }
}

-- Lualine configuration
lvim.builtin.lualine.style = "default"
lvim.builtin.lualine.options.theme = "tokyonight"
lvim.builtin.lualine.sections.lualine_a = { "mode" }
lvim.builtin.lualine.sections.lualine_b = { "branch", "diff" }
lvim.builtin.lualine.sections.lualine_c = {
  {
    "filename",
    path = 1, -- Show relative path
    symbols = {
      modified = " ●",
      readonly = " ",
      unnamed = "[No Name]",
    }
  }
}
lvim.builtin.lualine.sections.lualine_x = {
  "diagnostics",
  "encoding",
  "fileformat",
  "filetype"
}

-- Treesitter configuration
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "c",
  "javascript",
  "json",
  "lua",
  "python",
  "typescript",
  "tsx",
  "css",
  "rust",
  "java",
  "yaml",
  "go",
}
lvim.builtin.treesitter.highlight.enable = true
lvim.builtin.treesitter.rainbow.enable = true

-- Telescope configuration
lvim.builtin.telescope.defaults.layout_strategy = "horizontal"
lvim.builtin.telescope.defaults.layout_config = {
  horizontal = {
    preview_width = 0.55,
    results_width = 0.8,
  },
  width = 0.87,
  height = 0.80,
  preview_cutoff = 120,
}

-- Which-key configuration
lvim.builtin.which_key.setup.window.border = "rounded"
lvim.builtin.which_key.setup.window.margin = { 1, 0, 1, 0 }
lvim.builtin.which_key.setup.plugins.presets.operators = true
lvim.builtin.which_key.setup.plugins.presets.motions = true

-- ============================================================================
-- Plugins
-- ============================================================================
lvim.plugins = {
  -- Essential productivity
  "github/copilot.vim",
  "wakatime/vim-wakatime",

  -- ========================================
  -- Theme & Visual Enhancements
  -- ========================================
  {
    "ghifarit53/tokyonight-vim",
    config = function()
      vim.g.tokyonight_style = "storm"
      vim.g.tokyonight_enable_italic = true
      vim.g.tokyonight_transparent_background = true
      vim.cmd([[colorscheme tokyonight]])
    end
  },

  -- Color highlighter
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({
        "*",
      }, {
        RGB = true,
        RRGGBB = true,
        names = true,
        RRGGBBAA = true,
        rgb_fn = true,
        hsl_fn = true,
        css = true,
        css_fn = true,
      })
    end
  },

  -- Better notifications
  {
    "rcarriga/nvim-notify",
    config = function()
      require("notify").setup({
        background_colour = "#00000000",  -- Fully transparent
        fps = 60,
        icons = {
          DEBUG = "",
          ERROR = "",
          INFO = "",
          TRACE = "✎",
          WARN = ""
        },
        level = 2,
        minimum_width = 50,
        render = "default",
        stages = "fade_in_slide_out",
        timeout = 3000,
        top_down = true
      })
      vim.notify = require("notify")
    end
  },

  -- Scrollbar with diagnostic integration
  {
    "petertriho/nvim-scrollbar",
    event = "BufReadPost",
    config = function()
      require("scrollbar").setup({
        show = true,
        show_in_active_only = false,
        set_highlights = true,
        handle = {
          text = " ",
          color = "#5a5a5a",
          hide_if_all_visible = true,
        },
        marks = {
          Error = { color = "#db4b4b" },
          Warn = { color = "#e0af68" },
          Info = { color = "#0db9d7" },
          Hint = { color = "#1abc9c" },
          Misc = { color = "#9d7cd8" },
        },
        handlers = {
          cursor = true,
          diagnostic = true,
          gitsigns = true,
          handle = true,
        },
        excluded_filetypes = {
          "alpha",
          "dashboard",
          "neo-tree",
          "NvimTree",
          "toggleterm",
        },
      })
      -- Integrate with gitsigns after setup
      require("scrollbar.handlers.gitsigns").setup()
    end
  },

  -- Better UI elements
  {
    "stevearc/dressing.nvim",
    config = function()
      require("dressing").setup({
        input = {
          enabled = true,
          default_prompt = "➤ ",
          border = "rounded",
          win_options = {
            winblend = 10,  -- Add transparency
          },
        },
        select = {
          enabled = true,
          backend = { "telescope", "builtin" },
          telescope = require("telescope.themes").get_dropdown({
            winblend = 10,  -- Add transparency to dropdown
          }),
        },
      })
    end
  },

  -- ========================================
  -- Functional Improvements
  -- ========================================

  -- Git signs and blame
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup {
        signs = {
          add = { text = "│" },
          change = { text = "│" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
          untracked = { text = "┆" },
        },
        current_line_blame = true,
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = "eol",
          delay = 300,
        },
        current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end
          -- Navigation
          map("n", "]c", function()
            if vim.wo.diff then return "]c" end
            vim.schedule(function() gs.next_hunk() end)
            return "<Ignore>"
          end, { expr = true })
          map("n", "[c", function()
            if vim.wo.diff then return "[c" end
            vim.schedule(function() gs.prev_hunk() end)
            return "<Ignore>"
          end, { expr = true })
          -- Actions
          map("n", "<leader>gp", gs.preview_hunk)
          map("n", "<leader>gb", function() gs.blame_line { full = true } end)
        end
      }
    end
  },

  -- Auto pairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({
        check_ts = true,
        ts_config = {
          lua = { "string" },
          javascript = { "template_string" },
        },
        disable_filetype = { "TelescopePrompt", "vim" },
        fast_wrap = {
          map = "<M-e>",
          chars = { "{", "[", "(", '"', "'" },
          pattern = [=[[%'%"%)%>%]%)%}%,]]=],
          end_key = "$",
          keys = "qwertyuiopzxcvbnmasdfghjkl",
          check_comma = true,
          highlight = "Search",
          highlight_grey = "Comment"
        },
      })
    end
  },

  -- Surround selections
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup()
    end
  },

  -- Signature help for function parameters
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function()
      require("lsp_signature").setup({
        bind = true,
        handler_opts = {
          border = "rounded"
        },
        hint_enable = true,
        hint_prefix = "🐼 ",
        hi_parameter = "LspSignatureActiveParameter",
        floating_window = true,
        floating_window_above_cur_line = true,
        transparency = 100,  -- Fully transparent (0-100 scale, higher = more transparent)
        toggle_key = "<C-k>",
        select_signature_key = "<M-n>",
        move_cursor_key = nil,
        max_height = 12,
        max_width = 80,
        padding = " ",
      })
    end
  },

  -- Enhanced LSP UI
  {
    "glepnir/lspsaga.nvim",
    branch = "main",
    config = function()
      require("lspsaga").setup({
        ui = {
          border = "rounded",
          devicon = true,
          title = true,
          code_action = "💡",
        },
        lightbulb = {
          enable = true,
          enable_in_insert = true,
          sign = true,
          sign_priority = 40,
          virtual_text = false,
        },
        symbol_in_winbar = {
          enable = true,
        },
      })
      -- Keymaps
      vim.keymap.set("n", "gh", "<cmd>Lspsaga lsp_finder<CR>")
      vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>")
      vim.keymap.set("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>")
      vim.keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>")
      vim.keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>")
      vim.keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>")
      vim.keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>")
    end
  },

  -- Better code folding
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    config = function()
      vim.o.foldcolumn = "1"
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      require("ufo").setup({
        provider_selector = function()
          return { "treesitter", "indent" }
        end
      })
      vim.keymap.set("n", "zR", require("ufo").openAllFolds)
      vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
    end
  },

  -- Treesitter context
  {
    "nvim-treesitter/nvim-treesitter-context",
    config = function()
      require("treesitter-context").setup({
        enable = true,
        max_lines = 3,
        trim_scope = "outer",
        patterns = {
          default = {
            "class",
            "function",
            "method",
          },
        },
      })
    end
  },

  -- Rainbow delimiters
  {
    "HiPhish/rainbow-delimiters.nvim",
    config = function()
      local rainbow_delimiters = require("rainbow-delimiters")
      require("rainbow-delimiters.setup").setup({
        strategy = {
          [""] = rainbow_delimiters.strategy["global"],
          vim = rainbow_delimiters.strategy["local"],
        },
        query = {
          [""] = "rainbow-delimiters",
          lua = "rainbow-blocks",
        },
        highlight = {
          "RainbowDelimiterRed",
          "RainbowDelimiterYellow",
          "RainbowDelimiterBlue",
          "RainbowDelimiterOrange",
          "RainbowDelimiterGreen",
          "RainbowDelimiterViolet",
          "RainbowDelimiterCyan",
        },
      })
    end
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
        performance_mode = false,
      })
    end
  },

  -- Discord presence
  {
    "andweeb/presence.nvim",
    config = function()
      require("presence").setup({
        auto_update = true,
        neovim_image_text = "The One True Text Editor",
        main_image = "neovim",
        log_level = nil,
        debounce_timeout = 10,
        enable_line_number = false,
        buttons = true,
        show_time = true,
      })
    end
  },

  -- Enhanced terminal
  {
    "akinsho/toggleterm.nvim",
    config = function()
      require("toggleterm").setup({
        size = 20,
        open_mapping = [[<c-\>]],
        hide_numbers = true,
        shade_terminals = false,  -- Disable shading for transparency
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        direction = "float",
        close_on_exit = true,
        shell = vim.o.shell,
        float_opts = {
          border = "curved",
          winblend = 10,  -- Add transparency
          highlights = {
            border = "Normal",
            background = "Normal",
          },
        },
      })
    end
  },
}
