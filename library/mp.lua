---@meta
mp = mp

---@class mp.timer
---@field timeout number
---@field oneshot boolean
--- Disable the timer. Does nothing if already disabled.
---@field stop fun()
--- Disable the timer and reset elapsed time.
---@field kill fun()
--- Restart the timer.
---@field resume fun()
--- Whether the timer is currently enabled.
---@field is_enabled fun(): boolean

---@class mp.overlay
---@field data string
---@field format string
---@field id integer
---@field z integer
---@field w integer|nil
---@field h integer|nil
---@field ox integer
---@field oy integer
--- Commit the overlay to the screen.
---@field update fun(): table
--- Remove the overlay from the screen.
---@field remove fun()

---@class mp.hook
--- Defer the hook continuation.
---@field defer fun()
--- Continue the hook.
---@field cont fun()


return mp
