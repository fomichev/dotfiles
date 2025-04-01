local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- TODO:
-- https://wezfurlong.org/wezterm/config/lua/keyassignment/ActivateKeyTable.html
-- https://wezfurlong.org/wezterm/config/lua/keyassignment/ActivateCommandPalette.html
-- https://wezfurlong.org/wezterm/config/lua/keyassignment/ActivateCopyMode.html
-- https://wezfurlong.org/wezterm/copymode.html

config.font = wezterm.font('CommitMono Nerd Font')
config.font_size = 18

config.window_decorations = 'INTEGRATED_BUTTONS'
config.use_fancy_tab_bar = false
config.disable_default_key_bindings = true

--config.color_scheme = 'Tokyo Night'
--config.leader = { key = 'LeftAlt', timeout_milliseconds = 1000 }

wezterm.on('update-status', function(window, _)
  local name = window:active_key_table()
  if name then
    name = 'TABLE: ' .. name
  else
    name = 'n/a'
  end


  local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider
  local segments = {
    name,
    window:active_workspace(),
    wezterm.strftime('%a %b %-d %H:%M'),
    wezterm.hostname(),
  }

  local bg = wezterm.color.parse('gray')
  local fg = wezterm.color.parse('white')

  local gradient_to, gradient_from = bg, bg
  gradient_from = gradient_to:lighten(0.2)

  local gradient = wezterm.color.gradient(
    {
      orientation = 'Horizontal',
      colors = { gradient_from, gradient_to },
    },
    #segments
  )

  local elements = {}

  for i, seg in ipairs(segments) do
    local is_first = i == 1

    if is_first then
      table.insert(elements, { Background = { Color = 'none' } })
    end
    table.insert(elements, { Foreground = { Color = gradient[i] } })
    table.insert(elements, { Text = SOLID_LEFT_ARROW })

    table.insert(elements, { Foreground = { Color = fg } })
    table.insert(elements, { Background = { Color = gradient[i] } })
    table.insert(elements, { Text = ' ' .. seg .. ' ' })
  end

  window:set_right_status(wezterm.format(elements))
end)

local function move_tab(nr)
  return {
    key = tostring(nr),
    mods = 'ALT',
    action = wezterm.action.ActivateTab(nr - 1),
  }
end

local function move_pane(key, direction)
  return {
    key = key,
    mods = 'ALT',
    action = wezterm.action.ActivatePaneDirection(direction),
  }
end

local function resize_pane(key, direction)
  return {
    key = key,
    mods = 'ALT',
    action = wezterm.action.AdjustPaneSize { direction, 5 }
  }
end

config.skip_close_confirmation_for_processes_named = {}

config.keys = {
  {
    key = 'c',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.CopyTo 'Clipboard',
  },
  {
    key = 'v',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.PasteFrom 'Clipboard',
  },

  {
    key = '-',
    mods = 'CTRL',
    action = wezterm.action.DecreaseFontSize,
  },
  {
    key = '=',
    mods = 'CTRL',
    action = wezterm.action.IncreaseFontSize,
  },
  {
    key = '0',
    mods = 'CTRL',
    action = wezterm.action.ResetFontSize,
  },

  {
    key = 'c',
    mods = 'ALT',
    action = wezterm.action.SpawnTab 'CurrentPaneDomain',
  },
  {
    key = 's',
    mods = 'ALT',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  {
    key = 'v',
    mods = 'ALT',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },

  move_tab(1),
  move_tab(2),
  move_tab(3),
  move_tab(4),
  move_tab(5),
  move_tab(6),
  move_tab(7),
  move_tab(8),
  move_tab(9),

  {
    key = 'w',
    mods = 'ALT',
    action = wezterm.action.CloseCurrentTab { confirm = true },
  },

  {
    key = 'y',
    mods = 'ALT',
    action = wezterm.action.ActivateKeyTable {
      name = 'yank',
      one_shot = false,
    },
  },



  move_pane('j', 'Down'),
  move_pane('k', 'Up'),
  move_pane('h', 'Left'),
  move_pane('l', 'Right'),
  resize_pane('=', 'Down'),
  resize_pane('-', 'Up'),
  resize_pane('[', 'Left'),
  resize_pane(']', 'Right'),

--  {
--    -- When we push LEADER + R...
--    key = 'r',
--    mods = 'LEADER',
--    -- Activate the `resize_panes` keytable
--    action = wezterm.action.ActivateKeyTable {
--      name = 'resize_panes',
--      -- Ensures the keytable stays active after it handles its
--      -- first keypress.
--      one_shot = false,
--      -- Deactivate the keytable after a timeout.
--      timeout_milliseconds = 1000,
--    }
--  },
--  {
--    key = 'f',
--    mods = 'LEADER',
--    -- Present a list of existing workspaces
--    action = wezterm.action.ShowLauncherArgs { flags = 'FUZZY|WORKSPACES' },
--  },
}

config.key_tables = {
  yank = {
  {
      key = 'y',
      --mods = 'CTRL',
      action = wezterm.action.ScrollByPage(-1),
  },
  {
      key = 'd',
      --mods = 'CTRL',
      action = wezterm.action.ScrollByPage(1),
  },
  {
    key = '?',
    action = wezterm.action.Search {CaseSensitiveString=""},
  },
  {
    key = 'q',
    action = wezterm.action.PopKeyTable,
  },
  },
}

return config
