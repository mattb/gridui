local GridControl = include("lib/control")

local GridRect = {}
GridRect.__index = GridRect

setmetatable(GridRect, {
  __index = GridControl, -- this is what makes the inheritance work
  __call = function (cls, options)
    local self = setmetatable({}, cls)
    self:_init(options)
    return self
  end,
})

function GridRect:_init(options)
  GridControl._init(self, options)

  self.stroke_brightness = options.stroke_brightness or 13
  self.fill_brightness = options.fill_brightness or 13
end

function GridRect:draw(led)
  for x = 1, self.width do
    for y = 1, self.height do
      local brightness = self.fill_brightness
      if y == 1 or y == self.height or x == 1 or x == self.width then
        brightness = self.stroke_brightness
      end
      led(self.x + x - 1, self.y + y - 1, brightness)
    end
  end
end

return GridRect
