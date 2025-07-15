module "Core.Utils", package.seeall
export ScriptProcessor

ScriptProcessor = {
    ProcessFile: (filename) =>
        input_path = "./workspace/inputs/#{filename}"
        require_path = "workspace.inputs.#{filename}"\gsub(".moon", "")

        Core.Common.Logger\Info "Processing File #{filename}"

        unless Core.Utils.FileExplorer\FileExists input_path
            Core.Common.Logger\Error "File not found: #{input_path}"
            return false

        Core.Common.Database\Init filename

        script = require require_path
        output_path = Core.Common.Database\Flush!
        if output_path
            Core.Common.Logger\Info "Successfully processed #{filename} -> #{output_path}"
            return true
        else
            -- Core.Common.Logger\Error "Failed to generate SQL for #{filename}"
            return false

    ProcessAllFiles: =>
        Core.Common.Logger\Info "Starting batch processing of all input files"
        unless Core.Utils.FileExplorer\FileExists "./workspace/inputs"
            Core.Common.Logger\Error "Inputs directory not found: './workspace/inputs'"
            return false

        files = Core.Utils.FileExplorer\GetMoonFiles "./workspace/inputs"

        if #files == 0
            Core.Common.Logger\Warning "No .moon files found in './workspace/inputs'"
            return true

        Core.Common.Logger\Info "Found #{#files} MoonScript files to process"

        success_count = 0
        for filename in *files
            if @ProcessFile filename
                success_count += 1
        
        Core.Common.Logger\Info "Batch processing completed: #{success_count}/#{#files} files processed successfully"
        return success_count == #files
}