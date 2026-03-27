-- config based on https://github.com/KevinSilvester/wezterm-config
-- local Config = require('config')
--
-- require('utils.backdrops')
--    :set_files()
--    -- :set_focus('#000000')
--    :random()
--
-- require('events.right-status').setup()
-- require('events.left-status').setup()
-- require('events.tab-title').setup()
-- require('events.new-tab-button').setup()
-- require('utils.mouse')
--
-- return Config:init()
--    :append(require('config.appearance'))
--    :append(require('config.bindings'))
--    :append(require('config.domains'))
--    :append(require('config.fonts'))
--    :append(require('config.general'))
--    :append(require('config.launch')).options

-- TODO: remove old config and clean up here
local wezterm = require('wezterm')
local config = {}

-- font
config.font = wezterm.font('JetBrains Mono', { weight = 'Regular' })
config.font_size = 13.0
config.line_height = 1.0

-- appearance
config.color_scheme = 'tokyonight-storm'
config.window_decorations = 'RESIZE'
config.hide_tab_bar_if_only_one_tab = true
config.window_padding = {
   left = 0,
   right = 0,
   top = 0,
   bottom = 0,
}
-- TODO: custom command for disabling background image
config.window_background_image = '/home/alex/.config/wezterm/backdrops/nord-space.png'
config.window_background_image_hsb = {
   brightness = 0.1,
   -- hue = 40.0,
   saturation = 1.0,
}

-- mouse
config.mouse_bindings = {
   {
      event = { Up = { streak = 1, button = 'Left' } },
      mods = 'NONE',
      action = wezterm.action({ CompleteSelectionOrOpenLinkAtMouseCursor = 'Clipboard' }),
      -- NOTE: the default action is:
      -- action=wezterm.action{CompleteSelectionOrOpenLinkAtMouseCursor="PrimarySelection"},
   },
}

-- config.default_prog = { 'tmux', 'a', '||', 'tmux' }
-- config.default_prog = { 'zsh', '-c', 'tmux attach || tmux' }
-- config.default_prog =
--    { 'zsh', '-c', [[
--     (tmux attach -t mysession || tmux new -s mysession); zsh
--  '-l', ]] }
config.adjust_window_size_when_changing_font_size = false
return config
