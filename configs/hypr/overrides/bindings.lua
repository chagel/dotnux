-- Personal window/workspace scheme, ported from the pre-Omarchy config in
-- Dotnux (configs/hypr/hyprland.lua).
--
-- hyprland.lua sets `omarchy_default_bindings = false`, which skips ALL of
-- Omarchy's default binding modules. Only tiling.lua is actually being
-- replaced, so the other four are pulled back in here.
local require_optional = require("default.hypr.require_optional")

require("default.hypr.bindings.media")
require("default.hypr.bindings.clipboard")
require("default.hypr.bindings.utilities")
require("default.hypr.bindings.voxtype")
require_optional.module("default.hypr.bindings.applications")

-- Keys the surviving modules still hold that this scheme wants back.
hl.unbind("SUPER + K")             -- was: keybindings cheatsheet (still in the menu)
hl.unbind("SUPER + SHIFT + comma") -- was: dismiss all notifications
hl.unbind("SUPER + SHIFT + SPACE") -- was: toggle top bar
hl.unbind("SUPER + SHIFT + M")     -- was: launch Spotify

local mainMod = "SUPER"

-- Second way into the Omarchy menu, on the key the old fuzzel launcher used.
-- SUPER+SPACE still opens it too.
o.bind(mainMod .. " + SHIFT + grave", "Omarchy menu", "omarchy-menu toggle")

-- The keybindings cheatsheet, displaced from SUPER+K by focus-up. CONTROL+
-- SHIFT+ALT is the hyper-style modifier the app launchers use.
o.bind("CONTROL + SHIFT + ALT + K", "Keybindings", "omarchy-menu-keybindings")

-- Lock on the same hyper modifier. utilities.lua keeps its SUPER+CTRL+L bind,
-- so both reach omarchy-system-lock.
o.bind("CONTROL + SHIFT + ALT + L", "Lock system", "omarchy-system-lock")

-- Screenshot likewise, alongside the PRINT bind utilities.lua still holds.
o.bind("CONTROL + SHIFT + ALT + S", "Screenshot", "omarchy-capture-screenshot")

-- Live en/zh dictionary (scripts/define). `tui` routes through
-- omarchy-launch-tui, so it opens in whatever terminal is default and gets the
-- org.omarchy.define app-id; `focus` raises the window if it is already open
-- rather than stacking another.
o.bind("CONTROL + SHIFT + ALT + D", "Define", { tui = "define", focus = true })

o.bind(mainMod .. " + Q", "Close window", hl.dsp.window.close())

-- Focus with mainMod + hjkl.
o.bind(mainMod .. " + H", "Focus left",  hl.dsp.focus({ direction = "l" }))
o.bind(mainMod .. " + L", "Focus right", hl.dsp.focus({ direction = "r" }))
o.bind(mainMod .. " + K", "Focus up",    hl.dsp.focus({ direction = "u" }))
o.bind(mainMod .. " + J", "Focus down",  hl.dsp.focus({ direction = "d" }))

-- Resize the active window.
o.bind(mainMod .. " + SHIFT + H", "Shrink window horizontally", hl.dsp.window.resize({ x = -50, y = 0,   relative = true }), { repeating = true })
o.bind(mainMod .. " + SHIFT + L", "Grow window horizontally",   hl.dsp.window.resize({ x = 50,  y = 0,   relative = true }), { repeating = true })
o.bind(mainMod .. " + SHIFT + J", "Grow window vertically",     hl.dsp.window.resize({ x = 0,   y = 50,  relative = true }), { repeating = true })
o.bind(mainMod .. " + SHIFT + K", "Shrink window vertically",   hl.dsp.window.resize({ x = 0,   y = -50, relative = true }), { repeating = true })

-- CONTROL switches workspace; mainMod forwards ALT+<digit> to the focused
-- window (the macOS CMD+[1-9] habit); mainMod+SHIFT moves the window.
for i = 1, 9 do
  o.bind(mainMod .. " + " .. i,         "Send ALT+" .. i .. " to window",   hl.dsp.send_shortcut({ mods = "ALT", key = tostring(i), window = "activewindow" }))
  o.bind(mainMod .. " + SHIFT + " .. i, "Move window to workspace " .. i,   hl.dsp.window.move({ workspace = i }))
  o.bind("CONTROL + " .. i,             "Switch to workspace " .. i,        hl.dsp.focus({ workspace = i }))
end

o.bind(mainMod .. " + 0",         "Toggle magic workspace",  hl.dsp.workspace.toggle_special("magic"))
o.bind(mainMod .. " + SHIFT + 0", "Move window to magic",    hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through workspaces with mainMod + wheel.
o.bind(mainMod .. " + mouse_down", "Next workspace",     hl.dsp.focus({ workspace = "e+1" }))
o.bind(mainMod .. " + mouse_up",   "Previous workspace", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize with mainMod + LMB/RMB drag.
o.bind(mainMod .. " + mouse:272", "Move window",   hl.dsp.window.drag(),   { mouse = true })
o.bind(mainMod .. " + mouse:273", "Resize window", hl.dsp.window.resize(), { mouse = true })

-- Move a window to the monitor left/right. Directions are geometric, so these
-- must match how the panels are actually laid out.
o.bind(mainMod .. " + SHIFT + comma",  "Move window to left monitor",  hl.dsp.window.move({ monitor = "l" }))
o.bind(mainMod .. " + SHIFT + period", "Move window to right monitor", hl.dsp.window.move({ monitor = "r" }))

-- Must match general:layout (dwindle). dwindle accepts only togglesplit,
-- swapsplit, movetoroot and preselect; master-only messages fail silently.
o.bind(mainMod .. " + SHIFT + SPACE",     "Swap split",   hl.dsp.layout("swapsplit"))
-- movetoroot was SUPER+SPACE before; that stays Omarchy's menu.
o.bind(mainMod .. " + SHIFT + backslash", "Move to root", hl.dsp.layout("movetoroot"))
-- preserve_split pins a split's orientation, so flipping side-by-side to
-- stacked has to be asked for explicitly. Was SUPER+V here and SUPER+J in
-- Omarchy; V is universal paste and J is focus-down, so it lands on SHIFT+V.
o.bind(mainMod .. " + SHIFT + V",         "Toggle split", hl.dsp.layout("togglesplit"))

-- Window manipulation.
o.bind(mainMod .. " + M",         "Full width",   hl.dsp.window.fullscreen({ mode = "maximized" }))
o.bind(mainMod .. " + SHIFT + M", "Full screen",  hl.dsp.window.fullscreen({ mode = "fullscreen" }))
o.bind(mainMod .. " + F",         "Toggle float", hl.dsp.window.float({ action = "toggle" }))

-- TAB and SHIFT+TAB cycle within the workspace. This used to be a fuzzel
-- picker over every workspace; Omarchy's own cycle is enough, and the menu
-- covers the picking.
o.bind(mainMod .. " + TAB",         "Focus next window",     hl.dsp.window.cycle_next())
o.bind(mainMod .. " + SHIFT + TAB", "Focus previous window", hl.dsp.window.cycle_next({ next = false }))
