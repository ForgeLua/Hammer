module "Core", package.seeall
export Log

Log = {
    Level: {
        DEBUG: 1
        INFO: 2
        WARN: 3
        ERROR: 4
        FATAL: 5
    }

    Color: {
        [1]: "\27[36m",  -- Cyan for DEBUG
        [2]: "\27[32m",  -- Green for INFO
        [3]: "\27[33m",  -- Yellow for WARN
        [4]: "\27[31m",  -- Red for ERROR
        [5]: "\27[35m"   -- Magenta for FATAL
    }
}

Log.Debug = (message) ->
    color = Log.Color[Log.Level.DEBUG]
    print "#{color}DEBUG:\27[0m #{message}"

Log.Info = (message) ->
    color = Log.Color[Log.Level.INFO]
    print "#{color}INFO:\27[0m #{message}"

Log.Warn = (message) ->
    color = Log.Color[Log.Level.WARN]
    print "#{color}WARN:\27[0m #{message}"

Log.Error = (message) ->
    color = Log.Color[Log.Level.ERROR]
    print "#{color}ERROR:\27[0m #{message}"

Log.Fatal = (message) ->
    color = Log.Color[Log.Level.FATAL]
    print "#{color}FATAL:\27[0m #{message}"