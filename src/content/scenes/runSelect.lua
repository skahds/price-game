local flux = system.getStorage("flux")
local starters = {}
local order = 1
local width, height = 400, 400
local difficulyNaming = {"Easy", "Medium", "Hard"}
local starterChosen
local starterHovering = 1
local difficultySelected = 1
local coverLeft, coverRight, arrowLeft, arrowRight
local toPlay

local function deleteAll(args)
  for k, ent in pairs(args) do
    if ent.delete then
      ent:delete()
    end
  end
end

main.defineScene("runSelect", function ()
  for i, starter in ipairs(main.starters) do
    local t = utils.deepCopy(starter)
    t.x, t.y = 100+(width+100)*(i-1), 720/2-height/2-80
    t.renderLayer = 60
    table.insert(starters, t)
  end

  toPlay = main.ui.spawnUI("toPlay", {x=540, y=550, renderLayer=102})

  coverLeft = main.ui.spawnUI("cover", {x=50, y=70, width=330, height=580,
    rx=20, ry=20,
    renderLayer=93,
    color = {0.6, 0.6, 0.6},
    outlineColor = {0.4, 0.4, 0.4}, outline=10})

  coverRight = main.ui.spawnUI("cover", {x=1280-380, y=70, width=330, height=580,
    rx=20, ry=20,
    renderLayer=93,
    color = {0.6, 0.6, 0.6},
    outlineColor = {0.4, 0.4, 0.4}, outline=10})

  arrowLeft = main.ui.spawnUI("runSelectArrow", {x=400, y=360-64})
  arrowRight = main.ui.spawnUI("runSelectArrow", {x=1280-400, y=360-64, sx=-1})

  main.tweenCamera(0.2, {x=0, y=0})
  main.hideCharts()
end, function ()
  starters = {}

  deleteAll({toPlay, coverLeft, coverRight, arrowLeft, arrowRight})
end)

local flux = system.getStorage("flux")

main.ui.defineUI("runSelectArrow", {
  image = "runArrowLeft",
  renderLayer = 95,
  width = 64,
  height= 128,
  onHover = function (ent)

  end,
  notHovered = function (ent)

  end,
  onMouseReleased = function (ent, button)
    if ent.sx and ent.sx < 0 then
      starterHovering = math.min(#starters, starterHovering+1)
    else
      starterHovering = math.max(1, starterHovering-1)
    end
  end,
})

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
    -- if ent.order ~= starterHovering then starterHovering = ent.order return end

    local selection = starters[starterHovering]
    starterChosen = starterHovering
    selection.onActivate()

    if selection.route then
      system.updateStorage("main:route", selection.route)
    end

    if selection.scoreWithDifficulty then
      system.updateStorage("main:scoreRequirementList", selection.scoreWithDifficulty[difficultySelected])
    end

    -- if ent.order == 1 then
    --   main.playScene("levelSelect")
      
    -- else
      main.playScene("levelSelect")
    -- end
  end
})

system.on("@update", function ()
  if system.getStorage("main:currentScene") ~= "runSelect" then
    return
  end

  if starters[starterHovering] == nil then
    return
  end

  if starterHovering == 1 then
    arrowLeft.isVisible = false
  else
    arrowLeft.isVisible = true
  end

  if starterHovering == #starters then
    arrowRight.isVisible = false
  else
    arrowRight.isVisible = true
  end

  local offsetX = (starterHovering-1)*500+width/2-640
  for i, starter in ipairs(starters) do
    flux.to(starter, 0.3, {x=(width+100)*(i-1)-offsetX})

    if i == starterHovering then
      starter.renderLayer = 90
    else
      starter.renderLayer = 60
    end
  end

  local starter = starters[starterHovering]
  if difficultySelected > #starter.scoreWithDifficulty then
    difficultySelected = #starter.scoreWithDifficulty
  end
end)

system.on("@mouse:released", function (button)
  if button ~= 1 then
    return
  end
  if system.getStorage("main:currentScene") ~= "runSelect" then
    return
  end

  local mouse = system.getStorage("realMouse")
  local rightCoverX = 1280-380
  local blockSpacing = 80
  local y = 100+blockSpacing+10
  local starter = starters[starterHovering]
  for i, difficulty in ipairs(starter.scoreWithDifficulty) do
    if main.AABB_check(mouse, {x=rightCoverX, y=y+(i-1)*blockSpacing, width=330, height=blockSpacing}) then
      difficultySelected = i
    end
  end
  
end)

system.on("@draw", function ()
  if system.getStorage("main:currentScene") ~= "runSelect" then
    return
  end

  if starters[starterHovering] == nil then
    return
  end

  --bg overlayer to darken everything up
  system.render(80, function ()
    love.graphics.setColor(0.03, 0.03, 0.03, 0.4)
    love.graphics.rectangle("fill", 0, 0, 1820, 720)
  end, true)

  for i, starter in ipairs(starters) do
    system.render(starter.renderLayer, function ()
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
      local t = main.printRichText({format=str, renderLayer=starter.renderLayer+1, x=starter.x+width/2, y=starter.y+100+i*60})
      t.x = t.x - t.richText:getWidth()/2
    end
  end

  local starter = starters[starterHovering]
  --left cover modifier selection
  local leftCoverMidX = 50+330/2
  local t = main.printRichText({
    format = "Modifier",
    x=leftCoverMidX,
    y=100,
    renderLayer=97
  })
  t.x = t.x - t.richText:getWidth()/2



  --right cover difficulty selection
  local rightCoverMidX = 1280-380+330/2
  local rightCoverX = 1280-380
  local t = main.printRichText({
    format = "Difficulty",
    x=rightCoverMidX,
    y=100,
    renderLayer=97
  })
  t.x = t.x - t.richText:getWidth()/2
  local blockSpacing = 80

  for i, difficulty in ipairs(starter.scoreWithDifficulty) do
    local t = main.printRichText({
      format = difficulyNaming[i] or "NIL",
      x=rightCoverX+20,
      y=110+blockSpacing+(i-0.5)*(blockSpacing),
      renderLayer=97
    })
    t.y = t.y - t.richText:getHeight()/2
  end

  -- lines
  system.render(96, function ()
    love.graphics.setLineWidth(10)
    local y = 100+blockSpacing+10

    local resultY = y+(difficultySelected-1)*(blockSpacing)
    love.graphics.setColor(1, 1, 1, 0.3)
    love.graphics.rectangle("fill", rightCoverX+5, resultY, 330-10, blockSpacing)

    love.graphics.setColor(0.4, 0.4, 0.4)
    love.graphics.line(rightCoverX, y, 1280-50, y)
    for i, difficulty in ipairs(starter.scoreWithDifficulty) do
      local resultY = y+i*(blockSpacing)

      love.graphics.setColor(0.4, 0.4, 0.4)
      love.graphics.line(rightCoverX, resultY, 1280-50, resultY)
    end
  end, true)
end)

system.on("@mouse:wheelmoved", function (t)
  local y=t.y
  if y < 0 and starterHovering < #starters then
    starterHovering = starterHovering + 1
  elseif y > 0 and starterHovering > 1 then
    starterHovering = starterHovering - 1
  end
end)

system.register("runSelect", 11, function ()
  local t = {}
  t.starterChosen = starterChosen
  t.difficultySelected = difficultySelected
  return t
end, function (t)
  if t.starterChosen then
    local selection = main.starters[t.starterChosen]
    starterChosen = t.starterChosen
    if selection.route then
      system.updateStorage("main:route", selection.route)
    end

    if selection.scoreWithDifficulty then
      system.updateStorage("main:scoreRequirementList", selection.scoreWithDifficulty[t.difficultySelected])
    end
  end
end)