#!/usr/bin/env moon

require "core.package"

Helper = require "core.os.helper"

if not Core.DotEnv.config()
    Core.Log.Fatal "Failed to load environment variables. Ensure you have a .env file in the current directory."
    return

command_line_interpreter = Core.CommandLineInterpreter!

-- Init command line (general init, git, trinity, etc.)
command_line_interpreter\RegisterCommand(
    "init-all"
    () ->
        -- SYSTEM ID CHECK
        system_id = Core.OsExecute.GetSystemId!
        if not system_id
            Core.Log.Error "Failed to determine the system ID. Ensure you are running this in a valid shell environment."
            return
        
        Core.Log.Info "Detected system ID: #{system_id}"
        
        -- COMMANDS AND PACKAGES
        commands = Helper.COMMAND[string.upper(system_id)]
        packages = Helper.PACKAGE[string.upper(system_id)]
        if not commands or not packages
            Core.Log.Error "Unsupported system ID: #{system_id}. Please check the supported systems in the documentation."
            return
        
        -- DIRECTORY CHECK
        current_directory = command_line_interpreter\GetCurrentDirectory!
        if not current_directory
            Core.Log.Error "Failed to get current directory. Ensure you are running this in a valid shell environment."
            return
        Core.Log.Info "Initializing Hammer in directory: #{current_directory}"
        
        -- GIT CHECK AND INSTALLATION
        success, result = Core.OsExecute.Run("git --version")
        if not success
            Core.Log.Error "Git is not installed. Please install Git to continue."
            Core.Log.Info "Do you want to install Git? (y/n)"
            if io.read!\lower! == "y"
                success, result = Core.OsExecute.Run(commands.INSTALL .. "git")
                if not success
                    Core.Log.Error "Failed to install Git: #{result}"
                    return
            else
                Core.Log.Info "Git installation skipped. Exiting."
                return
        
        -- GIT REPOSITORY INITIALIZATION
        success, result = Core.OsExecute.Run("git submodule update --init --recursive")
        if not success
            Core.Log.Error "Failed to initialize trinitycore repository: #{result}"
            return
        Core.Log.Info "Hammer submodules initialized successfully."
        
        -- DEPENDENCIES INSTALLATION
        Core.Log.Info "Installing dependencies..."

        success, result = Core.OsExecute.Run(commands.INSTALL .. table.concat(packages, " "))
        if not success
            Core.Log.Error "Failed to install dependencies: #{result}"
            return
        Core.Log.Info "Dependencies installed successfully."     
    "Initialize Hammer with the necessary configurations and repositories."
)






-- This is the main entry point for the Hammer command line tool.
-- It initializes the command line interpreter and runs it.
command_line_interpreter\Run(...)