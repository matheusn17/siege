local spawner = dofile("objs/entity.lua")

spawner.name = "spawner"
spawner.pos_x = 16
spawner.pos_y = 13

spawner.replace = function (self, x, y, ra)
    
  local angle = math.random(0, 2 * 1000 * math.pi)/1000
  if not ra then return nil end
    
  if not x then x = (math.sin(angle)*ra.size_x ) + ra.size_x/2 end
  if not y then y = (math.cos(angle)*ra.size_x ) + ra.size_x/2 end
  
  self.pos_x = x
  self.pos_y = y
  
  --self:checkOutOfBounds(render_area)
end

spawner.spawnEntity = function (self, entity)
  entity:spawn(self.pos_x, self.pos_y)
end

spawner.respawnEntity = function (self, entity)
  entity:respawn(self.pos_x, self.pos_y)
end

return spawner
