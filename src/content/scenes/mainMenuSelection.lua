local flux = system.getStorage("flux")
local uis = {}
local tabBarUI = {}
local tabs = {}
local tabUI = {}
local textGroup = {}
local infos = {selectY = 360, iconGap=100, barGap=250} -- for fluxes/general magic number
local waitInfos = {time = 0}
local currentTab
local rightX = 1280*2/3
local middleY = 360

local function defineTab(eType)
  table.insert(tabs, eType)
  table.insert(tabUI, {})
end

local function animationOpenTab(tab)
  tabs[tab].open(tab)

  if textGroup[tab] then
    for i, text in ipairs(textGroup[tab].texts) do
      flux.to(text, 0.5, {x=(textGroup[tab].info.x or (rightX))}):ease("backout")
    end

    if textGroup[tab].cover then
      flux.to(textGroup[tab].cover, 0.5, {x=(textGroup[tab].info.x or (rightX))}):ease("backout")
    end
  end
end

local function openTab(tab)
  if currentTab and waitInfos.tab == nil then
    if textGroup[currentTab] then
      for i, text in ipairs(textGroup[currentTab].texts) do
        flux.to(text, 0.5, {x=1500}):ease("backin")
      end

      if textGroup[currentTab].cover then
        flux.to(textGroup[currentTab].cover, 0.5, {x=1500}):ease("backin")
      end
    end
    tabs[currentTab].close(currentTab)

    waitInfos.tab = tab
    waitInfos.time = 0.3
  elseif currentTab and waitInfos.tab then
    waitInfos.tab = tab
    waitInfos.time = 0.3
  else
    animationOpenTab(tab)
  end

  currentTab = tab
end

-- just call on load, all other gets executed automatically
local function createTextGroup(tab, info, t)
  textGroup[tab] = {info=utils.deepCopy(info), texts={}, uis={},}
  local tbl = textGroup[tab]
  local totalHeight = 0
  local maxWidth = 0
  for i, str in ipairs(t) do
    local font = system.getFont("defaultFont60")
    if info.font and info.font[i] then
      font = system.getFont(info.font[i])
    end
    local text = main.newRichText({
      format = str,
      x = 1500,
      y = info.y or 360,
      renderLayer = 100,
      font=font,
    })
    text.ox = text.richText:getWidth()/2
    text.y = text.y + totalHeight
    totalHeight = totalHeight + text.richText:getHeight()
    maxWidth = math.max(text.richText:getWidth(), maxWidth)

    table.insert(tbl.texts, text)
  end

  for i, text in ipairs(tbl.texts) do
    text.y = text.y - totalHeight/2
  end

  if info.cover == true then
    tbl.cover = main.ui.spawnUI("cover", {
      x=1500,
      y=(info.y or 360),
      width = maxWidth+30,
      height = totalHeight+30,
      color = {0.6, 0.6, 0.6},
      outline = 10,
      ox = (maxWidth+30)/2,
      oy = (totalHeight+30)/2,
      rx=10,
      ry=10,
      outlineColor = {0.4, 0.4, 0.4},
      ignoreUIChecks = false,
      renderLayer = 98})
  end
end

local function deleteAll(args)
  for k, ent in pairs(args) do
    if ent and ent.delete then
      ent:delete()
    end
  end
end

main.defineScene("mainMenu", function ()
  for i, tab in ipairs(tabs) do
    if tab.load then
      tab.load(i)
    end

    local yIndex = i-(#tabs/2+0.5)
    local y1 = middleY+yIndex*infos.iconGap
    local y2 = middleY+yIndex*infos.barGap

    local ui = main.ui.spawnUI("menuTabIndicator", {x=70, y=y1, image=tab.image, designatedTab=i})
    table.insert(uis, ui)

    local ui = main.ui.spawnUI("menuTabBox", {x=360, y=y2, text=tab.name, designatedTab=i})
    table.insert(tabBarUI, ui)
  end

  openTab(1)

  main.hideCharts()
end, function ()
  for i, tab in ipairs(tabs) do
    if tab.unload then
      tab.unload(i)
    end
  end

  currentTab = nil

  for k, v in pairs(textGroup) do
    for i, text in ipairs(v.texts) do
      text:delete()
    end
    if v.cover then
      v.cover:delete()
    end
  end
  textGroup = {}

  deleteAll(uis)
  deleteAll(tabBarUI)
  uis = {}
  tabBarUI = {}
end)

system.on("@update", function ()
  if system.getStorage("main:currentScene") ~= "mainMenu" then
    return
  end

  if waitInfos.time > 0 then
    waitInfos.time = waitInfos.time - system.getStorage("dt")
    if waitInfos.time <= 0 and waitInfos.tab then
      animationOpenTab(waitInfos.tab)
      waitInfos.time = 0
      waitInfos.tab = nil
    end
  end

  local infosToBeFluxed = {}
  if currentTab then
    local yIndex = currentTab-(#tabs/2+0.5)
    local y = middleY+yIndex*infos.iconGap
    infosToBeFluxed.selectY = y

    for i, tab in ipairs(tabs) do
      if tab.update then
        tab.update(i)
      end
    end
  end

  flux.to(infos, 0.3, infosToBeFluxed)

  for i, ui in ipairs(tabBarUI) do
    local yDiff = (i-(currentTab or 1))*infos.barGap
    flux.to(ui, 0.3, {y=360+yDiff})
  end
end)

system.on("@draw", function ()
  if system.getStorage("main:currentScene") ~= "mainMenu" then
    return
  end

  system.render(100, function ()
    love.graphics.draw(system.getImage("selectTabIcon"), 140, infos.selectY, 0, 1.4, 1.4, 16, 16)

    love.graphics.setLineWidth(5)
    love.graphics.setColor(1, 1, 1, 0.4)
    for i, ui in ipairs(tabBarUI) do
      if i == 1 then
        goto continue
      end
      local x = ui:getX()+ui:getWidth()/2
      local y1 = tabBarUI[i-1]:getY() + ui:getHeight() + 15
      local y2 = ui:getY() - 15
      love.graphics.line(x, y1, x, y2)
      
      ::continue::
    end
  end, true)
end)

system.on("@mouse:wheelmoved", function (t)
  if system.getStorage("main:currentScene") ~= "mainMenu" or currentTab == nil then
    return
  end
  local y=t.y
  if y < 0 and currentTab < #tabs then
    openTab(currentTab + 1)
  elseif y > 0 and currentTab > 1 then
    openTab(currentTab - 1)
  end
end)

main.ui.defineUI("menuTabBox", {
  image = "mainMenuTab",
  renderLayer = 100,
  width = 144,
  height= 72,
  ox=72,
  oy=36,
  sx=1.4,
  sy=1.4,
  screenSpace = true,
  isTweening=false,
  onHover = function (ent)

  end,
  notHovered = function (ent)

  end,
  onMouseReleased = function (ent, button)
    if ent.designatedTab then
      openTab(ent.designatedTab)
    end
  end,
})

main.ui.defineUI("menuTabIndicator", {
  image = "fightNode",
  renderLayer = 100,
  width = 48,
  height= 48,
  ox=24,
  oy=24,
  sx=1.4,
  sy=1.4,
  screenSpace = true,
  isTweening=false,
  onHover = function (ent)
    if ent.isTweening == false then
      ent.tween = flux.to(ent, 0.3, {sx=1.8, sy=1.8}):ease("backout")
      ent.isTweening=true
    end
  end,
  notHovered = function (ent)
    if ent.isTweening == true then
      ent.tween = flux.to(ent, 0.3, {sx=1.4, sy=1.4}):ease("backout")
      ent.isTweening=false
    end
  end,
  onMouseReleased = function (ent, button)
    if ent.designatedTab then
      openTab(ent.designatedTab)
    end
  end,
})



--
-- tabs
--


-- play
main.ui.defineButton("tabPlay:toRunSelect", {
  name = "Play",
  width = 200,
  height = 100,
  color = {0.6, 0.6, 0.9},
  renderLayer = 62,
  screenSpace = true,
  text = "PLAY",
  audio = "breaker",
  onButtonClicked = function (ent)
    local pipeline = main.getPipeline("scene")
    if #pipeline.pipeline == 0 then
      main.playScene("runSelect")
    end
  end
})

defineTab({
  name = "Play",
  image = "playTabIcon",
  load = function (tab)
    local t = main.ui.spawnUI("tabPlay:toRunSelect", {x=1290, y=middleY+120})
    tabUI[tab].play = t

    createTextGroup(tab, {cover=true, font={"defaultFont90"}, y=270}, {"PLAY", "Start a brand", "new run and","earn credits!"})
  end,
  unload = function (tab)
    for k, t in pairs(tabUI[tab]) do
      t:delete()
    end
    tabUI[tab] = {}
  end,
  open = function (tab)
    local t = tabUI[tab].play
    if t then
      flux.to(t, 0.5, {x = rightX - t:getWidth()/2}):ease("backout")
    end
  end,
  close = function (tab)
    local t = tabUI[tab].play
    if t then
      flux.to(t, 0.5, {x = 1290}):ease("backin")
    end
  end,
})



-- metashop
local metashopY = 440
local items = {}
local bag = {}
system.on("@load", function ()
  local t = main.meta.getLockedEntities{type="metashop"}
  for k, ent in pairs(t) do
    table.insert(bag, ent.definition)
  end

  for i=1, 4 do
    local rand = love.math.random(1, #bag)
    local t = bag[rand]
    table.insert(items, t)
    table.remove(bag, rand)
  end
end)

local function deleteItem(item)
  if item.isCard then
    main.deleteCard(item)
  elseif item.isNews then
    item.ui:delete()
    item:delete()
  elseif item.isPatternsCard then
    item.ui:delete()
    item:delete()
  end
end

local function clearExistingItem(t)
  for i=#t, 1, -1 do
    local item = t[i]
    deleteItem(item)
  end
  
  t = {}
end

local function putItemInPlace(tab)
  local xIndex = 1
  local yIndex = 1
  local targetGap = 220
  for e, item in ipairs(tabUI[tab].items) do
    local x = rightX + (xIndex-1.5)*targetGap
    local y = metashopY + (yIndex-1.5)*targetGap
    
    xIndex = xIndex + 1
    if xIndex > 2 then
      xIndex = 1
      yIndex = yIndex + 1
    end
    flux.to(item.ui, 0.5, {x=x, y=y}):ease("backout")
  end
end

local function createItem(item, info)
  if tabUI[info.tab].items == nil then
    tabUI[info.tab].items = {}
  end
  
  local index = #tabUI[info.tab].items
  local yIndex = math.floor(index/2+1)
  local targetGap = 180
  local y = metashopY + (yIndex-1.5)*targetGap

  local t
  if item.isCard then
    local c = main.createCard(item.id, {ignoreCardSelect=true, tab=info.tab}, "metashop")
    c.ui.renderLayer = 98
    c.ui.x = 1350
    c.ui.y = y
    c.ui.ox = c.ui.width/2
    c.ui.oy = c.ui.height/2
    table.insert(tabUI[info.tab].items, c)
    t=c
  elseif item.isNews then
    local n = main.spawnEntity(item.id, {x=1350, y=y, tab=info.tab})
    n.isMetaShop = true
    n.ui.renderLayer = 98
    n.ui.sx = 2
    n.ui.sy = 2
    n.ui.ox = n.ui.width/2
    n.ui.oy = n.ui.height/2
    n.ui.screenSpace = true
    n.screenSpace = true
    table.insert(tabUI[info.tab].items, n)
    t=n
  end
end
--todo: ofc fix bug where if you unlock enough and no more item in bag it crash
local canClick = true
local function unlockItem(ent, tab)
  if ent.alreadyChosen == true then
    return
  end
  ent.alreadyChosen = true

  main.meta.unlock(ent.id)

  main.wait(1, function ()
    canClick=true
  end)

  for i, item in ipairs(tabUI[tab].items) do
    if item == ent then
      table.remove(tabUI[tab].items, i)
    end
  end

  local rand = love.math.random(1, #bag)
  local item = bag[rand]
  table.remove(bag, rand)
  if item then
    createItem(item, {tab=tab})
  end

  local cover = main.ui.spawnUI("cover", {x=640-110, y=720, width=220, height=730,
    renderLayer=102,
    color = {0.7, 0.96, 1},
    outlineColor = {0.4, 0.8, 0.88}, outline=20})
  flux.to(cover, 0.5, {y=-5})

  local ui = ent.ui
  ui.renderLayer = 104
  flux.to(ui, 0.5, {x=640, y=360})
  main.wait(0.8, function ()
    putItemInPlace(tab)
    flux.to(ui, 0.5, {x=640, y=1400}):ease("backin"):oncomplete(function ()
      deleteItem(ent)
    end)
    flux.to(cover, 0.7, {y=-730}):oncomplete(function ()
      cover:delete()
    end)
  end)

  main.createPopupText({text={"ITEM"}, lifetime=1.5, timeMomentaryStill=0.35, x=640, startY=-200, targetY=360-130, outline=true, outlineColor={0, 0, 0}, renderLayer=105,})
  main.createPopupText({text={"UNLOCKED!"}, lifetime=1.5, timeMomentaryStill=0.35, x=640, startY=720+200, targetY=360+90, outline=true, outlineColor={0, 0, 0}, renderLayer=105})
end

system.on("main:cardClicked", function (ent, button)
  if button ~= 1 then
    return
  end

  if ent == nil then
    return
  end

  if ent.ownerShip == "metashop" and canClick then
    canClick = false
    unlockItem(ent, ent.tab)
  end
end)

system.on("main:newsClicked", function (ent, button)
  if button ~= 1 then
    return
  end

  if ent == nil then
    return
  end

  if ent.isMetaShop ~= true then
    return
  end

  if canClick then
    canClick = false
    unlockItem(ent, ent.tab)
  end
end)

defineTab({
  name = "Shop",
  image = "shopTabIcon",
  load = function (tab)
    tabUI[tab].items = {}

    for e, item in ipairs(items) do
      createItem(item, {tab=tab})
    end

    local t = main.newRichText({
      format = 0 .. " {creditIcon}",
      x = 1500,
      y= 100,
      renderLayer = 100,
      outline = true,
      outlineColor={0,0,0},
    })
    t.y = t.y - t.richText:getHeight()/2
    tabUI[tab].credits = t
  end,
  unload = function (tab)
    clearExistingItem(tabUI[tab].items)

    for k, t in pairs(tabUI[tab]) do
      if t.delete then
        t:delete()
      end
    end

    tabUI[tab] = {}
  end,
  open = function (tab)
    putItemInPlace(tab)
    local text = tabUI[tab].credits
    flux.to(text, 0.5, {x=rightX-text.richText:getWidth()/2}):ease("backout")
  end,
  close = function (tab)
    for i, item in ipairs(tabUI[tab].items) do
      flux.to(item.ui, 0.5, {x=1350, y=item.ui.y}):ease("backin")
    end
    flux.to(tabUI[tab].credits, 0.5, {x=1500}):ease("backin")
  end,
  update = function (tab)
    local credits = main.meta.getTable().credits
    if credits and tabUI[tab].credits then
      main.updateRichTextText(tabUI[tab].credits, credits .. " {creditIcon}")
    end

    for i, item in ipairs(tabUI[tab].items) do
      local ui = item.ui
      local x = system.ask("ui:getUIX", combiner.ADD, ui)
      local y = system.ask("ui:getUIY", combiner.ADD, ui)

      local text = main.printRichText({
        format = "30 {creditIcon}",
        x=x,
        y=y+ui:getHeight()/2+15,
        outline = true,
        outlineColor={0,0,0},
        renderLayer=99
      })
      text.x = text.x - text.richText:getWidth()/2
      text.y = text.y - text.richText:getHeight()/2
    end
  end,
})



-- metastats?
defineTab({
  name = "Stats",
  image = "statsTabIcon",
  load = function (tab)
    createTextGroup(tab, {cover=true, font={"defaultFont90"}}, {"STATS", "Run Played: 0", "Credits Earned: 0","Collection : 0/0" ,"Highest Score: 0"})
  end,
  unload = function (tab)
    
  end,
  open = function (tab)
    
  end,
  close = function (tab)
    
  end
})



-- exit?
defineTab({
  name = "Exit",
  image = "exitTabIcon",
  load = function (tab)
    tabUI[tab].exit = main.ui.spawnUI("settingExit", {x=1500, y=720/2})
  end,
  unload = function (tab)
    deleteAll(tabUI[tab])
  end,
  open = function (tab)

    for k, ui in pairs(tabUI[tab]) do
      flux.to(ui, 0.5, {x=rightX-ui:getWidth()/2}):ease("backout")
    end
  end,
  close = function (tab)
    for k, ui in pairs(tabUI[tab]) do
      flux.to(ui, 0.5, {x=1500}):ease("backin")
    end
  end
})