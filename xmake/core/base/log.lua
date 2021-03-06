--!A cross-platform build utility based on Lua
--
-- Licensed to the Apache Software Foundation (ASF) under one
-- or more contributor license agreements.  See the NOTICE file
-- distributed with this work for additional information
-- regarding copyright ownership.  The ASF licenses this file
-- to you under the Apache License, Version 2.0 (the
-- "License"); you may not use this file except in compliance
-- with the License.  You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
-- 
-- Copyright (C) 2015 - 2017, TBOOX Open Source Group.
--o
-- @author      ruki
-- @file        log.lua
--

-- define module: log
local log = log or {}

-- get the log file
function log.file()

    -- get the output file 
    if log._FILE == nil then
        local outputfile = log.outputfile()
        if outputfile then

            -- get directory
            local i = outputfile:find_last("[/\\]")
            if i then
                if i > 1 then i = i - 1 end
                dir = outputfile:sub(1, i)
            else
                dir = "."
            end

            -- ensure the directory
            if not os.isdir(dir) then
                os.mkdir(dir) 
            end

            -- open the log file
            log._FILE = io.open(outputfile, 'w+')
        end
        log._FILE = log._FILE or false
    end
    return log._FILE
end

-- get the output file
function log.outputfile()
    if log._LOGFILE == nil then
        log._LOGFILE = os.getenv("XMAKE_LOGFILE") or false
    end
    return log._LOGFILE
end

-- flush log to file
function log.flush()
    local file = log.file()
    if file then
        io.flush(file)
    end
end

-- close the log file
function log.close()
    local file = log.file()
    if file then
        file:close()
    end
end

-- print log to the log file
function log.print(...)
    local file = log.file()
    if file then
        file:write(string.format(...) .. "\n")
    end
end

-- print variables to the log file
function log.printv(...)
    local file = log.file()
    if file then
        local values = {...}
        for i, v in ipairs(values) do
            -- dump basic type
            if type(v) == "string" or type(v) == "boolean" or type(v) == "number" then
                file:write(tostring(v))
            else
                file:write("<" .. tostring(v) .. ">")
            end
            if i ~= #values then
                file:write(" ")
            end
        end
        file:write('\n')
    end
end

-- printf log to the log file
function log.printf(...)
    local file = log.file()
    if file then
        file:write(string.format(...))
    end
end

-- write log the log file
function log:write(...)
    local file = log.file()
    if file then
        file:write(...)
    end
end

-- return module: log
return log
