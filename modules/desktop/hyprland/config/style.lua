local fonts = require("fonts")

hl.config({
	general = {
		gaps_in = 6,
		gaps_out = 10,
		float_gaps = 10,
		border_size = 1,
		resize_on_border = true,
		allow_tearing = true,
		no_focus_fallback = true,

		layout = "scrolling",
	},

	ecosystem = {
		no_donation_nag = true,
	},

	dwindle = {
		preserve_split = true,
	},

	decoration = {
		rounding = 8,
		rounding_power = 2,
		active_opacity = 1,
		inactive_opacity = 1,

		shadow = {
			enabled = true,
			range = 4,
			render_power = 3,
		},

		blur = {
			enabled = true,
			size = 3,
			passes = 1,
			vibrancy = 0.1696,
		},
	},

	master = {
		new_status = "master",
	},

	misc = {
		force_default_wallpaper = 0,
		disable_hyprland_logo = true,
		font_family = fonts.nerd,
		mouse_move_enables_dpms = true,
		key_press_enables_dpms = true,
		focus_on_activate = true,
		middle_click_paste = true,
	},

	animations = {
		enabled = true,
		workspace_wraparound = true,
	},

	group = {
		groupbar = {
			font_size = 10,
			gradients = true,
			gradient_round_only_edges = false,
			gradient_rounding = 10,
			height = 25,
			indicator_height = 1,
			gaps_in = 3,
			gaps_out = 3,
		},
	},

	xwayland = {
		force_zero_scaling = true,
	},
})

hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

hl.curve("easy", { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 3.1, bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.21, bezier = "easeOutQuint", style = "slidefadevert 5%" })
hl.animation({
	leaf = "workspacesIn",
	enabled = true,
	speed = 1.21,
	bezier = "easeOutQuint",
	style = "slidefadevert 5%",
})
hl.animation({
	leaf = "workspacesOut",
	enabled = true,
	speed = 1.21,
	bezier = "easeOutQuint",
	style = "slidefadevert 5%",
})
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 1.21, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "specialWorkspaceIn", enabled = true, speed = 1.21, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "specialWorkspaceOut", enabled = true, speed = 1.21, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 7, bezier = "quick" })
