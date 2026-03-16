--the top tab that appears in all scenes when playing the game
local flux = system.getStorage("flux")
local isVisible = false
local uis = {}
local midX = 640
local width = 1300
local height=60

function main.showTopTab()
  isVisible = true
  for i, ui in pairs(uis) do
    ui.isVisible = true
  end
end

function main.hideTopTab()
  isVisible = false
  for i, ui in pairs(uis) do
    ui.isVisible = false
  end
end

system.on("@draw", function ()
  if isVisible == true then

  end
end)

-- maybe use ui for the tab?..
main.ui.defineUI("topTab", {
  defaultWidth = width,
  defaultHeight = 90, --true: 60
  screenSpace = true,
  renderLayer = 600,
  color = {0.7, 0.7, 0.7, 1},
  outline = 5,
  outlineColor = {0.6,0.6,0.6,1},

  onDraw = function (ent)

  end
})

main.ui.defineUI("topTab:openSetting", {
  width = 48,
  height = 48,
  ox=24,
  oy=24,
  image="gearIcon",
  renderLayer = 101,
  screenSpace = true,
  isTweening=false,
  onHover = function (ent)
    if ent.isTweening == false then
      ent.tween = flux.to(ent, 0.3, {sx=1.4, sy=1.4}):ease("backinout")
      ent.isTweening=true
    end
  end,
  notHovered = function (ent)
    if ent.isTweening == true then
      ent.tween = flux.to(ent, 0.3, {sx=1, sy=1}):ease("backinout")
      ent.isTweening=false
    end
  end,
  onMouseReleased = function (ent)
    main.openUITab("settings")
  end
})

system.on("@load", function ()
  uis.topTab = main.ui.spawnUI("topTab", {x=640-width/2, y=-30})
  uis.rightText = main.newRichText({format="a",
    y=5, x=0, renderLayer = 603, outline=true, outlineColor={0,0,0}})
  uis.setting = main.ui.spawnUI("topTab:openSetting", {x=1280-50, y=height/2, renderLayer=603})

  main.hideTopTab()
end)

system.on("@update", function ()
  local money = main.getMoney()
  main.updateRichTextText(uis.rightText, "{moneyColor}$" .. math.floor(money) .. "{/moneyColor}")

  uis.rightText.x = 1280-160 - uis.rightText.richText:getWidth()
end)