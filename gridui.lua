local GridUI = include("lib/libgrid_ui")
local Button = include("lib/button")
local Fader = include("lib/fader")
local Rect = include("lib/rect")
local GroupButtons = include("lib/group_button")

local ControlSpec = require 'controlspec'
local Formatters = require 'formatters'

local g = grid.connect()
local gridui = GridUI.new {grid = g}

function init()
  local button1 = Button {
    x = 1,
    y = 1,
    action = function(options) print("I'm button 1: " .. options.val) end
  }
  local button2 = Button {
    x = 3,
    y = 3,
    width = 2,
    height = 2,
    momentary = 1,
    action = function(options)
      if options.val == 1 then
        print("I'm button 2 " .. options.control.id ..
                  " and I'm turning off button 1")
        button1:set(false)
      end
    end
  }
  gridui:add(button1)
  gridui:add(button2)
  gridui:add(Rect {
    x = 5,
    y = 5,
    width = 4,
    height = 4,
    stroke_brightness = 13,
    fill_brightness = 8
  })

  gridui:add(Fader {
    x = 1,
    y = 5,
    width = 1,
    height = 4,
    value = 1.0,
    direction = "up"
  })
  
  gridui:add(Fader {
    x = 5,
    y = 1,
    width = 4,
    height = 2,
    value = 0.5,
    direction = "left"
  })

  local gb = GroupButtons.new {
    x = 10,
    y = 1,
    width = 2,
    height = 2,
    momentary = false,
    columns = 3,
    rows = 2,
    action = function(options)
      print("I'm a grid button: " .. options.group_position.x .. "/" ..
                options.group_position.y .. ": " .. options.val)
    end
  }
  gridui:add(gb)

  local gb_unique = GroupButtons.new {
    x = 10,
    y = 6,
    width = 1,
    height = 1,
    momentary = false,
    columns = 4,
    rows = 1,
    action = function(options)
      options.group:set_all(0)
      options.group:set_index(options.group_position.index, 1)
    end
  }
  gridui:add(gb_unique)

  params:add{
    type = 'control',
    id = 'loop_index',
    name = 'Dim',
    controlspec = ControlSpec.new(0, 1, 'lin', 0.05, 100, '%'),
    formatter = Formatters.percentage,
    action = function(value) 
      gridui:set_dim(value)
      gridui:update()
    end
  }
  
end

function redraw() 
  screen.clear()
  gridui:draw_on_screen()
  screen.update()
end