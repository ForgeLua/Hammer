module "Core.Common", package.seeall
export DBCObject

class DBCObject
    new: (schema) =>
        @schema = schema
        @header = {
            signature: "WDBC"
            record_count: 0
            field_count: #schema
            record_size: #schema * 4
            string_block_size: 0
        }

        @schema.field_map = {}

        for i, field in ipairs(@schema)
            @schema.field_map[field.name] = i

        @records = {}

    CreateRecord: =>
        record = {
            _data: {}
        }

        mt = {
            _schema: @schema
            __index: (tbl, key) ->
                field_index = @schema.field_map[key]
                if field_index
                    return tbl._data[field_index]
                else
                    return rawget tbl, key
            __newindex: (tbl, key, value) ->
                field_index = @schema.field_map[key]
                if field_index
                    tbl._data[field_index] = value
                else
                    Core.Common.Logger\Error "Nop!"
        }

        setmetatable record, mt
        return record

    AddRecord: (record) =>
        table.insert @records, record 
        @header.record_count = #@records

    LoadFromString: (data) =>
        stream = Core.Utils.BinaryStream data
        signature = string.char unpack stream\ReadBytes 4

        if (signature != "WDBC")
            Core.Common.Logger\Error "Invalid signature: #{signature}"
        
        @header.record_count = stream\ReadUInt32!
        @header.field_count = stream\ReadUInt32!
        @header.record_size = stream\ReadUInt32!
        @header.string_block_size = stream\ReadUInt32!

        if (@header.field_count != #@schema)
            Core.Common.Logger.Warning "The number of fields in the file does not match the schema."

        records_end_pos = 20 + @header.record_count * @header.record_size
        string_block_data = data\sub records_end_pos + 1

        @records = {}
        stream.pos = 21

        for i = 1, @header.record_count
            record = @CreateRecord!
            for j = 1, @header.field_count
                field_def = @schema[j]
                field_pos = 20 + ((i - 1) * @header.record_size) + ((j - 1) * 4) + 1

                switch field_def and field_def.type
                    when "string"
                        stream.pos = field_pos
                        record[field_def.name] = stream\ReadString records_end_pos, string_block_data
                    when "int32"
                        stream.pos = field_pos
                        record[field_def.name] = stream\ReadInt32!
                    when "uint32"
                        stream.pos = field_pos
                        record[field_def.name] = stream\ReadUInt32!
                    when "float"
                        stream.pos = field_pos
                        record[field_def.name] = stream\ReadFloat!
                    else
                        stream.pos = field_pos
                        record[field_def.name] = stream\ReadUInt32!
            stream.pos = 20 + i * @header.record_size + 1
            @AddRecord record
        return @

    SaveToString: =>
        string_map = { [""]: 0 }
        string_list = { "" }
        current_offset = 1

        for record in *@records
            for field in *@schema
                if field.type == "string"
                    str = record[field.name] or ""
                    if string_map[str] == nil
                        string_map[str] = current_offset
                        table.insert string_list, str
                        current_offset += #str + 1

        string_block = (table.concat string_list, "\0") .. "\0"
        @header.string_block_size = #string_block

        stream = Core.Utils.BinaryStream!
        stream\WriteBytes { string.byte "WDBC", 1, -1 }
        stream\WriteUInt32 @header.record_count
        stream\WriteUInt32 @header.field_count
        stream\WriteUInt32 @header.record_size
        stream\WriteUInt32 @header.string_block_size

        for record in *@records
            for field in *@schema
                value = record[field.name]
                
                switch field.type
                    when "int32" then stream\WriteInt32 value or 0
                    when "float" then stream\WriteFloat value or 0
                    when "string" then stream\WriteUInt32 string_map[value or ""]
                    else stream\WriteUInt32 value or 0

        stream\WriteBytes { string.byte string_block }
        return stream\ToString!

    Load: (file_path) =>
        if not Core.Utils.FileExplorer\FileExists file_path
            Core.Common.Logger\Error "Unable to open file"
        content = Core.Utils.FileExplorer\ReadFile file_path

        return @LoadFromString content

    Save: (file_path) =>
        data = @SaveToString!
        if not Core.Utils.FileExplorer\WriteFile file_path, data
            Core.Common.Logger\Error "Unable to open file for write"
        Core.Common.Logger.Info "Write successfully"