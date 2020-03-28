local GridControl = {}
GridControl.__index = GridControl

-- make a subclass like this:
-----------------------------
--
-- local MyControl = {}
-- MyControl.__index = MyControl
--
-- setmetatable(MyControl, {
--   __index = GridControl,
--   __call = function (cls, options)
--     local self = setmetatable({}, cls)
--     self:_init(options)
--     return self
--   end,
-- })
-- 
-- function MyControl:_init(options)
--   GridControl._init(self, options)
--   ... set up your own self from the options
-- end

setmetatable(GridControl, {
  __call = function (cls, options)
    local self = setmetatable({}, cls)
    self:_init(options)
    return self
  end,
})

function GridControl:_init(options)
  self.id = options.id
  self.group = options.group
  self.x = options.x
  self.y = options.y
  self.width = options.width or 1
  self.height = options.height or 1
  self.enabled = true
  self.update_ui = function() end
  return s
end

function GridControl:set_enabled(val)
  self.enabled = val
  self:update_ui()
end

function GridControl:keys() return {} end

function GridControl:draw(led) end

function GridControl:set(val) end

function GridControl:get() end

function GridControl:key(x, y, z) end

function GridControl:on_add(grid_ui) end

return GridControl
