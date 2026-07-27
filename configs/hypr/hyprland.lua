-- Hyprland config. See https://wiki.hypr.land/Configuring/Start/
-- Migrated from hyprland.conf (hyprlang) — hyprlang is deprecated since 0.55.

------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({ output = "eDP-1", mode = "2560x1440@60", position = "0x0",    scale = 1.25 })
hl.monitor({ output = "DP-2",  mode = "highres",      position = "0x-2560", scale = 1, transform = 3 })

-- local main_monitor = "desc:Dell Inc. DELL S3422DWG BF60T63"
-- hl.monitor({ output = main_monitor, mode = "3440x1440@60", position = "0x-1440", scale = 1 })
-- hl.monitor({ output = "eDP-1", mode = "1920x1080@60", position = "0x0", scale = 1 })

-- local monitor_left  = "DP-4"
-- local monitor_right = "DP-2"
-- hl.monitor({ output = monitor_left,  mode = "highres", position = "0x0",     scale = 1 })
-- hl.monitor({ output = monitor_right, mode = "highres", position = "3840x-600", scale = 1, transform = 1 })
-- hl.monitor({ output = "eDP-1", disabled = true })


---------------------
---- MY PROGRAMS ----
---------------------

local terminal    = "ghostty"
local browser     = "google-chrome-stable --force-device-scale-factor=1.2"
local bar         = "waybar"
local fileManager = "nautilus"


-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/
hl.on("hyprland.start", function()
    hl.exec_cmd("fcitx5 -d")
    hl.exec_cmd("hyprsleep")
    hl.exec_cmd("wlsunset -S 7:00 -s 18:30 -t 5000")
    hl.exec_cmd(bar)
    hl.exec_cmd("hyprwsd") -- refreshes the bar's workspace indicators
    -- hl.exec_cmd("hyprpaper")
    -- hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")
end)


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- "gtk3" makes Qt apps follow the GTK font/theme via xdg-desktop-portal-gtk,
-- so they match GTK apps without a separate qt5ct/qt6ct config to maintain.
hl.env("QT_QPA_PLATFORMTHEME", "gtk3")
hl.env("QT_ENABLE_HIGHDPI_SCALING", "1")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_SCALE_FACTOR", "2")
hl.env("GDK_SCALE", "2")
hl.env("GDK_DPI_SCALE", "1")
hl.env("GTK_IM_MODULE", "fcitx5")
hl.env("QT_IM_MODULE", "fcitx5")
hl.env("XMODIFIERS", "@im=fcitx5")
hl.env("XIM_PROGRAM", "/usr/bin/fcitx5")
hl.env("QUTE_QT_WRAPPER", "PyQt6")


-----------------------
---- LOOK AND FEEL ----
-----------------------

-- See https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
    xwayland = {
        force_zero_scaling = true,
    },

    general = {
        gaps_in  = 5,
        gaps_out = 10,

        border_size = 2,

        col = {
            active_border   = { colors = { "rgba(3f1e85cc)", "rgba(8f11a0cc)" }, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },

        -- Set to true to enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = false,

        -- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before turning this on
        allow_tearing = false,

        layout = "dwindle",
    },

    decoration = {
        rounding = 10,

        -- Change transparency of focused and unfocused windows
        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = "rgba(1a1a1aee)",
        },

        blur = {
            enabled  = true,
            size     = 3,
            passes   = 1,
            vibrancy = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },

    misc = {
        disable_hyprland_logo   = true,
        disable_splash_rendering = true,
        mouse_move_enables_dpms = true,
        enable_swallow          = true,
        swallow_regex           = "^(st)$",
    },

    ecosystem = {
        no_update_news   = true,
        no_donation_nag  = true,
    },
})

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1} } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1} } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1} } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1.0} } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1} } })

hl.animation({ leaf = "global",        enabled = true, speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 4.1,  bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })


-----------------
---- LAYOUTS ----
-----------------

-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
hl.config({
    dwindle = {
        preserve_split = true, -- you probably want this
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
hl.config({
    master = {
        new_status = "master",
    },
})


---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "ctrl:nocaps",
        kb_rules   = "",

        repeat_delay = 200,
        repeat_rate  = 50,

        follow_mouse = 1,

        sensitivity = 1.0, -- -1.0 - 1.0, 0 means no modification.

        touchpad = {
            natural_scroll = false,
        },
    },
})

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

-- Example per-device config
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ for more
-- hl.device({ name = "epic-mouse-v1", sensitivity = -0.5 })


--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
hl.window_rule({ match = { class = "galculator" },                    float = true })
hl.window_rule({ match = { class = "(org\\.pulseaudio\\.)?pavucontrol" }, float = true })
hl.window_rule({ match = { class = "blueman-manager" },               float = true })
hl.window_rule({ match = { title = "Clocks" },                        float = true })

hl.window_rule({
    name  = "scratchpad",
    match = { title = "scratchpad" },

    float        = true,
    pin          = true,
    center       = true,
    no_anim      = true,
    stay_focused = true,
})

-- hl.window_rule({ match = { title = ".*Chromium.*" }, no_shadow = true })

hl.window_rule({
    -- Ignore maximize requests from apps. You'll probably like this.
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

-- See https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- Both monitor variables were commented out in the old config, so these rules
-- (and the focusmonitor half of the number binds below) never took effect.
-- Set the outputs and uncomment to bind workspaces 1-5 / 6-9 to two monitors.
-- local monitor_left, monitor_right = "eDP-1", "DP-2"
-- for _, ws in ipairs({ 1, 2, 3, 4, 5 }) do
--     hl.workspace_rule({ workspace = ws, monitor = monitor_left,  default = ws == 1 })
-- end
-- for _, ws in ipairs({ 6, 7, 8, 9 }) do
--     hl.workspace_rule({ workspace = ws, monitor = monitor_right, default = ws == 6 })
-- end


---------------------
---- KEYBINDINGS ----
---------------------

-- See https://wiki.hypr.land/Configuring/Basics/Binds/ for more
local mainMod = "SUPER"

hl.bind(mainMod .. " + Q", hl.dsp.window.close())

-- Move focus with mainMod + hjkl
hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "down" }))

-- Resize the active window
hl.bind(mainMod .. " + SHIFT + h", hl.dsp.window.resize({ x = -50, y = 0,  relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + l", hl.dsp.window.resize({ x = 50,  y = 0,  relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + j", hl.dsp.window.resize({ x = 0,   y = 50, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + k", hl.dsp.window.resize({ x = 0,   y = -50, relative = true }), { repeating = true })

-- Switch workspaces with mainMod + [1-9]
-- Move the active window to a workspace with mainMod + SHIFT + [1-9]
for i = 1, 9 do
    hl.bind(mainMod .. " + " .. i,           hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. i,   hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + 0",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"),   { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),   { locked = true, repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),  { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),{ locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl s 10%+"),                        { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 10%-"),                        { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

-- Move windows to the monitor above/below with mainMod + SHIFT + [comma/period]
hl.bind(mainMod .. " + SHIFT + comma",  hl.dsp.window.move({ monitor = "u" }))
hl.bind(mainMod .. " + SHIFT + period", hl.dsp.window.move({ monitor = "d" }))

-- Layout manipulation
hl.bind(mainMod .. " + SHIFT + space", hl.dsp.layout("orientationcycle"))
hl.bind(mainMod .. " + space",         hl.dsp.layout("swapwithmaster"))

-- Window manipulation
hl.bind(mainMod .. " + C",         hl.dsp.window.center())
hl.bind(mainMod .. " + M",         hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind(mainMod .. " + F",         hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + TAB",         hl.dsp.window.cycle_next())
hl.bind(mainMod .. " + SHIFT + TAB", hl.dsp.window.cycle_next({ next = false }))

hl.bind(mainMod .. " + E",      hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + P",      hl.dsp.exec_cmd("drun"))
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + B",      hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + N",      hl.dsp.exec_cmd(terminal .. " -T scratchpad -W 120x34 vim /home/mike/.scratch.note"))
hl.bind(mainMod .. " + O",      hl.dsp.exec_cmd("define"))
hl.bind("Print", hl.dsp.exec_cmd("screenshot"))
hl.bind("F4",    hl.dsp.exec_cmd("pavucontrol"))
hl.bind("F10",   hl.dsp.exec_cmd("blueman-manager"))
hl.bind("CONTROL + " .. mainMod .. " + ALT + L", hl.dsp.exec_cmd("lock"))
hl.bind("CONTROL + " .. mainMod .. " + ALT + Q", hl.dsp.exit())
