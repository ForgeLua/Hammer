module("Core.Utils", package.seeall)
ScriptProcessor = {
  ProcessFile = function(self, filename)
    local input_path = "./workspace/inputs/" .. tostring(filename)
    local require_path = ("workspace.inputs." .. tostring(filename)):gsub(".moon", "")
    Core.Common.Logger:Info("Processing File " .. tostring(filename))
    if not (Core.Utils.FileExplorer:FileExists(input_path)) then
      Core.Common.Logger:Error("File not found: " .. tostring(input_path))
      return false
    end
    Core.Common.Database:Init(filename)
    local script = require(require_path)
    local output_path = Core.Common.Database:Flush()
    if output_path then
      Core.Common.Logger:Info("Successfully processed " .. tostring(filename) .. " -> " .. tostring(output_path))
      return true
    else
      return false
    end
  end,
  ProcessAllFiles = function(self)
    Core.Common.Logger:Info("Starting batch processing of all input files")
    if not (Core.Utils.FileExplorer:FileExists("./workspace/inputs")) then
      Core.Common.Logger:Error("Inputs directory not found: './workspace/inputs'")
      return false
    end
    local files = Core.Utils.FileExplorer:GetMoonFiles("./workspace/inputs")
    if #files == 0 then
      Core.Common.Logger:Warning("No .moon files found in './workspace/inputs'")
      return true
    end
    Core.Common.Logger:Info("Found " .. tostring(#files) .. " MoonScript files to process")
    local success_count = 0
    for _index_0 = 1, #files do
      local filename = files[_index_0]
      if self:ProcessFile(filename) then
        success_count = success_count + 1
      end
    end
    Core.Common.Logger:Info("Batch processing completed: " .. tostring(success_count) .. "/" .. tostring(#files) .. " files processed successfully")
    return success_count == #files
  end
}
