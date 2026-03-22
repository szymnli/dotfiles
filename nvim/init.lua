-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- ─── Leader keys (must be before lazy) ──────────────────────────────────────
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- ─── Core options ────────────────────────────────────────────────────────────
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.clipboard = "unnamedplus" -- share system clipboard

-- ─── Plugins ─────────────────────────────────────────────────────────────────
require("lazy").setup({
    spec = {

        -- ── Colorscheme ─────────────────────────────────────────────────────────
        {
            "catppuccin/nvim",
            name = "catppuccin",
            priority = 1000,       -- load first
            opts = {
                flavour = "mocha", -- mocha is the "espresso" dark variant
                integrations = {
                    treesitter = true,
                    telescope = { enabled = true },
                    which_key = true,
                    gitsigns = true,
                    nvimtree = true,
                    mason = true,
                    cmp = true,
                    native_lsp = { enabled = true },
                },
            },
            config = function(_, opts)
                require("catppuccin").setup(opts)
                vim.cmd.colorscheme("catppuccin-mocha")
            end,
        },

        -- ── File explorer ────────────────────────────────────────────────────────
        {
            "nvim-tree/nvim-tree.lua",
            dependencies = { "nvim-tree/nvim-web-devicons" },
            keys = { { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Explorer" } },
            opts = { view = { width = 30 }, renderer = { group_empty = true } },
        },

        -- ── Fuzzy finder ────────────────────────────────────────────────────────
        {
            "nvim-telescope/telescope.nvim",
            dependencies = {
                "nvim-lua/plenary.nvim",
                { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
            },
            keys = {
                { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
                { "<leader>fg", "<cmd>Telescope live_grep<cr>",  desc = "Live Grep" },
                { "<leader>fb", "<cmd>Telescope buffers<cr>",    desc = "Buffers" },
                { "<leader>fh", "<cmd>Telescope help_tags<cr>",  desc = "Help" },
            },
            config = function()
                require("telescope").setup({})
                require("telescope").load_extension("fzf")
            end,
        },

        -- ── Syntax highlighting ──────────────────────────────────────────────────
        {
            "nvim-treesitter/nvim-treesitter",
            build = ":TSUpdate",
            opts = {
                ensure_installed = { "lua", "python", "c", "bash", "json", "yaml", "markdown" },
                highlight = { enable = true },
                indent = { enable = true },
            },
            config = function(_, opts)
                require("nvim-treesitter").setup(opts)
            end,
        },

        -- ── LSP + Mason ──────────────────────────────────────────────────────────
        { "williamboman/mason.nvim", opts = {} },
        {
            "williamboman/mason-lspconfig.nvim",
            dependencies = { "williamboman/mason.nvim" },
            opts = {
                ensure_installed = { "pyright", "clangd", "lua_ls", "bashls" },
                automatic_installation = true,
            },
        },
        {
            "neovim/nvim-lspconfig",
            dependencies = { "williamboman/mason-lspconfig.nvim" },
            config = function()
                local on_attach = function(_, bufnr)
                    local map = function(keys, func, desc)
                        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
                    end
                    map("gd", vim.lsp.buf.definition, "Go to Definition")
                    map("K", vim.lsp.buf.hover, "Hover Docs")
                    map("<leader>rn", vim.lsp.buf.rename, "Rename")
                    map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
                    map("[d", vim.diagnostic.goto_prev, "Prev Diagnostic")
                    map("]d", vim.diagnostic.goto_next, "Next Diagnostic")
                end

                -- New 0.11 API: vim.lsp.config + vim.lsp.enable
                vim.lsp.config("*", { on_attach = on_attach })

                -- Per-server overrides go here, before enable()
                vim.lsp.config("lua_ls", {
                    settings = {
                        Lua = {
                            diagnostics = { globals = { "vim" } },
                        },
                    },
                })

                vim.lsp.enable({ "pyright", "clangd", "lua_ls", "bashls" })
            end,
        },

        -- ── Autocompletion ───────────────────────────────────────────────────────
        {
            "hrsh7th/nvim-cmp",
            dependencies = {
                "hrsh7th/cmp-nvim-lsp",
                "hrsh7th/cmp-buffer",
                "hrsh7th/cmp-path",
                "L3MON4D3/LuaSnip",
                "saadparwaiz1/cmp_luasnip",
                "rafamadriz/friendly-snippets",
            },
            config = function()
                local cmp = require("cmp")
                local luasnip = require("luasnip")
                require("luasnip.loaders.from_vscode").lazy_load()
                cmp.setup({
                    snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
                    mapping = cmp.mapping.preset.insert({
                        ["<C-Space>"] = cmp.mapping.complete(),
                        ["<CR>"]      = cmp.mapping.confirm({ select = true }),
                        ["<Tab>"]     = cmp.mapping(function(fallback)
                            if cmp.visible() then
                                cmp.select_next_item()
                            elseif luasnip.expand_or_jumpable() then
                                luasnip.expand_or_jump()
                            else
                                fallback()
                            end
                        end, { "i", "s" }),
                    }),
                    sources = cmp.config.sources({
                        { name = "nvim_lsp" },
                        { name = "luasnip" },
                        { name = "buffer" },
                        { name = "path" },
                    }),
                })
            end,
        },

        -- ── Auto-pairs & surrounds ───────────────────────────────────────────────
        { "windwp/nvim-autopairs",   event = "InsertEnter", opts = {} },
        {
            "kylechui/nvim-surround",
            event = "VeryLazy",
            opts = {},
        },

        -- ── Git integration ──────────────────────────────────────────────────────
        {
            "lewis6991/gitsigns.nvim",
            opts = {
                signs = {
                    add    = { text = "▎" },
                    change = { text = "▎" },
                    delete = { text = "" },
                },
            },
        },

        -- ── Status line ──────────────────────────────────────────────────────────
        {
            "nvim-lualine/lualine.nvim",
            dependencies = { "nvim-tree/nvim-web-devicons", "catppuccin/nvim" },
            opts = { options = { theme = "catppuccin-mocha" } },
        },

        -- ── Buffer tabs ──────────────────────────────────────────────────────────
        {
            "akinsho/bufferline.nvim",
            dependencies = "nvim-tree/nvim-web-devicons",
            opts = { options = { diagnostics = "nvim_lsp" } },
        },

        -- ── Keybinding hints ─────────────────────────────────────────────────────
        {
            "folke/which-key.nvim",
            event = "VeryLazy",
            opts = {},
        },

        -- ── Comment toggling ─────────────────────────────────────────────────────
        {
            "numToStr/Comment.nvim",
            event = "VeryLazy",
            opts = {},
        },

        -- ── Indentation guides ───────────────────────────────────────────────────
        {
            "lukas-reineke/indent-blankline.nvim",
            main = "ibl",
            opts = {},
        },

        -- ── Terminal ─────────────────────────────────────────────────────────────
        {
            "akinsho/toggleterm.nvim",
            keys = { { "<leader>t", "<cmd>ToggleTerm direction=horizontal<cr>", desc = "Terminal" } },
            opts = { size = 15, shade_terminals = true },
        },

        -- ── Formatting ───────────────────────────────────────────────────────────
        {
            "stevearc/conform.nvim",
            event = "BufWritePre",
            opts = {
                formatters_by_ft = {
                    python = { "black" },
                    c      = { "clang_format" },
                    lua    = { "stylua" },
                },
                format_on_save = { timeout_ms = 500, lsp_fallback = true },
            },
        },

        -- ── Dashboard ────────────────────────────────────────────────────────
        {
            "goolord/alpha-nvim",
            dependencies = { "nvim-tree/nvim-web-devicons" },
            config = function()
                local alpha = require("alpha")
                local dashboard = require("alpha.themes.dashboard")

                dashboard.section.header.val = {
                    "      |\\      _,,,---,,_      ",
                    "ZZZzz /,`.-'`'    -.  ;-;;,_  ",
                    "     |,4-  ) )-,_. ,\\ (  `'-' ",
                    "    '---''(_/--'  `-\\_)      ",
                }

                dashboard.section.buttons.val = {
                    dashboard.button("f", "  Find file", function()
                        require("telescope.builtin").find_files()
                    end),
                    dashboard.button("g", "  Live grep", function()
                        require("telescope.builtin").live_grep()
                    end),
                    dashboard.button("r", "  Recent files", function()
                        require("telescope.builtin").oldfiles()
                    end),
                    dashboard.button("e", "  File explorer", function()
                        require("nvim-tree.api").tree.toggle()
                    end),
                    dashboard.button("c", "  Config", function()
                        vim.cmd("edit " .. vim.fn.stdpath("config") .. "/init.lua")
                    end),
                    dashboard.button("q", "  Quit", function()
                        vim.cmd("qa")
                    end),
                }

                dashboard.section.footer.val = "  " ..
                    vim.fn.len(vim.tbl_keys(require("lazy").plugins())) .. " plugins loaded"

                alpha.setup(dashboard.config)
            end,
        },

    },

    install = { colorscheme = { "catppuccin-mocha", "habamax" } },
    checker = { enabled = true },
})
