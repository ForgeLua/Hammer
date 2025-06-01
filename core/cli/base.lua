local Log = require("core.log.base")

local CommandLineInterpreter = {}
CommandLineInterpreter.__index = CommandLineInterpreter

function CommandLineInterpreter:new()
  local instance = setmetatable({}, CommandLineInterpreter)
  instance.commands = {
    help = {
      func = function() instance:DisplayHelp() end,
      description = "Display this help message",
      error_message = "Use 'help' to see available commands."
    },

    version = {
      func = function() Log.Info("Hammer CLI version 1.0.0") end,
      description = "Display the version of Hammer CLI",
      error_message = "Use 'version' to see the current version."
    }
  }
  return instance
end

function CommandLineInterpreter:GetCurrentDirectory()
    -- Method 1 (Linux and macOS): Using `pwd` command
    local success, handle = pcall(io.popen, "pwd 2>/dev/null")
    if success and handle then
        local path = handle:read("*a")
        local closeSuccess = pcall(handle.close, handle)
        if closeSuccess and path then
            path = path:match("^(.-)\n*$")
            if path and path ~= "" then
                return path
            end
        end
    end

    -- Method 2 (Windows): Using `cd` command
    success, handle = pcall(io.popen, "cd 2>nul")
    if success and handle then
        local path = handle:read("*a")
        local closeSuccess = pcall(handle.close, handle)
        if closeSuccess and path then
            path = path:match("^(.-)\n*$")
            if path and path ~= "" then
                return path
            end
        end
    end

    Log.Warn("Failed to get current directory. Ensure you are running this in a valid shell environment.")
    return nil
end

function CommandLineInterpreter:RegisterCommand(name, func, description, error_message)
    self.commands[name] = {
        func = func,
        description = description or "No description available",
        error_message = error_message or "An error occurred while executing the command."
    }
end

function CommandLineInterpreter:DisplayHelp()
    Log.Info("Usage: ./hammer <command> [options]")
    Log.Info("Available commands:")
    for name, command in pairs(self.commands) do
        Log.Info(string.format("  %s: %s", name, command.error_message or "No description available"))
    end
end

function CommandLineInterpreter:Dispatch(args)
    if (not args or #args == 0) then
        self:DisplayHelp()
        return
    end

    local command_name = args[1]
    local command = self.commands[command_name]
    if (not command) then
        Log.Error("Unknown command: " .. command_name)
        self:DisplayHelp()
        return
    end

    local command_args = { table.unpack(args, 2) }
    local success, result = pcall(command.func, self, table.unpack(command_args))
    if not success then
        Log.Error("Error executing command '" .. command_name .. "': " .. result .. "\n" .. command.error_message)
        self:DisplayHelp()
        return
    end
end

function CommandLineInterpreter:Run(args)
    if (not args or #args == 0) then
        self:DisplayHelp()
        return
    end

    self:Dispatch(args)
end

return CommandLineInterpreter