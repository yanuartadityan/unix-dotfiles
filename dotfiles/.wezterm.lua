-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- GUI: Set window position
local mux = wezterm.mux
wezterm.on('gui-startup', function(window)
	local tab, pane, window = mux.spawn_window(cmd or {})
	local gui_window = window:gui_window();
	gui_window:set_position(75, 75);
end)

-- This will hold configuration
local config = wezterm.config_builder()

-- Launcher config
config.default_prog = { 'nu' }

-- Appearance config
config.font_size = 10
config.initial_rows = 45
config.initial_cols = 165
config.color_scheme = 'Sandcastle (base16)'
config.window_decorations = 'RESIZE'
config.tab_bar_at_bottom = true
config.integrated_title_buttons = { 'Close' }
config.window_background_opacity = 0.92
config.win32_system_backdrop = 'Auto'
config.prefer_egl = true
config.window_padding = {
	left = 40,
	right = 40,
	bottom = 25,
	top = 25,
}

-- Scrollbar config
config.enable_scroll_bar = false

return config
