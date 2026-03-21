-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
config.color_scheme = "Catppuccin Mocha"

config.font = wezterm.font("MesloLGS Nerd Font Mono")
config.font_size = 14.5

config.enable_tab_bar = false

config.window_decorations = "RESIZE"
config.window_background_opacity = 0.9
config.macos_window_background_blur = 10

config.keys = {
	{
		key = "c",
		mods = "CMD",
		action = wezterm.action_callback(function(window, pane)
			local selection = window:get_selection_text_for_pane(pane)
			if selection and selection ~= "" then
				-- If text is selected, copy it
				window:perform_action(wezterm.action.CopyTo("ClipboardAndPrimarySelection"), pane)
			else
				-- Otherwise, send Ctrl+C
				window:perform_action(wezterm.action.SendKey({ key = "c", mods = "CTRL" }), pane)
			end
		end),
	},
}

return config
