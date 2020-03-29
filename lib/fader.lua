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
  self.level = options.level or 4
  self.action = options.action or function(val) end
  self.min = options.min or 0
  self.max = options.max or (self.width - 1)
  self:set_value(options.value or options.min or self.min)
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
    -- print("UP/DOWN fader not implemented")
  return end
  for x = 1, self.width do
    if x < self.position then
      brightness = self.on_brightness
    elseif x == self.position then
      brightness = math.floor((self.on_brightness + self.level) / 2)
    elseif x > self.position then
      brightness = self.level
    end

    local directional_x = x
    if self.direction == "left" then
      directional_x = self.width - directional_x
    else
      directional_x = directional_x - 1
    end
    for y = 1, self.height do 
      led(self.x + directional_x, self.y + y - 1, brightness)
    end
  end
end

function GridFader:set_position(position)
  self.position = math.floor(position)
  self.update_ui()
end

function GridFader:set_value(val)
  self:set_position(1 + (self.width - 1) * (val - self.min) / (self.max - self.min - 1))
end

function GridFader:get_value() 
  return ((self.position - 1) * (self.max - self.min - 1)) / (self.width - 1) + self.min
end

function GridFader:key(x, y, z)
  if z == 1 then
    if self.direction == "right" then
      self:set_position(x - self.x + 1)
    elseif self.direction == "left" then
      self:set_position(self.width - (x - self.x))
    end
  end
end

return GridFader