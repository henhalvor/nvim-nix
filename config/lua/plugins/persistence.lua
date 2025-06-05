return {
	"folke/persistence.nvim",
	event = "VimEnter", -- this will only start session saving when an actual file was opened
	opts = {
		-- add any custom options here
		--  dir = vim.fn.stdpath("state") .. "/sessions/", -- directory where session files are saved
		-- minimum number of file buffers that need to be open to save
		-- Set to 0 to always save
		need = 1,
		branch = true, -- use git branch to save session
	},
	config = function(_, opts)

		-- Auto-load session on startup
		vim.api.nvim_create_autocmd("VimEnter", {
			group = vim.api.nvim_create_augroup("restore_session", { clear = true }),
			callback = function()
				-- Check if we should auto-load session
				local should_load = false

				if vim.fn.argc() == 0 then
					-- No arguments passed (nvim)
					should_load = true
				elseif vim.fn.argc() == 1 then
					-- Check if the single argument is current directory
					local arg = vim.fn.argv(0)
					if arg == "." or arg == vim.fn.getcwd() then
						should_load = true
					end
				end

				if should_load and vim.fn.getcwd() ~= vim.env.HOME then
					require("persistence").load()
				end
			end,
			nested = true,
		})

		require("persistence").setup(opts)
		-- load the session for the current directory
		vim.keymap.set("n", "<leader>qs", function()
			require("persistence").load()
		end, { desc = "Persistence load session for current directory" })

		-- select a session to load
		vim.keymap.set("n", "<leader>qS", function()
			require("persistence").select()
		end, { desc = "Persistence [S]elect" })

		-- load the last session
		vim.keymap.set("n", "<leader>ql", function()
			require("persistence").load({ last = true })
		end, { desc = "Persistence [L]oad last session" })

		-- stop Persistence => session won't be saved on exit
		vim.keymap.set("n", "<leader>qd", function()
			require("persistence").stop()
		end, { desc = "Persistence Stop" })
	end,
}
