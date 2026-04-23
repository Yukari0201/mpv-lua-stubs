---@meta
input = {}

-- Show the console to let the user enter text.
-- 
-- The following entries of `table` are read:
-- 
-- `prompt`  
-- The string to be displayed before the input field.
-- 
-- `submit`  
-- A callback invoked when the user presses Enter. The first argument is
-- the text in the console.
-- 
-- `keep_open`  
-- Whether to keep the console open on submit. Defaults to `false`.
-- 
-- `opened`  
-- A callback invoked when the console is shown. This can be used to
-- present a list of options with `input.set_log()`.
-- 
-- `edited`  
-- A callback invoked when the text changes. The first argument is the text
-- in the console.
-- 
-- `complete`  
-- A callback invoked when the user edits the text or moves the cursor. The
-- first argument is the text before the cursor. The callback should return
-- a table of the string candidate completion values and the 1-based cursor
-- position from which the completion starts. console will show the
-- completions that fuzzily match the text between this position and the
-- cursor and allow selecting them.
-- 
-- The third and optional return value is a string that will be appended to
-- the input line without displaying it in the completions.
-- 
-- `autoselect_completion`  
-- Whether to automatically select the first completion on submit if one
-- wasn\'t already manually selected. Defaults to `false`.
-- 
-- `closed`  
-- A callback invoked when the console is hidden, either because
---@param table any
function input.get(table) end

-- user closed it with a key binding. The first argument is the text in the
-- console, and the second argument is the cursor position.
-- 
-- `default_text`  
-- A string to pre-fill the input field with.
-- 
-- `cursor_position`  
-- The initial cursor position, starting from 1.
-- 
-- `history_path`  
-- If specified, the path to save and load the history of the entered
-- lines.
-- 
-- `id`  
-- An identifier that determines which input history and log buffer to use
-- among the ones stored for `input.get()` calls. Defaults to the calling
-- script name with `prompt` appended.
-- 
function input.terminate() end

-- Close the console.
-- 
function input.terminate() end

-- Add a line to the log buffer. `style` can contain additional ASS tags to
-- apply to `message`, and `terminal_style` can contain escape sequences
-- that are used when the console is displayed in the terminal.
-- 
---@param message any
---@param style any
---@param terminal_style any
function input.log(message, style, terminal_style) end

-- Helper to add a line to the log buffer with the same color as the one
-- used for commands that error. Useful when the user submits invalid
-- input.
-- 
---@param message any
function input.log_error(message) end

-- Replace the entire log buffer.
-- 
-- `log` is a table of strings, or tables with `text`, `style` and
-- `terminal_style` keys.
-- 
-- Example:
-- 
-- ```
-- input.set_log({
--     "regular text",
--     {
--         text = "error text",
--         style = "{\\c&H7a77f2&}",
--         terminal_style = "\027[31m",
--     }
-- })
-- ```
-- 
---@param log any
function input.set_log(log) end

-- Specify a list of items that are presented to the user for selection.
-- 
-- The following entries of `table` are read:
-- 
-- `prompt`  
-- The string to be displayed before the input field.
-- 
-- `items`  
-- The table of the entries to choose from.
-- 
-- `default_item`  
-- The 1-based integer index of the preselected item.
-- 
-- `submit`  
-- The callback invoked when the user presses Enter. The first argument is
-- the 1-based index of the selected item.
-- 
-- `keep_open`  
-- Whether to keep the console open on submit. Defaults to `false`.
-- 
-- Example:
-- 
-- > ```
-- > input.select({
-- >     items = {
-- >         "First playlist entry",
-- >         "Second playlist entry",
-- >     },
-- >     submit = function (id)
-- >         mp.commandv("playlist-play-index", id - 1)
-- >     end,
-- > })
-- > ```
-- 
---@param table any
function input.select(table) end


return input
