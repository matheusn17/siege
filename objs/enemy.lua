local enemy = dofile("objs/entity.lua")

enemy.name = "enemy"
enemy.drawable = true
enemy.facing = "left" -- or right
enemy.size_x = 16
enemy.size_y = 13
enemy.speed_x = 0
enemy.speed_y = 0
enemy.target = args.enemy_target
enemy.lifespan = 0
enemy.damage_refresh_timer = love.timer.getTime()

enemy.sprite = love.graphics.newImage("assets/enemy.png")
enemy.sprite:setFilter("nearest", "nearest")

enemy.body = love.physics.newBody(args.world, enemy.pos_x, enemy.pos_y, "dynamic")
enemy.shape = love.physics.newRectangleShape(enemy.size_x, enemy.size_y)
enemy.fixture = love.physics.newFixture(enemy.body, enemy.shape)

enemy.fixture:setGroupIndex(3)

enemy.body:setInertia(0)
enemy.body:setLinearDamping(0)

enemy.update = function (self, render_area)
  self.body:setAngle(math.atan2(self.body:getX() - self.target.body:getX(), self.body:getY() - self.target.body:getY()))
    
  self.body:setLinearVelocity(math.sin(self.body:getAngle()) * -15, math.cos(self.body:getAngle()) * -15)
  self.pos_x, self.pos_y = self.body:getPosition()
  
  self:handleCollisions()
  
  --self:checkOutOfBounds(render_area)
end

enemy.checkOutOfBounds = function (self, render_area)
  if (self.body:getX() < -(self.size_x * 2)) then
    self.body:setX( render_area.size_x + (self.size_x * 1.5) )
  elseif (self.body:getX() > (render_area.size_x + (self.size_x * 2) )) then
    self.body:setX( -(self.size_x * 1.5) )
  end
  
  if (self.body:getY() < -(self.size_y * 2)) then
    self.body:setY( render_area.size_y + (self.size_y * 1.5) )
  elseif (self.body:getY() > (render_area.size_y + (self.size_y * 2) )) then
    self.body:setY( -(self.size_y * 1.5) )
  end

end

enemy.handleCollisions = function (self)
  if ( love.timer.getTime() - self.damage_refresh_timer )  > 0.1 then
    local contacts = self.body:getContacts()
    
    for j, c in pairs(contacts) do
      local fixture_a, fixture_b = c:getFixtures()
    
      if( fixture_a:getGroupIndex() == 1 or fixture_b:getGroupIndex() == 1) then
        -- TODO
        self:die()
        return nil
      end   
    end
    self.damage_refresh_timer = love.timer.getTime()
  end
end

enemy.spawn = function (self, x, y)
  self.pos_x = x
  self.pos_y = y
  self.body:setX(x)
  self.body:setY(y)
  self.body:setActive(true)
  enemy.drawable = true
end

enemy.despawn = function (self)
  self.pos_x = -2048
  self.pos_y = -2048
  self.body:setX(-2048)
  self.body:setY(-2048)
  self.body:setActive(false)
  enemy.drawable = false
end

enemy.respawn = function (self, x, y)
  self:despawn()
  self:spawn(x, y)
end

enemy.die = function (self)
  -- do things
  self:despawn()
end

return enemy
