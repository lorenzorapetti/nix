hl.config {
  binds = {
    hide_special_on_workspace_change = true,
    workspace_center_on = 1,
    movefocus_cycles_groupfirst = true,
    drag_threshold = 10,
  },
}

local browser = 'helium-browser'
local terminal = 'alacritty'
local file_manager = 'nautilus'
local main_mod = 'SUPER'

local function quick_terminal(command)
  return string.format('quick_terminal "%s"', command)
end

local function vicinae_app(app)
  return string.format('vicinae vicinae://launch/applications/%s', app)
end

local function bind(key, action, description)
  hl.bind(key, action, { description = description })
end

local function bindm(key, action, description)
  hl.bind(main_mod .. ' + ' .. key, action, { description = description })
end

local function exec(cmd)
  return hl.dsp.exec_cmd(cmd)
end

local function run_app(app)
  return exec('runapp ' .. app)
end

local function system_action(action)
  return exec('system-action ' .. action)
end

local function define_submap(name, callback)
  hl.define_submap(name, function()
    callback()

    bind('ESCAPE', hl.dsp.submap 'reset', 'Exit Submap')
    bind('CAPS_LOCK', hl.dsp.submap 'reset', 'Exit Submap')
  end)
end

local function submap_bind(key, action, description)
  hl.bind(key, function()
    hl.dispatch(action)
    hl.dsp.submap 'reset'
  end, { description = description })
end

--------------------- Programs ---------------------
bindm('RETURN', run_app(terminal), 'Open Terminal')
bindm('B', exec(vicinae_app 'helium'), 'Open Browser')
bindm('E', exec(quick_terminal 'yazi'), 'Open Terminal File Manager')
bindm('D', exec(quick_terminal 'bluetui'), 'Open Bluetooth Settings')
bindm('V', exec(quick_terminal 'wiremix'), 'OpenVolume Control')
bindm('GRAVE', exec 'vicinae vicinae://launch/@nino-mau/store.vicinae.hypr/windows', 'Switch Windows')
bindm('SHIFT + E', exec(vicinae_app 'org.gnome.Nautilus'), 'Open File Manager')

--------------------- Launchers ---------------------
bindm('SPACE', exec 'vicinae toggle', 'Toggle Launcher')
bindm('SHIFT + SPACE', run_app '1password --quick-access', 'Toggle 1Password')
bindm('Y', exec 'vicinae vicinae://extensions/vicinae/clipboard/history', 'Toggle Clipboard History')
bindm('O', exec 'wlr-which-key', 'Which Key')

bindm('ESCAPE', system_action 'session lock', 'Lock Screen')
bindm('CAPS_LOCK', system_action 'session lock', 'Lock Screen')
bindm('SHIFT + ESCAPE', system_action 'session menu-toggle', 'Power Menu')
bindm('SHIFT + CAPS_LOCK', system_action 'session menu-toggle', 'Power Menu')

local exit_hyprland = 'command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch "hl.dsp.exit()"'
bindm('CTRL + ESCAPE', exec(exit_hyprland), 'Exit Hyprland')
bindm('CTRL + CAPS_LOCK', exec(exit_hyprland), 'Exit Hyprland')

--------------------- Screenshot ---------------------
bind('PRINT', system_action 'screenshot region', 'Screenshot of region')
bind('SHIFT + PRINT', exec 'screenshot window', 'Screenshot of window')
bind('CTRL + PRINT', exec 'screenshot output', 'Screenshot of display')

bindm('PRINT', hl.dsp.submap 'screenshot', 'Screenshot Submap')

define_submap('screenshot', function()
  submap_bind('S', system_action 'screenshot region', 'Screenshot of region')
  submap_bind('W', exec 'screenshot window', 'Screenshot of window')
  submap_bind('R', system_action 'screenrecord start', 'Screenrecord')
  submap_bind('SHIFT + R', system_action 'screenrecord stop', 'Stop Screenrecord')
end)

--------------------- Apps ---------------------
bindm('A', exec 'wlr-which-key --initial-keys a', 'Apps')

--------------------- Windows ---------------------
bindm('Q', hl.dsp.window.close(), 'Close Current Window')
bindm('SHIFT + F', hl.dsp.window.float { action = 'toggle' }, 'Toggle Floating')

bindm('F', function()
  local window = hl.get_active_window()
  if not window then
    return
  end

  if window.floating then
    hl.dispatch(hl.dsp.window.cycle_next { next = true, floating = false, tiling = true })
  else
    hl.dispatch(hl.dsp.window.cycle_next { next = true, floating = true, tiling = false })
  end
end, 'Toggle Floating')

bindm('M', hl.dsp.window.fullscreen { action = 'toggle', mode = 'maximized' }, 'Toggle Maximize')
bindm('P', function()
  local window = hl.get_active_window()
  if not window then
    return
  end

  if not window.floating then
    hl.dispatch(hl.dsp.window.float { action = 'set' })
  end

  hl.dispatch(hl.dsp.window.pin())
end, 'Pin Window')
bindm('tab', hl.dsp.focus { last = true }, 'Focus Current or Last Window')

local directions = {
  left = { 'LEFT', 'H' },
  right = { 'RIGHT', 'L' },
  up = { 'UP', 'K' },
  down = { 'DOWN', 'J' },
}

for dir, keys in pairs(directions) do
  for _, key in ipairs(keys) do
    bindm(key, function()
      local workspace = hl.get_active_workspace()

      if workspace ~= nil and workspace.tiled_layout == 'scrolling' and (dir == 'left' or dir == 'right') then
        hl.dispatch(hl.dsp.layout('focus ' .. (dir == 'left' and 'l' or 'r')))
      else
        hl.dispatch(hl.dsp.focus { direction = dir })
      end
    end, 'Focus ' .. dir .. ' window')
    bindm('SHIFT + ' .. key, function()
      local workspace = hl.get_active_workspace()

      if workspace ~= nil and workspace.tiled_layout == 'scrolling' and (dir == 'left' or dir == 'right') then
        hl.dispatch(hl.dsp.layout('swapcol ' .. (dir == 'left' and 'l' or 'r')))
      else
        hl.dispatch(hl.dsp.window.move { direction = dir })
      end
    end, 'Move window ' .. dir)
    -- bind('CTRL + ' .. key, hl.dsp.window.move(dir), 'Move window ' .. dir)
  end
end

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(main_mod .. ' + mouse:272', hl.dsp.window.drag(), { mouse = true })
hl.bind(main_mod .. ' + mouse:273', hl.dsp.window.resize(), { mouse = true })

bindm('R', hl.dsp.submap 'resize', 'Resize Submap')

define_submap('resize', function()
  bind('C', hl.dsp.layout 'colresize +conf', 'Resize Column')
  submap_bind('M', hl.dsp.layout 'colresize 1', 'Maximize Column')
  hl.bind('LEFT', hl.dsp.window.resize { x = -20, y = 0, relative = true }, { description = 'Resize Left', repeating = true })
  hl.bind('RIGHT', hl.dsp.window.resize { x = 20, y = 0, relative = true }, { description = 'Resize Right', repeating = true })
  hl.bind('UP', hl.dsp.window.resize { x = 0, y = -20, relative = true }, { description = 'Resize Up', repeating = true })
  hl.bind('DOWN', hl.dsp.window.resize { x = 0, y = 20, relative = true }, { description = 'Resize Down', repeating = true })
  hl.bind('H', hl.dsp.window.resize { x = -20, y = 0, relative = true }, { description = 'Resize Left', repeating = true })
  hl.bind('L', hl.dsp.window.resize { x = 20, y = 0, relative = true }, { description = 'Resize Right', repeating = true })
  hl.bind('K', hl.dsp.window.resize { x = 0, y = -20, relative = true }, { description = 'Resize Up', repeating = true })
  hl.bind('J', hl.dsp.window.resize { x = 0, y = 20, relative = true }, { description = 'Resize Down', repeating = true })
end)

--------------------- Workspaces ---------------------
for i = 1, 10 do
  local key = i % 10 -- 10 maps to key 0
  bindm(key, hl.dsp.focus { workspace = i }, 'Focus Workspace ' .. i)
  bindm('SHIFT + ' .. key, hl.dsp.window.move { workspace = i }, 'Move Window to Workspace ' .. i)
end

bindm('S', hl.dsp.workspace.toggle_special 'magic', 'Toggle Special Workspace')
bindm('SHIFT + S', hl.dsp.window.move { workspace = 'special:magic' }, 'Move Window to Special Workspace')

--------------------- Groups ---------------------

--------------------- Monitors ---------------------
bindm('PERIOD', hl.dsp.focus { monitor = '+1' }, 'Focus Next Monitor')
bindm('COMMA', hl.dsp.focus { monitor = '-1' }, 'Focus Previous Monitor')

bindm('SHIFT + PERIOD', hl.dsp.window.move { monitor = '+1', follow = true }, 'Move Window to Next Monitor')
bindm('SHIFT + COMMA', hl.dsp.window.move { monitor = '-1', follow = true }, 'Move Window to Previous Monitor')

bindm('CTRL + PERIOD', hl.dsp.workspace.move { monitor = '+1' }, 'Move Workspace to Next Monitor')
bindm('CTRL + COMMA', hl.dsp.workspace.move { monitor = '-1' }, 'Move Workspace to Previous Monitor')

--------------------- Notifications ---------------------
bindm('N', exec 'wlr-which-key --initial-keys n', 'Notifications')

--------------------- Media ---------------------
-- Laptop multimedia keys for volume and LCD brightness
hl.bind('XF86AudioRaiseVolume', system_action 'volume up', { locked = true, repeating = true })
hl.bind('XF86AudioLowerVolume', system_action 'volume down', { locked = true, repeating = true })
hl.bind('XF86AudioMute', system_action 'volume mute', { locked = true, repeating = true })
hl.bind('XF86AudioMicMute', system_action 'mic mute', { locked = true, repeating = true })
hl.bind('XF86MonBrightnessUp', system_action 'brightness up', { locked = true, repeating = true })
hl.bind('XF86MonBrightnessDown', system_action 'brightness down', { locked = true, repeating = true })

-- Requires playerctl
hl.bind('XF86AudioNext', system_action 'media next', { locked = true })
hl.bind('XF86AudioPause', system_action 'media toggle', { locked = true })
hl.bind('XF86AudioPlay', system_action 'media toggle', { locked = true })
hl.bind('XF86AudioPrev', system_action 'media previous', { locked = true })

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
