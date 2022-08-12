local tower = dofile("objs/entity.lua")

tower.name = "tower"
tower.drawable = true
tower.size_x = 24
tower.size_y = 30
tower.pos_x = args.render_area.size_x/2
tower.pos_y = args.render_area.size_y/2
tower.health = 10
tower.status = "alive"

tower.sprite = love.graphics.newImage("assets/tower.png")
tower.sprite:setFilter("nearest", "nearest")

tower.body = love.physics.newBody(args.world, tower.pos_x, tower.pos_y, "static")
tower.shape = love.physics.newRectangleShape(tower.size_x, tower.size_y)
tower.fixture = love.physics.newFixture(tower.body, tower.shape)

tower.fixture:setGroupIndex(2)

tower.update = function (self)
  tower:checkStatus()
  tower:handleCollisions()
end

tower.checkStatus = function (self)
  if self.status == "alive" then
    if self.health <= 0 then
      self.sprite = love.graphics.newImage("assets/tower_destroyed.png")
      self.status = "dead"
    end
  end
end

tower.handleCollisions = function (self)
  local contacts = self.body:getContacts()
  
  for j, c in pairs(contacts) do
    local fixture_a, fixture_b = c:getFixtures()
    
    if( fixture_a:getGroupIndex() == 1 or fixture_b:getGroupIndex() == 1) then
      -- TODO
      self:takeDamage(1)
    end
      
  end
end

tower.takeDamage = function (self, amount)
  self.health = self.health - amount
end

return tower
