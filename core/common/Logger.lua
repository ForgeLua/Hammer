module("Core.Common", package.seeall)
local Color = {
  [1] = "\27[36m",
  [2] = "\27[32m",
  [3] = "\27[33m",
  [4] = "\27[31m",
  [5] = "\27[35m"
}
local Level = {
  DEBUG = 1,
  INFO = 2,
  WARN = 3,
  ERROR = 4,
  FATAL = 5
}
Logger = {
  Debug = function(self, message)
    local color = Color[Level.DEBUG]
    return print(tostring(color) .. "DEBUG:\27[0m " .. tostring(message))
  end,
  Info = function(self, message)
    local color = Color[Level.INFO]
    return print(tostring(color) .. "INFO:\27[0m " .. tostring(message))
  end,
  Warning = function(self, message)
    local color = Color[Level.WARN]
    return print(tostring(color) .. "WARN:\27[0m " .. tostring(message))
  end,
  Error = function(self, message)
    local color = Color[Level.ERROR]
    return error(tostring(color) .. "ERROR:\27[0m " .. tostring(message))
  end,
  Fatal = function(self, message)
    local color = Color[Level.FATAL]
    return error(tostring(color) .. "FATAL:\27[0m " .. tostring(message))
  end
}
