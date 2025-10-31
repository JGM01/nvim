-- Core options
vim.o.number = true
vim.o.relativenumber = true
vim.o.wrap = false
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.swapfile = false
vim.o.winborder = "rounded"
vim.o.background = "dark"
vim.o.signcolumn = "yes"
vim.o.cursorline = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.scrolloff = 8
vim.o.clipboard = "unnamedplus"
vim.o.termguicolors = true
vim.g.mapleader = " "

-- Keymaps
vim.keymap.set('n', '<leader>o', ':update<CR> :source<CR>')
vim.keymap.set('n', '<leader>q', ':quit<CR>')
vim.keymap.set('n', '<leader>pv', ':Ex<CR>')
vim.keymap.set('n', '<leader>w', function()
	vim.lsp.buf.format()
	vim.cmd('write')
end, { noremap = true, silent = true, desc = 'Format and save buffer' })

vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float,
	{ noremap = true, silent = true, desc = 'Show diagnostic message' })
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { noremap = true, silent = true, desc = 'Rename symbol' })
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { noremap = true, silent = true, desc = 'Go to definition' })
vim.keymap.set('n', 'gr', vim.lsp.buf.references, { noremap = true, silent = true, desc = 'Go to references' })
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { noremap = true, silent = true, desc = 'Code action' })

-- Plugins
vim.pack.add({
	-- Essentials
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/typicode/bg.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
	{ src = "https://github.com/mbbill/undotree" },

	-- Treesitter for better syntax highlighting
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", run = ":TSUpdate" },

	-- Autocompletion stack
	{ src = "https://github.com/hrsh7th/nvim-cmp" },
	{ src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
	{ src = "https://github.com/hrsh7th/cmp-buffer" },
	{ src = "https://github.com/hrsh7th/cmp-path" },
	{ src = "https://github.com/L3MON4D3/LuaSnip" },
	{ src = "https://github.com/saadparwaiz1/cmp_luasnip" },
	{ src = "https://github.com/onsails/lspkind.nvim" },
})

-- Treesitter config
require('nvim-treesitter.configs').setup({
	ensure_installed = { "lua", "c", "cpp", "rust", "python", "json", "html", "css", "javascript", "wgsl" },
	highlight = { enable = true },
	indent = { enable = true },
	rainbow = { enable = true, extended_mode = true },
})

-- LSP setup with cmp integration
local capabilities = require('cmp_nvim_lsp').default_capabilities()
vim.lsp.enable({ "lua_ls", "clangd", "rust_analyzer", "wgsl-analyzer" }, { capabilities = capabilities })

-- Telescope mappings
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

-- nvim-cmp setup
local cmp = require('cmp')
local luasnip = require('luasnip')

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		['<C-Space>'] = cmp.mapping.complete(),
		['<CR>'] = cmp.mapping.confirm({ select = true }),
		['<Tab>'] = cmp.mapping.select_next_item(),
		['<S-Tab>'] = cmp.mapping.select_prev_item(),
	}),
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
	}, {
		{ name = 'buffer' },
		{ name = 'path' },
	}),
	formatting = {
		format = require('lspkind').cmp_format({
			mode = 'symbol_text',
			maxwidth = 50,
			ellipsis_char = '...',
		}),
	},
})
