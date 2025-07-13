module "Core.Common", package.seeall
export Logger

Color = {
    [1]: "\27[36m",  -- Cyan for DEBUG
    [2]: "\27[32m",  -- Green for INFO
    [3]: "\27[33m",  -- Yellow for WARN
    [4]: "\27[31m",  -- Red for ERROR
    [5]: "\27[35m"   -- Magenta for FATAL
}

Level = {
    DEBUG: 1
    INFO: 2
    WARN: 3
    ERROR: 4
    FATAL: 5
}

Logger = {
    Debug: (message) =>
        color = Color[Level.DEBUG]
        print "#{color}DEBUG:\27[0m #{message}"
    Info: (message) =>
        color = Color[Level.INFO]
        print "#{color}INFO:\27[0m #{message}"
    Warning: (message) =>
        color = Color[Level.WARN]
        print "#{color}WARN:\27[0m #{message}"
    Error: (message) =>
        color = Color[Level.ERROR]
        print "#{color}ERROR:\27[0m #{message}"
    Fatal: (message) =>
        color = Color[Level.FATAL]
        print "#{color}FATAL:\27[0m #{message}"
}