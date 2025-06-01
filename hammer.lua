#!/usr/bin/env lua

local CommandLineInterpreter = require("core.cli.base")
local cli = CommandLineInterpreter:new()

cli:RegisterCommand("init", function()
    print('ok')
end, "Install all dependencies and set up the project structure.", "Use 'init' to initialize the project.")

cli:Run(arg or {})