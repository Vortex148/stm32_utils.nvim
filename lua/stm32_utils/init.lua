local M = {}

-- Base command. Used for debugging, flashing, etc.
CLI_COMMAND = "STM32_Programmer_CLI"

function M.setup(opts)
	if opts ~= nil then
		if opts.cli_path ~= nil then
			CLI_COMMAND = opts.cli_path
		end
	end

	-- Checks if user has STM32_Programmer_CLI installed via calling the command and checking the result.
 	executable_exists = pcall(function() vim.system({CLI_COMMAND}, {text=true}):wait() end)

	if not executable_exists then
		error("Executable not found at path: " .. CLI_COMMAND .. ". Ensure binary exists at location and path is valid")

	end

	-- Register all user commands.
	RegisterCommands()
end


function RegisterCommands()
	-- All user commands follow the format of "S32<DESCRIPTION>"
	vim.api.nvim_create_user_command('S32ListDevices', function() M.get_targets_uart() end, {})
end


-- Only gets uart targets
function M.get_targets_uart()
	COLON_OFFSET_FOR_VALUE = 2

	local target_query = vim.system({CLI_COMMAND, "-l"}, {text=true}):wait()
	local targets_text = target_query.stdout

	-- Find and extract UART segment from query via find command, store index in "start_index"
	local start_index = string.find(targets_text,"UART Interface")
	targets_text = string.sub(targets_text, start_index, string.len(targets_text))
	targets_text = string.gsub(targets_text, "\27%[%d+;?%d*m", "")	

	-- Extract detected targets through splitting. STM32_Programmer_CLI uses double newlines to denote new blocks of information
	targets = {}
	for i in string.gmatch(targets_text, "(.-)\n\n") do
		table.insert(targets, i)
	end

	-- Remove heading data, only keep detected targets
	table.remove(targets, 1)
	table.remove(targets, 1)

	for index, value in ipairs(targets) do 
		print(value)
		print("-------")
	end

end

return M
