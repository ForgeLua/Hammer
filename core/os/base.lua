local OsExecute = {}

function OsExecute.GetSystemId()
    local os_release_file = io.open("/etc/os-release", "r")
    if (not os_release_file) then
        return nil
    end


    local os_info = os_release_file:read("*all")
    os_release_file:close()
    return os_info:match("ID_LIKE=\"?(%w+)\"?")
end

function OsExecute.Run(command)
    local success, result = pcall(os.execute, command)
    return success and result
end

return OsExecute