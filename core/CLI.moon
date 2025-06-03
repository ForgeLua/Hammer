module "Core", package.seeall
export CommandLineInterpreter

Log = require "core.log.base"

class CommandLineInterpreter
    new: =>
        @commands = {
            help: {
                func: () ->
                    @DisplayHelp!
                description: "Display Help message"
                error_message: "Use 'help' to see available commands."
            }

            version: {
                func: () ->
                    Log.Info "Hammer CLI version 1.0.0"
                description: "Display the version of Hammer CLI"
                error_message: "Use 'version' to see the current version"
            }
        }

    GetCurrentDirectory: () =>
        success, handle = pcall io.popen, "pwd 2>/dev/null"
        if (success and handle)
            path = handle\read "*a"
            close_success = pcall handle.close, handle
            if (close_success and path)
                path = path\match "^(.-)\n*$"
                if (path and path ~= "")
                    return path

        Log.Warn "Failed to get current directory. Ensure you are running this in a valid shell environment."
        return nil

    RegisterCommand: (name, func, description = "No description available", error_message = "An error occurred while executing the command.") =>
        @command[name] = {
            func: func
            description: description
            error_message: error_message
        }

    DisplayHelp: () =>
        Log.Info "Usage: ./hammer <command> [options]"
        Log.Info "Available commands:"
        for name, command in pairs(@commands)
            Log.Info "#{name}: #{command.error_message}"

    Dispatch: (args) =>
        return @DisplayHelp! unless args or #args == 0

        command_name = args[1]
        command = @commands[command_name]
        if (not command)
            Log.Error "Unknown command: #{command_name}"
            return @DisplayHelp!

        command_args = { table.unpack(args, 2) }
        success, result = pcall command.func, args, table.unpack(command_args)
        if (not success)
            Log.Error "Error executing command '#{command_name}': #{result}\n #{command.error_message}"
            return @DisplayHelp!

    Run: (args) =>
        return @DisplayHelp! unless args or #args == 0
        @Dispatch args