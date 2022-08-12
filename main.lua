function love.load()

  objs = { }
  objs.phy_world = dofile("objs/phy_world.lua")
  objs.render_area = dofile("objs/render_area.lua")
  
  args = { world = objs.phy_world, render_area = objs.render_area }
    objs.player = dofile("objs/player.lua")
    objs.tower = dofile("objs/tower.lua")
  --objs.enemy_model = require("enemy")
  --objs.enemies = { }

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
    
    if(objs.tower.status == 'dead') then
      love.graphics.setColor(0, 0, 0)
      love.graphics.printf("GAME OVER", 0, 0, objs.render_area.size_x, "center")
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
    tpb:setLinearVelocity(tpb_vx, -50)
  end
  
  if key == 's' then
    tpb:setLinearVelocity(tpb_vx, 50)
  end
  
  if key == 'a' then
    tpb:setLinearVelocity(-50, tpb_vy)
  end
  
  if key == 'd' then
    tpb:setLinearVelocity(50, tpb_vy)
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
