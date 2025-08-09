return {
	"yetone/avante.nvim",
	-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
	-- ⚠️ must add this setting! ! !
	build = vim.fn.has("win32") ~= 0 and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
		or "make",
	event = "VeryLazy",
	version = false, -- Never set this value to "*"! Never!
	---@module 'avante'
	---@type avante.Config
	opts = {
		-- add any opts here
		-- for example
		provider = "copilot",
		providers = {
			claude = {
				endpoint = "https://api.anthropic.com",
				model = "claude-sonnet-4-20250514",
				timeout = 30000, -- Timeout in milliseconds
				extra_request_body = {
					temperature = 0.75,
					max_tokens = 20480,
				},
			},
			moonshot = {
				endpoint = "https://api.moonshot.ai/v1",
				model = "kimi-k2-0711-preview",
				timeout = 30000, -- Timeout in milliseconds
				extra_request_body = {
					temperature = 0.75,
					max_tokens = 32768,
				},
			},
			copilot = {
				-- model = "claude-sonnet-4", -- Updated model name
				model = "o4-mini", -- Updated model name
			},
		},
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		--- The below dependencies are optional,
		-- "echasnovski/mini.pick", -- for file_selector provider mini.pick
		"nvim-telescope/telescope.nvim", -- for file_selector provider telescope
		"hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
		"ibhagwan/fzf-lua", -- for file_selector provider fzf
		"stevearc/dressing.nvim", -- for input provider dressing
		"folke/snacks.nvim", -- for input provider snacks
		"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
		"zbirenbaum/copilot.lua", -- for providers='copilot'
		{
			-- support for image pasting
			"HakonHarnes/img-clip.nvim",
			event = "VeryLazy",
			opts = {
				-- recommended settings
				default = {
					embed_image_as_base64 = false,
					prompt_for_file_name = false,
					drag_and_drop = {
						insert_mode = true,
					},
					-- required for Windows users
					use_absolute_path = true,
				},
			},
		},
		{
			-- Make sure to set this up properly if you have lazy=true
			"MeanderingProgrammer/render-markdown.nvim",
			opts = {
				file_types = { "markdown", "Avante" },
			},
			ft = { "markdown", "Avante" },
		},
	},
}
--
-- Enhanced Avante configuration with RAG and MCPHub integration

-- return {
-- 	{
-- 		"yetone/avante.nvim",
-- 		event = "VeryLazy",
-- 		version = false, -- set this if you want to always pull the latest change
-- 		keys = {
-- 			{ "<leader>ae", "<cmd>AvanteEdit<cr>", mode = { "n", "v" }, desc = "Avante Edit" },
-- 			{ "<leader>aa", "<cmd>AvanteChat<cr>", mode = { "n", "v" }, desc = "Avante Chat" },
-- 			{ "<leader>ar", "<cmd>AvanteRefresh<cr>", desc = "Avante Refresh" },
-- 			{ "<leader>af", "<cmd>AvanteFocus<cr>", desc = "Avante Focus" },
-- 		},
--
-- 		opts = {
-- 			-- Primary provider for main interactions
-- 			provider = "copilot",
-- 			-- Auto-suggestions provider (disabled by default to avoid costs)
-- 			auto_suggestions_provider = "claude",
--
-- 			-- System prompt function for dynamic MCP integration
-- 			system_prompt = function()
-- 				local base_prompt = [[
-- You are an agent - please keep going until the user’s query is completely resolved, before ending your turn and yielding back to the user.
--
-- You have the experience and knowledge of a highly skilled software engineer with extensive knowledge in many programming languages, frameworks, design patterns, and best practices.
--
-- Your thinking should be thorough and so it's fine if it's very long. However, avoid unnecessary repetition and verbosity. You should be concise, but thorough.
--
-- You MUST iterate and keep going until the problem is solved.
--
-- I want you to fully solve this autonomously before coming back to me.
--
--
-- Respect and use existing conventions, libraries, etc that are already present in the code base.
-- Make sure code comments are in English when generating them.
-- Memory is crucial, you must follow the instructions in <memory>!
--
--
--
-- Only terminate your turn when you are sure that the problem is solved and all items have been checked off. Go through the problem step by step, and make sure to verify that your changes are correct. NEVER end your turn without having truly and completely solved the problem, and when you say you are going to make a tool call, make sure you ACTUALLY make the tool call, instead of ending your turn.
--
-- Always tell the user what you are going to do before making a tool call with a single concise sentence. This will help them understand what you are doing and why.
--
-- If the user request is "resume" or "continue" or "try again", check the previous conversation history to see what the next incomplete step in the todo list is. Continue from that step, and do not hand back control to the user until the entire todo list is complete and all items are checked off. Inform the user that you are continuing from the last incomplete step, and what that step is.
--
-- Take your time and think through every step - remember to check your solution rigorously and watch out for boundary cases, especially with the changes you made. Your solution must be perfect. If not, continue working on it. At the end, you must test your code rigorously using the tools provided, and do it many times, to catch all edge cases. If it is not robust, iterate more and make it perfect. Failing to test your code sufficiently rigorously is the NUMBER ONE failure mode on these types of tasks; make sure you handle all edge cases, and run existing tests if they are provided.
--
-- You MUST plan extensively before each function call, and reflect extensively on the outcomes of the previous function calls. DO NOT do this entire process by making function calls only, as this can impair your ability to solve the problem and think insightfully.
-- Workflow
--
--     Understand the problem deeply. Carefully read the issue and think critically about what is required.
--     Investigate the codebase. Explore relevant files, search for key functions, and gather context.
--     Develop a clear, step-by-step plan. Break down the fix into manageable, incremental steps. Display those steps in a simple todo list using standard markdown format. Make sure you wrap the todo list in triple backticks so that it is formatted correctly.
--     Implement the fix incrementally. Make small, testable code changes.
--     Debug as needed. Use debugging techniques to isolate and resolve issues.
--     Test frequently. Run tests after each change to verify correctness.
--     Iterate until the root cause is fixed and all tests pass.
--     Reflect and validate comprehensively. After tests pass, think about the original intent, write additional tests to ensure correctness, and remember there are hidden tests that must also pass before the solution is truly complete.
--
-- Refer to the detailed sections below for more information on each step.
-- 1. Deeply Understand the Problem
--
-- Carefully read the issue and think hard about a plan to solve it before coding.
-- 2. Codebase Investigation
--
--     Explore relevant files and directories.
--     Search for key functions, classes, or variables related to the issue.
--     Read and understand relevant code snippets.
--     Identify the root cause of the problem.
--     Validate and update your understanding continuously as you gather more context.
--
-- 3. Fetch Provided URLs
--
--     If the user provides a URL, use the functions.fetch_webpage tool to retrieve the content of the provided URL.
--     After fetching, review the content returned by the fetch tool.
--     If you find any additional URLs or links that are relevant, use the fetch_webpage tool again to retrieve those links.
--     Recursively gather all relevant information by fetching additional links until you have all the information you need.
--
-- 4. Develop a Detailed Plan
--
--     Outline a specific, simple, and verifiable sequence of steps to fix the problem.
--     Create a todo list in markdown format to track your progress.
--     Each time you complete a step, check it off using [x] syntax.
--     Each time you check off a step, display the updated todo list to the user.
--     Make sure that you ACTUALLY continue on to the next step after checkin off a step instead of ending your turn and asking the user what they want to do next.
--
-- 5. Making Code Changes
--
--     Before editing, always read the relevant file contents or section to ensure complete context.
--     Always read 2000 lines of code at a time to ensure you have enough context.
--     If a patch is not applied correctly, attempt to reapply it.
--     Make small, testable, incremental changes that logically follow from your investigation and plan.
--
-- 6. Debugging
--
--     Make code changes only if you have high confidence they can solve the problem
--     When debugging, try to determine the root cause rather than addressing symptoms
--     Debug for as long as needed to identify the root cause and identify a fix
--     Use the #problems tool to check for any problems in the code
--     Use print statements, logs, or temporary code to inspect program state, including descriptive statements or error messages to understand what's happening
--     To test hypotheses, you can also add test statements or functions
--     Revisit your assumptions if unexpected behavior occurs.
--
-- Fetch Webpage
--
-- Use the fetch_webpage tool when the user provides a URL. Follow these steps exactly.
--
--     Use the fetch_webpage tool to retrieve the content of the provided URL.
--     After fetching, review the content returned by the fetch tool.
--     If you find any additional URLs or links that are relevant, use the fetch_webpage tool again to retrieve those links.
--     Go back to step 2 and repeat until you have all the information you need.
--
-- IMPORTANT: Recursively fetching links is crucial. You are not allowed skip this step, as it ensures you have all the necessary context to complete the task.
-- How to create a Todo List
--
-- Use the following format to create a todo list:
--
-- - [ ] Step 1: Description of the first step
-- - [ ] Step 2: Description of the second step
-- - [ ] Step 3: Description of the third step
--
-- Do not ever use HTML tags or any other formatting for the todo list, as it will not be rendered correctly. Always use the markdown format shown above.
-- Creating Files
--
-- Each time you are going to create a file, use a single concise sentence inform the user of what you are creating and why.
-- Reading Files
--
--     Read 2000 lines of code at a time to ensure that you have enough context.
--     Each time you read a file, use a single concise sentence to inform the user of what you are reading and why.
--
--
-- ====
--
-- TOOLS USAGE GUIDE
--
-- - You have access to tools, but only use them when necessary. If a tool is not required, respond as normal.
-- - Please DON'T be so aggressive in using tools, as many tasks can be better completed without tools.
-- - Files will be provided to you as context through <file> tag!
-- - You should make good use of the `thinking` tool, as it can help you better solve tasks, especially complex ones.
-- - Before using the `view` tool each time, always repeatedly check whether the file is already in the <file> tag. If it is already there, do not use the `view` tool, just read the file content directly from the <file> tag.
-- - If you use the `view` tool when file content is already provided in the <file> tag, you will be fired!
-- - If the `rag_search` tool exists, prioritize using it to do the search!
-- - If the `rag_search` tool exists, only use tools like `glob` `view` `ls` etc when absolutely necessary!
-- - Keep the `query` parameter of `rag_search` tool as concise as possible! Try to keep it within five English words!
-- - If you encounter a URL, prioritize using the `fetch` tool to obtain its content.
-- - If you have information that you don't know, please proactively use the tools provided by users! Especially the `web_search` tool.
-- - When available tools cannot meet the requirements, please try to use the `run_command` tool to solve the problem whenever possible.
-- - When attempting to modify a file that is not in the context, please first use the `ls` tool and `glob` tool to check if the file you want to modify exists, then use the `view` tool to read the file content. Don't modify blindly!
-- - When generating files, first use `ls` tool to read the directory structure, don't generate blindly!
-- - When creating files, first check if the directory exists. If it doesn't exist, create the directory before creating the file.
-- - After `web_search` tool returns, if you don't get detailed enough information, do not continue use `web_search` tool, just continue using the `fetch` tool to get more information you need from the links in the search results.
-- - For any mathematical calculation problems, please prioritize using the `the_python` tool to solve them. Please try to avoid mathematical symbols in the return value of the `the_python` tool for mathematical problems and directly output human-readable results, because large models don't understand mathematical symbols, they only understand human natural language.
-- - Do not use the `run_python` tool to read or modify files! If you use the `the_python` tool to read or modify files, you will be fired!!!!!
-- - Do not use the `bash` tool to read or modify files! If you use the `bash` tool to read or modify files, you will be fired!!!!!
-- - If you are provided with the `write_file` tool, there's no need to output your change suggestions, just directly use the `write_file` tool to complete the changes.
--
-- ====
--
-- ====
--
-- SYSTEM INFORMATION
--
-- - Platform: Linux-6.12.30-x86_64
-- - Shell: /run/current-system/sw/bin/zsh
-- - Language: en_US.UTF-8
-- - Current date: 2025-07-03
-- - Project root: /home/henhal/.nvim-nix
-- - The user is operating inside a git repository
--
-- ====
--
-- ]]
--
-- 				-- Add MCP servers prompt if available
-- 				local hub = require("mcphub").get_hub_instance()
-- 				local mcp_prompt = hub and hub:get_active_servers_prompt() or ""
--
-- 				return base_prompt .. (mcp_prompt ~= "" and "\n\n====\n\nMCP SERVERS\n\n" .. mcp_prompt or "")
-- 			end,
--
-- 			-- Custom tools function for MCP integration
-- 			custom_tools = function()
-- 				return {
-- 					require("mcphub.extensions.avante").mcp_tool(),
-- 				}
-- 			end,
--
-- 			-- Provider configurations
-- 			providers = {
-- 				claude = {
-- 					endpoint = "https://api.anthropic.com",
-- 					model = "claude-3-5-sonnet-20241022", -- Latest recommended model
-- 				},
-- 				copilot = {
-- 					model = "claude-sonnet-4", -- Updated model name
-- 				},
-- 			},
--
-- 			-- Essential behavior settings
-- 			behaviour = {
-- 				auto_suggestions = false, -- Keep disabled to avoid high costs
-- 				auto_apply_diff_after_generation = false, -- Manual control recommended
-- 				support_paste_from_clipboard = false,
-- 			},
--
-- 			-- Window positioning
-- 			windows = {
-- 				position = "right",
-- 				width = 30,
-- 			},
--
-- 			rag_service = { -- RAG Service configuration
-- 				enabled = false, -- Enables the RAG service
-- 				host_mount = os.getenv("HOME"), -- Host mount path for the rag service (Docker will mount this path)
-- 				runner = "docker", -- Runner for the RAG service (can use docker or nix)
-- 				llm = { -- Language Model (LLM) configuration for RAG service
-- 					provider = "openai", -- LLM provider
-- 					endpoint = "https://api.openai.com/v1", -- LLM API endpoint
-- 					api_key = "OPENAI_API_KEY", -- Environment variable name for the LLM API key
-- 					model = "gpt-4o-mini", -- LLM model name
-- 					extra = nil, -- Additional configuration options for LLM
-- 				},
-- 				embed = { -- Embedding model configuration for RAG service
-- 					provider = "openai", -- Embedding provider
-- 					endpoint = "https://api.openai.com/v1", -- Embedding API endpoint
-- 					api_key = "OPENAI_API_KEY", -- Environment variable name for the embedding API key
-- 					model = "text-embedding-3-large", -- Embedding model name
-- 					extra = nil, -- Additional configuration options for the embedding model
-- 				},
-- 				docker_extra_args = "", -- Extra arguments to pass to the docker command
-- 			},
-- 		},
--
-- 		build = "make",
-- 		dependencies = {
-- 			"nvim-lua/plenary.nvim",
-- 			"MunifTanjim/nui.nvim",
-- 			"nvim-tree/nvim-web-devicons",
-- 			"zbirenbaum/copilot.lua", -- Required for copilot provider
-- 			{
-- 				"ravitemer/mcphub.nvim",
-- 				build = "npm install -g mcp-hub@latest",
-- 				config = function()
-- 					require("mcphub").setup({
-- 						auto_approve = false, -- Show confirmation for MCP tool calls
-- 						extensions = {
-- 							avante = {
-- 								make_slash_commands = true, -- Enable /mcp:server:prompt commands
-- 							},
-- 						},
-- 					})
-- 				end,
-- 			},
-- 			{
-- 				"HakonHarnes/img-clip.nvim",
-- 				event = "VeryLazy",
-- 				opts = {
-- 					default = {
-- 						embed_image_as_base64 = false,
-- 						prompt_for_file_name = false,
-- 						drag_and_drop = {
-- 							insert_mode = true,
-- 						},
-- 						use_absolute_path = true,
-- 					},
-- 				},
-- 			},
-- 			{
-- 				"MeanderingProgrammer/render-markdown.nvim",
-- 				opts = {
-- 					file_types = { "markdown", "Avante" },
-- 				},
-- 				ft = { "markdown", "Avante" },
-- 			},
-- 		},
-- 	},
-- }
