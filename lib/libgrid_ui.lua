local GridUI = {}
GridUI.__index = GridUI

function GridUI.new(options)
  local s = setmetatable({}, GridUI)
  s.grid = options.grid
  s.layout = {
    x = (options.x or 1) - 1,
    y = (options.y or 1) - 1,
    width = options.width or 16,
    height = options.width or 8
  }
  s.controls = {}
  s.controls_draw_order = {}
  s.key_handlers = {}
  s.grid.key = function(x, y, z) s:key(x, y, z) end
  return s
end

local function RandomVariable(length)
  math.randomseed(os.clock() ^ 5)
  local res = ""
  for i = 1, length do res = res .. string.char(math.random(97, 122)) end
  return res
end

function GridUI:add(control)
  if not control.id then control.id = RandomVariable(10) end
  control.update_ui = function() self:update() end
  self.controls[control.id] = control
  table.insert(self.controls_draw_order, control)
  for _, k in ipairs(control:keys()) do
    self.key_handlers[k.x .. ":" .. k.y] =
        function(x, y, z) control:key(x, y, z) end
  end
  control:on_add(self)
  self:update()
end

function GridUI:get(id)
  local control = self.controls[id]
  return control:get()
end

function GridUI:set(id, val)
  local control = self.controls[id]
  local result = control:set(val)
  return result
end

function GridUI:key(x, y, z)
  local no_handler = function(x, y, z)
    print("No handler for " .. x .. "/" .. y .. "/" .. z)
  end
  local handler = self.key_handlers[x .. ":" .. y] or no_handler
  handler(x, y, z)
end

function GridUI:update()
  for _, control in pairs(self.controls_draw_order) do
    control:draw(function(x, y, val)
      self.grid:led(x + self.layout.x, y + self.layout.y, val)
    end)
  end
  self.grid:refresh()
end

return GridUI
