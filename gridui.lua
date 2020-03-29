local GridUI = include("lib/libgrid_ui")
local Button = include("lib/button")
local Fader = include("lib/fader")
local Rect = include("lib/rect")
local GroupButtons = include("lib/group_button")

local ControlSpec = require 'controlspec'
local Formatters = require 'formatters'

local inspect = include("lib/inspect")

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
    width = 4,
    height = 2,
    value = 1.0,
    direction = "right"
  })
  
  gridui:add(Fader {
    x = 5,
    y = 1,
    width = 4,
    height = 2,
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
    momentary = true,
    columns = 4,
    rows = 1,
    action = function(options)
      for i = 1, 4 do
        if i == options.group_position.index then
          options.group:set_index_level(i, 10)
        else
          options.group:set_index_level(i, 4)
        end
      end
    end
  }
  gridui:add(gb_unique)

  local gb_range = GroupButtons.new {
    x = 10,
    y = 8,
    width = 1,
    height = 1,
    momentary = true,
    columns = 6,
    rows = 1,
    action = function(options)
      if options.group:get_pressed_count() == 2 then
        local minmax = options.group:get_pressed_min_max()
        print(inspect(minmax))
        for i = 1, 6 do
          if i >= minmax.min and i <= minmax.max then
            options.group:set_index_level(i, 10)
          else
            options.group:set_index_level(i, 4)
          end
        end
      end
    end
  }
  gridui:add(gb_range)

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