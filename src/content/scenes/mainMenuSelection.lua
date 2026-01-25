local uis = {}
local tabs = {}
local tabUI = {}
local infos = {selectY = 360, iconGap=100} -- for fluxes/general magic number
local currentTab
local rightX = 1280*2/3
local middleY = 360

local function defineTab(eType)
  table.insert(tabs, eType)
  table.insert(tabUI, {})
end

local function openTab(tab)
  if currentTab then
    tabs[currentTab].unload(currentTab)
  end
  currentTab = tab
  tabs[tab].load(tab)
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
  openTab(1)
  for i, tab in ipairs(tabs) do
    local yIndex = i-(#tabs/2+0.5)
    local y = middleY+yIndex*infos.iconGap

    local ui = main.ui.spawnUI("menuTabIndicator", {x=100, y=y, image=tab.image, designatedTab=i})
    table.insert(uis, ui)
  end

  main.hideCharts()
end, function ()
  if currentTab then
    tabs[currentTab].unload(currentTab)
  end
  currentTab = nil

  deleteAll(uis)
end)

system.on("@draw", function ()
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


  system.render(100, function ()
    love.graphics.draw(system.getImage("selectTabIcon"), 170, infos.selectY, 0, 1.4, 1.4, 16, 16)
  end, true)
end)

main.ui.defineUI("menuTabBox", {
  image = "mainMenuTab",
  renderLayer = 100,
  width = 96,
  height= 48,
  ox=48,
  oy=24,
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
    local t = main.ui.spawnUI("tabPlay:toRunSelect", {x=rightX, y=middleY+200})
    t.x = t.x - t:getWidth()/2
    table.insert(tabUI[tab], t)
  end,
  unload = function (tab)
    for k, v in pairs(tabUI[tab]) do
      v:delete()
    end
  end
})

-- metashop
defineTab({
  name = "Shop",
  image = "shopTabIcon",
  load = function (tab)
    
  end,
  unload = function (tab)
    
  end
})

-- metastats?
defineTab({
  name = "Stats",
  image = "shopTabIcon",
  load = function (tab)
    
  end,
  unload = function (tab)
    
  end
})

-- exit?
defineTab({
  name = "Exit",
  image = "shopTabIcon",
  load = function (tab)
    
  end,
  unload = function (tab)
    
  end
})