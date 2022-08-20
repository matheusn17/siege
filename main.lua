function love.load()

  math.randomseed(os.time())

  objs = { }
  objs.phy_world = dofile("objs/phy_world.lua")
  objs.spawner = dofile("objs/spawner.lua")
  objs.render_area = dofile("objs/render_area.lua")
  
  args = { world = objs.phy_world, render_area = objs.render_area }
    objs.player = dofile("objs/player.lua")
    objs.tower = dofile("objs/tower.lua")
  
  args = { world = objs.phy_world, render_area = objs.render_area, enemy_target = objs.tower } 
    objs.enemies = { }
    for i = 1, 5 do
      objs.enemies[i] = dofile("objs/enemy.lua")
    end
  
  -- spawn enemies
  for _, enemie in pairs(objs.enemies) do
    objs.spawner:replace(math.random(0, objs.render_area.size_x), math.random(objs.render_area.size_y))
    objs.spawner:spawnEntity(enemie)
  end
  -- Sets
  --love.window.setMode(100, 100, { vsync = 0 } )
  love.graphics.setBackgroundColor(0,0,0,1)
  
  timer = 0
  
  args = nil
  collectgarbage()
end

function love.update( dt )
  
  timer = timer + dt

  if timer >= 0.03 then
    objs.phy_world:update(timer) 
    objs.player:update(objs.render_area)
    objs.tower:update()
    
    for key, obj in pairs(objs.enemies) do
      obj:update(objs.render_area)
    end 
    
    timer = 0
  end
    
end

function love.draw()

  love.graphics.setCanvas(objs.render_area.canvas)
  love.graphics.clear(1,1,1,1)
  
    for key, obj in pairs(objs) do
      if obj.drawable then
        love.graphics.draw(obj.sprite, obj.pos_x, obj.pos_y, 0, 1, 1, obj.size_x/2, obj.size_y/2)
        
        -- physics debbug
        love.graphics.setColor(0.9, 0.1, 0.1)
        love.graphics.rectangle("line", obj.pos_x - (obj.size_x/2), obj.pos_y - (obj.size_y/2), obj.size_x, obj.size_y)
      end
    end
    
    -- enemies array rendered separately
    for key, obj in pairs(objs.enemies) do
      if obj.drawable then
        love.graphics.draw(obj.sprite, obj.pos_x, obj.pos_y, 0, 1, 1, obj.size_x/2, obj.size_y/2)
        
        -- physics debbug
        love.graphics.setColor(0.9, 0.1, 0.1)
        love.graphics.rectangle("line", obj.pos_x - (obj.size_x/2), obj.pos_y - (obj.size_y/2), obj.size_x, obj.size_y)
      end
    end
    
    if(objs.tower.status == 'dead') then
      love.graphics.setColor(0, 0, 0)
      love.graphics.printf("GAME OVER", 0, 0, objs.render_area.size_x, "center")
    else
      love.graphics.setColor(0, 0, 0)
      love.graphics.printf("TOWER HEALTH: " .. objs.tower.health, 0, 0, objs.render_area.size_x, "center")
    end
      
  love.graphics.setCanvas()
  love.graphics.setColor(1, 1, 1)
    love.graphics.draw(objs.render_area.canvas, objs.render_area.pos_x, objs.render_area.pos_y, 0, objs.render_area.scale, objs.render_area.scale, objs.render_area.size_x/2, objs.render_area.size_y/2)

end

function love.resize(x, y)
  if x < y then
    objs.render_area.scale = x / objs.render_area.size_x
  else
    objs.render_area.scale = y / objs.render_area.size_y
  end
  
  objs.render_area.pos_x = love.graphics.getWidth()/2
  objs.render_area.pos_y = love.graphics.getHeight()/2

end

function love.keypressed( key, sc, isRepeat)
  -- Just to make the code smaller
  local tpb = objs.player.body
  local tpb_vx, tpb_vy = tpb:getLinearVelocity()
  
  if key == 'w' then
    tpb:applyForce(0, -500)
  end
  
  if key == 's' then
    tpb:applyForce(0, 500)
  end
  
  if key == 'a' then
    tpb:applyForce(-500, 0)
  end
  
  if key == 'd' then
    tpb:applyForce(500, 0)
  end
end

function love.keyreleased( key, sc, isRepeat)

  -- Just to make the code smaller
  local tpb = objs.player.body
  local tpb_vx, tpb_vy = tpb:getLinearVelocity()
  
  if key == 'w' then
    tpb:setLinearVelocity(tpb_vx, 0)
  end
  
  if key == 's' then
    tpb:setLinearVelocity(tpb_vx, 0)
  end
  
  if key == 'a' then
    tpb:setLinearVelocity(0, tpb_vy)
  end
  
  if key == 'd' then
    tpb:setLinearVelocity(0, tpb_vy)
  end
  
  if key == 'space' then
    objs.tower:takeDamage(5)
  end
  
end
