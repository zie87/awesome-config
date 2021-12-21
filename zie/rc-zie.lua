-------------------------------------------------------------------------------
--                      Colorless config                                     --
-------------------------------------------------------------------------------

-- Load modules
-------------------------------------------------------------------------------

-- Standard awesome library
------------------------------------------------------------
local awful = require "awful"
local wibox = require "wibox"
local beautiful = require "beautiful"

require "awful.autofocus"

-- User modules
------------------------------------------------------------
local redflat = require "redflat"

redflat.startup:activate()

-- Error handling
-------------------------------------------------------------------------------
require "zie.ercheck-config"

-- Setup theme and environment vars
-------------------------------------------------------------------------------
local env = require "zie.env-config"
env:init()

-- Layouts setup
-------------------------------------------------------------------------------
local layouts = require "zie.layout-config"
layouts:init()

-- Main menu configuration
-------------------------------------------------------------------------------
local mymenu = require "zie.menu-config"
mymenu:init { env = env }

-- Panel widgets
-------------------------------------------------------------------------------

-- Separator
-------------------------------------------------------------------------------
local separator = redflat.gauge.separator.vertical()

-- Tasklist
-------------------------------------------------------------------------------
local tasklist = {}

tasklist.buttons = awful.util.table.join(
  awful.button({}, 1, redflat.widget.tasklist.action.select),
  awful.button({}, 2, redflat.widget.tasklist.action.close),
  awful.button({}, 3, redflat.widget.tasklist.action.menu),
  awful.button({}, 4, redflat.widget.tasklist.action.switch_next),
  awful.button({}, 5, redflat.widget.tasklist.action.switch_prev)
)

-- Taglist widget
-------------------------------------------------------------------------------
local taglist = {}
taglist.style = { widget = redflat.gauge.tag.orange.new, show_tip = true }
taglist.buttons = awful.util.table.join(
  awful.button({}, 1, function(t)
    t:view_only()
  end),
  awful.button({ env.mod }, 1, function(t)
    if client.focus then
      client.focus:move_to_tag(t)
    end
  end),
  awful.button({}, 2, awful.tag.viewtoggle),
  awful.button({}, 3, function(t)
    redflat.widget.layoutbox:toggle_menu(t)
  end),
  awful.button({ env.mod }, 3, function(t)
    if client.focus then
      client.focus:toggle_tag(t)
    end
  end),
  awful.button({}, 4, function(t)
    awful.tag.viewnext(t.screen)
  end),
  awful.button({}, 5, function(t)
    awful.tag.viewprev(t.screen)
  end)
)

-- Textclock widget
--------------------------------------------------------------------------------
local textclock = {}
textclock.widget = redflat.widget.textclock { timeformat = "%H:%M", dateformat = "%b  %d  %a" }

-- Layoutbox configure
--------------------------------------------------------------------------------
local layoutbox = {}

layoutbox.buttons = awful.util.table.join(
  awful.button({}, 1, function()
    awful.layout.inc(1)
  end),
  awful.button({}, 3, function()
    redflat.widget.layoutbox:toggle_menu(mouse.screen.selected_tag)
  end),
  awful.button({}, 4, function()
    awful.layout.inc(1)
  end),
  awful.button({}, 5, function()
    awful.layout.inc(-1)
  end)
)

-- Tray widget
--------------------------------------------------------------------------------
local tray = {}
tray.widget = redflat.widget.minitray()

tray.buttons = awful.util.table.join(awful.button({}, 1, function()
  redflat.widget.minitray:toggle()
end))

-- PA volume control
--------------------------------------------------------------------------------
local volume = {}
volume.widget = redflat.widget.pulse(nil, { widget = redflat.gauge.audio.blue.new })

-- activate player widget
-- redflat.float.player:init({ name = env.player })

volume.buttons = awful.util.table.join(
  awful.button({}, 4, function()
    volume.widget:change_volume()
  end),
  awful.button({}, 5, function()
    volume.widget:change_volume { down = true }
  end),
  awful.button({}, 2, function()
    volume.widget:mute()
  end)
  -- awful.button({}, 3, function() redflat.float.player:show()                  end),
  -- awful.button({}, 1, function() redflat.float.player:action("PlayPause")     end),
  -- awful.button({}, 8, function() redflat.float.player:action("Previous")      end),
  -- awful.button({}, 9, function() redflat.float.player:action("Next")          end)
)

-- Screen setup
-----------------------------------------------------------------------------------------------------------------------
awful.screen.connect_for_each_screen(function(s)
  -- wallpaper
  env.wallpaper(s)

  -- tags
  awful.tag({ "Tag1", "Tag2", "Tag3", "Tag4", "Tag5" }, s, awful.layout.layouts[1])

  -- layoutbox widget
  layoutbox[s] = redflat.widget.layoutbox { screen = s }

  -- taglist widget
  taglist[s] = redflat.widget.taglist({ screen = s, buttons = taglist.buttons, hint = env.tagtip }, taglist.style)

  -- tasklist widget
  tasklist[s] = redflat.widget.tasklist { screen = s, buttons = tasklist.buttons }

  -- panel wibox
  s.panel = awful.wibar { position = "bottom", screen = s, height = beautiful.panel_height or 36 }

  -- add widgets to the wibox
  s.panel:setup {
    layout = wibox.layout.align.horizontal,
    { -- left widgets
      layout = wibox.layout.fixed.horizontal,

      env.wrapper(mymenu.widget, "mainmenu", mymenu.buttons),
      separator,
      env.wrapper(taglist[s], "taglist"),
      separator,
      s.mypromptbox,
    },
    { -- middle widget
      layout = wibox.layout.align.horizontal,
      expand = "outside",

      nil,
      env.wrapper(tasklist[s], "tasklist"),
    },
    { -- right widgets
      layout = wibox.layout.fixed.horizontal,

      separator,
      env.wrapper(volume.widget, "volume", volume.buttons),
      separator,
      env.wrapper(layoutbox[s], "layoutbox", layoutbox.buttons),
      separator,
      env.wrapper(textclock.widget, "textclock"),
      separator,
      env.wrapper(tray.widget, "tray", tray.buttons),
    },
  }
end)

-- Key bindings
-----------------------------------------------------------------------------------------------------------------------
local hotkeys = require "zie.keys-config"
hotkeys:init { env = env, menu = mymenu.mainmenu }

-- Rules
-----------------------------------------------------------------------------------------------------------------------
local rules = require "zie.rules-config"
rules:init { hotkeys = hotkeys }

-- Titlebar setup
-----------------------------------------------------------------------------------------------------------------------
local titlebar = require "zie.titlebar-config"
titlebar:init()

-- Base signal set for awesome wm
-----------------------------------------------------------------------------------------------------------------------
local signals = require "zie.signals-config"
signals:init { env = env }
