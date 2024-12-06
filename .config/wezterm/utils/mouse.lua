local wezterm = require('wezterm')
return {
   mouse_bindings = {
      -- Change the default click behavior so that it populates
      -- the Clipboard rather the PrimarySelection.
      {
         event = { Up = { streak = 1, button = 'Left' } },
         mods = 'NONE',
         action = wezterm.action.CompleteSelectionOrOpenLinkAtMouseCursor('Clipboard'),
      },
   },
}
