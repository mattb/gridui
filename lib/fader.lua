local GridControl = include("lib/control")

local GridFader = {}
GridFader.__index = GridFader

setmetatable(GridFader, {
  __index = GridControl, -- this is what makes the inheritance work
  __call = function (cls, options)
    local self = setmetatable({}, cls)
    self:_init(options)
    return self
  end,
})

function GridFader:_init(options)
  GridControl._init(self, options)
  self.direction = options.direction or "right"
  self.on_brightness = options.on_brightness or 13
  self.off_brightness = options.off_brightness or 4
  self.action = options.action or function(val) end
  self.value = options.value or 0
end

function GridFader:keys()
  local k = {}
  for x = 1, self.width do
    for y = 1, self.height do
      table.insert(k, {x = self.x + x - 1, y = self.y + y - 1})
    end
  end
  return k
end

function GridFader:draw(led)
  local brightness
  if self.direction == "up" or self.direction == "down" then 
    print("UP/DOWN fader not implemented")
  return end
  for x = 1, self.width do
    local progress = (x - 1) / (self.width - 1)
    if progress <= self.value then
      brightness = self.on_brightness
    elseif progress > self.value then
      -- TODO: fade
      brightness = self.off_brightness
    end
    local directional_x = x
    if self.direction == "left" then
      directional_x = self.width - directional_x
    end
    directional_x = self.x + directional_x
    for y = 1, self.height do 
      led(directional_x, self.y + y - 1, brightness)
    end
  end
end

function GridFader:set(val)
  self.value = val
  self.update_ui()
end

function GridFader:get() return self.value end

function GridFader:key(x, y, z)
  if z == 1 then
    local val
    if self.direction == "right" then
      val = (x - self.x) / (self.width - 1)
    elseif self.direction == "left" then
      val = 1 - (x - self.x) / (self.width - 1)
    end
    self:set(val)
  end
end

return GridFader