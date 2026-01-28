local uis = {}
local tabBarUI = {}
local tabs = {}
local tabUI = {}
local infos = {selectY = 360, iconGap=100, barGap=250} -- for fluxes/general magic number
local currentTab
local rightX = 1280*2/3
local middleY = 360

local function defineTab(eType)
  table.insert(tabs, eType)
  table.insert(tabUI, {})
end

local function openTab(tab)
  if currentTab then
    tabs[currentTab].close(currentTab)
  end
  currentTab = tab
  tabs[tab].open(tab)
end

local function deleteAll(args)
  for k, ent in pairs(args) do
    if ent and ent.delete then
      ent:delete()
    end
  end
end

local flux = system.getStorage("flux")
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

    local ui = main.ui.spawnUI("menuTabBox", {x=300, y=y2, text=tab.name, designatedTab=i})
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

  deleteAll(uis)
  deleteAll(tabBarUI)
end)

system.on("@update", function ()
  if system.getStorage("main:currentScene") ~= "mainMenu" then
    return
  end

  local infosToBeFluxed = {}
  if currentTab then
    local yIndex = currentTab-(#tabs/2+0.5)
    local y = middleY+yIndex*infos.iconGap
    infosToBeFluxed.selectY = y
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

-- tabs
-- play
defineTab({
  name = "Play",
  image = "playTabIcon",
  load = function (tab)
    local t = main.ui.spawnUI("tabPlay:toRunSelect", {x=1290, y=middleY+200})
    tabUI[tab].play = t
  end,
  unload = function (tab)
    for k, t in pairs(tabUI[tab]) do
      t:delete()
    end
    tabUI[tab] = nil
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
defineTab({
  name = "Shop",
  image = "shopTabIcon",
  load = function (tab)
    
  end,
  unload = function (tab)
    
  end,
  open = function (tab)
    
  end,
  close = function (tab)
    
  end
})

-- metastats?
defineTab({
  name = "Stats",
  image = "shopTabIcon",
  load = function (tab)
    
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
  image = "shopTabIcon",
  load = function (tab)
    
  end,
  unload = function (tab)
    
  end,
  open = function (tab)
    
  end,
  close = function (tab)
    
  end
})