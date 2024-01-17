
local wezterm = require 'wezterm'
local c = wezterm.config_builder()

c.default_prog = {"C:\\Program Files\\PowerShell\\7\\pwsh.exe", "-nologo"}

-- Font configurations
c.font = wezterm.font_with_fallback({
    "Cartograph CF",
    "Symbols Nerd Font",
})
c.front_end = "WebGpu"
c.font_size = 9
c.harfbuzz_features = { "calt=1", "ss01=1" }
c.font_rules = {
    {
        italic = true,
        intensity = "Bold",
        font = wezterm.font {
            family = "Cartograph CF",
            weight = "Regular",
            italic = true,
        },
    },
    {
        italic = true,
        intensity = "Normal",
        font = wezterm.font {
            family = "Cartograph CF",
            weight = "Regular",
            italic = true,
        },
    },
    {
        italic = true,
        intensity = "Half",
        font = wezterm.font {
            family = "Cartograph CF",
            weight = "Regular",
            italic = true
        },
    },
    {
        italic = false,
        intensity = "Bold",
        font = wezterm.font {
            family = "Cartograph CF",
            weight="Regular",
        },
    }
}

-- Window configurations
c.window_decorations = "RESIZE"
c.window_padding = { left = 0, right = 0, top = 20, bottom = 0 }

-- General configurations
c.adjust_window_size_when_changing_font_size = false
c.audible_bell = "Disabled"
c.default_cursor_style = "BlinkingBlock"
c.cursor_blink_rate = 500
c.cursor_blink_ease_in = 'Constant'
c.cursor_blink_ease_out = 'Constant'
c.inactive_pane_hsb = { brightness = 0.90 }

-- Colors and tab bar configurations
require('lua.rose-pine').apply_to_config(c)
wezterm.plugin.require("https://github.com/nekowinston/wezterm-bar").apply_to_config(c, {
    position = "top",
    dividers = "rounded"
})

return c
