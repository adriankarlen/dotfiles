local wezterm = require("wezterm")
local bar = wezterm.plugin.require("https://github.com/adriankarlen/bar.wezterm")

local utils = require("lua.utils")

local c = {}

if wezterm.config_builder then
  c = wezterm.config_builder()
end

-- Actions
local act = wezterm.action

-- Initial Position
local inital_x = 140
local inital_y = 50

-- Config table
c = {
  default_prog = utils.is_windows and { "pwsh", "-NoLogo" } or "zsh",
  initial_cols = 130,
  initial_rows = 40,
  window_padding = { left = "1cell", right = "1cell", top = 0, bottom = 0 },

  window_decorations = "RESIZE",
  use_fancy_tab_bar = false,
  status_update_interval = 1000,
  tab_bar_at_bottom = true,
  show_new_tab_button_in_tab_bar = false,

  -- General configurations
  adjust_window_size_when_changing_font_size = false,
  audible_bell = "Disabled",
  default_cursor_style = "BlinkingBlock",
  cursor_blink_rate = 500,
  cursor_blink_ease_in = "Constant",
  cursor_blink_ease_out = "Constant",
  inactive_pane_hsb = { brightness = 0.9 },

  font = wezterm.font_with_fallback({
    { family = "Cartograph CF", weight = "DemiBold" },
  }),
  font_rules = {
    {
      italic = true,
      intensity = "Half",
      font = wezterm.font("Cartograph CF", { weight = "DemiBold", italic = true }),
    },
  },
  font_size = 12,

  scrollback_lines = 3000,
  default_workspace = "main",

  -- Keys
  leader = { key = "a", mods = "CTRL", timeout_miliseconds = 1000 },
  treat_left_ctrlalt_as_altgr = true,
  keys = {
    -- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
    {
      key = "a",
      mods = "LEADER|CTRL",
      action = act({ SendString = "\x01" }),
    },
    {
      key = "ö",
      mods = "LEADER",
      action = act({ SplitVertical = { domain = "CurrentPaneDomain" } }),
    },
    {
      key = "ä",
      mods = "LEADER",
      action = act({ SplitHorizontal = { domain = "CurrentPaneDomain" } }),
    },
    -- creates a pane at the bottom and launches spotify_player
    {
      key = "s",
      mods = "LEADER",
      action = act({
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
      action = act({ SpawnTab = "CurrentPaneDomain" }),
    },
    {
      key = "h",
      mods = "LEADER",
      action = act({ ActivatePaneDirection = "Left" }),
    },
    {
      key = "j",
      mods = "LEADER",
      action = act({ ActivatePaneDirection = "Down" }),
    },
    {
      key = "k",
      mods = "LEADER",
      action = act({ ActivatePaneDirection = "Up" }),
    },
    {
      key = "l",
      mods = "LEADER",
      action = act({ ActivatePaneDirection = "Right" }),
    },
    {
      key = "H",
      mods = "LEADER|SHIFT",
      action = act({ AdjustPaneSize = { "Left", 5 } }),
    },
    {
      key = "J",
      mods = "LEADER|SHIFT",
      action = act({ AdjustPaneSize = { "Down", 5 } }),
    },
    {
      key = "K",
      mods = "LEADER|SHIFT",
      action = act({ AdjustPaneSize = { "Up", 5 } }),
    },
    {
      key = "L",
      mods = "LEADER|SHIFT",
      action = act({ AdjustPaneSize = { "Right", 5 } }),
    },
    {
      key = "&",
      mods = "LEADER|SHIFT",
      action = act({ CloseCurrentTab = { confirm = true } }),
    },
    {
      key = "x",
      mods = "LEADER",
      action = act({ CloseCurrentPane = { confirm = true } }),
    },
    {
      key = "n",
      mods = "SHIFT|CTRL",
      action = "ToggleFullScreen",
    },
    {
      key = "v",
      mods = "SHIFT|CTRL",
      action = act.PasteFrom("Clipboard"),
    },
    {
      key = "c",
      mods = "SHIFT|CTRL",
      action = act.CopyTo("Clipboard"),
    },
    {
      key = "e",
      mods = "LEADER",
      action = act.PromptInputLine({
        description = wezterm.format({
          { Attribute = { Intensity = "Bold" } },
          { Foreground = { AnsiColor = "Fuchsia" } },
          { Text = "Renaming Tab Title...:" },
        }),
        action = wezterm.action_callback(function(window, _, line)
          if line then
            window:active_tab():set_title(line)
          end
        end),
      }),
    },

    -- Workspaces
    {
      key = "w",
      mods = "LEADER",
      action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }),
    },

    -- update plugins
    {
      key = "u",
      mods = "LEADER",
      action = wezterm.action_callback(function(window, _)
        wezterm.plugin.update_all()
        window:toast_notification("wezterm", "plugins updated!", nil, 4000)
      end),
    },
  },
}

-- Move through tabs with numbers
for i = 1, 9 do
  table.insert(c.keys, {
    key = tostring(i),
    mods = "LEADER",
    action = act.ActivateTab(i - 1),
  })
end

-- Initial position
local mux = wezterm.mux
wezterm.on("gui-startup", function(cmd)
  local _, _, window = mux.spawn_window(cmd or {})
  window:gui_window():set_position(inital_x, inital_y)
end)

-- NVIM ZenMode
wezterm.on("user-var-changed", function(window, pane, name, value)
  wezterm.log_info("var", name, value)
  local overrides = window:get_config_overrides() or {}
  if name == "ZEN_MODE" then
    local incremental = value:find("+")
    local number_value = tonumber(value)
    if incremental ~= nil then
      while number_value > 0 do
        window:perform_action(wezterm.action.IncreaseFontSize, pane)
        number_value = number_value - 1
      end
      overrides.enable_tab_bar = false
    elseif number_value < 0 then
      window:perform_action(wezterm.action.ResetFontSize, pane)
      overrides.font_size = nil
      overrides.enable_tab_bar = true
    else
      overrides.font_size = number_value
      overrides.enable_tab_bar = false
    end
  end
  window:set_config_overrides(overrides)
end)

require("lua.rose-pine").apply_to_config(c)
bar.apply_to_config(c, {
  enabled_modules = {
    username = false,
    hostname = false,
  },
})

return c
