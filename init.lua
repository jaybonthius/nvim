-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Create a group for your autocommands to avoid duplicates
local configgroup = vim.api.nvim_create_augroup("configgroup", {
    clear = true
})

-- Set Pollen synx for specific file extensions
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
    pattern = {"*.pm", "*.pp", "*.ptree"},
    command = "set filetype=pollen",
    group = configgroup
})

-- Suggested editor settings for Pollen filetype
vim.api.nvim_create_autocmd("FileType", {
    pattern = "pollen",
    callback = function()
        vim.opt_local.wrap = true -- Soft wrap (don't affect buffer)
        vim.opt_local.linebreak = true -- Wrap on word-breaks only
    end,
    group = configgroup
})

-- Easy insertion of special chars
vim.api.nvim_set_keymap('i', '<C-L>', 'λ', {
    noremap = true,
    silent = true
})
vim.api.nvim_set_keymap('i', '<C-E>', '◊', {
    noremap = true,
    silent = true
})

-- reload shortcut
vim.api.nvim_set_keymap('n', '<leader>rc', ':source ~/.config/nvim/init.lua<CR>', {
    noremap = true,
    silent = true
})

-- formatting racket files
local function format_racket_file()
    local filename = vim.fn.expand('%:p') -- Get the full path of the current file
    vim.cmd('!raco fmt -i ' .. filename)
    vim.cmd('edit!') -- Reload the file in case raco fmt changes it
end

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = {"*.rkt", "*.rktl"}, -- Add any other Racket file extensions you use
    callback = format_racket_file
})

-- tailwind configuration
local nvim_lsp = require('lspconfig')
nvim_lsp.tailwindcss.setup({
    capabilities = capabilities,
    filetypes = {"html", "racket"},
    init_options = {
        userLanguages = {
            racket = "plaintext"
        }
    },
    settings = {
        tailwindCSS = {
            experimental = {
                classRegex = {"\\(class\\s+\"([^\\\"]+)\"\\)", "\\(className\\s+\"([^\\\"]+)\"\\)",
                              "\\(tailwind\\s+\"([^\\\"]+)\"\\)"}
            }
        }
    }
})

require('tailwind-sorter').setup({
    on_save_enabled = true, -- If `true`, automatically enables on save sorting.
    on_save_pattern = {'*.html', '*.js', '*.rkt'}, -- The file patterns to watch and sort.
    node_path = 'node'
})
