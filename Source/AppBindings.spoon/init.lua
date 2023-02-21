local AppBindings = {}

-- Metadata
AppBindings.name = "AppBindings"
AppBindings.version = "1.1"
AppBindings.author = "Robert Chung <robertchung97@gmail.com>"
AppBindings.homepage = "https://github.com/robertchung97/remap-keys-spoon"
AppBindings.license = "MIT - https://opensource.org/licenses/MIT"

local logger = hs.logger.new("AppBindings", "debug")
AppBindings.logger = logger

function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

---------------------------
-- INIT
---------------------------
function AppBindings:init()
    self.__hotkeys = {}
    self.__inited = true
    return self
end


function AppBindings:pressFn(sequence)
    return function()
        for _, sequenceItem in pairs(sequence) do
            hs.eventtap.event.newKeyEvent(sequenceItem.modifiers, sequenceItem.key, true):post()
        end
    end
end

function AppBindings:appRemap(from, to)
    local fn = self:pressFn(to.sequence)
    return hs.hotkey.new(from.modifiers, from.key, fn, nil, fn)
end

-- Listen to _window_ events and see if the user went out of focus.
function AppBindings:start()
    local hotkeys = self.__hotkeys

    hs.window.filter.default:subscribe(hs.window.filter.windowFocused, function(_, appName)
        for appTitle, hk in pairs(hotkeys) do
            for _, hotkey in pairs(hk) do
                if (appName == appTitle) then
                    hotkey:enable()
                else
                    hotkey:disable()
                end
            end
        end
    end)

    return self
end


-- Translate user input keymap to hs.hotkey functions
function AppBindings:keymapToHotkeys(appTitle, keymaps)
    for _, val in ipairs(keymaps) do
        local from = val.from
        local to = val.to

        local app = self.__hotkeys[appTitle] or {}
        table.insert(app, self:appRemap(from, to))
        self.__hotkeys[appTitle] = app
    end

    return self
end

function AppBindings:bind(appTitle, keymaps)
    self.logger.d("Found binding for app " .. appTitle)
    self:keymapToHotkeys(appTitle, keymaps)

    return self
end

return AppBindings

