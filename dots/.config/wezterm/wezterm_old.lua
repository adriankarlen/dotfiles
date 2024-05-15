local wezterm = require("wezterm")
local c = wezterm.config_builder()

c.default_prog = { "C:\\Program Files\\PowerShell\\7\\pwsh.exe", "-nologo" }

-- Font configurations
c.font = wezterm.font("Cartograph CF", { weight = "DemiBold" })
c.font_size = 10.25
c.harfbuzz_features = { "calt=1" }
c.font_rules = {
  {
    italic = true,
    intensity = "Half",
    font = wezterm.font(
      "CartographCF Nerd Font",
      { weight = "Bold", italic = true }
    ),
  },
}

-- Keybindings
c.leader = { key = "a", mods = "CTRL" }
c.disable_default_key_bindings = true
c.keys = {
  -- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
  {
    key = "a",
    mods = "LEADER|CTRL",
    action = wezterm.action({ SendString = "\x01" }),
  },
  {
    key = "ö",
    mods = "LEADER",
    action = wezterm.action({
      SplitVertical = { domain = "CurrentPaneDomain" },
    }),
  },
  {
    key = "ä",
    mods = "LEADER",
    action = wezterm.action({
      SplitHorizontal = {
        domain = "CurrentPaneDomain",
      },
    }),
  },
  -- creates a pane at the bottom and launches spotify_player
  {
    key = "s",
    mods = "LEADER",
    action = wezterm.action({
      SplitPane = {
        direction = "Down",
        command = { args = { "spotify_player" } },
        size = { Cells = 6 },
      },
    }),
  },
  { key = "z", mods = "LEADER", action = "TogglePaneZoomState" },
  {
    key = "c",
    mods = "LEADER",
    action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }),
  },
  {
    key = "h",
    mods = "LEADER",
    action = wezterm.action({ ActivatePaneDirection = "Left" }),
  },
  {
    key = "j",
    mods = "LEADER",
    action = wezterm.action({ ActivatePaneDirection = "Down" }),
  },
  {
    key = "k",
    mods = "LEADER",
    action = wezterm.action({ ActivatePaneDirection = "Up" }),
  },
  {
    key = "l",
    mods = "LEADER",
    action = wezterm.action({ ActivatePaneDirection = "Right" }),
  },
  {
    key = "H",
    mods = "LEADER|SHIFT",
    action = wezterm.action({ AdjustPaneSize = { "Left", 5 } }),
  },
  {
    key = "J",
    mods = "LEADER|SHIFT",
    action = wezterm.action({ AdjustPaneSize = { "Down", 5 } }),
  },
  {
    key = "K",
    mods = "LEADER|SHIFT",
    action = wezterm.action({ AdjustPaneSize = { "Up", 5 } }),
  },
  {
    key = "L",
    mods = "LEADER|SHIFT",
    action = wezterm.action({ AdjustPaneSize = { "Right", 5 } }),
  },
  {
    key = "1",
    mods = "LEADER",
    action = wezterm.action({ ActivateTab = 0 }),
  },
  {
    key = "2",
    mods = "LEADER",
    action = wezterm.action({ ActivateTab = 1 }),
  },
  {
    key = "3",
    mods = "LEADER",
    action = wezterm.action({ ActivateTab = 2 }),
  },
  {
    key = "4",
    mods = "LEADER",
    action = wezterm.action({ ActivateTab = 3 }),
  },
  {
    key = "5",
    mods = "LEADER",
    action = wezterm.action({ ActivateTab = 4 }),
  },
  {
    key = "6",
    mods = "LEADER",
    action = wezterm.action({ ActivateTab = 5 }),
  },
  {
    key = "7",
    mods = "LEADER",
    action = wezterm.action({ ActivateTab = 6 }),
  },
  {
    key = "8",
    mods = "LEADER",
    action = wezterm.action({ ActivateTab = 7 }),
  },
  {
    key = "9",
    mods = "LEADER",
    action = wezterm.action({ ActivateTab = 8 }),
  },
  {
    key = "&",
    mods = "LEADER|SHIFT",
    action = wezterm.action({ CloseCurrentTab = { confirm = true } }),
  },
  {
    key = "x",
    mods = "LEADER",
    action = wezterm.action({ CloseCurrentPane = { confirm = true } }),
  },

  { key = "n", mods = "SHIFT|CTRL", action = "ToggleFullScreen" },
  {
    key = "v",
    mods = "SHIFT|CTRL",
    action = wezterm.action.PasteFrom("Clipboard"),
  },
  {
    key = "c",
    mods = "SHIFT|CTRL",
    action = wezterm.action.CopyTo("Clipboard"),
  },
}

-- Window configurations
c.window_decorations = "RESIZE"
c.window_padding = { left = 4, right = 0, top = 0, bottom = 0 }

-- General configurations
c.adjust_window_size_when_changing_font_size = false
c.audible_bell = "Disabled"
c.default_cursor_style = "BlinkingBlock"
c.cursor_blink_rate = 500
c.cursor_blink_ease_in = "Constant"
c.cursor_blink_ease_out = "Constant"
c.inactive_pane_hsb = { brightness = 0.9 }

-- Colors and tab bar configurations
require("lua.rose-pine").apply_to_config(c)
require("lua.bar").apply_to_config(c)

return c
