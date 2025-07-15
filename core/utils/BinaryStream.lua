module("Core.Utils", package.seeall)
do
  local _class_0
  local _base_0 = {
    ReadBytes = function(self, count)
      if self.pos + count > #self.data + 1 then
        Core.Common.Logger:Error("Attempting to read beyond the end of the stream")
      end
      local chunk = { }
      for i = 0, count - 1 do
        table.insert(chunk, self.data[self.pos + i])
      end
      self.pos = self.pos + count
      return chunk
    end,
    ReadUInt32 = function(self)
      local a, b, c, d = unpack(self:ReadBytes(4))
      return a + b * 256 + c * 256 ^ 2 + d * 256 ^ 3
    end,
    ReadInt32 = function(self)
      local val = self:ReadUInt32()
      return val >= 2 ^ 31 and val - 2 ^ 32 or val
    end,
    ReadFloat = function(self)
      local a, b, c, d = unpack(self:ReadBytes(4))
      local sign = (d >= 128) and -1 or 1
      local exp = (d % 128) * 2 + math.floor(c / 128)
      local mant = a + b * 256 + (c % 128) * 65536
      if exp == 255 then
        return mant == 0 and (sign * math.huge) or (0 / 0)
      elseif exp == 0 then
        if mant == 0 then
          return 0.0 * sign
        end
        return sign * (mant / (2 ^ 23)) * (2 ^ (exp - 127))
      end
      return sign * (1 + mant / (2 ^ 23)) * (2 ^ (exp - 127))
    end,
    ReadString = function(self, string_block_start, string_block_data)
      local offset = self:ReadUInt32()
      if offset == 0 then
        return ""
      end
      local str_start = offset + 1
      local str_end = string_block_data:find("\0", str_start)
      if str_end then
        return string_block_data:sub(str_start, str_end - 1)
      end
      return string_block_data:sub(str_start)
    end,
    WriteBytes = function(self, bytes)
      for i = 1, #bytes do
        self.data[self.pos + i - 1] = bytes[i]
      end
      self.pos = self.pos + #bytes
      return self
    end,
    WriteUInt32 = function(self, value)
      self:WriteBytes({
        value % 256,
        math.floor(value / 256) % 256,
        math.floor(value / 65536) % 256,
        math.floor(value / 16777216) % 256
      })
      return self
    end,
    WriteInt32 = function(self, value)
      if value < 0 then
        value = value + (2 ^ 32)
      end
      self:WriteUInt32(value)
      return self
    end,
    WriteFloat = function(self, value) end,
    ToString = function(self)
      local CHUNK_SIZE = 4096
      local parts = { }
      local data_len = #self.data
      for i = 1, data_len, CHUNK_SIZE do
        local j = math.min(i + CHUNK_SIZE - 1, data_len)
        local chunk_str = string.char(unpack(self.data, i, j))
        table.insert(parts, chunk_str)
      end
      return table.concat(parts)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, data)
      self.data = { }
      if data and #data > 0 then
        for i = 1, #data do
          self.data[i] = data:byte(i)
        end
      end
      self.pos = 1
    end,
    __base = _base_0,
    __name = "BinaryStream"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  BinaryStream = _class_0
  return _class_0
end
