local flux = system.getStorage("flux")
local starters = {}
local order = 1
local width, height = 400, 500
local starterChosen
local starterHovering = 1

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
  renderLayer = 62,
  screenSpace = true,
  text = "PLAY",
  audio = "breaker",
  onButtonClicked = function (ent)
    if #main.getPipeline("scene").pipeline > 0 then return end
    if ent.order ~= starterHovering then starterHovering = ent.order return end

    local selection = starters[ent.order]
    starterChosen = ent.order
    selection.onActivate()

    if selection.route then
      system.updateStorage("main:route", selection.route)
    end

    if selection.scoreRequirementList then
      system.updateStorage("main:scoreRequirementList", selection.scoreRequirementList)
    end

    -- if ent.order == 1 then
    --   main.playScene("levelSelect")
      
    -- else
      main.playScene("levelSelect")
    -- end
  end
})

system.on("@draw", function ()
  local offsetX = (starterHovering-1)*500+width/2-640
  for i, starter in ipairs(starters) do
    flux.to(starter, 0.3, {x=(width+100)*(i-1)-offsetX})
    starter.ui.x = starter.x+width/2-100
  end

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
    local lines = utils.seperateSlashN(starter.description)
    for _, str in ipairs(lines) do
      table.insert(texts, str)
    end
    for i, str in ipairs(texts) do
      local t = main.printRichText({format=str, renderLayer=61, x=starter.x+width/2, y=starter.y+100+i*60})
      t.x = t.x - t.richText:getWidth()/2
    end
  end
end)

system.on("@mouse:wheelmoved", function (t)
  local y=t.y
  if y > 0 and starterHovering < #starters then
    starterHovering = starterHovering + 1
  elseif y < 0 and starterHovering > 1 then
    starterHovering = starterHovering - 1
  end
end)

system.register("runSelect", 11, function ()
  local t = {}
  t.starterChosen = starterChosen
  return t
end, function (t)
  if t.starterChosen then
    local selection = main.starters[t.starterChosen]
    starterChosen = t.starterChosen
    if selection.route then
      system.updateStorage("main:route", selection.route)
    end

    if selection.scoreRequirementList then
      system.updateStorage("main:scoreRequirementList", selection.scoreRequirementList)
    end
  end
end)