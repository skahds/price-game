--combo juice!!
local flux = system.getStorage("flux")
local text = main.newRichText({
  format = "a",
  x = 990,
  y = 150,
  renderLayer=70,
  sx=1,
  sy=1,
  ox=1,
  oy=1,
  r=0,
  outline=true,
  color = {1, 1, 1, 0},
  outlineColor = {0.5, 0.5, 0.5, 0},
  font = system.getFont("defaultFont100")
})

local startColor, endColor = {0.95, 0.3, 0.3, 1}, {0.95, 0.62, 0.35}
local infos = {opacity=0, currentCombo = 0, noComboTimer = 0}
system.on("@update", function ()
  local combo = system.getStorage("main:currentCombo")
  if combo == nil or combo <= 1 or system.getStorage("main:isOnTurn") == true then
    infos.noComboTimer = infos.noComboTimer + system.getStorage("dt")
    if infos.noComboTimer > 1 then
      infos.currentCombo = 0
    end

    if infos.noComboTimer > 0.3 then
      flux.to(infos, 0.3, {opacity=0})
    end
  else
    infos.currentCombo = combo
    infos.noComboTimer = 0
    flux.to(infos, 0.1, {opacity=1})
    if infos.opacity < 0.02 then
      infos.opacity = 0
    end
  end
  local comboA = infos.currentCombo

  text.color = utils.lerpColor(startColor, endColor, comboA/10)
  text.outlineColor = utils.lerpColor(startColor, endColor, comboA/10)
  for i, color in ipairs(text.outlineColor) do
    text.outlineColor[i] = color*0.6
  end
  text.color[4] = infos.opacity
  text.outlineColor[4] = infos.opacity

  main.updateRichTextText(text, "COMBO " .. comboA .. "x")
end)

local function makeJuice(text, event)
  system.on(event, function ()
    local rotation = text.r + (love.math.random()-0.5)*2
    local scaleFactor = 1.3
    local sx = text.sx * scaleFactor
    local sy = text.sy * scaleFactor
    flux.to(text, 0.1, {sx = sx, sy=sy, r=rotation}):oncomplete(function ()
      flux.to(text, 0.1, {sx = 1, sy=1,r=0})
    end)
  end)

  system.on("@update", function ()
    local richText = text.richText
    local ox = richText:getWidth()/2
    local oy = richText:getHeight()/2
    text.ox = ox
    text.oy = oy
  end)
end

makeJuice(text, "main:comboChanged")