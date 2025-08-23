-- ~/.nvim-nix/config/lua/core/colorscheme.lua

-- ~/.nvim-nix/config/lua/core/colorscheme.lua

-- Plugin specs
local plugins = {
	{
		"catppuccin/nvim",
		name = "catppuccin",
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
		end,
	},
	{
		"sainnhe/gruvbox-material",
		lazy = false,
		priority = 1000,
		config = function()
			vim.g.gruvbox_material_transparent_background = 2
		end,
	},

	{
		"luisiacc/gruvbox-baby",
		lazy = false, -- load on startup
		priority = 1000, -- load before other plugins
		config = function()
			-- Set transparent background BEFORE setting the colorscheme!
			vim.g.gruvbox_baby_transparent_mode = true
		end,
	},
	{
		"rose-pine/neovim",
		name = "rose-pine",
		config = function()
			require("rose-pine").setup({
				styles = {
					transparency = true,
				},
				disable_background = true,
			})
		end,
	},
}

-- === Persistence logic ===
local function save_colorscheme(name)
	-- Save the current colorscheme to a file (overwrites previous when switching colorscheme with telescope)
	local path = vim.fn.stdpath("config") .. "/colorscheme.tmp.lua"
	local file = io.open(path, "w")
	if file then
		file:write("vim.cmd([[colorscheme " .. name .. "]])\n")
		file:close()
	end
end

-- Save whenever :colorscheme is executed
vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function(args)
		save_colorscheme(args.match)
	end,
})

-- Apply saved scheme *after* Lazy has finished loading plugins
vim.api.nvim_create_autocmd("User", {
	pattern = "VeryLazy",
	callback = function()
		local colorscheme_config = vim.fn.stdpath("config") .. "/colorscheme.tmp.lua"
		if vim.fn.filereadable(colorscheme_config) == 1 then
			dofile(colorscheme_config)
		else
			-- fallback
			vim.cmd.colorscheme("catppuccin")
		end
	end,
})

return plugins
