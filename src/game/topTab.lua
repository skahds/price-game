--the top tab that appears in all scenes when playing the game
local isVisible = false
local uis = {}

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
  defaultWidth = 1400,
  defaultHeight = 80, --true: 50
  screenSpace = true,
  renderLayer = 600,
  color = {0.8, 0.8, 0.8, 1},
  outline = 5,
  outlineColor = {0.65,0.65,0.65,1},

  onDraw = function (ent)

  end
})

system.on("@load", function ()
  uis.topTab = main.ui.spawnUI("topTab", {x=-50, y=-30})

  -- main.hideTopTab()
end)