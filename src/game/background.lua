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



main.parallaxClass = class()
local parallax = main.parallaxClass


function parallax:init(options)
  options = options or {}
  self.defaultParallaxFactor = options.defaultParallaxFactor or 0.15 -- parallax factor: 0 = doesn't move at all, 1 = moves with camera
  self.defaultZoomFactor = options.defaultZoomFactor or self.defaultParallaxFactor
  self.tileW = options.tileW or 1000  -- logical "canvas" width to wrap within
  self.tileH = options.tileH or 1000  -- logical "canvas" height to wrap within
end

-- Returns screen-space x, y and a scale multiplier for a given world-space object position.
-- Call this per-object
function parallax:project(objX, objY, _parallaxFactor, _zoomFactor)
  local camera, infos = main.getCamera()
  local sw, sh   = system.getStorage("screenDimension").w, system.getStorage("screenDimension").h
  local cx, cy   = sw / 2, sh / 2

  local parallaxFactor = _parallaxFactor or self.defaultParallaxFactor
  local zoomFactor = _zoomFactor or self.defaultZoomFactor
  -- parallax translation
  local wx = objX - camera.x * parallaxFactor
  local wy = objY - camera.y * parallaxFactor

  -- edge wrapping: keep object within one tileW/tileH of screen centre
  wx = wx - math.floor((wx - cx) / self.tileW  + 0.5) * self.tileW
  wy = wy - math.floor((wy - cy) / self.tileH + 0.5) * self.tileH

  -- parallax zoom around screen centre
  local zoom  = infos.zoom
  local pzoom = zoom ^ zoomFactor
  local sx    = cx + (wx - cx) * pzoom
  local sy    = cy + (wy - cy) * pzoom

  return sx, sy, pzoom
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
    flux.to(main.background.originalMult, time, {1, 0.7, 0.7})
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

system.on("@load", function ()
  main.playBackground("default")
end)