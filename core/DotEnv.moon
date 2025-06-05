module "Core", package.seeall
export DotEnv

DotEnv = {}

-- Internal state
cache = {}
original_getenv = os.getenv
configured = false

-- Enhanced getenv that checks cache first,  system environment
---@param key string
---@return string|nil
getenv_override = (key) ->
    return cache[key] or original_getenv(key)

-- Check if line is a comment or empty line
---@param line string
---@return boolean
skip_line = (line) ->
    return line\match("^%s*[#;]") or line\match("^%s*$")

-- Remove leading and trailing whitespace
---@param str string
---@return string
trim = (str) ->
    return str\match("^%s*(.-)%s*$")

-- Remove surrounding quotes from value
---@param value string
---@return string
unquote = (value) ->
    return value\match('^"(.*)"$') or value\match("^'(.*)'$") or value

-- Process escape sequences in environment variable values
---@param value string
---@return string
unescape = (value) ->
    return value\gsub("\\(.)", {
        n: "\n", r: "\r", t: "\t", ["\\"]: "\\", ['"']: '"', ["'"]: "'"
    })

-- Parse a single line from .env file
---@param line string
---@return string|nil, string|nil
parse_line = (line) ->
    key, value = line\match("^([^=]+)=(.*)$")
    if not key  return nil, nil 
    
    key = trim(key)
    if key == ""
        return nil, nil 
    
    value = unescape(unquote(trim(value or "")))
    return key, value

-- Load environment variables from file
---@param path string?
---@return boolean success, string? error_message
DotEnv.load = (path) ->
    path = path or ".env"
    
    file, err = io.open(path, "r")
    if not file
        return false, "Cannot open file\ " .. tostring(err)
    
    for line in file\lines()
        if not skip_line(line)
            key, value = parse_line(line)
            if key != nil
                cache[key] = value
  
    file\close()
    return true

-- Configure DotEnv (load file and override os.getenv)
---@param path string?
DotEnv.config = (path) ->
    if configured 
        return 
    
    ok, err = DotEnv.load(path)
    return false unless ok 
    
    _G.os.getenv = getenv_override
    configured = true
    return true

-- Get environment variable value
---@param key string
---@return string|nil
DotEnv.get = (key) ->
    return cache[key]


-- Set environment variable value
---@param key string
---@param value string|number
DotEnv.set = (key, value) ->
    cache[key] = tostring(value)

-- Get all cached environment variables
---@return table<string, string>
DotEnv.all = () ->
    result = {}
    for k, v in pairs(cache) do
        result[k] = v
    
    return result

-- Clear all cached variables
DotEnv.clear = () ->
    cache = {}

-- Reset DotEnv to initial state
DotEnv.reset = () ->
    cache = {}
    _G.os.getenv = original_getenv
    configured = false