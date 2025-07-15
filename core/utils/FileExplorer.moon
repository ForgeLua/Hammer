module "Core.Utils", package.seeall
export FileExplorer

lfs = require "lfs"

date_format = "%Y-%m-%d_%H"

FileExplorer = {
    CreateDirectory: (path) =>
        success, err = lfs.mkdir path
        if not success and err != "File exists"
            Core.Common.Logger.Error "Failed to create directory #{path}: #{err}"
            return false
        return true

    GetMoonFiles: (directory) =>
        files = {}
        for file in lfs.dir directory
            if file\match "%.moon$"
                table.insert files, file

        return files

    GetBaseName: (filename) =>
        filename\match "^(.+)%.moon$" or filename

    GenerateOutputName: (input_filename) =>
        if input_filename
            base_name = @GetBaseName input_filename
            return "#{base_name}_#{os.date date_format}.sql"
        else
            return "generated_#{os.date date_format}.sql"

    FileExists: (path) =>
        file = io.open path, "r"
        if file
            file\close!
            return true
        return false

    ReadFile: (path) =>
        file = io.open path, "r"
        if file
            content = file\read "*a"
            file\close!
            return content
        return nil

    WriteFile: (path, data) =>
        file = io.open path, "wb"
        if file
            file\write(data)
            file\close!
            return true
        return false
}