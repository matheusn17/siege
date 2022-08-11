function love.load()

  objs = { }
  objs.phy_world = dofile("objs/phy_world.lua")
  
  args = { world = objs.phy_world }
    objs.player = dofile("objs/player.lua")
  --objs.tower = require("tower")
  --objs.enemy_model = require("enemy")
  --objs.enemies = { }
  objs.render_area = dofile("objs/render_area.lua")

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
    
    timer = 0
  end
    
end

function love.draw()

  for key, obj in pairs(objs) do
    if obj.drawable then
      love.graphics.setCanvas(objs.render_area.canvas)
        love.graphics.clear(1,1,1,1)
        love.graphics.draw(obj.sprite, obj.pos_x, obj.pos_y)
        
      love.graphics.setCanvas()

        love.graphics.draw(objs.render_area.canvas, objs.render_area.pos_x, objs.render_area.pos_y, 0, objs.render_area.scale)
    end
  end

end

function love.resize(x, y)
  if x < y then
    objs.render_area.scale = x / objs.render_area.size_x
  else
    objs.render_area.scale = y / objs.render_area.size_y
  end
end

function love.keypressed( key, sc, isRepeat)
  if key == 'w' then
    objs.player.body:applyLinearImpulse(0, -50)
  end
  
  if key == 's' then
    objs.player.body:applyLinearImpulse(0, 50)
  end
  
  if key == 'a' then
    objs.player.body:applyLinearImpulse(-50, 0)
  end
  
  if key == 'd' then
    objs.player.body:applyLinearImpulse(50, 0)
  end
end

function love.keyreleased( key, sc, isRepeat)
  if key == 'w' then
    objs.player.body:applyLinearImpulse(0, 50)
  end
  
  if key == 's' then
    objs.player.body:applyLinearImpulse(0, -50)
  end
  
  if key == 'a' then
    objs.player.body:applyLinearImpulse(50, 0)
  end
  
  if key == 'd' then
    objs.player.body:applyLinearImpulse(-50, 0)
  end
  
end
