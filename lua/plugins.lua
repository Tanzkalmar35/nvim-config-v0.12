vim.pack.add({
    { src = "https://github.com/lewis6991/gitsigns.nvim" },
    { src = "https://github.com/mason-org/mason.nvim" },
    { src = "https://github.com/saghen/blink.cmp",                version = vim.version.range("^1") },
    { src = "https://github.com/ellisonleao/gruvbox.nvim" },
    { src = "https://github.com/ibhagwan/fzf-lua" },
    { src = "https://github.com/tpope/vim-fugitive" },
    { src = "https://github.com/m4xshen/autoclose.nvim" },
    { src = "https://github.com/folke/flash.nvim" },
    { src = "https://github.com/nvim-tree/nvim-web-devicons" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
    { src = "https://github.com/mfussenegger/nvim-jdtls" },
    { src = "https://github.com/kkoomen/vim-doge" },
    { src = "https://github.com/kevinhwang91/nvim-ufo" },
    { src = "https://github.com/kevinhwang91/promise-async" },
    { src = "https://github.com/Kicamon/markdown-table-mode.nvim" },
})

require('gitsigns').setup({ signcolumn = false })
require('mason').setup({
    ensure_installed = {
        "jdlts",
    }
})
require('autoclose').setup({})
require('flash').setup()
require('markdown-table-mode').setup()
require('nvim-treesitter.configs').setup({
    ensure_installed = { "lua", "go", "rust", "java" },
    highlight = { enable = true }
})

require('blink.cmp').setup({
    fuzzy = { implementation = 'prefer_rust_with_warning' },
    signature = { enabled = true },
    keymap = {
        preset = "default",
        ["<C-space>"] = {},
        ["<C-p>"] = {},
        ["<Tab>"] = { "select_and_accept", "fallback" },
        ["<S-Tab>"] = {},
        ["<C-y>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-n>"] = { "select_and_accept" },
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-b>"] = { "scroll_documentation_down", "fallback" },
        ["<C-f>"] = { "scroll_documentation_up", "fallback" },
        ["<C-l>"] = { "snippet_forward", "fallback" },
        ["<C-h>"] = { "snippet_backward", "fallback" },
        -- ["<C-e>"] = { "hide" },
    },

    appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "normal",
    },

    completion = {
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 200,
        }
    },

    cmdline = {
        keymap = {
            preset = 'inherit',
            ['<CR>'] = { 'accept_and_enter', 'fallback' },
        },
    },

    sources = { default = { "lsp" } }
})

local actions = require('fzf-lua.actions')
require('fzf-lua').setup({
    winopts = { backdrop = 85 },
    keymap = {
        builtin = {
            ["<C-f>"] = "preview-page-down",
            ["<C-b>"] = "preview-page-up",
            ["<C-p>"] = "toggle-preview",
        },
        fzf = {
            ["ctrl-a"] = "toggle-all",
            ["ctrl-t"] = "first",
            ["ctrl-g"] = "last",
            ["ctrl-d"] = "half-page-down",
            ["ctrl-u"] = "half-page-up",
        }
    },
    actions = {
        files = {
            ["ctrl-q"] = actions.file_sel_to_qf,
            ["ctrl-n"] = actions.toggle_ignore,
            ["ctrl-h"] = actions.toggle_hidden,
            ["enter"]  = actions.file_edit_or_qf,
        }
    }
})

local java_aug = vim.api.nvim_create_augroup("JavaJdtls", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
    group = java_aug,
    pattern = "java",
    callback = function()
        -- --- MANUALLY DEFINE THE PATH ---
        -- Get the path to the jdtls executable installed by Mason
        local mason_bin_path = vim.fn.stdpath("data") .. "/mason/bin/jdtls"
        -- --- VERIFY THE PATH (for safety) ---
        -- This checks if the file actually exists before we try to use it
        if vim.fn.executable(mason_bin_path) == 0 then
            print("Error: jdtls executable not found at: " .. mason_bin_path)
            print("Make sure Mason has installed jdtls.")
            return
        end

        local jdtls = require("jdtls")
        jdtls.start_or_attach({
            -- We are now explicitly telling nvim-jdtls what command to run
            cmd = { mason_bin_path },
            root_dir = jdtls.setup.find_root({
                "pom.xml",
                "build.gradle",
                "settings.gradle",
                ".git",
            }),
            on_attach = function(client, bufnr)
                local map = function(mode, lhs, rhs, desc)
                    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
                end

                -- Java-specific refactoring maps
                map("n", "<leader>jo", jdtls.organize_imports, "Organize Imports")
                map("n", "<leader>jev", jdtls.extract_variable, "Extract Variable")
                map("v", "<leader>jem", "<ESC><CMD>lua require('jdtls').extract_method(true)<CR>", "Extract Method")
            end,
        })
    end,
})

-- ### nvim-ufo config ###

vim.o.foldcolumn = "1"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true

vim.keymap.set("n", "zR", require("ufo").openAllFolds)
vim.keymap.set("n", "zM", require("ufo").closeAllFolds)

require("ufo").setup({
    provider_selector = function(bufnr, filetype, buftype)
        return { "treesitter", "indent" }
    end
})
