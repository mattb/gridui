local GridUI = include("lib/libgrid_ui")
local button = include("lib/button")

local counter = metro.init()

function init()
  local g = grid.connect()
  local gridui = GridUI.new{grid=g}
  local button1 = button.new{id="b1", x=1, y=1, 
    action = function(val) print("I'm button 1: " .. val) end 
  }
  local button2 = button.new{id="b2", x=3, y=3, width=2, height=2, momentary=1,
    action = function(val) 
      if val == 1 then
        print("I'm button 2: " .. val .. " and I'm turning off button 1") 
        button1:set(false)
      end
    end 
  }
  gridui:add(button1)
  gridui:add(button2)
  counter.time = 1/15
  counter.count = -1
  counter.event = function()
    gridui:update()
  end
  counter:start()
end