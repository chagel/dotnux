-- Personal input overrides. Uncommented settings replace Omarchy's defaults.
-- See https://wiki.hypr.land/Configuring/Basics/Variables/#input

-- Caps Lock is Ctrl. This drops Omarchy's default compose:caps, so Caps is no
-- longer the Compose key -- fcitx5/rime is what types anything that needed it.
-- Both Shifts together still give a real Caps Lock, one Shift turns it back off.
hl.config({
  input = {
    kb_options = "ctrl:nocaps,shift:both_capslock_cancel",
  },
})

-- Three-finger swipe changes tag, dwm style. Hyprland's own action = "workspace"
-- walks one pool shared by every monitor, which is the thing hypr/workspace-tags
-- .lua exists to undo, so the step is computed here instead. The widget lays its
-- tags out in blocks of STRIDE per monitor, so the block a workspace belongs to
-- follows from its id alone -- no need to know which monitor owns which block.
-- Both numbers are the Workspace Tags settings: keep them in step with the panel.
local TAGS = 9
local STRIDE = 10

local function step(delta)
  local workspace = hl.get_active_workspace()
  if not workspace then
    return
  end

  local base = math.floor((workspace.id - 1) / STRIDE) * STRIDE
  local tag = workspace.id - base
  if tag < 1 or tag > TAGS then
    tag = 1
  end

  hl.dispatch(hl.dsp.focus({ workspace = tostring(base + ((tag - 1 + delta) % TAGS) + 1) }))
end

-- Swipe left for the tag on the right, the way macOS moves between spaces.
hl.gesture({ fingers = 3, direction = "left", action = function() step(1) end })
hl.gesture({ fingers = 3, direction = "right", action = function() step(-1) end })

-- Swipe up for the window tree, Mission Control's half of the same habit. It is
-- a shell overlay rather than a dispatcher, which is what o.bind wraps a string
-- command in -- a gesture takes a function, so the wrap is written out here.
-- The same picker is on SUPER + slash in hypr/bindings.lua.
hl.gesture({
  fingers = 3,
  direction = "up",
  action = function()
    hl.dispatch(hl.dsp.exec_cmd("omarchy-shell shell toggle chagel.window-tree"))
  end,
})
