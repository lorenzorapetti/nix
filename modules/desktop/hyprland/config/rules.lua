hl.layer_rule({
	name = "vicinae-blur",
	match = {
		namespace = "vicinae",
	},
	blur = true,
	ignore_alpha = 0,
})

hl.layer_rule({
	name = "no-animation",
	match = {
		namespace = "(vicinae|waybar)",
	},
	no_anim = true,
})

hl.layer_rule({
	name = "wlr-which-key",
	match = {
		namespace = "wlr_which_key",
	},
	no_anim = true,
})

hl.window_rule({
	name = "no-screenshare",
	match = {
		class = "1password",
	},
	no_screen_share = true,
})

hl.window_rule({
	name = "float-apps",
	match = {
		class = "(org.pulseaudio.pavucontrol|blueman-manager|com.gabm.satty|org.gnome.FileRoller|com.nextcloud.desktopclient.nextcloud)",
	},
	float = true,
	size = {
		"monitor_w*0.8",
		"monitor_h*0.7",
	},
})

hl.window_rule({
	name = "special-apps",
	match = {
		class = "(org.gnome.Nautilus|1password)",
	},
	workspace = "special:magic",
})

hl.window_rule({
	name = "huddle",
	match = {
		title = "^Huddle",
	},
	float = true,
	size = {
		"monitor_w*0.8",
		"monitor_h*0.7",
	},
})

hl.window_rule({
	name = "maximised-apps",
	match = {
		class = "(helium)",
	},
	scrolling_width = 1,
})

hl.window_rule({
	name = "quick-terminal",
	match = {
		class = "(com.ghostty.quick_terminal|quick_terminal|quick-terminal)",
	},
	float = true,
	size = {
		"monitor_w*0.9",
		"monitor_h*0.8",
	},
})

hl.window_rule({
	name = "picture-in-picture-meet",
	match = {
		title = "^Meet.*",
	},
	float = true,
	pin = true,
	size = {
		"monitor_w*0.3",
		"monitor_h*0.4",
	},
	move = {
		"monitor_w-(monitor_w*0.3)-12",
		"monitor_h-(monitor_h*0.4)-12",
	},
})

hl.window_rule({
	name = "picture-in-picture",
	match = {
		title = "(Picture in picture|Picture in Picture|picture in picture|picture_in_picture|picture-in-picture)",
	},
	float = true,
	pin = true,
	size = {
		"monitor_w*0.4",
		"monitor_h*0.35",
	},
	move = {
		"monitor_w-(monitor_w*0.4)-12",
		"monitor_h-(monitor_h*0.35)-12",
	},
})

hl.window_rule({
	name = "floating-large",
	match = {
		class = "dev.noctalia.Noctalia",
	},
	float = true,
	size = {
		"monitor_w*0.7",
		"monitor_h*0.6",
	},
	center = true,
})

hl.window_rule({
	name = "screen-share-popup",
	match = {
		class = "hyprland-share-picker",
	},
	float = true,
	no_anim = true,
	size = {
		"monitor_w*0.4",
		"monitor_h*0.5",
	},
	center = true,
})

hl.window_rule({
	name = "chat-apps",
	match = {
		class = "(vesktop|org.telegram.desktop)",
	},
	workspace = 6,
})

hl.window_rule({
	name = "work-chat-apps",
	match = {
		class = "(slack|teams-for-linux)",
	},
	workspace = 5,
})

hl.window_rule({
	name = "suppress-maximize-events",
	match = {
		class = ".*",
	},
	suppress_event = "maximize",
})

hl.window_rule({
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},
	no_focus = true,
})

hl.window_rule({
	name = "move-hyprland-run",
	match = {
		class = "hyprland-run",
	},
	move = {
		"20",
		"monitor_h-120",
	},
	float = true,
})

hl.workspace_rule({
	workspace = "special:tasks",
	on_created_empty = "runapp ticktick",
	layout = "monocle",
	gaps_out = {
		left = 80,
		right = 80,
		top = 60,
		bottom = 60,
	},
})

hl.workspace_rule({
	workspace = "special:magic",
	layout = "monocle",
	gaps_out = {
		left = 80,
		right = 80,
		top = 60,
		bottom = 60,
	},
})

-- Gaming

hl.window_rule({
	name = "steam-tweaks",
	match = {
		class = "steam",
		float = true,
	},
	min_size = "1 1",
	rounding = 0,
})

hl.window_rule({
	name = "proton-game-tag",
	match = {
		xdg_tag = "proton-game",
	},
	tag = "+game",
})
hl.window_rule({
	name = "steam-apps-tag",
	match = {
		initial_class = "steam_app_.*",
	},
	tag = "+game",
})
hl.window_rule({
	name = "gamescope-tag",
	match = {
		class = "gamescope",
	},
	tag = "+game",
})

hl.window_rule({
	name = "games",
	match = {
		tag = "game",
		fullscreen = true,
	},
	border_size = 0,
	rounding = 0,
	decorate = false,
	force_rgbx = true,
	sync_fullscreen = true,
	no_anim = true,
	no_blur = true,
	no_dim = true,
	no_max_size = true,
	no_shadow = true,
	persistent_size = true,
	focus_on_activate = true,
	immediate = true,
})
hl.window_rule({
	name = "game-popups",
	match = {
		tag = "game",
	},
	content = "game",
	workspace = 3,
	center = true,
	idle_inhibit = "always",
})
