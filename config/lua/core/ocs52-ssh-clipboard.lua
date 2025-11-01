return {
	"ojroques/nvim-osc52",
	config = function()
		local osc52 = require("osc52")

		-- Auto-copy any yanked text to clipboard
		vim.api.nvim_create_autocmd("TextYankPost", {
			callback = function()
				if vim.v.event.operator == "y" and vim.v.event.regname == "" then
					osc52.copy_register("")
				end
			end,
		})
	end,
}
