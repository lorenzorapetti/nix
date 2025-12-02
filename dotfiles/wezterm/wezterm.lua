local wezterm = require("wezterm")

local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")
local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")

local config = wezterm.config_builder()
local act = wezterm.action

-- Basic config

config.color_scheme = "Catppuccin Mocha"
config.font = wezterm.font("GeistMono Nerd Font")
config.font_size = 12
config.use_cap_height_to_scale_fallback_fonts = true

config.max_fps = 120

config.adjust_window_size_when_changing_font_size = false
config.check_for_updates = false
config.window_padding = {
	left = 10,
	right = 10,
	top = 0,
	bottom = 0,
}
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.show_new_tab_button_in_tab_bar = false
config.tab_max_width = 30
config.pane_focus_follows_mouse = true

-- SSH

config.ssh_domains = {
	{
		name = "tyr",
		remote_address = "10.0.1.11",
		username = "lorenzo",
	},
}

-- KEYMAPS

-- config.disable_default_key_bindings = true
config.leader = { key = "a", mods = "CTRL" }
config.keys = {
	{
		key = "t",
		mods = "LEADER",
		action = act.SpawnTab("CurrentPaneDomain"),
	},
	{
		key = "x",
		mods = "LEADER",
		action = act.CloseCurrentTab({ confirm = false }),
	},
	{
		key = "[",
		mods = "ALT",
		action = act.ActivateTabRelative(-1),
	},
	{
		key = "]",
		mods = "ALT",
		action = act.ActivateTabRelative(1),
	},
	{ key = "{", mods = "SHIFT|ALT", action = act.MoveTabRelative(-1) },
	{ key = "}", mods = "SHIFT|ALT", action = act.MoveTabRelative(1) },
	{
		key = "r",
		mods = "LEADER|CTRL",
		action = act.PromptInputLine({
			description = "Enter new name for tab",
			action = wezterm.action_callback(function(window, pane, line)
				-- line will be `nil` if they hit escape without entering anything
				-- An empty string if they just hit enter
				-- Or the actual line of text they wrote
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
	{
		key = "|",
		mods = "LEADER|SHIFT",
		action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "s",
		mods = "ALT|CTRL",
		action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "-",
		mods = "LEADER",
		action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "v",
		mods = "ALT|CTRL",
		action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{ key = "h", mods = "ALT|CTRL", action = act.ActivatePaneDirection("Left") },
	{ key = "j", mods = "ALT|CTRL", action = act.ActivatePaneDirection("Down") },
	{ key = "k", mods = "ALT|CTRL", action = act.ActivatePaneDirection("Up") },
	{ key = "l", mods = "ALT|CTRL", action = act.ActivatePaneDirection("Right") },
	{
		key = "r",
		mods = "LEADER",
		action = act.ActivateKeyTable({
			name = "pane_movement",
			one_shot = false,
		}),
	},
	{ key = "y", mods = "LEADER", action = wezterm.action.ActivateCopyMode },
	{
		key = "c",
		mods = "CTRL",
		action = wezterm.action_callback(function(window, pane)
			local has_selection = window:get_selection_text_for_pane(pane) ~= ""
			if has_selection then
				window:perform_action(act.CopyTo("ClipboardAndPrimarySelection"), pane)

				window:perform_action(act.ClearSelection, pane)
			else
				window:perform_action(act.SendKey({ key = "c", mods = "CTRL" }), pane)
			end
		end),
	},
	{ key = "V", mods = "CTRL", action = act.PasteFrom("Clipboard") },
	{ key = " ", mods = "SHIFT|CTRL", action = wezterm.action.QuickSelect },
	{
		key = "s",
		mods = "LEADER",
		action = workspace_switcher.switch_workspace(),
	},
	{
		key = "S",
		mods = "LEADER",
		action = workspace_switcher.switch_to_prev_workspace(),
	},
}

config.key_tables = {
	pane_movement = {
		{ key = "h", action = act.AdjustPaneSize({ "Left", 1 }) },
		{ key = "j", action = act.AdjustPaneSize({ "Down", 1 }) },
		{ key = "k", action = act.AdjustPaneSize({ "Up", 1 }) },
		{ key = "l", action = act.AdjustPaneSize({ "Right", 1 }) },

		{ key = "Escape", action = "PopKeyTable" },
	},
}

smart_splits.apply_to_config(config)
workspace_switcher.apply_to_config(config)

return config
