local isSettingShown = false
local cover, exit, back, restart
local uiInTab = {}
local activeTabs = {}
local sfxStorage, musicStorage, gameSpeedStorage, crtStorage = "audio:sfxVolume", "audio:musicVolume", "main:gameSpeedSlider", "main:crtEffect"
local selectedTab = 1

system.updateStorage(crtStorage, 0.3)
system.updateStorage(gameSpeedStorage, 0.1)
local function deleteAll(arg)
  for k, ent in ipairs(arg) do
    ent:delete()
  end
end

local speedTable = {1, 2, 3, 4, 6, 8, 12, 16, 32, 128}
speedTable[0] = 0.5

local function saveSettings()
  local a = system.getStorage(sfxStorage)
  local b = system.getStorage(musicStorage)
  local c = system.getStorage(gameSpeedStorage)
  local d = system.getStorage(crtStorage)
  local t = {[sfxStorage]=a, [musicStorage]=b, [gameSpeedStorage]=c, [crtStorage]=d}
  system.writeFileTable("settings", t)
end



local function tab1()
  local dimension = system.getStorage("screenDimension")
  table.insert(uiInTab, main.ui.spawnUI("basicSlider", {
    x=dimension.w/2,
    y=dimension.h/2-100,
    width = 300,
    height = 50,
    onBasicSliderDraw = function (ent)
      love.graphics.setColor(1, 1, 1)
      local font = system.getFont("defaultFont50")
      love.graphics.setFont(font)
      local format = "Game speed: " .. speedTable[ent.slideAmount*10] .. "x"
      local width = font:getWidth(format)
      love.graphics.print(format, ent.x+ent:getWidth()/2-width/2, ent.y-50)
    end,
    targetStorage = gameSpeedStorage,
    slideAmount = system.getStorage(gameSpeedStorage) or 0.5,
    ballColor = {0.8, 0.4, 0.4},
    renderLayer = 410,
    outline = 10,
    outlineBelow = true,
    outlineColor = {0.5, 0.5, 0.5},
  }))

  table.insert(uiInTab, main.ui.spawnUI("openCollection", {
    x=dimension.w/2+150-125,
    y=dimension.h/2-30,
    renderLayer = 412,
    height=80
  }))

  table.insert(uiInTab, main.ui.spawnUI("openPatterns", {
    x=dimension.w/2+150-125,
    y=dimension.h/2+80,
    renderLayer = 412,
    height=80
  }))
end

local function tab2()
  local dimension = system.getStorage("screenDimension")
  table.insert(uiInTab, main.ui.spawnUI("basicSlider", {
    x=dimension.w/2,
    y=dimension.h/2-100,
    width = 300,
    height = 50,
    onBasicSliderDraw = function (ent)
      love.graphics.setColor(1, 1, 1)
      local font = system.getFont("defaultFont50")
      love.graphics.setFont(font)
      local format = "CRT: " .. ent.slideAmount * 100 .. "%"
      local width = font:getWidth(format)
      love.graphics.print(format, ent.x+ent:getWidth()/2-width/2, ent.y-50)
    end,
    targetStorage = crtStorage,
    slideAmount = system.getStorage(crtStorage) or 0.5,
    ballColor = {0.8, 0.4, 0.4},
    renderLayer = 410,
    outline = 10,
    outlineBelow = true,
    outlineColor = {0.5, 0.5, 0.5},
  }))
end

local function tab3()
  local dimension = system.getStorage("screenDimension")
  table.insert(uiInTab, main.ui.spawnUI("basicSlider", {
    x=dimension.w/2,
    y=dimension.h/2-100,
    width = 300,
    height = 50,
    onBasicSliderDraw = function (ent)
      love.graphics.setColor(1, 1, 1)
      local font = system.getFont("defaultFont50")
      love.graphics.setFont(font)
      local format = "SFX: " .. ent.slideAmount * 100 .. "%"
      local width = font:getWidth(format)
      love.graphics.print(format, ent.x+ent:getWidth()/2-width/2, ent.y-50)
    end,
    targetStorage = sfxStorage,
    slideAmount = system.getStorage(sfxStorage) or 1,
    ballColor = {0.8, 0.4, 0.4},
    renderLayer = 410,
    outline = 10,
    outlineBelow = true,
    outlineColor = {0.5, 0.5, 0.5},
  }))

  table.insert(uiInTab, main.ui.spawnUI("basicSlider", {
    x=dimension.w/2,
    y=dimension.h/2,
    width = 300,
    height = 50,
    onBasicSliderDraw = function (ent)
      love.graphics.setColor(1, 1, 1)
      local font = system.getFont("defaultFont50")
      love.graphics.setFont(font)
      local format = "MUSIC: " .. ent.slideAmount * 100 .. "%"
      local width = font:getWidth(format)
      love.graphics.print(format, ent.x+ent:getWidth()/2-width/2, ent.y-50)
    end,
    targetStorage = musicStorage,
    slideAmount = system.getStorage(musicStorage) or 1,
    ballColor = {0.8, 0.4, 0.4},
    renderLayer = 411,
    outline = 10,
    outlineBelow = true,
    outlineColor = {0.5, 0.5, 0.5},
  }))
end

local tabs = {tab1, tab2, tab3}

main.defineUITab("settings", function ()
  isSettingShown = true
  local width = 700
  local height = 400
  local dimension = system.getStorage("screenDimension")
  cover = main.ui.spawnUI("cover", {
    x=dimension.w/2-width/2,
    y=dimension.h/2-height/2,
    width = width,
    height = height,
    color = {0.6, 0.6, 0.6},
    outline = 10,
    rx=20,
    ry=20,
    outlineColor = {0.4, 0.4, 0.4},
    ignoreUIChecks = false,
    renderLayer = 400})

  exit = main.ui.spawnUI("settingExit", {
    x=dimension.w/2-width/3-75,
    y=dimension.h/2+80,
    renderLayer = 412,
  })

  back = main.ui.spawnUI("settingBack", {
    x=dimension.w/2-width/3-75,
    y=dimension.h/2-30,
    renderLayer = 412,
  })

  restart = main.ui.spawnUI("settingRestart", {
    x=dimension.w/2-width/3-75,
    y=dimension.h/2-140,
    renderLayer = 412,
  })

  local name = {"GAME", "GRAPHICS", "AUDIO"}
  for i=1, #tabs do
    table.insert(activeTabs, main.ui.spawnUI("settingTab", {
      x=dimension.w/2-width/2+(i-1)*160,
      y=dimension.h/2-height/2-64,
      renderLayer = 412,
      outline = 10,
      rx=20,
      ry=20,
      outlineColor = {0.4, 0.4, 0.4},
      order = i,
      text=name[i],
      font=system.getFont("defaultFont40")
    }))
  end

  tabs[selectedTab]()
end, function ()
  deleteAll({cover, exit, back, restart, collection})
  deleteAll(uiInTab)
  deleteAll(activeTabs)
  isSettingShown = false
  saveSettings()
end)

main.ui.defineButton("settingBack", {
  width = 200,
  height = 80,
  color = {0.4, 0.4, 0.7},
  renderLayer = 101,
  screenSpace = true,
  text = "BACK",
  audio = "breaker",
  onButtonClicked = function (ent)
    main.openUITab("settings", false)
  end
})

main.ui.defineButton("settingExit", {
  width = 200,
  height = 80,
  color = {0.7, 0.4, 0.4},
  renderLayer = 101,
  screenSpace = true,
  text = "EXIT",
  audio = "breaker",
  onButtonClicked = function (ent)
    love.event.quit()
  end
})

main.ui.defineUI("settingTab", {
  renderLayer = 101,
  screenSpace = true,
  width = 160,
  height= 64,
  order = 1,
  color = {0.6, 0.6, 0.6},
  text="REPLACEME",
  onUpdate = function (ent)
    if selectedTab ~= ent.order then
      ent.color = {0.45, 0.45, 0.45}
    else
      ent.color = {0.6, 0.6, 0.6}
    end
  end,
  onMouseReleased = function (ent, button)
    selectedTab = ent.order
    deleteAll(uiInTab)
    tabs[ent.order]()
  end,
})

local function restartGame()
  if #main.getPipeline("scene").pipeline > 0 then
    return
  end
  for k, pile in ipairs(main.getAllPiles()) do
    for i=#pile, 1, -1 do
      local card = pile[i]
      main.deleteCard(card)
    end
  end

  local chart = system.getStorage("main:chart")
  if chart then
    chart:clear()
    for i=#chart.news, 1, -1 do
      local news = chart.news[i]
      main.deleteNews(news)
    end
  end

  system.updateStorage("main:endLevelReward", {})
  main.resetPatterns()

  local mainPipeline = main.getPipeline("main")
  while #mainPipeline.pipeline > 0 do
    mainPipeline:skipCurrentAction()
  end

  main.clearTutorial()
  main.clearRewardOptions()
  main.clearRewardUpgrade()
  main.clearRewardEditPattern()
  main.resetStats()

  if system.getStorage("main:currentScene") == "play" then
    system.updateStorage("main:currentDay", 0)
  end

  main.playScene("menu")
end

main.ui.defineButton("settingRestart", {
  width = 200,
  height = 80,
  color = {0.5, 0.7, 0.6},
  renderLayer = 101,
  screenSpace = true,
  text = "RESTART",
  audio = "breaker",
  onButtonClicked = function (ent)
    restartGame()
    main.closeAllUITabs()
  end
})

main.ui.defineButton("settingGuide", {
  width = 60,
  height = 60,
  color = {0.7, 0.4, 0.4},
  renderLayer = 101,
  screenSpace = true,
  text = "?",
  audio = "breaker",
  onButtonClicked = function (ent)
    main.ui.guidebook()
    main.openUITab("settings", false)
  end
})

system.on("@update", function ()
  local speed = system.getStorage(gameSpeedStorage) or 0.5

  local speed = speed * 10
  local speed = speedTable[speed]
  system.updateStorage("main:defaultDelayMult", speed)
end)

system.on("@load", function ()
  local s = system.readFileTable("settings")
  if s then
    for k, v in pairs(s) do
      system.updateStorage(k, v)
    end
  end
end)

system.on("@draw", function ()
  if isSettingShown then
    system.render(399, function ()
      love.graphics.setColor(0.05, 0.05, 0.05, 0.5)
      love.graphics.rectangle("fill", 0, 0, 1280, 720)
    end, true)
  end
end)