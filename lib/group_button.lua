local Button = include("lib/button")
local inspect = include("lib/inspect")

local GridGroupButtons = {}
GridGroupButtons.__index = GridGroupButtons

function GridGroupButtons.new(options)
  local s = setmetatable({}, GridGroupButtons)

  s.id = options.id
  s.x = options.x
  s.y = options.y
  s.width = options.width or 1
  s.height = options.height or 1
  s.brightness = options.brightness or 13
  s.momentary = options.momentary or nil
  s.action = options.action or function(val) end
  s.columns = options.columns
  s.rows = options.rows

  return s
end

function GridGroupButtons:on_add(grid_ui)
  self.buttons = {}
  local bx = self.x
  local by = self.y

  for i = 1, self.rows do
    for j = 1, self.columns do
      local button = Button.new{x=bx,
        y=by,
        group=self,
        width=self.width,
        height=self.height, 
        momentary=self.momentary,
        action = function(options) 
          self.action({
            control=options.control,
            group=self,
            val=options.val,
            group_position=self:control_local_vars(options.control)
          })
        end 
      }
      table.insert(self.buttons, button)
      grid_ui:add(button)
      bx = bx + self.width
    end
    by = by + self.height
    bx = self.x
  end
end

function GridGroupButtons:control_local_vars(control)
  local x = control.x
  x = x - self.x
  x = math.floor(x / self.width)

  local y = control.y
  y = y - self.y
  y = math.floor(y / self.height)

  return {
    x=x + 1,
    y=y + 1,
    index=x + y*self.columns + 1
  }
end

function GridGroupButtons:keys()
  return {}
end

function GridGroupButtons:draw(led)
  for _, b in pairs(self.buttons) do b:draw(led) end
end

function GridGroupButtons:set_all(val)
  for _, b in pairs(self.buttons) do b:set(val) end
end

function GridGroupButtons:set_index(index, val)
  self.buttons[index]:set(val)
end

function GridGroupButtons:get()
end

function GridGroupButtons:key(x,y,z)
end

return GridGroupButtons