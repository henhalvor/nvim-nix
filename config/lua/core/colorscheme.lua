return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	opts = {
		flavour = "macchiato",
		background = {
			light = "macchiato",
			dark = "macchiato",
		},
		transparent_background = true,
		integrations = {
			cmp = true,
			treesitter = true,
			telescope = true,
			noice = true,
			notify = true,
			which_key = true,
			fidget = true,
		},
	},
	config = function(_, opts)
		require("catppuccin").setup(opts)
		vim.cmd.colorscheme("catppuccin")
	end,
}

-- return {
-- 	"sainnhe/gruvbox-material",
-- 	lazy = false,
-- 	priority = 1000,
-- 	config = function()
-- 		vim.g.gruvbox_material_transparent_background = 2 -- or 2 for more transparency
-- 		vim.cmd.colorscheme("gruvbox-material")
-- 	end,
-- }

-- return {
-- 	"luisiacc/gruvbox-baby",
-- 	lazy = false, -- load on startup
-- 	priority = 1000, -- load before other plugins
-- 	config = function()
-- 		-- Set transparent background BEFORE setting the colorscheme!
-- 		vim.g.gruvbox_baby_transparent_mode = true
-- 		vim.cmd("colorscheme gruvbox-baby")
-- 	end,
-- }

-- lua/plugins/rose-pine.lua
-- return {
-- 	"rose-pine/neovim",
-- 	name = "rose-pine",
-- 	config = function()
-- 		require("rose-pine").setup({
-- 			styles = {
-- 				transparency = true,
-- 			},
-- 			disable_background = true,
-- 		})
--
-- 		vim.cmd("colorscheme rose-pine")
-- 	end,
-- }

-- return {
-- 	"ribru17/bamboo.nvim",
-- 	lazy = false,
-- 	priority = 1000,
-- 	config = function()
-- 		require("bamboo").setup({
-- 			-- optional configuration here
-- 			-- Main options --
-- 			-- NOTE: to use the light theme, set `vim.o.background = 'light'`
-- 			style = "vulgaris", -- Choose between 'vulgaris' (regular), 'multiplex' (greener), and 'light'
-- 			toggle_style_key = nil, -- Keybind to toggle theme style. Leave it nil to disable it, or set it to a string, e.g. "<leader>ts"
-- 			toggle_style_list = { "vulgaris", "multiplex", "light" }, -- List of styles to toggle between
-- 			transparent = true, -- Show/hide background
-- 			dim_inactive = false, -- Dim inactive windows/buffers
-- 			term_colors = true, -- Change terminal color as per the selected theme style
-- 			ending_tildes = false, -- Show the end-of-buffer tildes. By default they are hidden
-- 			cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu
--
-- 			-- Change code style ---
-- 			-- Options are anything that can be passed to the `vim.api.nvim_set_hl` table
-- 			-- You can also configure styles with a string, e.g. keywords = 'italic,bold'
-- 			code_style = {
-- 				comments = { italic = true },
-- 				conditionals = { italic = true },
-- 				keywords = {},
-- 				functions = {},
-- 				namespaces = { italic = true },
-- 				parameters = { italic = true },
-- 				strings = {},
-- 				variables = {},
-- 			},
--
-- 			-- Lualine options --
-- 			lualine = {
-- 				transparent = false, -- lualine center bar transparency
-- 			},
--
-- 			-- Custom Highlights --
-- 			colors = {}, -- Override default colors
-- 			highlights = {}, -- Override highlight groups
--
-- 			-- Plugins Config --
-- 			diagnostics = {
-- 				darker = false, -- darker colors for diagnostic
-- 				undercurl = true, -- use undercurl instead of underline for diagnostics
-- 				background = true, -- use background color for virtual text
-- 			},
-- 		})
-- 		require("bamboo").load()
-- 	end,
-- }
