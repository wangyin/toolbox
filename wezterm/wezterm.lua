local wezterm = require("wezterm")
local Tab = require("tab")
local Keys = require("keys")

local c = {}
if wezterm.config_builder then
	c = wezterm.config_builder()
	c:set_strict_mode(true)
end

c.color_scheme = "tokyonight_night"
c.use_fancy_tab_bar = false
c.show_new_tab_button_in_tab_bar = false
c.font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Light", italic = false })
c.font_size = 13
c.animation_fps = 60
c.max_fps = 60
c.underline_thickness = "200%"
c.underline_position = "-3pt"
c.enable_wayland = false
c.pane_focus_follows_mouse = false
c.warn_about_missing_glyphs = false
c.show_update_window = false
c.check_for_updates = false
c.line_height = 1.2
c.window_close_confirmation = "NeverPrompt"
c.window_padding = {
	left = 0,
	right = 0,
	top = 10,
	bottom = 0,
}
c.initial_cols = 110
c.initial_rows = 25
c.inactive_pane_hsb = {
	saturation = 1.0,
	brightness = wezterm.GLOBAL.is_dark and 0.90 or 0.95,
}
c.enable_scroll_bar = false
c.tab_bar_at_bottom = false
c.use_fancy_tab_bar = false
c.show_new_tab_button_in_tab_bar = false
c.window_decorations = "RESIZE"
c.window_background_opacity = 0.9
c.tab_max_width = 50
c.hide_tab_bar_if_only_one_tab = false
c.audible_bell = "Disabled"
c.leader = { key = ',', mods = 'CTRL' }
c.disable_default_key_bindings = false
c.keys = Keys.keys
c.key_tables = Keys.key_tables
c.hyperlink_rules = {
	{
		regex = "\\b\\w+://[\\w.-]+:[0-9]{2,15}\\S*\\b",
		format = "$0",
	},
	{
		regex = "\\b\\w+://[\\w.-]+\\.[a-z]{2,15}\\S*\\b",
		format = "$0",
	},
	{
		regex = [[\b\w+@[\w-]+(\.[\w-]+)+\b]],
		format = "mailto:$0",
	},
	{
		regex = [[\bfile://\S*\b]],
		format = "$0",
	},
	{
		regex = [[\b\w+://(?:[\d]{1,3}\.){3}[\d]{1,3}\S*\b]],
		format = "$0",
	},
	{
		regex = [[\b[tT](\d+)\b]],
		format = "https://example.com/tasks/?t=$1",
	},
}

wezterm.on(
  "gui-startup",
  function(cmd)
    local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
    window:gui_window():maximize()
  end
)

wezterm.on(
  "format-tab-title",
  function(tab, tabs, panes, config, hover, max_width)
    local palette = config.resolved_palette.tab_bar
    local colors = {
      fg = tab.is_active and palette.active_tab.bg_color or palette.inactive_tab.bg_color,
      bg = palette.background,
      text = config.resolved_palette.foreground,
    }
    local process = Tab.get_process(tab)

    return {
      { Foreground = { Color = colors.fg } },
      { Background = { Color = colors.bg } },
      { Text = "" },
      "ResetAttributes",
      { Foreground = { Color = colors.text } },
      { Text = string.format(" %s  ", tab.tab_index + 1) },
      process[1],
      process[2],
      { Foreground = { Color = colors.text }},
      { Text = "  " },
      { Text = Tab.get_current_working_folder_name(tab) },
      { Foreground = { Color = colors.fg } },
      { Background = { Color = colors.bg } },
      { Text = "" },
    }
  end
)

-- Show which key table is active in the status area
wezterm.on('update-right-status', function(window, pane)
  local name = window:active_key_table()
  if name then
    name = 'TABLE: ' .. name
  end
  window:set_right_status(name or '')
end)


return c
