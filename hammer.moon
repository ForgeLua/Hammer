#!/usr/bin/env moon

require "core.package"

if not Core.DotEnv.config()
    Core.Log.Fatal "Failed to load environment variables. Ensure you have a .env file in the current directory."
    return

command_line_interpreter = Core.CommandLineInterpreter!

-- Init command line (general init, git, trinity, etc.)
command_line_interpreter\RegisterCommand(
    "init-all"
    () ->
        current_directory = command_line_interpreter\GetCurrentDirectory!
        if not current_directory
            Core.Log.Error "Failed to get current directory. Ensure you are running this in a valid shell environment."
            return
        Core.Log.Info "Initializing Hammer in directory: #{current_directory}"

        -- Here install all trinitycore dependencies
        Core.Log.Info "Installing dependencies..."
        success, result = Core.OsExecute.Run("trinitycore install")
        
    "Initialize Hammer with the necessary configurations and repositories."
)






-- This is the main entry point for the Hammer command line tool.
-- It initializes the command line interpreter and runs it.
command_line_interpreter\Run(...)