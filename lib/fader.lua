local GridFader = {}
GridFader.__index = GridFader

function GridFader.new(options)
  local s = setmetatable({}, GridFader)

  s.id = options.id
  s.update_ui = function() end
  s.group = options.group
  s.x = options.x
  s.y = options.y
  s.width = options.width or 1
  s.height = options.height or 1
  s.direction = options.direction or "right"
  s.on_brightness = options.on_brightness or 13
  s.off_brightness = options.off_brightness or 4
  s.action = options.action or function(val) end
  s.value = options.value or 0
  return s
end

function GridFader:on_add(grid_ui) end

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