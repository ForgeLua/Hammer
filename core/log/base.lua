-- Colored logging for Lua (without oop)
local Log = {
    Levels = {
        DEBUG = 1,
        INFO = 2,
        WARN = 3,
        ERROR = 4,
        FATAL = 5
    },

    Colors = {
        [1] = "\27[36m",  -- Cyan for DEBUG
        [2] = "\27[32m",  -- Green for INFO
        [3] = "\27[33m",  -- Yellow for WARN
        [4] = "\27[31m",  -- Red for ERROR
        [5] = "\27[35m"   -- Magenta for FATAL
    }
}

function Log.Debug(message)
    local color = Log.Colors[Log.Levels.DEBUG]
    print(string.format("%sDEBUG:\27[0m %s", color, message))
end

function Log.Info(message)
    local color = Log.Colors[Log.Levels.INFO]
    print(string.format("%sINFO:\27[0m %s", color, message))
end

function Log.Warn(message)
    local color = Log.Colors[Log.Levels.WARN]
    print(string.format("%sWARN:\27[0m %s", color, message))
end

function Log.Error(message)
    local color = Log.Colors[Log.Levels.ERROR]
    print(string.format("%sERROR:\27[0m %s", color, message))
end

function Log.Fatal(message)
    local color = Log.Colors[Log.Levels.FATAL]
    print(string.format("%sFATAL:\27[0m %s", color, message))
end

return Log