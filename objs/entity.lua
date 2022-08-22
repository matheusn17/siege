local entity = {
  name = "",
  pos_x = 0,
  pos_y = 0,
  size_x = 0,
  size_y = 0,
  drawable = false,
  facing_left = false
}

entity.getDistanceFrom = function (self, x, y) 
  return math.sqrt((self.pos_x - x) ^ 2 + (self.pos_y - y) ^ 2)
end


return entity
