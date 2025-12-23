local play
local credits
local logo
local discord
local settings
local continue
local collection

local function deleteAll(args)
  for k, ent in pairs(args) do
    if ent and ent.delete then
      ent:delete()
    end
  end
end

local flux = system.getStorage("flux")
main.defineScene("menu", function ()
  logo = main.ui.spawnUI("logo", {x=640-220, y=-300})
  flux.to(logo, 2, {y=100})
  if love.filesystem.getInfo("save.sav") then
    play = main.ui.spawnUI("menuPlay", {x=640-110-150, y=390})
    continue = main.ui.spawnUI("loadGame", {x=640-110+150, y=390})
  else
    play = main.ui.spawnUI("menuPlay", {x=640-110, y=390})
  end
  collection = main.ui.spawnUI("openCollection", {x=640-125, y=720-150})
  credits = main.ui.spawnUI("credits", {x=20, y=20})
  discord = main.ui.spawnUI("discord", {x=20, y=720-150})
  settings = main.ui.spawnUI("openSetting", {x=1280-20-200, y=720-150})
  main.hideCharts()
end, function ()
  local chart = system.getStorage("main:chart")
  if chart == nil then
    main.spawnChart({bearPower = 0.1, bullPower = 0.1})
    chart = system.getStorage("main:chart")
    local pos = chart:getCurrentPricePos()
  end

  deleteAll({play, credits, logo, discord, continue, settings, collection})
end)