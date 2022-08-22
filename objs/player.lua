local player = dofile("objs/entity.lua")

player.name = "player"
player.drawable = true
player.facing_left = true -- or right
player.size_x = 16
player.size_y = 13
player.speed_x = 0
player.speed_y = 0
player.open_mouth = false
--player.open_mouth_sndfx = love.audio.newSource( "assets/open_mouth.ogg", "static" )
player.open_mouth_sprite = love.graphics.newImage("assets/player_attacking.png")
player.idle_sprite = love.graphics.newImage("assets/player.png")

player.open_mouth_sprite:setFilter("nearest", "nearest")
player.idle_sprite:setFilter("nearest", "nearest")

player.sprite = player.idle_sprite

player.body = love.physics.newBody(args.world, player.pos_x, player.pos_y, "dynamic")
player.shape = love.physics.newRectangleShape(player.size_x, player.size_y)
player.fixture = love.physics.newFixture(player.body, player.shape)

player.fixture:setGroupIndex(1)

player.body:setInertia(0)
player.body:setLinearDamping(0)

player.update = function (self, ra, enemies)
  local far_from_enemies = true

  self.pos_x, self.pos_y = self.body:getPosition()
  self:checkOutOfBounds(ra)
  
  for _, enemy in pairs(enemies) do
    if self:getDistanceFrom(enemy.pos_x, enemy.pos_y) < (self.size_x * 2.5) then
      
      if not self.open_mouth then
        --self.open_mouth_sndfx:play()
        self.open_mouth = true
      end
      
      far_from_enemies = false
      self.sprite = self.open_mouth_sprite
    end
  end
  
  if far_from_enemies then
    self.open_mouth = false
    self.sprite = self.idle_sprite
  end    
    
end

player.checkOutOfBounds = function (self, ra)
  if (self.body:getX() < -(self.size_x * 2)) then
    self.body:setX( ra.size_x + (self.size_x * 1.5) )
  elseif (self.body:getX() > (ra.size_x + (self.size_x * 2) )) then
    self.body:setX( -(self.size_x * 1.5) )
  end
  
  if (self.body:getY() < -(self.size_y * 2)) then
    self.body:setY( ra.size_y + (self.size_y * 1.5) )
  elseif (self.body:getY() > (ra.size_y + (self.size_y * 2) )) then
    self.body:setY( -(self.size_y * 1.5) )
  end
end

return player
