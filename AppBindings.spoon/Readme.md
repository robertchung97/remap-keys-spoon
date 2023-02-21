# Spoons

## AppBindings.spoon

This spoon allows you to easily set custom app-specific key bindings.

Just provide the app name as seen in the menubar and a mapping from and to new keyboard shortcut.

### Installation

Clone into your `~/.hammerspoon/Spoons/` directory

**Configure:** Add to your `init.lua`

```lua
hs.loadSpoon("AppBindings")
```

Example:

```lua
-- App Specific Bindings

local bindings = hs.loadSpoon("AppBindings")
bindings:bind('Alacritty', {
    {
        from = { modifiers = {'ctrl'}, key = 'tab'},
          to = { sequence = {
                   { modifiers = {'ctrl'}, key = 'b'},
                   { modifiers = {'ctrl'}, key = 'l'}
               }}
    },
    {
        from = { modifiers = {'ctrl', 'shift'}, key = 'tab'},
          to = { sequence = {
                   { modifiers = {'ctrl'}, key = 'b'},
                   { modifiers = {'ctrl'}, key = 'h'}
               }}
    },
})
bindings:start()
```

Don't forget to save and reload Hammerspoon configuration.
