module("Core.Common", package.seeall)
do
  local _class_0
  local _base_0 = {
    CreateRecord = function(self)
      local record = {
        _data = { }
      }
      local mt = {
        _schema = self.schema,
        __index = function(tbl, key)
          local field_index = self.schema.field_map[key]
          if field_index then
            return tbl._data[field_index]
          else
            return rawget(tbl, key)
          end
        end,
        __newindex = function(tbl, key, value)
          local field_index = self.schema.field_map[key]
          if field_index then
            tbl._data[field_index] = value
          else
            return Core.Common.Logger:Error("Nop!")
          end
        end
      }
      setmetatable(record, mt)
      return record
    end,
    AddRecord = function(self, record)
      table.insert(self.records, record)
      self.header.record_count = #self.records
    end,
    LoadFromString = function(self, data)
      local stream = Core.Utils.BinaryStream(data)
      local signature = string.char(unpack(stream:ReadBytes(4)))
      if (signature ~= "WDBC") then
        Core.Common.Logger:Error("Invalid signature: " .. tostring(signature))
      end
      self.header.record_count = stream:ReadUInt32()
      self.header.field_count = stream:ReadUInt32()
      self.header.record_size = stream:ReadUInt32()
      self.header.string_block_size = stream:ReadUInt32()
      if (self.header.field_count ~= #self.schema) then
        Core.Common.Logger.Warning("The number of fields in the file does not match the schema.")
      end
      local records_end_pos = 20 + self.header.record_count * self.header.record_size
      local string_block_data = data:sub(records_end_pos + 1)
      self.records = { }
      stream.pos = 21
      for i = 1, self.header.record_count do
        local record = self:CreateRecord()
        for j = 1, self.header.field_count do
          local field_def = self.schema[j]
          local field_pos = 20 + ((i - 1) * self.header.record_size) + ((j - 1) * 4) + 1
          local _exp_0 = field_def and field_def.type
          if "string" == _exp_0 then
            stream.pos = field_pos
            record[field_def.name] = stream:ReadString(records_end_pos, string_block_data)
          elseif "int32" == _exp_0 then
            stream.pos = field_pos
            record[field_def.name] = stream:ReadInt32()
          elseif "uint32" == _exp_0 then
            stream.pos = field_pos
            record[field_def.name] = stream:ReadUInt32()
          elseif "float" == _exp_0 then
            stream.pos = field_pos
            record[field_def.name] = stream:ReadFloat()
          else
            stream.pos = field_pos
            record[field_def.name] = stream:ReadUInt32()
          end
        end
        stream.pos = 20 + i * self.header.record_size + 1
        self:AddRecord(record)
      end
      return self
    end,
    SaveToString = function(self)
      local string_map = {
        [""] = 0
      }
      local string_list = {
        ""
      }
      local current_offset = 1
      local _list_0 = self.records
      for _index_0 = 1, #_list_0 do
        local record = _list_0[_index_0]
        local _list_1 = self.schema
        for _index_1 = 1, #_list_1 do
          local field = _list_1[_index_1]
          if field.type == "string" then
            local str = record[field.name] or ""
            if string_map[str] == nil then
              string_map[str] = current_offset
              table.insert(string_list, str)
              current_offset = current_offset + #str + 1
            end
          end
        end
      end
      local string_block = (table.concat(string_list, "\0")) .. "\0"
      self.header.string_block_size = #string_block
      local stream = Core.Utils.BinaryStream()
      stream:WriteBytes({
        string.byte("WDBC", 1, -1)
      })
      stream:WriteUInt32(self.header.record_count)
      stream:WriteUInt32(self.header.field_count)
      stream:WriteUInt32(self.header.record_size)
      stream:WriteUInt32(self.header.string_block_size)
      local _list_1 = self.records
      for _index_0 = 1, #_list_1 do
        local record = _list_1[_index_0]
        local _list_2 = self.schema
        for _index_1 = 1, #_list_2 do
          local field = _list_2[_index_1]
          local value = record[field.name]
          local _exp_0 = field.type
          if "int32" == _exp_0 then
            stream:WriteInt32(value or 0)
          elseif "float" == _exp_0 then
            stream:WriteFloat(value or 0)
          elseif "string" == _exp_0 then
            stream:WriteUInt32(string_map[value or ""])
          else
            stream:WriteUInt32(value or 0)
          end
        end
      end
      stream:WriteBytes({
        string.byte(string_block)
      })
      return stream:ToString()
    end,
    Load = function(self, file_path)
      if not Core.Utils.FileExplorer:FileExists(file_path) then
        Core.Common.Logger:Error("Unable to open file")
      end
      local content = Core.Utils.FileExplorer:ReadFile(file_path)
      return self:LoadFromString(content)
    end,
    Save = function(self, file_path)
      local data = self:SaveToString()
      if not Core.Utils.FileExplorer:WriteFile(file_path, data) then
        Core.Common.Logger:Error("Unable to open file for write")
      end
      return Core.Common.Logger.Info("Write successfully")
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, schema)
      self.schema = schema
      self.header = {
        signature = "WDBC",
        record_count = 0,
        field_count = #schema,
        record_size = #schema * 4,
        string_block_size = 0
      }
      self.schema.field_map = { }
      for i, field in ipairs(self.schema) do
        self.schema.field_map[field.name] = i
      end
      self.records = { }
    end,
    __base = _base_0,
    __name = "DBCObject"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  DBCObject = _class_0
  return _class_0
end
