module "Core.Common", package.seeall
export DBCObject

DBCRecord = {
    __index: (table, key) ->
        schema = getmetatable(table)._schema
        field_index = schema.field_map[key]

        if field_index
            return table._data[field_index]
        return nil
    
    __newindex: (table, key, value) ->
        schema = getmetatable(table)._schema
        field_index = schema.field_map[key]

        if field_index
            table._data[field_index] = value
        else
            Core.Common.Logger.Error "The field '#{tostring(key)}' does not exist in the DBC schema."
}

class DBCObject
    new: (schema) =>
        @header = {
            signature: "WDBC"
            record_count: 0
            field_count: #schema
            record_size: 0
            string_block_size: 0
        }

        @schema = schema
        @schema.field_map = {}

        for i, field in ipairs(@schema)
            @schema.field_map[field.name] = i
            @header.record_size = @header.record_size + 4

        @records = {}

    CreateRecord: =>
        record = { 
            _data: {} 
        }

        setmetatable record, {
            __index: DBCRecord.__index,
            __newindex: DBCRecord.__newindex,
            _schema: @schema 
        }

        return record

    AddRecord: (record) =>
        table.insert @records, record 
        @header.record_count = #@records

    LoadFromString: (data) =>
        stream = Core.Utils.BinaryStream data
        signature = string.char(table.unpack(stream\ReadBytes(4)))

        if (signature != "WDBC")
            Core.Common.Logger\Error "Invalid signature: #{signature}"
        
        @header.record_count = stream\ReadUInt32!
        @header.field_count = stream\ReadUInt32!
        @header.record_size = stream\ReadUInt32!
        @header.string_block_size = stream\ReadUInt32!

        if (@header.field_count != #@schema)
            Core.Common.Logger.Warning "The number of fields in the file does not match the schema."

        records_end_pos = 20 + @header.record_count * @header.record_size
        string_block_start = records_end_pos
        string_block_data = data\sub(string_block_start + 1)

        @records = {}
        stream.pos = 21

        for i = 1, @header.record_count
            record = @CreateRecord!
            for j = 1, @header.field_count
                field_type = @schema[j] and @schema[j].type or "uint32"

                if field_type == "int32"
                    record._data[j] = stream\ReadInt32!
                elseif field_type == "uint32"
                    record._data[j] = stream\ReadUInt32!
                elseif field_type == "float"
                    record._data[j] = stream\ReadFloat!
                elseif field_type == "string"
                    record._data[j] = stream\ReadString string_block_start, string_block_data
                else
                    stream\ReadUInt32!

            @AddRecord record
        return @

    SaveToString: =>
        string_map = { [""]: 0 }
        string_list = { "" }
        current_offset = 1

        for _, record in ipairs @records
            for i, field in ipairs @schema
                if field.type == "string"
                    str = record._data[i] or ""
                    if string_map[str] == nil
                        string_map[str] = current_offset
                        table.insert string_list, str
                        current_offset = current_offset + #str + 1

        string_block = table.concat(string_list, "\0") .. "\0"
        @header.string_block_size = #string_block

        stream = Core.Utils.BinaryStream!
        stream\WriteBytes { string.byte "WDBC", 1, 4 }
        stream\WriteUInt32 @header.record_count
        stream\WriteUInt32 @header.field_count
        stream\WriteUInt32 @header.record_size
        stream\WriteUInt32 @header.string_block_size

        for _, record in ipairs @records
            for i, field in ipairs @schema
                value = record._data[i]
                
                if field.type == "int32"
                    stream\WriteInt32 value or 0
                elseif field.type == "uint32"
                    stream\WriteUInt32 value or 0
                elseif field.type == "float"
                    stream\WriteFloat value or 0
                elseif field.type == "string"
                    stream\WriteUInt32 string_map[value or ""]

        stream\WriteBytes { string.byte string_block, 1, -1 }
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