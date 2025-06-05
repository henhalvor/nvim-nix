return {
	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"github/copilot.vim",
		},
		enabled = true,
		opts = {
			adapters = {
				copilot = function()
					return require("codecompanion.adapters").extend("copilot", {
						schema = {
							model = {
								-- default = "gemini-2.5-pro",
								default = "claude-4-sonnet",
							},
						},
						-- formatted_name = "Gemini 2.5 Pro", -- Add this line
						formatted_name = "Claude 4 Sonnet", -- Add this line
					})
				end,
			},

			display = {
				chat = {
					intro_message = "Welcome to CodeCompanion ✨! Press ? for options",
					show_header_separator = true, -- Show header separators in the chat buffer? Set this to false if you're using an external markdown formatting plugin
					auto_scroll = true,
					-- show_settings = true, -- This displays the model being used
					show_token_count = true, -- Show token usage
					show_references = true, -- Show references from slash commands
					token_count = function(tokens, adapter)
						return string.format("%s (%d tokens)", adapter.formatted_name, tokens)
					end,
					separator = "─",
					window = {
						layout = "vertical",
						border = "rounded", -- Better looking border
						height = 0.8,
						width = 0.45,
					},
					roles = {
						-- In roles.llm (line 48)
						llm = function(adapter)
							local model = adapter.formatted_model or adapter.formatted_name
							return "CodeCompanion----- (" .. model .. ")"
						end,
						user = "henhalvor",
					},
				},
			},
			strategies = {
				chat = {
					adapter = "copilot",
					roles = {
						---The header name for the LLM's messages
						---@type string|fun(adapter: CodeCompanion.Adapter): string
						llm = function(adapter)
							-- return string.format("🤖 %s ", adapter.formatted_name) -- More descriptive
							return string.format("🤖 - LLM") -- Simplified for cleaner display
						end,

						---The header name for your messages
						---@type string
						user = "👤 - henhalvor",
					},
					opts = {
						completion_provider = "blink", -- blink|cmp|coc|default
					},
					keymaps = {
						close = {
							modes = {
								n = "q",
							},
							index = 3,
							callback = "keymaps.close",
							description = "Close Chat",
						},
						stop = {
							modes = {
								n = "<C-c>",
							},
							index = 4,
							callback = "keymaps.stop",
							description = "Stop Request",
						},
					},
				},
			},
			inline = {
				adapter = "copilot",
			},
			-- 🔥 Crucial: Register MCP Extension in `opts`
			extensions = {
				mcphub = {
					callback = "mcphub.extensions.codecompanion",
					opts = {
						show_result_in_chat = true,
						make_vars = true,
						make_slash_commands = true, -- Enables `/` slash commands
						auto_register_servers = true, -- Automatically register servers from MCP Hub
					},
				},
			},
		},

		keys = {
			{
				"<leader>ac",
				"<cmd>CodeCompanionActions<cr>",
				mode = { "n", "v" },
				noremap = true,
				silent = true,
				desc = "CodeCompanion actions",
			},
			{
				"<leader>aa",
				"<cmd>CodeCompanionChat Toggle<cr>",
				mode = { "n", "v" },
				noremap = true,
				silent = true,
				desc = "CodeCompanion chat",
			},
			{
				"<leader>ad",
				"<cmd>CodeCompanionChat Add<cr>",
				mode = "v",
				noremap = true,
				silent = true,
				desc = "CodeCompanion add to chat",
			},
		},
		-- config = function()
		-- 	require("codecompanion").setup({
		-- 		extensions = {
		-- 			mcphub = {
		-- 				callback = "mcphub.extensions.codecompanion",
		-- 				opts = {
		-- 					show_result_in_chat = true, -- Show mcp tool results in chat
		-- 					make_vars = true, -- Convert resources to #variables
		-- 					make_slash_commands = true, -- Add prompts as /slash commands
		-- 				},
		-- 			},
		-- 		},
		-- 	})
		-- end,
	},

	--
	-- Markdown rendering
	--
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = { "markdown", "codecompanion" },
	},

	--
	-- AutoComplete
	--
	{
		"saghen/blink.cmp",
		dependencies = { "olimorris/codecompanion.nvim", "saghen/blink.compat" },
		event = "InsertEnter",
		opts = {
			enabled = function()
				return vim.bo.buftype ~= "prompt" and vim.b.completion ~= false
			end,
			completion = {
				accept = {
					auto_brackets = {
						kind_resolution = {
							blocked_filetypes = { "typescriptreact", "javascriptreact", "vue", "codecompanion" },
						},
					},
				},
			},
			sources = {
				per_filetype = {
					codecompanion = { "codecompanion" },
				},
			},
		},
	},

	--
	-- MCP Hub
	--
	{
		"ravitemer/mcphub.nvim",
		build = "npm install -g mcp-hub@latest",
		config = function()
			require("mcphub").setup()
		end,
	},
}
