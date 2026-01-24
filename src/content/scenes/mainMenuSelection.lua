local uis = {}
local tabs = {}
local tabUI = {}
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

  main.hideCharts()
end, function ()
  if currentTab then
    tabs[currentTab].unload(currentTab)
  end
  currentTab = nil

  deleteAll(uis)
end)

-- play
main.ui.defineButton("tabPlay:toRunSelect", {
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
  image = "shopTabIcon",
  load = function (tab)
    
  end,
  unload = function (tab)
    
  end
})

-- metastats
defineTab({
  image = "shopTabIcon",
  load = function (tab)
    
  end,
  unload = function (tab)
    
  end
})