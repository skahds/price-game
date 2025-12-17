system.on("@draw", function ()
  local pattern = main.getCurrentPattern()
  if pattern == nil then
    return
  end

  local chart = system.getStorage("main:chart")
  if chart == nil then
    return
  end

  local amountOfBar = #pattern.sequence
  local x = chart:getBar(-amountOfBar).x
  local width = chart:getBar(-1).x+chart:getBar(-1).width-chart:getBar(-amountOfBar).x
  local y = math.huge
  local lowestY = -math.huge
  local height = 0
  print"starting"
  for i=#chart.bars, #chart.bars-amountOfBar+1, -1 do
    print(y, lowestY)
    y = math.min(y, math.min(chart.bars[i].y, chart.bars[i].y+chart.bars[i].height))
    lowestY = math.max(lowestY, math.max(chart.bars[i].y, chart.bars[i].y+chart.bars[i].height))
    print(y, lowestY)
  end
  height = lowestY - y

  local t = main.printRichText({
    format = pattern.name,
    renderLayer = 30,
    x=x+width/2,
    y=y-5,
    screenSpace = false,
    font = system.getFont("defaultFont20")
  })
  t.x = t.x - t.richText:getWidth()/2
  t.y = t.y - t.richText:getHeight()

  system.render(30, function ()
    love.graphics.setColor(1, 1, 1, 0.45)
    love.graphics.setLineWidth(3)
    love.graphics.rectangle("line", x, y, width, height)
  end)
end)