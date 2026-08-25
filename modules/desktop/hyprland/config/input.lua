hl.config({
	input = {
		kb_layout = "us",
		kb_options = "compose:ralt",
		repeat_delay = 250,
		repeat_rate = 70,

		follow_mouse = 1,
		accel_profile = "flat",
		sensitivity = 0.5,

		touchpad = {
			natural_scroll = false,
			disable_while_typing = true,
			scroll_factor = 0.2,
			clickfinger_behavior = true,
		},
	},

	cursor = {
		hide_on_key_press = true,
		no_hardware_cursors = 1,
	},
})

hl.device({
	name = "at-translated-set-2-keyboard",
	kb_options = "compose:ralt,ctrl:nocaps",
})

hl.gesture({
	fingers = 3,
	direction = "vertical",
	action = "workspace",
})

hl.gesture({
	fingers = 3,
	direction = "left",
	action = function()
		hl.dispatch(hl.dsp.focus({ direction = "left" }))
	end,
})

hl.gesture({
	fingers = 3,
	direction = "right",
	action = function()
		hl.dispatch(hl.dsp.focus({ direction = "right" }))
	end,
})
