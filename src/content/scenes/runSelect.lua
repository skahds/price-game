local starters = {}
local order = 1
local width, height = 400, 500

main.defineScene("runSelect", function ()
  for i, starter in ipairs(main.starters) do
    local t = utils.deepCopy(starter)
    t.x, t.y = 100+(width+100)*(i-1), 720/2-height/2
    t.ui = main.ui.spawnUI("toPlay", {x=t.x+width/2-100, y=t.y+height-100-50, order=i})
    table.insert(starters, t)
  end

  main.tweenCamera(0.2, {x=0, y=0})
  main.hideCharts()
end, function ()
  for i, starter in ipairs(starters) do
    starter.ui:delete()
  end
  starters = {}
end)

main.ui.defineButton("toPlay", {
  width = 200,
  height = 100,
  color = {0.6, 0.6, 0.9},
  renderLayer = 101,
  screenSpace = true,
  text = "PLAY",
  audio = "breaker",
  onButtonClicked = function (ent)
    local selection = starters[ent.order]
    selection.onActivate()

    if ent.order == 1 then
      main.playScene("levelSelect")
      system.updateStorage("main:isDoingTutorial", true)
    else
      main.playScene("levelSelect")
    end
  end
})

local function seperateLines(text)
  local t = {}
  while true do
    local ss, se = string.find(text, "\n")
    if ss then
      local firstPart = string.sub(text, 1, ss)
      table.insert(t, firstPart)
      text = string.sub(text, se+1, #text)
    else
      table.insert(t, text)
      break
    end
  end

  return t
end

system.on("@draw", function ()
  for i, starter in ipairs(starters) do
    system.render(60, function ()
      love.graphics.setColor(0.6, 0.6, 0.6)
      love.graphics.rectangle("fill", starter.x, starter.y, width, height, 10, 10)

      love.graphics.setLineWidth(10)
      love.graphics.setColor(0.4, 0.4, 0.4)
      love.graphics.rectangle("line", starter.x, starter.y, width, height, 10, 10)

      love.graphics.setColor(1, 1, 1)
      love.graphics.draw(system.getImage((starter.image or "placeholder")), starter.x+width/2-64, starter.y+100-64, 0, 2, 2)
    end, true)

    local texts = {}
    table.insert(texts, starter.name)
    local lines = seperateLines(starter.description)
    for _, str in ipairs(lines) do
      table.insert(texts, str)
    end
    for i, str in ipairs(texts) do
      local t = main.printRichText({format=str, renderLayer=61, x=starter.x+width/2, y=starter.y+100+i*60})
      t.x = t.x - t.richText:getWidth()/2
    end
  end
end)