local render_area = dofile("objs/entity.lua")

render_area.size_x = 256
render_area.size_y = 256

if love.graphics.getWidth() < love.graphics.getHeight() then
  render_area.scale = love.graphics.getWidth() / render_area.size_x
else
  render_area.scale = love.graphics.getHeight() / render_area.size_y
end

render_area.canvas = love.graphics.newCanvas(render_area.size_x, render_area.size_y)
render_area.canvas:setFilter("nearest","nearest")

return render_area
