local M = {}


CLI_COMMAND = "STM32_Programmer_CLI"

function M.setup(opts)
	if opts ~= nil then
		if opts.cli_path ~= nil then
			CLI_COMMAND = opts.cli_path
		end
	end

 	executable_exists = pcall(function() vim.system({CLI_COMMAND}, {text=true}):wait() end)

	if not executable_exists then
		error("Executable not found at path: " .. CLI_COMMAND .. ". Ensure binary exists at location and path is valid")

	end
end

function M.test()
	print(CLI_COMMAND)	
end



return M
