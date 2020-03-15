local GridUI = include("lib/libgrid_ui")
local button = include("lib/button")
local rect = include("lib/rect")

function init()
  local g = grid.connect()
  local gridui = GridUI.new{grid=g}
  local button1 = button.new{x=1, y=1, 
    action = function(options) print("I'm button 1: " .. options.val) end 
  }
  local button2 = button.new{x=3, y=3, width=2, height=2, momentary=1,
    action = function(options) 
      if options.val == 1 then
        print("I'm button 2 " .. options.control.id .. " and I'm turning off button 1") 
        button1:set(false)
      end
    end 
  }
  gridui:add(button1)
  gridui:add(button2)
  gridui:add(rect.new{x = 5, y = 5, width = 4, height = 4, stroke_brightness = 13, fill_brightness = 8})
end