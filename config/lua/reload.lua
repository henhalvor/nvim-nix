local M = {}

function M.reload_config()
	local timer = vim.loop.new_timer()
	local initial_time = vim.loop.hrtime()

	vim.notify("🚀 Reloading Neovim configuration...", vim.log.levels.INFO, { title = "Config Reload" })

	-- Patterns for Lua modules to clear from cache.
	-- Based on your lazy.nvim setup: { import = "core" }, { import = "plugins" }
	local patterns_to_clear = {
		"^core", -- Matches modules like 'core' or 'core.utils' (will also match 'core.reload' itself)
		"^plugins", -- Matches modules like 'plugins' or 'plugins.lsp'
		-- Add other patterns here if you create other top-level Lua directories
		-- e.g., "^myutils", if you have lua/myutils/*.lua
	}

	for key, _ in pairs(package.loaded) do
		for _, pattern in ipairs(patterns_to_clear) do
			if string.match(key, pattern) then
				package.loaded[key] = nil
				-- vim.notify("Cleared from cache: " .. key, vim.log.levels.DEBUG) -- Optional: for debugging
				break -- Module cleared, move to next item in package.loaded
			end
		end
	end

	-- Re-source the main configuration file
	local mrv = vim.env.MYVIMRC
	local config_file_sourced_successfully = false

	local function try_source_config(file_path, is_lua)
		local cmd = is_lua and "luafile " or "source "
		local success, err = pcall(vim.cmd, cmd .. file_path)
		if success then
			config_file_sourced_successfully = true
		else
			vim.notify(
				"🚨 Error sourcing " .. file_path .. ": " .. tostring(err),
				vim.log.levels.ERROR,
				{ title = "Config Reload" }
			)
		end
	end

	if mrv and mrv ~= "" and vim.fn.filereadable(mrv) == 1 then
		try_source_config(mrv, string.sub(mrv, -4) == ".lua")
	else
		local fallback_init_lua = vim.fn.stdpath("config") .. "/init.lua"
		if vim.fn.filereadable(fallback_init_lua) == 1 then
			vim.notify(
				"MYVIMRC not found or invalid, trying fallback: " .. fallback_init_lua,
				vim.log.levels.WARN,
				{ title = "Config Reload" }
			)
			try_source_config(fallback_init_lua, true)
		else
			vim.notify(
				"🚨 Could not find MYVIMRC or default init.lua to reload.",
				vim.log.levels.ERROR,
				{ title = "Config Reload" }
			)
			timer:start(0, 0, function() -- Ensure timer cleanup and final notification
				vim.loop.timer_stop(timer)
				local elapsed_ms = (vim.loop.hrtime() - initial_time) / 1000000
				vim.notify(
					"🔥 Config reload failed (config file not found) in " .. string.format("%.2f", elapsed_ms) .. "ms",
					vim.log.levels.ERROR,
					{ title = "Config Reload" }
				)
			end)
			return
		end
	end

	-- If main config sourcing was successful, optionally sync lazy.nvim
	if config_file_sourced_successfully and package.loaded["lazy"] then
		local lazy_ok, lazy = pcall(require, "lazy")
		if lazy_ok and lazy.sync then
			vim.notify("🔄 Syncing lazy.nvim plugins...", vim.log.levels.INFO, { title = "Config Reload" })
			pcall(lazy.sync) -- errors in lazy.sync will be caught by pcall
		end
	end

	timer:start(0, 0, function()
		vim.loop.timer_stop(timer)
		local elapsed_ms = (vim.loop.hrtime() - initial_time) / 1000000
		if config_file_sourced_successfully then
			vim.notify(
				"🎉 Neovim configuration reloaded successfully in " .. string.format("%.2f", elapsed_ms) .. "ms",
				vim.log.levels.INFO,
				{ title = "Config Reload" }
			)
		else
			vim.notify(
				"🔥 Config reload finished with errors in " .. string.format("%.2f", elapsed_ms) .. "ms",
				vim.log.levels.WARN,
				{ title = "Config Reload" }
			)
		end
	end)
end

return M
