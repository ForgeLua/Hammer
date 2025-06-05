module "Core", package.seeall
export CommandLineInterpreter

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
                    Core.Log.Info "Hammer CLI version 1.0.0"
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

        Core.Log.Warn "Failed to get current directory. Ensure you are running this in a valid shell environment."
        return nil

    RegisterCommand: (name, func, description = "No description available", error_message = "An error occurred while executing the command.") =>
        @commands[name] = {
            func: func
            description: description
            error_message: error_message
        }

    DisplayHelp: () =>
        Core.Log.Info "Usage: ./hammer <command> [options]"
        Core.Log.Info "Available commands:"
        for name, command in pairs(@commands)
            Core.Log.Info "#{name}: #{command.error_message}"

    Dispatch: (args) =>
        if (not args or #args == 0)
            return @DisplayHelp!

        command = @commands[args]
        if (not command)
            Core.Log.Error "Unknown command: #{args}"
            return @DisplayHelp!

        success, result = pcall command.func, args
        if (not success)
            Core.Log.Error "Error executing command '#{args}': #{result}\n #{command.error_message}"
            return @DisplayHelp!

    Run: (args) =>
        if (not args or #args == 0)
            return @DisplayHelp!
        @Dispatch args