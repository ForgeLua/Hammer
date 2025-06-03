-- local Helper = require("core.os.helper")
-- local OsExecute = {}

-- function OsExecute.GetSystemId()
--     local os_release_file = io.open("/etc/os-release", "r")
--     if (not os_release_file) then
--         return nil
--     end

--     local os_info = os_release_file:read("*all")
--     os_release_file:close()
--     return os_info:match("ID_LIKE=\"?(%w+)\"?")
-- end

-- function OsExecute.Run(command)
--     local success, result = pcall(os.execute, command)
--     return success and result
-- end

-- function OsExecute.GetRootDirectory()
--     local handle
--     if package.config:sub(1,1) == '\\' then
--         -- Windows
--         handle = io.popen("cd")
--     else
--         -- Unix/Linux/MacOS
--         handle = io.popen("pwd")
--     end
    
--     if handle then
--         local result = handle:read("*a")
--         handle:close()

--         result = result:gsub("[\r\n]+$", "")
--         return result
--     end
--     return nil
-- end

-- function OsExecute.GoToDirectory(directory)
--     local success, results = pcall(os.execute, string.format(Helper.COMMAND.UNIVERSAL.CD, directory))
--     return success, result
-- end

-- function OsExecute.ExecuteInDirectory(directory, command)
--     if not directory or not command then
--         return false, "Paramètres manquants"
--     end
    
--     local combined_cmd
--     if package.config:sub(1,1) == '\\' then
--         combined_cmd = string.format('cd /d "%s" && %s', directory, command)
--     else
--         combined_cmd = string.format('cd "%s" && %s', directory, command)
--     end
    
--     local success, result = pcall(os.execute, combined_cmd)
--     return success, result
-- end

-- return OsExecute