module("Core.Utils", package.seeall)
local lfs = require("lfs")
local date_format = "%Y-%m-%d_%H"
FileExplorer = {
  CreateDirectory = function(self, path)
    local success, err = lfs.mkdir(path)
    if not success and err ~= "File exists" then
      Core.Common.Logger.Error("Failed to create directory " .. tostring(path) .. ": " .. tostring(err))
      return false
    end
    return true
  end,
  GetMoonFiles = function(self, directory)
    local files = { }
    for file in lfs.dir(directory) do
      if file:match("%.moon$") then
        table.insert(files, file)
      end
    end
    return files
  end,
  GetBaseName = function(self, filename)
    return filename:match("^(.+)%.moon$" or filename)
  end,
  GenerateOutputName = function(self, input_filename)
    if input_filename then
      local base_name = self:GetBaseName(input_filename)
      return tostring(base_name) .. "_" .. tostring(os.date(date_format)) .. ".sql"
    else
      return "generated_" .. tostring(os.date(date_format)) .. ".sql"
    end
  end,
  FileExists = function(self, path)
    local file = io.open(path, "r")
    if file then
      file:close()
      return true
    end
    return false
  end,
  ReadFile = function(self, path)
    local file = io.open(path, "r")
    if file then
      local content = file:read("*a")
      file:close()
      return content
    end
    return nil
  end,
  WriteFile = function(self, path, data)
    local file = io.open(path, "wb")
    if file then
      file:write(data)
      file:close()
      return true
    end
    return false
  end
}
