local GridRect = {}
GridRect.__index = GridRect

function GridRect.new(options)
  local s = setmetatable({}, GridRect)

  s.id = options.id
  s.group = options.group
  s.x = options.x
  s.y = options.y
  s.width = options.width or 1
  s.height = options.height or 1
  s.stroke_brightness = options.stroke_brightness or 13
  s.fill_brightness = options.fill_brightness or 13
  return s
end

function GridRect:keys()
  return {}
end

function GridRect:draw(led)
  for x = 1,self.width do
    for y = 1, self.height do
      local brightness = self.fill_brightness
      if y == 1 or y == self.height or x == 1 or x == self.width then
        brightness = self.stroke_brightness
      end
      led(self.x + x - 1, self.y + y - 1, brightness)
    end
  end
end

function GridRect:set(val)
end

function GridRect:get()
end

function GridRect:key(x,y,z)
end

function GridRect:on_add(grid_ui)
end

return GridRect