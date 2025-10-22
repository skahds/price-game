local isSettingShown = false
local cover, sfxSlider, musicSlider, exit, back, restart
local sfxStorage, musicStorage = "audio:sfxVolume", "audio:musicVolume"

local function deleteAll(arg)
  for k, ent in ipairs(arg) do
    ent:delete()
  end
end

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
      renderLayer = 400}, true)
    
    sfxSlider = main.ui.spawnUI("basicSlider", {
      x=dimension.w/2,
      y=dimension.h/2-100,
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

    exit = main.ui.spawnUI("exit", {
      x=dimension.w/2-width/4-75,
      y=dimension.h/2+80,
      renderLayer = 412,
    }, true)

    back = main.ui.spawnUI("back", {
      x=dimension.w/2-width/4-75,
      y=dimension.h/2-30,
      renderLayer = 412,
    }, true)

    restart = main.ui.spawnUI("restart", {
      x=dimension.w/2-width/4-75,
      y=dimension.h/2-140,
      renderLayer = 412,
    }, true)
  else
    deleteAll({cover, sfxSlider, musicSlider, exit, back, restart})
    isSettingShown = false
  end
end