local GridUI = include("lib/libgrid_ui")
local Button = include("lib/button")
local Rect = include("lib/rect")
local GroupButtons = include("lib/group_button")

function init()
  local g = grid.connect()
  local gridui = GridUI.new{grid=g}
  local button1 = Button.new{x=1, y=1, 
    action = function(options) print("I'm button 1: " .. options.val) end 
  }
  local button2 = Button.new{x=3, y=3, width=2, height=2, momentary=1,
    action = function(options) 
      if options.val == 1 then
        print("I'm button 2 " .. options.control.id .. " and I'm turning off button 1") 
        button1:set(false)
      end
    end 
  }
  gridui:add(button1)
  gridui:add(button2)
  gridui:add(Rect.new{x = 5, y = 5, width = 4, height = 4, stroke_brightness = 13, fill_brightness = 8})
  gridui:add(Rect.new{x = 5, y = 5, width = 4, height = 4, stroke_brightness = 13, fill_brightness = 8})

  local gb = GroupButtons.new{x=10, y=1, width = 2, height = 2, momentary = false, columns=3, rows=2,
    action = function(options) print("I'm a grid button: " .. options.group_position.x .. "/" .. options.group_position.y .. ": " .. options.val) end 
  }
  gridui:add(gb)
  
  local gb_unique = GroupButtons.new{x=10, y=6, width = 1, height = 1, momentary = false, columns=4, rows=1,
    action = function(options)
      options.group:set_all(0)
      options.group:set_index(options.group_position.index, 1)
    end
  }
  gridui:add(gb_unique)
end