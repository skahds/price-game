local isSettingShown = false
local cover, gameSpeedSlider, sfxSlider, musicSlider, exit, back, restart, guide
local sfxStorage, musicStorage, gameSpeedStorage = "audio:sfxVolume", "audio:musicVolume", "main:gameSpeedSlider"

local function deleteAll(arg)
  for k, ent in ipairs(arg) do
    ent:delete()
  end
end

local speedTable = {0.1, 0.2, 0.5, 0.75, 1, 2, 3, 4, 5, 6}
speedTable[0] = 0

function main.ui.gameSettings()
  if isSettingShown == false then
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
      outline = 20,
      outlineColor = {0.2, 0.2, 0.2},
      ignoreUIChecks = false,
      renderLayer = 400}, true)

    gameSpeedSlider = main.ui.spawnUI("basicSlider", {
      x=dimension.w/2,
      y=dimension.h/2-100,
      width = 300,
      height = 50,
      onBasicSliderDraw = function (ent)
        love.graphics.setColor(1, 1, 1)
        local font = system.getFont("defaultFont50")
        love.graphics.setFont(font)
        local format = "Game speed " .. speedTable[ent.slideAmount*10] .. "x"
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
    }, true)
    
    sfxSlider = main.ui.spawnUI("basicSlider", {
      x=dimension.w/2,
      y=dimension.h/2,
      width = 300,
      height = 50,
      onBasicSliderDraw = function (ent)
        love.graphics.setColor(1, 1, 1)
        local font = system.getFont("defaultFont50")
        love.graphics.setFont(font)
        local format = "SFX " .. ent.slideAmount * 100 .. "%"
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
    }, true)

    musicSlider = main.ui.spawnUI("basicSlider", {
      x=dimension.w/2,
      y=dimension.h/2+100,
      width = 300,
      height = 50,
      onBasicSliderDraw = function (ent)
        love.graphics.setColor(1, 1, 1)
        local font = system.getFont("defaultFont50")
        love.graphics.setFont(font)
        local format = "MUSIC " .. ent.slideAmount * 100 .. "%"
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
    }, true)

    exit = main.ui.spawnUI("settingExit", {
      x=dimension.w/2-width/4-75,
      y=dimension.h/2+80,
      renderLayer = 412,
    }, true)

    back = main.ui.spawnUI("settingBack", {
      x=dimension.w/2-width/4-75,
      y=dimension.h/2-30,
      renderLayer = 412,
    }, true)

    restart = main.ui.spawnUI("settingRestart", {
      x=dimension.w/2-width/4-75,
      y=dimension.h/2-140,
      renderLayer = 412,
    }, true)

    guide = main.ui.spawnUI("settingGuide", {
      x=dimension.w/2-width/4-75-80,
      y=dimension.h/2-140,
      renderLayer = 412,
    }, true)
  else
    deleteAll({cover, sfxSlider, musicSlider, exit, back, restart, guide, gameSpeedSlider})
    isSettingShown = false
  end
end

main.ui.defineButton("settingBack", {
  width = 200,
  height = 80,
  color = {0.4, 0.4, 0.7},
  renderLayer = 101,
  screenSpace = true,
  text = "BACK",
  audio = "breaker",
  onButtonClicked = function (ent)
    main.ui.gameSettings()
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
    -- save game later
    love.event.quit()
  end
})

-- TEMPORARY
main.ui.defineButton("settingRestart", {
  width = 200,
  height = 80,
  color = {0.5, 0.7, 0.6},
  renderLayer = 101,
  screenSpace = true,
  text = "RESTART",
  audio = "breaker",
  onButtonClicked = function (ent)
    love.event.restart()
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
    main.ui.gameSettings()
  end
})

system.on("@update", function ()
  local speed = system.getStorage(gameSpeedStorage) or 0.5

  local speed = speed * 10
  local speed = speedTable[speed]
  system.updateStorage("main:defaultDelayMult", speed)
end)