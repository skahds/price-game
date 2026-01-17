local flux = system.getStorage("flux")
local starters = {}
local width, height = 400, 400
local difficulyNaming = {"Easy", "Medium", "Hard"}
local starterChosen
local starterHovering = 1
local difficultySelected = 1
local pressableBoxes = {}
local runModeSelected = {}
local existingNews = {}
local coverLeft, coverRight, arrowLeft, arrowRight
local toPlay
local modifierButton
local isModifierOpen = false
local modifierUIS = {}
local modifierValues = {}

local function deleteAll(args)
  for k, ent in pairs(args) do
    if ent.delete then
      ent:delete()
    end
  end
end

local function formatNum(value, modifierScoreEffect)
  return "x" .. 1 + (value * modifierScoreEffect)/100 .. " moola"
end

local function openModifier(action)
  if isModifierOpen == false and action ~= "close" then
    table.insert(modifierUIS, main.ui.spawnUI("cover", {
      x=640-800/2,
      y=80,
      width = 800,
      height = 450,
      color = {0.6, 0.6, 0.6},
      outline = 10,
      rx=10,
      ry=10,
      outlineColor = {0.4, 0.4, 0.4},
      ignoreUIChecks = false,
      renderLayer = 100}))

      local yGap = 80
      for i, modifier in ipairs(main.runModifiers) do
        local amount = modifier.range[2]-modifier.range[1]
        local totalWidth = 50*amount
        local ui = main.ui.spawnUI("modifierSlider", {
          attachedModifier=i,
          x=640-200,
          y=130+(i-1)*yGap,
          width = totalWidth,
          increment = amount,
          slideAmount = 1*(-modifier.range[1]+(modifierValues[i] or 0))/amount
        })
        ui.x = ui.x - ui:getWidth()/2
        ui.y = ui.y - ui:getHeight()/2
        table.insert(modifierUIS, ui)

        local text = main.newRichText({
          attachedModifier = i,
          usage = "description",
          format = modifier.updateDescription(modifierValues[i] or 0),
          renderLayer = 200,
          x=640,
          y=130+(i-1)*yGap,
          font = system.getFont("defaultFont40"),
        })
        text.y = text.y - text.richText:getHeight()/2
        table.insert(modifierUIS, text)

        local scoreResult = main.newRichText({
          attachedModifier = i,
          usage = "scoreEffect",
          format = formatNum(modifierValues[ui.attachedModifier] or 0, modifier.scoreEffect),
          renderLayer = 200,
          x=640+150,
          y=130+(i-1)*yGap,
          font = system.getFont("defaultFont40"),
        })
        text.y = text.y - text.richText:getHeight()/2
        table.insert(modifierUIS, scoreResult)
      end


    isModifierOpen = true
  else
    for i=#modifierUIS, 1, -1 do
      local ui = modifierUIS[i]
      ui:delete()
    end

    isModifierOpen = false
  end
end

local function updateModifier()
  for i, ui in ipairs(modifierUIS) do
    if ui.richText then
      local modifier = main.runModifiers[ui.attachedModifier]
      local value = modifierValues[ui.attachedModifier] or 0
      if ui.usage == "description" then
        main.updateRichTextText(ui, modifier.updateDescription(value))
      elseif ui.usage == "scoreEffect" then
        local mult = formatNum(value, modifier.scoreEffect)
        main.updateRichTextText(ui, mult)
      end
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
    
    local ui = main.ui.spawnUI("pressableBox", {
      x=leftCoverX,
      y=y+blockSpacing*(i-1),
      width=330,
      height=blockSpacing,
      modesOrder = i
    })
    table.insert(pressableBoxes, ui)
  end

  --kinda hacky? whatever; on @update, positions will be moved if the difficulty doesn't exist
  local rightCoverX = 1280-380
  for i=1, 4 do
    local ui = main.ui.spawnUI("pressableBox", {
      x=rightCoverX,
      y=y+(i-1)*blockSpacing,
      width=330,
      height=blockSpacing,
      difficultyOrder = i
    })
    table.insert(pressableBoxes, ui)
  end

  main.tweenCamera(0.2, {x=0, y=0})
  main.hideCharts()
end, function ()
  starters = {}
  openModifier("close")
  for k, v in pairs(modifierValues) do
    if v ~= 0 then
      main.runModifiers[k].effect(v)
    end
  end

  deleteAll({toPlay, coverLeft, coverRight, arrowLeft, arrowRight, modifierButton})
  deleteAll(pressableBoxes)
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

main.ui.defineUI("pressableBox", {
  renderLayer = 95,
  width = 1,
  height= 1,
  color = {1, 1, 1, 0},
  screenSpace=true,
  onHover = function (ent)

  end,
  notHovered = function (ent)

  end,
  onMouseReleased = function (ent)
    if ent.modesOrder then
      local i = ent.modesOrder
      if runModeSelected[i] ~= true then
        runModeSelected[i] = true
      else
        runModeSelected[i] = false
      end
    elseif ent.difficultyOrder then
      difficultySelected = ent.difficultyOrder
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
    if selection.isNotImplemented == true then
      return
    end

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

-- main thing to edit when creating: increment, onBasicSliderDraw, targetStorage
main.ui.defineSlider("modifierSlider", {
  attachedModifier = 0,
  defaultWidth = 200,
  defaultHeight = 50,
  renderLayer = 200,
  slideDirection = "horizontal",
  slideAmount = 0.5,
  screenSpace = true,
  increment = 1 / ( 0.1 ),
  outline = 10,
  outlineBelow = true,
  outlineColor = {0.5, 0.5, 0.5},

  onDraw = function (ent)
    local slideAmount = ent.slideAmount or 0.5
    local x = ent.x
    local y = ent.y

    if ent.slideDirection == "horizontal" then
      x = x + ent:getWidth() * slideAmount
      y = y + ent:getHeight()/2
    end

    system.render(ent.renderLayer+1, function ()
      love.graphics.setColor(0.4, 0.4, 0.4)
      love.graphics.circle("fill", x, y, ent:getHeight()/2.2)
    end, ent.screenSpace)
  end,

  onSlide = function (ent, amountScrolled)
    -- snaps it by increments
    local increment = ent.increment
    local slideAmount = math.floor(amountScrolled*increment + 0.5)/increment
    ent.slideAmount = slideAmount
    local range = main.runModifiers[ent.attachedModifier].range
    local rangeAmount = range[2]-range[1]
    local amount = math.floor((range[1]+slideAmount*rangeAmount)+0.5) -- 0 -> -1, 0.5 -> 0, 1 -> 1
    modifierValues[ent.attachedModifier] = amount
    updateModifier()
  end
})

system.on("@update", function ()
  if system.getStorage("main:currentScene") ~= "runSelect" then
    return
  end

  if starters[starterHovering] == nil then
    return
  end

  local rightCoverX = 1280-380
  local starter = starters[starterHovering]
  for i, ui in ipairs(pressableBoxes) do
    if ui.difficultyOrder then
      if #starter.scoreWithDifficulty < ui.difficultyOrder then
        ui.x = 2000
      else
        ui.x = rightCoverX
      end
    end
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

  system.render(82, function ()
    love.graphics.setColor(1, 1, 1, 0.5)
    for i=1, #starters do
      love.graphics.circle("fill", 640-((#starters/2)-(i-0.5))*80, 20, 10)
    end
      love.graphics.circle("fill", 640-((#starters/2)-(starterHovering-0.5))*80, 20, 10)
  end, true)

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