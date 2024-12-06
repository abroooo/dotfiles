-- config based on https://github.com/KevinSilvester/wezterm-config
local Config = require('config')

require('utils.backdrops')
   :set_files()
   -- :set_focus('#000000')
   :random()

require('events.right-status').setup()
require('events.left-status').setup()
require('events.tab-title').setup()
require('events.new-tab-button').setup()
require('utils.mouse')

return Config:init()
   :append(require('config.appearance'))
   :append(require('config.bindings'))
   :append(require('config.domains'))
   :append(require('config.fonts'))
   :append(require('config.general'))
   :append(require('config.launch')).options
