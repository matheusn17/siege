local spawner = dofile("objs/entity.lua")

spawner.name = "spawner"
spawner.pos_x = 16
spawner.pos_y = 13


spawner.replace = function (self, x, y)
  
  if not x then x = 0 end
  if not y then y = 0 end
  
  self.pos_x = x
  self.pos_y = y
  
  --self:checkOutOfBounds(render_area)
end

spawner.spawnEntity = function (self, entity)
  entity:spawn(self.pos_x, self.pos_y)
end

return spawner
