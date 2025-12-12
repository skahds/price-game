local flux = system.getStorage("flux")
local starters = {}
local width, height = 400, 400
local difficulyNaming = {"Easy", "Medium", "Hard"}
local starterChosen
local starterHovering = 1
local difficultySelected = 1
local runModeSelected = {}
local existingNews = {}
local coverLeft, coverRight, arrowLeft, arrowRight
local toPlay
local modifierButton
local isModifierOpen = false
local modifierUIS = {}

local function deleteAll(args)
  for k, ent in pairs(args) do
    if ent.delete then
      ent:delete()
    end
  end
end

local function openModifier(action)
  if isModifierOpen == false and action ~= "close" then
    table.insert(modifierUIS, main.ui.spawnUI("cover", {
      x=640-600/2,
      y=100,
      width = 600,
      height = 400,
      color = {0.6, 0.6, 0.6},
      outline = 10,
      rx=10,
      ry=10,
      outlineColor = {0.4, 0.4, 0.4},
      ignoreUIChecks = false,
      renderLayer = 100}))

    isModifierOpen = true
  else
    deleteAll(modifierUIS)

    isModifierOpen = false
  end
end

main.defineScene("runSelect", function ()
  for i, starter in ipairs(main.starters) do
    local t = utils.deepCopy(starter)
    t.x, t.y = 100+(width+100)*(i-1), 720/2-height/2-80
    t.renderLayer = 60
    table.insert(starters, t)
  end

  toPlay = main.ui.spawnUI("toPlay", {x=640-120-100, y=550, renderLayer=102})
  modifierButton = main.ui.spawnUI("openModifier", {x=640+120-100, y=550, renderLayer=102})

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

  local leftCoverX = 50
  local blockSpacing = 80
  local y = 100+blockSpacing+10
  for i, mode in ipairs(main.runModes) do
    existingNews[i] = {}
    for e, news in ipairs(mode.news) do
      local n = main.spawnEntity(news, {x=leftCoverX+10, y=y+blockSpacing*(i-0.5)})
      n.ui.renderLayer = 140
      n.ui.sx = 2
      n.ui.sy = 2
      n.ui.x = n.ui.x + (n.ui:getWidth()+10)*(e-1)
      n.ui.y = n.ui.y - n.ui:getHeight()/2
      n.ui.screenSpace = true
      table.insert(existingNews[i], n)
    end
  end

  main.tweenCamera(0.2, {x=0, y=0})
  main.hideCharts()
end, function ()
  starters = {}
  openModifier("close")

  deleteAll({toPlay, coverLeft, coverRight, arrowLeft, arrowRight, modifierButton})
  for _, t in pairs(existingNews) do
    for i=#t, 1, -1 do
      local news = t[i]
      news.ui:delete()
      news:delete()
    end
  end
end)

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

    local selection = starters[starterHovering]
    starterChosen = starterHovering
    selection.onActivate()

    if selection.route then
      system.updateStorage("main:route", selection.route)
    end

    if selection.scoreWithDifficulty then
      system.updateStorage("main:scoreRequirementList", selection.scoreWithDifficulty[difficultySelected])
    end

    main.playScene("levelSelect")

    for k, v in pairs(runModeSelected) do
      if v == true then
        local mode = main.runModes[k]

        for i, news in ipairs(mode.news) do
          local ent = main.spawnNews(news, {x=0, y=0})

          if main.canTrigger(ent, "OBTAIN") then
            local pipeline = main.getPipeline("main")
            pipeline:add(0.5, function ()
              main.triggerEnt(ent, "OBTAIN")
            end)
          end
        end
      end
    end
  end
})

main.ui.defineButton("openModifier", {
  width = 200,
  height = 100,
  color = {0.6, 0.8, 0.6},
  renderLayer = 62,
  screenSpace = true,
  text = "MODIFIER",
  audio = "breaker",
  onButtonClicked = function (ent)
    openModifier()
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
  local leftCoverX = 50
  local rightCoverX = 1280-380
  local blockSpacing = 80
  local y = 100+blockSpacing+10
  local starter = starters[starterHovering]

  for i, mode in ipairs(main.runModes) do
    if main.AABB_check(mouse, {x=leftCoverX, y=y+(i-1)*blockSpacing, width=330, height=blockSpacing}) then
      if runModeSelected[i] ~= true then
        runModeSelected[i] = true
      else
        runModeSelected[i] = false
      end
    end
  end

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
  --left cover mode selection
  local leftCoverMidX = 50+330/2
  local blockSpacing = 80
  local leftCoverX = 50
  local leftCoverRightX = 50+330

  local t = main.printRichText({
    format = "Modes",
    x=leftCoverMidX,
    y=70+(30+blockSpacing+10)/2,
    renderLayer=97
  })
  t.x = t.x - t.richText:getWidth()/2
  t.y = t.y - t.richText:getHeight()/2

  -- names
  local totalNews = 0
  for i, mode in ipairs(main.runModes) do
    local lastNews = existingNews[i][#existingNews[i]]
    local t = main.printRichText({
      format = mode.name,
      x=lastNews.ui:getX()+lastNews.ui:getWidth()+10,
      y=lastNews.ui:getY()+lastNews.ui:getHeight()/2,
      renderLayer=97,
      font = system.getFont("defaultFont40")
    })
    t.y = t.y - t.richText:getHeight()/2
  end

  -- lines
  system.render(96, function ()
    love.graphics.setLineWidth(10)
    local y = 100+blockSpacing+10

    for k, v in pairs(runModeSelected) do
      if v == true then
        local resultY = y+(k-1)*(blockSpacing)
        love.graphics.setColor(1, 1, 1, 0.3)
        love.graphics.rectangle("fill", leftCoverX+5, resultY, 330-10, blockSpacing)
      end
    end

    love.graphics.setColor(0.4, 0.4, 0.4)
    love.graphics.line(leftCoverX, y, leftCoverRightX, y)
    for i, mode in ipairs(main.runModes) do
      local resultY = y+i*(blockSpacing)

      love.graphics.setColor(0.4, 0.4, 0.4)
      love.graphics.line(leftCoverX, resultY, leftCoverRightX, resultY)
    end
  end, true)



  --right cover difficulty selection
  local rightCoverMidX = 1280-380+330/2
  local rightCoverX = 1280-380
  local t = main.printRichText({
    format = "Difficulty",
    x=rightCoverMidX,
    y=70+(30+blockSpacing+10)/2,
    renderLayer=97
  })
  t.x = t.x - t.richText:getWidth()/2
  t.y = t.y - t.richText:getHeight()/2
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