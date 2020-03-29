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
  s.dim = 1.0
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
        function(x, y, z) 
          if control.enabled == 1 then control:key(x, y, z) end
        end
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

function GridUI:seaw()t_dim(percentage) self.dim = percentage end

function GridUI:key(x, y, z)
  local no_handler = function(x, y, z)
    print("No handler for " .. x .. "/" .. y .. "/" .. z)
  end
  local handler = self.key_handlers[x .. ":" .. y] or no_handler
  handler(x, y, z)
end

function GridUI:enabled_controls()
  local ec = {}
  for _, control in pairs(self.controls_draw_order) do
    if control.enabled == 1 then
      table.insert(ec, control)
    end
  end
  return ec
end

function GridUI:update()
  for _, control in pairs(self:enabled_controls()) do
    control:draw(function(x, y, val)
      self.grid:led(x + self.layout.x, y + self.layout.y, math.floor(val * self.dim))
    end)
  end
  self.grid:refresh()
  redraw()
end

function GridUI:draw_on_screen()
  screen.level(math.floor(4 * self.dim))
  for x =1, self.layout.width do
    for y = 1, self.layout.height do
      screen.rect(x * 7, y * 7, 4, 4)
      screen.stroke()
    end
  end
  
  for _, control in pairs(self:enabled_controls()) do
    control:draw(function(x, y, val)
      screen.level(math.floor(val * self.dim))
      screen.rect(x * 7, y * 7, 4, 4)
      screen.fill()
      screen.stroke()
    end)
  end
end

return GridUI
