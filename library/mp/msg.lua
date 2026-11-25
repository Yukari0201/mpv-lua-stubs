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
---@param level "fatal"|"error"|"warn"|"info"|"v"|"debug"|"trace"
function msg.log(level, ...) end

-- All of these are shortcuts and equivalent to the corresponding
---@param ... any
function msg.fatal(...) end

-- All of these are shortcuts and equivalent to the corresponding
---@param ... any
function msg.error(...) end

-- All of these are shortcuts and equivalent to the corresponding
---@param ... any
function msg.warn(...) end

-- All of these are shortcuts and equivalent to the corresponding
---@param ... any
function msg.info(...) end

-- All of these are shortcuts and equivalent to the corresponding
---@param ... any
function msg.verbose(...) end

-- All of these are shortcuts and equivalent to the corresponding
---@param ... any
function msg.debug(...) end

-- All of these are shortcuts and equivalent to the corresponding
---@param ... any
function msg.trace(...) end


return msg
