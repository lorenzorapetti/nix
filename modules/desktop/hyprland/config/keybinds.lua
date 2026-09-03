local programs = require("programs")

hl.config({
	binds = {
		hide_special_on_workspace_change = true,
		workspace_center_on = 1,
		movefocus_cycles_groupfirst = true,
		drag_threshold = 10,
	},
})

local main_mod = "SUPER"

local function get_workspace()
	return hl.get_active_special_workspace() or hl.get_active_workspace()
end

local function layout_bind(bind_table)
	return function()
		local workspace = get_workspace()

		if not workspace then
			return
		end

		local layout = workspace.tiled_layout

		if bind_table[layout] or bind_table["default"] then
			hl.dispatch(bind_table[layout] or bind_table["default"])
		end
	end
end

local function quick_terminal(command)
	return string.format(programs.quick_terminal .. ' "%s"', command)
end

local function vicinae_app(app)
	return string.format("vicinae vicinae://launch/applications/%s", app)
end

local function bind(key, action, description)
	hl.bind(key, action, { description = description })
end

local function bindm(key, action, description)
	hl.bind(main_mod .. " + " .. key, action, { description = description })
end

local function bindh(key, action, description)
	hl.bind(main_mod .. " + SHIFT + CTRL + ALT + " .. key, action, { description = description })
end

local function exec(cmd)
	return hl.dsp.exec_cmd(cmd)
end

local function run_app(app)
	return exec(programs.runapp .. " " .. app)
end

local function system_action(action)
	return exec(programs.system_action .. " " .. action)
end

local function define_submap(name, callback)
	hl.define_submap(name, function()
		callback()

		bind("ESCAPE", hl.dsp.submap("reset"), "Exit Submap")
		bind("CAPS_LOCK", hl.dsp.submap("reset"), "Exit Submap")
	end)
end

local function submap_bind(key, action, description)
	hl.bind(key, function()
		hl.dispatch(action)
		hl.dispatch(hl.dsp.submap("reset"))
	end, { description = description })
end

local function submenu(key)
	return exec(programs.wlr_which_key .. " --initial-keys " .. key)
end

--------------------- Programs ---------------------
bindm("RETURN", run_app(programs.terminal), "Open Terminal")
bindm("B", exec(vicinae_app("helium")), "Open Browser")
bindm("E", exec(quick_terminal(programs.yazi)), "Open Terminal File Manager")
bindm("D", exec(quick_terminal(programs.bluetui)), "Open Bluetooth Settings")
bindm("V", exec(quick_terminal(programs.wiremix)), "Open Volume Control")
bindm("T", hl.dsp.workspace.toggle_special("tasks"), "Open Tasks")
bindm("GRAVE", system_action("window-switcher"), "Switch Windows")
bindm("SHIFT + E", exec(vicinae_app("org.gnome.Nautilus")), "Open File Manager")
bindm("CTRL + E", exec("vicinae vicinae://launch/core/search-emojis"), "Open Emoji Search")
bindh("E", exec(vicinae_app("org.gnome.Nautilus")), "Open File Manager")

--------------------- Launchers ---------------------
bindm("SPACE", exec("vicinae toggle"), "Toggle Launcher")
bindm("SHIFT + SPACE", run_app(programs._1password .. " --quick-access"), "Toggle 1Password")
bindm("Y", exec("vicinae vicinae://launch/clipboard/history"), "Toggle Clipboard History")
bindm("O", exec(programs.wlr_which_key), "Which Key")

bindm("ESCAPE", system_action("session lock"), "Lock Screen")
bindm("CAPS_LOCK", system_action("session lock"), "Lock Screen")
bindm("SHIFT + ESCAPE", system_action("session menu-toggle"), "Power Menu")
bindm("SHIFT + CAPS_LOCK", system_action("session menu-toggle"), "Power Menu")

bind("ALT + TAB", hl.dsp.exec_cmd("noctalia msg window-switcher"), "Window Switcher")

--------------------- Screenshot ---------------------
bind("PRINT", system_action("screenshot region"), "Screenshot of region")
bind("SHIFT + PRINT", exec("screenshot"), "Screenshot of window")

bindm("PRINT", submenu("s"), "Screenshot Submenu")

--------------------- Apps ---------------------
bindm("A", submenu("a"), "Apps")

--------------------- Windows ---------------------
bindm("Q", hl.dsp.window.close(), "Close Current Window")
bindm("SHIFT + F", hl.dsp.window.float({ action = "toggle" }), "Toggle Floating")

bindm("F", function()
	local window = hl.get_active_window()
	if not window then
		return
	end

	if window.floating then
		hl.dispatch(hl.dsp.window.cycle_next({ next = true, floating = false, tiling = true }))
	else
		hl.dispatch(hl.dsp.window.cycle_next({ next = true, floating = true, tiling = false }))
	end
end, "Toggle Floating")

bindm("M", hl.dsp.window.fullscreen({ action = "toggle", mode = "maximized" }), "Toggle Maximize")
bindm("P", function()
	local window = hl.get_active_window()
	if not window then
		return
	end

	if not window.floating then
		hl.dispatch(hl.dsp.window.float({ action = "set" }))
	end

	hl.dispatch(hl.dsp.window.pin())
end, "Pin Window")
bindm("tab", hl.dsp.focus({ last = true }), "Focus Current or Last Window")

local directions = {
	left = { "LEFT", "H", "mouse_left" },
	right = { "RIGHT", "L", "mouse_right" },
	up = { "UP", "K", "mouse_up" },
	down = { "DOWN", "J", "mouse_down" },
}

for dir, keys in pairs(directions) do
	for _, key in ipairs(keys) do
		bindm(key, function()
			local workspace = get_workspace()

			if not workspace then
				return
			end

			if workspace.tiled_layout == "scrolling" and (dir == "left" or dir == "right") then
				hl.dispatch(hl.dsp.layout("focus " .. (dir == "left" and "l" or "r")))
			elseif workspace.tiled_layout == "monocle" and (dir == "left" or dir == "right") then
				if dir == "left" then
					hl.dispatch(hl.dsp.layout("cycleprev"))
				else
					hl.dispatch(hl.dsp.layout("cyclenext"))
				end
			else
				hl.dispatch(hl.dsp.focus({ direction = dir }))
			end
		end, "Focus " .. dir .. " window")
		bindm("SHIFT + " .. key, function()
			local workspace = get_workspace()

			if workspace ~= nil and workspace.tiled_layout == "scrolling" and (dir == "left" or dir == "right") then
				hl.dispatch(hl.dsp.layout("swapcol " .. (dir == "left" and "l" or "r")))
			else
				hl.dispatch(hl.dsp.window.move({ direction = dir }))
			end
		end, "Move window " .. dir)
	end
end

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(main_mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(main_mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

bindm("SHIFT + R", hl.dsp.submap("resize"), "Resize Submap")

bindm(
	"R",
	layout_bind({
		scrolling = hl.dsp.layout("colresize +conf"),
	}),
	"Resize Column"
)
bindm(
	"C",
	layout_bind({
		scrolling = hl.dsp.layout("colresize 0.5"),
	}),
	"Maximize Column"
)

define_submap("resize", function()
	bind("C", hl.dsp.layout("colresize +conf"), "Resize Column")
	submap_bind("M", hl.dsp.layout("colresize 1"), "Maximize Column")
	hl.bind(
		"LEFT",
		hl.dsp.window.resize({ x = -20, y = 0, relative = true }),
		{ description = "Resize Left", repeating = true }
	)
	hl.bind(
		"RIGHT",
		hl.dsp.window.resize({ x = 20, y = 0, relative = true }),
		{ description = "Resize Right", repeating = true }
	)
	hl.bind(
		"UP",
		hl.dsp.window.resize({ x = 0, y = -20, relative = true }),
		{ description = "Resize Up", repeating = true }
	)
	hl.bind(
		"DOWN",
		hl.dsp.window.resize({ x = 0, y = 20, relative = true }),
		{ description = "Resize Down", repeating = true }
	)
	hl.bind(
		"H",
		hl.dsp.window.resize({ x = -20, y = 0, relative = true }),
		{ description = "Resize Left", repeating = true }
	)
	hl.bind(
		"L",
		hl.dsp.window.resize({ x = 20, y = 0, relative = true }),
		{ description = "Resize Right", repeating = true }
	)
	hl.bind(
		"K",
		hl.dsp.window.resize({ x = 0, y = -20, relative = true }),
		{ description = "Resize Up", repeating = true }
	)
	hl.bind(
		"J",
		hl.dsp.window.resize({ x = 0, y = 20, relative = true }),
		{ description = "Resize Down", repeating = true }
	)
end)

--------------------- Workspaces ---------------------
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	bindm(key, hl.dsp.focus({ workspace = i }), "Focus Workspace " .. i)
	bindm("SHIFT + " .. key, hl.dsp.window.move({ workspace = i }), "Move Window to Workspace " .. i)
end

bindm("S", hl.dsp.workspace.toggle_special("magic"), "Toggle Special Workspace")
bindm("SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }), "Move Window to Special Workspace")

hl.bind("SUPER + X", function ()
    if hl.get_workspace("special:minimized") then
        hl.dispatch(hl.dsp.window.move({ workspace = hl.get_active_workspace(), window = "tag:minimized" }))
        hl.dispatch(hl.dsp.window.clear_tags({ window = "tag:minimized" }))
    else
        hl.dispatch(hl.dsp.window.tag({ tag = "minimized", window = hl.get_active_window() }))
        hl.dispatch(hl.dsp.window.move({ workspace = "special:minimized", follow = false }))
    end
end)

--------------------- Layouts ---------------------

bindm("SEMICOLON", hl.dsp.submap("layout"), "Layout Submap")

define_submap("layout", function ()
  local function change_and_exit(layout)
      local workspace = get_workspace()

      return function ()
        if not workspace then
          return
        end

        if workspace.special then
          hl.workspace_rule({ workspace = tostring(workspace.name), layout = layout })
        else
          hl.workspace_rule({ workspace = tostring(workspace.id), layout = layout })
        end

        hl.dispatch(hl.dsp.submap("reset"))
      end
  end

  bind("D", change_and_exit("dwindle"), "Set Dwindle Layout")
  bind("S", change_and_exit("scrolling"), "Set Scrolling Layout")
  bind("M", change_and_exit("master"), "Set Master Layout")
  bind("O", change_and_exit("monocle"), "Set Monocle Layout")
end)

--------------------- Monitors ---------------------
bindm("PERIOD", hl.dsp.focus({ monitor = "+1" }), "Focus Next Monitor")
bindm("COMMA", hl.dsp.focus({ monitor = "-1" }), "Focus Previous Monitor")

bindm("SHIFT + PERIOD", hl.dsp.window.move({ monitor = "+1", follow = true }), "Move Window to Next Monitor")
bindm("SHIFT + COMMA", hl.dsp.window.move({ monitor = "-1", follow = true }), "Move Window to Previous Monitor")

bindm("CTRL + PERIOD", hl.dsp.workspace.move({ monitor = "+1" }), "Move Workspace to Next Monitor")
bindm("CTRL + COMMA", hl.dsp.workspace.move({ monitor = "-1" }), "Move Workspace to Previous Monitor")

--------------------- Notifications ---------------------
bindm("N", submenu("n"), "Notifications")

--------------------- Media ---------------------
-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", system_action("volume up"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", system_action("volume down"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", system_action("volume mute"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", system_action("mic mute"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", system_action("brightness up"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", system_action("brightness down"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", system_action("media next"), { locked = true })
hl.bind("XF86AudioPause", system_action("media toggle"), { locked = true })
hl.bind("XF86AudioPlay", system_action("media toggle"), { locked = true })
hl.bind("XF86AudioPrev", system_action("media previous"), { locked = true })

-- # ------------------- Groups -------------------
-- bindd = $mainMod SHIFT, G, Toggle Window into Group, togglegroup
-- bindd = $mainMod, G, Change Active Window in Group, changegroupactive, f
-- bindd = $mainMod CTRL, G, Move Window out of Group, moveoutofgroup
--
-- bindd = $mainMod SHIFT CTRL, left, Move Window into Left Group, moveintogroup, l
-- bindd = $mainMod SHIFT CTRL, right, Move Window into Right Group, moveintogroup, r
-- bindd = $mainMod SHIFT CTRL, up, Move Window into Above Group, moveintogroup, u
-- bindd = $mainMod SHIFT CTRL, down, Move Window into Below Group, moveintogroup, d
-- bindd = $mainMod SHIFT CTRL, h, Move Window into Left Group, moveintogroup, l
-- bindd = $mainMod SHIFT CTRL, l, Move Window into Right Group, moveintogroup, r
-- bindd = $mainMod SHIFT CTRL, k, Move Window into Above Group, moveintogroup, u
-- bindd = $mainMod SHIFT CTRL, j, Move Window into Below Group, moveintogroup, d
