-- Hyprland 0.56+ Lua config

local HOME = os.getenv("HOME") or "/home/skreep"
local mainMod = "SUPER"
local terminal = "kitty"

-- Environment
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("XCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("XCURSOR_SIZE", "24")
hl.env("NIXOS_OZONE_WL", "1")
hl.env("WALLPAPER_DIR", HOME .. "/Pictures/Wallpapers/")
hl.env("SCRIPT_DIR", HOME .. "/.config/hypr/scripts")

-- Generic monitor rule for the MacBook display and any attached display.
-- This intentionally replaces the old DP-2-only desktop monitor rule.
hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = 1,
})

-- Main configuration. Values from the old HyprMod-generated GUI config
-- are applied here as the final effective settings.
hl.config({
    general = {
        border_size = 0,
        gaps_in = 6,
        gaps_out = 12,
        float_gaps = 6,
        resize_on_border = false,
        extend_border_grab_area = 15,
        snap = {
            enabled = true,
            border_overlap = true,
            respect_gaps = true,
        },
        col = {
            active_border = { colors = { "0xffb4befe", "0xffcba6f7" }, angle = 0 },
            inactive_border = "0xff1e1e2e",
        },
    },

    decoration = {
        rounding = 25,
        rounding_power = 2.0,
        active_opacity = 0.85,
        inactive_opacity = 0.8,
        blur = {
            enabled = true,
            size = 8,
            passes = 3,
            brightness = 1.1,
            contrast = 0.81,
            ignore_opacity = true,
            popups = true,
            xray = true,
        },
        shadow = {
            enabled = false,
            range = 17,
        },
    },

    input = {
        kb_layout = "us,es",
        kb_options = "",
        accel_profile = "flat",
        touchpad =  {
	    tap_to_click = false,
            natural_scroll = false,
	    clickfinger_behavior = true,
        },
    },

    cursor = {
        no_warps = true,
        hide_on_key_press = true,
        inactive_timeout = 0,
    },

    misc = {
        font_family = "JetBrains Mono",
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        force_default_wallpaper = 0,
        animate_manual_resizes = true,
        animate_mouse_windowdragging = true,
        key_press_enables_dpms = true,
        mouse_move_enables_dpms = true,
    },

    ecosystem = {
        no_update_news = true,
        no_donation_nag = true,
    },

    animations = {
        enabled = true,
    },
})

-- Cursor/theme commands that need to run after Hyprland starts.
hl.on("hyprland.start", function()
    hl.exec_cmd("/usr/lib/kdeconnectd")
    hl.exec_cmd([[gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"]])
    hl.exec_cmd([[gsettings set org.gnome.desktop.interface gtk-theme "adw-gtk3"]])
    hl.exec_cmd("hyprctl setcursor Bibata-Modern-Ice 24")

    hl.exec_cmd("hyprshade on vibrance")
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("hypridle")
    hl.exec_cmd(HOME .. "/.config/hypr/scripts/init.sh")
    -- settings_watcher.sh is intentionally not autostarted here because the old
    -- version edits hyprland.conf directly. Your static settings are included above.
    hl.exec_cmd("playerctld")
    hl.exec_cmd("sh -c 'swayosd-server >/dev/null 2>&1 &'")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    hl.exec_cmd(HOME .. "/.config/hypr/scripts/volume_listener.sh")
    hl.exec_cmd("systemctl --user enable --now easyeffects")
end)

-- Animation settings equivalent to the HyprMod-generated config.
hl.curve("smoothIn", {
    type = "bezier",
    points = { { 0.25, 1.0 }, { 0.5, 1.0 } },
})
hl.animation({ leaf = "global", enabled = true, speed = 4.0, bezier = "smoothIn" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 7.0, bezier = "smoothIn", style = "slide" })

-- Gestures
hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace",
})

-- Layer rules
hl.layer_rule({
    name = "volume-osd-no-anim",
    match = { namespace = "^(volume_osd)$" },
    no_anim = true,
})
hl.layer_rule({
    name = "brightness-osd-no-anim",
    match = { namespace = "^(brightness_osd)$" },
    no_anim = true,
})
hl.layer_rule({
    name = "hyprpicker-no-anim",
    match = { namespace = "hyprpicker" },
    no_anim = true,
})
hl.layer_rule({
    name = "qsdock-no-anim",
    match = { namespace = "qsdock" },
    no_anim = true,
})
hl.layer_rule({
    name = "session-lock-effects",
    match = { namespace = "ext-session-lock" },
    blur = true,
    ignore_alpha = 0.2,
})

-- Window rules
hl.window_rule({
    name = "app-launcher",
    match = { title = "^(app-launcher)$" },
    float = true,
    center = true,
    size = { 1200, 600 },
    animation = "slide",
})
hl.window_rule({
    name = "quickshell-master",
    match = { title = "^(qs-master)$" },
    float = true,
    no_shadow = true,
    no_initial_focus = true,
})

-- Helpers
local function execbind(keys, cmd, flags)
    hl.bind(keys, hl.dsp.exec_cmd(cmd), flags)
end

hl.bind("switch:on:Lid Switch",
    hl.dsp.exec_cmd("hyprctl keyword monitor 'eDP-1,disable'"),
    { locked = true })

hl.bind("switch:off:Lid Switch",
    hl.dsp.exec_cmd("hyprctl keyword monitor 'eDP-1,preffered,auto,1'"),
    { locked = true })

-- Media
execbind("XF86AudioNext", "playerctl --player=Plexamp next", { locked = true })
execbind("XF86AudioPrev", "playerctl --player=Plexamp previous", { locked = true })

-- Mouse/window management
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- ALT+F4: preserve your qs-master special handling.
execbind("ALT + F4", [[bash -c 'if hyprctl activewindow | grep -q "title: qs-master"; then ~/.config/hypr/scripts/qs_manager.sh close; else hyprctl dispatch "hl.dsp.window.close()"; fi']])

-- Final HyprMod behavior for SUPER+Q is killactive.
hl.bind(mainMod .. " + Q", hl.dsp.window.close())

-- Toggle floating unless qs-master is active.
execbind(mainMod .. " + SHIFT + F", [[bash -c 'if ! hyprctl activewindow | grep -q "title: qs-master"; then hyprctl dispatch "hl.dsp.window.float({ action = \"toggle\" })"; fi']])

-- Resize active window
hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.resize({ x = -50, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.resize({ x = 50,  y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.window.resize({ x = 0, y = -50, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.window.resize({ x = 0, y = 50,  relative = true }), { repeating = true })

-- Move tiled windows
hl.bind(mainMod .. " + CTRL + left",  hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + CTRL + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + CTRL + up",    hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + CTRL + down",  hl.dsp.window.move({ direction = "down" }))

-- Focus
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Applications / launchers.
execbind(mainMod .. " + RETURN", terminal)
execbind(mainMod .. " + F", "librewolf") -- HyprMod override
execbind(mainMod .. " + E", "nautilus")
execbind(mainMod .. " + D", "bash " .. HOME .. "/.config/hypr/scripts/rofi_show.sh drun")
execbind("ALT + TAB", "bash " .. HOME .. "/.config/hypr/scripts/rofi_show.sh window")
execbind(mainMod .. " + C", "bash " .. HOME .. "/.config/hypr/scripts/rofi_clipboard.sh")
execbind(mainMod .. " + A", "swaync-client -t -sw")

-- Quickshell controls.
execbind(mainMod .. " + SHIFT + S", "bash " .. HOME .. "/.config/hypr/scripts/qs_manager.sh toggle stewart")
execbind(mainMod .. " + U", "bash " .. HOME .. "/.config/hypr/scripts/qs_manager.sh toggle music") -- HyprMod override
execbind(mainMod .. " + B", "bash " .. HOME .. "/.config/hypr/scripts/qs_manager.sh toggle battery")
execbind(mainMod .. " + W", "bash " .. HOME .. "/.config/hypr/scripts/qs_manager.sh toggle wallpaper")
execbind(mainMod .. " + S", "bash " .. HOME .. "/.config/hypr/scripts/qs_manager.sh toggle calendar")
execbind(mainMod .. " + N", "bash " .. HOME .. "/.config/hypr/scripts/qs_manager.sh toggle network")
execbind(mainMod .. " + SHIFT + T", "bash " .. HOME .. "/.config/hypr/scripts/qs_manager.sh toggle focustime")
execbind(mainMod .. " + V", "bash " .. HOME .. "/.config/hypr/scripts/qs_manager.sh toggle volume")

-- HyprMod extra app binds.
execbind(mainMod .. " + Z", "flatpak run com.plexamp.Plexamp")
execbind(mainMod .. " + X", "steam")

-- Hardware / screenshots / lock
execbind("Caps_Lock", "sleep 0.1 && swayosd-client --caps-lock", { locked = true })
execbind("XF86MonBrightnessDown", "swayosd-client --brightness -5 --device acpi_video0", { locked = true })
execbind("XF86MonBrightnessUp", "swayosd-client --brightness +5 --device acpi_video0", { locked = true })
execbind("XF86KbdBrightnessDown", "brightnessctl -d 'apple::kbd_backlight' set 10%-", { locked = true })
execbind("XF86KbdBrightnessUp", "brightnessctl -d 'apple::kbd_backlight' set 10%+", { locked = true })
execbind("Print", HOME .. "/.config/hypr/scripts/screenshot.sh", { locked = true })
execbind("SHIFT + Print", HOME .. "/.config/hypr/scripts/screenshot.sh --edit", { locked = true })
execbind("SUPER + Print", HOME .. "/.config/hypr/scripts/screenshot.sh --full", { locked = true })
execbind("SUPER + SHIFT + Print", HOME .. "/.config/hypr/scripts/screenshot.sh --full --edit", { locked = true })
execbind("XF86PowerOff", "bash " .. HOME .. "/.config/hypr/scripts/lock.sh", { locked = true })
execbind(mainMod .. " + L", "bash " .. HOME .. "/.config/hypr/scripts/lock.sh", { locked = true, repeating = true })

-- Audio
execbind(mainMod .. " + SPACE", "playerctl play-pause", { locked = true })
execbind("XF86AudioPause", "playerctl play-pause", { locked = true })
execbind("XF86AudioPlay", "playerctl play-pause", { locked = true })
execbind("XF86AudioMicMute", "swayosd-client --input-volume mute-toggle", { locked = true })
execbind("XF86AudioMute", "swayosd-client --output-volume mute-toggle", { locked = true })
execbind("XF86AudioLowerVolume", "swayosd-client --output-volume lower", { locked = true, repeating = true })
execbind("XF86AudioRaiseVolume", "swayosd-client --output-volume raise", { locked = true, repeating = true })

-- Workspace switching continues to use qs_manager.sh exactly like the old config.
for i = 1, 10 do
    local key = tostring(i % 10)
    execbind(mainMod .. " + " .. key, HOME .. "/.config/hypr/scripts/qs_manager.sh " .. i)
    execbind(mainMod .. " + SHIFT + " .. key, HOME .. "/.config/hypr/scripts/qs_manager.sh " .. i .. " move")
end

-- HyprMod managed settings
require("hyprland-gui")
