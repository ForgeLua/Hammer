module "Core.Utils", package.seeall
export BinaryStream

class BinaryStream
    new: (data) =>
        @data = {}

        if data and #data > 0
            for i = 1, #data
                @data[i] = data\byte i
        
        @pos = 1
        return @
    
    -- Read Methods
    ReadBytes: (count) =>
        if @pos + count > #@data + 1
            Core.Common.Logger\Error "Attempting to read beyond the end of the stream"
        
        chunk = {}
        for i = 0, count - 1
            table.insert chunk, @data[@pos + i]
        
        @pos = @pos + count
        return chunk

    ReadUInt32: =>
        a, b, c, d = table.unpack(@ReadBytes(4))
        return a + b * 256 + c * 256 ^ 2 + d * 256 ^ 3

    ReadInt32: =>
        val = @ReadUInt32!
        return val >= 2 ^ 31 and val - 2 ^ 32 or val

    ReadFloat: =>
        a, b, c, d = table.unpack(@ReadBytes(4))
        sign = (d >= 128) and -1 or 1
        exp = (d % 128) * 2 + math.floor(c / 128)
        mant = a + b * 256 + (c % 128) * 65536

        if exp == 255
            return mant == 0 and (sign * math.huge) or (0/0)
        elseif exp == 0
            if mant == 0
                return 0.0 * sign
            return sign * (mant / (2 ^ 23)) * (2 ^ (exp - 127))
        
        return sign * (1 + mant / (2 ^ 23)) * (2 ^ (exp - 127))

    ReadString: (string_block_start, string_block_data) =>
        offset = @ReadUInt32!
        if offset == 0
            return ""
        
        str_start = offset + 1
        str_end = string_block_data\find "\0", str_start
        if str_end
            return string_block_data\sub str_start, str_end - 1
        return string_block_data\sub str_start
    
    -- Write Methods
    WriteBytes: (bytes) =>
        for i = 1, #bytes
            @data[@pos + i - 1] = bytes[i]
        @pos = @pos + #bytes
        
        return @

    WriteUInt32: (value) =>
        @WriteBytes {
            value % 256
            math.floor(value / 256) % 256
            math.floor(value / 65536) % 256
            math.floor(value / 16777216) % 256
        }
        
        return @

    WriteInt32: (value) =>
        if value < 0
            value = value + 2 ^ 32
        @WriteUInt32 value
        
        return @
    
    WriteFloat: (value) =>
        -- Todo: Add WriteFloat method
    
    ToString: =>
        return string.char(table.unpack(@data))
    