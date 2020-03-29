local GridControl = include("lib/control")

local GridButton = {}
GridButton.__index = GridButton

setmetatable(GridButton, {
  __index = GridControl, -- this is what makes the inheritance work
  __call = function (cls, options)
    local self = setmetatable({}, cls)
    self:_init(options)
    return self
  end,
})

function GridButton:_init(options)
  GridControl._init(self, options)

  self.on_brightness = options.on_brightness or 13
  self.level = options.level or 4
  self.momentary = options.momentary or nil
  self.action = options.action or function(val) end

  self.on = 0
  self.pressed = 0
end

function GridButton:on_add(grid_ui) end

function GridButton:keys()
  local k = {}
  for x = 1, self.width do
    for y = 1, self.height do
      table.insert(k, {x = self.x + x - 1, y = self.y + y - 1})
    end
  end
  return k
end

function GridButton:draw(led)
  local brightness = self.level
  if self.on == 1 then brightness = self.on_brightness end
  if self.pressed == 1 then brightness = 15 end
  for x = 1, self.width do
    for y = 1, self.height do led(self.x + x - 1, self.y + y - 1, brightness) end
  end
end

function GridButton:set(val)
  self.on = val
  self.update_ui()
end

function GridButton:set_level(val)
  self.level = val
  self.update_ui()
end

function GridButton:get() return self.on end

function GridButton:key(x, y, z)
  self.pressed = z
  if self.momentary then
    self.on = z
    self.action {control = self, val = self.on}
  else
    if z == 1 then
      if self.on == 1 then
        self.on = 0
      else
        self.on = 1
      end
      self.action {control = self, val = self.on}
    end
  end
  self.update_ui()
end

return GridButton
