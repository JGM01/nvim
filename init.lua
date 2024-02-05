-- JACOBS CONFIG
--
-- VERY COOL
--


-- OPTIONS --

vim.opt.number = true		-- show numbers in gutter.
vim.opt.ignorecase = true	-- ignore case in searches.
vim.opt.smartcase = true	-- ignore unless search term is upper case.
vim.opt.hlsearch = false	-- removes highlights of previous results.
vim.opt.wrap = true			-- wrap text :D
vim.opt.breakindent = true	-- indent wrapped lines
vim.opt.tabstop = 4			-- tab spaces
vim.opt.shiftwidth = 4		-- amount to shift with >> or <<

vim.opt.showmode = false	-- remove mode b.c. lualine does it already

vim.opt.scrolloff = 10		-- give the cursor some space at the top & bottom
vim.opt.completeopt = {'menu', 'menuone', 'noselect'}

-- KEYMAPS --

vim.g.mapleader = ' '											-- set space as leader

vim.keymap.set({'n','x'}, '<leader>c', '"+y')					-- copy to OS clipboard
vim.keymap.set({'n','x'}, '<leader>v', '"+p')					-- paste from OS clipboard

vim.keymap.set('n', '<leader>a', ':keepjumps normal! ggVG<cr>') -- select all on page

vim.keymap.set('n', '<leader>e', '<cmd>Ex<cr>')

-- PLUGIN SPECIFIC KEYMAPS --

-- LAZY SETUP & CONFIG --

local lazy = {}


function lazy.install(path)
  if not vim.loop.fs_stat(path) then
    print('Installing lazy.nvim....')
    vim.fn.system({
      'git',
      'clone',
      '--filter=blob:none',
      'https://github.com/folke/lazy.nvim.git',
      '--branch=stable', -- latest stable release
      path,
    })
  end
end

function lazy.setup(plugins)
  if vim.g.plugins_ready then
    return
  end

  lazy.install(lazy.path)

  vim.opt.rtp:prepend(lazy.path)

  require('lazy').setup(plugins, lazy.opts)
  vim.g.plugins_ready = true
end

lazy.path = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
lazy.opts = {}

-- PLUGIN DECLARATIONS --

lazy.setup({

	{"nvim-lualine/lualine.nvim"},
	{"nvim-treesitter/nvim-treesitter"},
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { 'nvim-lua/plenary.nvim' }
	},
	{"neovim/nvim-lspconfig"},
	{"hrsh7th/nvim-cmp"},
	{"hrsh7th/cmp-nvim-lsp"},
	{"hrsh7th/cmp-buffer"},
	{"hrsh7th/cmp-path"},
	{"saadparwaiz1/cmp_luasnip"},
	{"hrsh7th/cmp-nvim-lsp"},
	{"L3MON4D3/LuaSnip"},
	{"rafamadriz/friendly-snippets"},
	{ "bluz71/vim-moonfly-colors", name = "moonfly", lazy = false, priority = 1000 },
})

-- PLUGIN CONFIG


vim.cmd [[colorscheme moonfly]]
vim.g.moonflyVirtualTextColor = true
local lspconfig = require('lspconfig')
local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

lspconfig.lua_ls.setup({
	capabilities = lsp_capabilities,
})

lspconfig.pyright.setup({
	capabilities = lsp_capabilities,
})

lspconfig.rust_analyzer.setup({
	capabilities = lsp_capabilities,
})


local cmp = require('cmp')
local luasnip = require('luasnip')
local select_opts = {behavior = cmp.SelectBehavior.Select}

cmp.setup({
	snippet = {
  		expand = function(args)
    		luasnip.lsp_expand(args.body)
  		end
	},
	sources = {
  		{name = 'path'},
  		{name = 'nvim_lsp', keyword_length = 1},
  		{name = 'buffer', keyword_length = 3},
  		{name = 'luasnip', keyword_length = 2},
	},
	window = {
  		documentation = cmp.config.window.bordered()
	},
	formatting = {
  		fields = {'menu', 'abbr', 'kind'}
	},
	formatting = {
  		fields = {'menu', 'abbr', 'kind'},
  		format = function(entry, item)
    		local menu_icon = {
      			nvim_lsp = 'λ',
      			luasnip = '⋗',
      			buffer = 'Ω',
      			path = '🖫',
    		}

    		item.menu = menu_icon[entry.source.name]
    		return item
  		end,
	},
	mapping = {
  		['<CR>'] = cmp.mapping.confirm({select = false}),
		['<C-p>'] = cmp.mapping.select_prev_item(select_opts),
		['<C-n>'] = cmp.mapping.select_next_item(select_opts),
		['<C-e>'] = cmp.mapping.abort(),
		['<C-y>'] = cmp.mapping.confirm({select = true}),
		['<CR>'] = cmp.mapping.confirm({select = false}),
		['<Tab>'] = cmp.mapping(function(fallback)
  			local col = vim.fn.col('.') - 1

				if cmp.visible() then
					cmp.select_next_item(select_opts)
			  elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
					fallback()
			  else
					cmp.complete()
			  end
		end, {'i', 's'}),
	}
})

local sign = function(opts)
  vim.fn.sign_define(opts.name, {
    texthl = opts.name,
    text = opts.text,
    numhl = ''
  })
end


vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
  vim.lsp.handlers.hover,
  {border = 'rounded'}
)

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
  vim.lsp.handlers.signature_help,
  {border = 'rounded'}
)

require('nvim-treesitter.configs').setup({	
	  ensure_installed = { "c", "lua", "vim", "vimdoc", "typescript", "tsx","javascript", "json", "html", "css", "rust", "python" },
	  sync_install = false,
	  highlight = { enable = true },
	  indent = { enable = true },  
})

require('lualine').setup({
	options = {
		icons_enabled = true,
		component_separators = '|',
		section_separators = '',
		disabled_filetypes = {
			statusline = {'NvimTree'}
		}
	},
})

require('luasnip.loaders.from_vscode').lazy_load()


-- PLUGIN SPECIFIC KEYMAPS --

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function()
    local bufmap = function(mode, lhs, rhs)
      local opts = {buffer = true}
      vim.keymap.set(mode, lhs, rhs, opts)
    end

    -- Displays hover information about the symbol under the cursor
    bufmap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')

    -- Jump to the definition
    bufmap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')

    -- Jump to declaration
    bufmap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')

    -- Lists all the implementations for the symbol under the cursor
    bufmap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>')

    -- Jumps to the definition of the type symbol
    bufmap('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>')

    -- Lists all the references 
    bufmap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>')

    -- Displays a function's signature information
    bufmap('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>')

    -- Renames all references to the symbol under the cursor
    bufmap('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>')

    -- Selects a code action available at the current cursor position
    bufmap('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>')

    -- Show diagnostics in a floating window
    bufmap('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')

    -- Move to the previous diagnostic
    bufmap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')

    -- Move to the next diagnostic
    bufmap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')
  end
})
