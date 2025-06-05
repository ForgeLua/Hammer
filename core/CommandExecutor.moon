module "Core", package.seeall
export OsExecute

Helper = require "core.os.helper"

OsExecute = {}

OsExecute.GetSystemId = ->
    os_release_file = os.open "/etc/os-release", "r"
    return nil unless os_release_file

    os_info = os_release_file\read "*all"
    os_release_file\close!

    return os_info\match "ID_LIKE=\"?(%w+)\"?"

OsExecute.Run = (command) ->
    if (not command or command == "")
        return false, "Command is empty"

    success, result = pcall(os.execute, command)
    if not success
        return false, result

    return true, result

OsExecute.GetRootDirectory = ->
    handle = nil
    if package.config\sub(1, 1) == '\\'
        -- Windows
        handle = io.popen("cd")
    else
        -- Unix/Linux/MacOS
        handle = io.popen("pwd")

    if handle
        result = handle\read "*a"
        handle:close()

        result = result\gsub("[\r\n]+$", "")
        return result

    return nil

OsExecute.GoToDirectory = (directory) ->
    if not directory or directory == ""
        return false, "Directory not specified or not exists"

    if package.config\sub(1, 1) == '\\'
        -- Windows
        command = string.format('cd /d "%s"', directory)
    else
        -- Unix/Linux/MacOS
        command = string.format('cd "%s"', directory)

    success, result = pcall(os.execute, command)
    if not success
        return false, result

    return true, result

OsExecute.ExecuteInDirectory = (directory, command) ->
    if not directory or not command or directory == "" or command == ""
        return false, "Missing parameters"

    if package.config\sub(1, 1) == '\\'
        -- Windows
        combined_cmd = string.format('cd /d "%s" && %s', directory, command)
    else
        -- Unix/Linux/MacOS
        combined_cmd = string.format('cd "%s" && %s', directory, command)

    success, result = pcall(os.execute, combined_cmd)
    if not success
        return false, result

    return true, result