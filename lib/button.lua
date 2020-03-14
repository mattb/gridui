local GridButton = {}
GridButton.__index = GridButton

function GridButton.new(options)
  local s = setmetatable({}, GridButton)

  s.id = options.id
  s.x = options.x
  s.y = options.y
  s.width = options.width or 1
  s.height = options.height or 1
  s.on_brightness = options.on_brightness or 15
  s.off_brightness = options.off_brightness or 4
  s.action = options.action or function(val) end

  s.on = 0
  return s
end

function GridButton:keys()
  local k = {}
  for x = 1,self.width do
    for y = 1, self.height do
      table.insert(k, {x = self.x + x - 1, y = self.y + y - 1})
    end
  end
  return k
end

function GridButton:draw(led)
  local brightness = self.off_brightness
  if self.on == 1 then
    brightness = self.on_brightness
  end
  for x = 1,self.width do
    for y = 1, self.height do
      led(self.x + x - 1, self.y + y - 1, brightness)
    end
  end
end

function GridButton:set(val)
  self.on = val
end

function GridButton:get()
  return self.on
end

function GridButton:key(x,y,z)
  if z == 1 then
    if self.on == 1 then self.on = 0 else self.on = 1 end
    self.action(self.on)
  end
end

return GridButton