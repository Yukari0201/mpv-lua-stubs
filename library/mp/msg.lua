---@meta
msg = {}

-- The level parameter is the message priority. It\'s a string and one of
-- `fatal`, `error`, `warn`, `info`, `v`, `debug`, `trace`. The user\'s
-- settings will determine which of these messages will be visible.
-- Normally, all messages are visible, except `v`, `debug` and `trace`.
-- 
-- The parameters after that are all converted to strings. Spaces are
-- inserted to separate multiple parameters.
-- 
-- You don\'t need to add newlines.
-- 
---@param level any
function msg.log(level, ...) end

-- All of these are shortcuts and equivalent to the corresponding
function msg.fatal(...) end

-- 
---@param level any
function msg.log(level, ...) end


return msg
