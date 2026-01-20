local flux = system.getStorage("flux")
main.background = {
  entities = {},
  backgrounds = {},
  currentBackground = nil,
  colorMult = {1, 1, 1, 1},
  originalMult = {1, 1, 1, 1},
  fluxuationMult = {1, 1, 1, 1},
}
local bg = main.background

function main.registerBackground(id, t)
  bg.entities[id] = t
  bg.backgrounds[id] = t:new({})
end

function main.playBackground(id)
  if bg.backgrounds[id] == nil then
    error("Background " .. id .. " doesn't exist")
  end

  bg.currentBackground = bg.backgrounds[id]
end

local function fluxuateColor()
  flux.to(bg.fluxuationMult, 8, {love.math.random(90, 110)/100, love.math.random(90, 110)/100, love.math.random(90, 110)/100}):oncomplete(fluxuateColor)
end
fluxuateColor()

system.on("main:sceneChanged", function ()
  local scene = system.getStorage("main:currentScene")
  local time = 4

  if scene == "levelSelect" then
    flux.to(main.background.originalMult, time, {1.2, 1.8, 2})
  elseif scene == "play" then
    flux.to(main.background.originalMult, time, {1.4, 1.6, 2.2})
  elseif scene == "shop" then
    flux.to(main.background.originalMult, time, {2.5, 2.1, 1.4})
  elseif scene == "metashop" then
    flux.to(main.background.originalMult, time, {1.3, 0.7, 0.7})
  else
    flux.to(main.background.originalMult, time, {1, 1, 1})
  end
end)

system.on("@update", function ()
  for i=1, 3 do
    bg.colorMult[i] = bg.originalMult[i] * bg.fluxuationMult[i]
  end

  if bg.currentBackground == nil then
    return
  end

  if bg.currentBackground.update then
    bg.currentBackground:update()
  end
end)

system.on("@draw", function ()
  if bg.currentBackground == nil then
    return
  end

  if bg.currentBackground.draw then
    bg.currentBackground:draw()
  end
end)