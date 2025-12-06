local wezterm = require("wezterm")

local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")
local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")

local config = wezterm.config_builder()
local act = wezterm.action

local function is_mac()
	return string.find(wezterm.target_triple, "darwin", 1, true) ~= nil
end

local function basename(s)
	return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

local get_last_folder_segment = function(cwd)
	local default_value = "N/A"
	if cwd == nil then
		return default_value
	end

	if cwd.scheme == "file" then
		local path = {}
		for segment in string.gmatch(cwd.path, "[^/]+") do
			table.insert(path, segment)
		end
		return path[#path]
	else
		return default_value
	end
end

local function get_current_working_dir(tab)
	local current_dir = tab.active_pane.current_working_dir or ""
	return get_last_folder_segment(current_dir)
end

local function get_process(tab)
	local process_icons = {
		["bash"] = wezterm.nerdfonts.cod_terminal_bash,
		["btm"] = wezterm.nerdfonts.mdi_chart_donut_variant,
		["cargo"] = wezterm.nerdfonts.dev_rust,
		["curl"] = wezterm.nerdfonts.mdi_flattr,
		["docker"] = wezterm.nerdfonts.linux_docker,
		["docker-compose"] = wezterm.nerdfonts.linux_docker,
		["dotnet"] = wezterm.nerdfonts.md_language_csharp,
		["fish"] = wezterm.nerdfonts.seti_powershell,
		["gh"] = wezterm.nerdfonts.dev_github_badge,
		["git"] = wezterm.nerdfonts.dev_git,
		["go"] = wezterm.nerdfonts.seti_go,
		["htop"] = wezterm.nerdfonts.mdi_chart_donut_variant,
		["kubectl"] = wezterm.nerdfonts.linux_docker,
		["kuberlr"] = wezterm.nerdfonts.linux_docker,
		["lazydocker"] = wezterm.nerdfonts.linux_docker,
		["lazygit"] = wezterm.nerdfonts.dev_git,
		["lua"] = wezterm.nerdfonts.seti_lua,
		["make"] = wezterm.nerdfonts.seti_makefile,
		["node"] = wezterm.nerdfonts.dev_nodejs_small,
		["nvim"] = wezterm.nerdfonts.custom_neovim,
		["psql"] = wezterm.nerdfonts.dev_postgresql,
		["pwsh"] = wezterm.nerdfonts.seti_powershell,
		["ruby"] = wezterm.nerdfonts.cod_ruby,
		["stern"] = wezterm.nerdfonts.linux_docker,
		["sudo"] = wezterm.nerdfonts.fa_hashtag,
		["tail"] = wezterm.nerdfonts.fa_file_text,
		["vim"] = wezterm.nerdfonts.dev_vim,
		["wget"] = wezterm.nerdfonts.mdi_arrow_down_box,
		["zsh"] = wezterm.nerdfonts.dev_terminal,
	}
	local process_name = basename(tab.active_pane.foreground_process_name)

	local icon = process_icons[process_name] or wezterm.nerdfonts.seti_checkbox_unchecked

	return icon
end

-- Basic config

config.color_scheme = "Catppuccin Mocha"
config.font = wezterm.font("GeistMono Nerd Font")
config.font_size = is_mac() and 13 or 12
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
-- config.hide_tab_bar_if_only_one_tab = true
config.show_new_tab_button_in_tab_bar = false
config.tab_max_width = 30
config.pane_focus_follows_mouse = true

if is_mac() then
	config.window_decorations = "RESIZE"
end

wezterm.on("format-tab-title", function(tab)
	local active_pane = tab.active_pane

	local process = get_process(tab)
	local cwd = get_current_working_dir(tab)
	local zoom_icon = active_pane.is_zoomed and wezterm.nerdfonts.cod_zoom_in .. " " or ""

	local title = string.format(" %s %s %s", process, cwd, zoom_icon)
	return {
		{ Text = title },
	}
end)

wezterm.on("update-right-status", function(window)
	local workspace_or_leader = window:active_workspace()
	-- Change the worspace name status if leader is active
	if window:active_key_table() then
		workspace_or_leader = window:active_key_table()
	end
	if window:leader_is_active() then
		workspace_or_leader = "LEADER"
	end

	local time = wezterm.strftime("%H:%M")

	window:set_right_status(wezterm.format({
		{ Text = wezterm.nerdfonts.oct_table .. "  " .. workspace_or_leader },
		{ Text = " | " },
		{ Text = wezterm.nerdfonts.md_clock .. "  " .. time .. " " },
	}))
end)

-- SSH

config.ssh_domains = {
	{
		name = "tyr",
		remote_address = "10.0.1.1",
		username = "lorenzo",
	},
}

-- KEYMAPS

-- config.disable_default_key_bindings = true
config.leader = { key = ";", mods = "CTRL" }
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

for i = 1, 9 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = "LEADER",
		action = act.ActivateTab(i - 1),
	})

	table.insert(config.keys, {
		key = "F" .. tostring(i),
		action = act.ActivateTab(i - 1),
	})
end

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
