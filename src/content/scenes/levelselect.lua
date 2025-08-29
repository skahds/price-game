-- only can click the latest one
local levels = {{x=0, y=0}}
local activeUI = {}

main.defineScene("levelSelect", function ()
  for i, level in ipairs(levels) do
    local x = level.x
    local y = level.y
    local isLast = false
    if i == #levels then
      isLast = true
    end
    local ui = main.ui.spawnUI("levelSelect", {x=x, y=y, isLastLevel=isLast}, true)
    activeUI[i] = ui
    ui.name = "Level " .. i
    main.updateRichTextText(ui.richtext, i)
  end
  local lastUI = activeUI[#activeUI]
  main.tweenCamera(0.2, {
    x=lastUI.x+lastUI.width/2,
    y=lastUI.y+lastUI.height/2})
end, function ()
  for i, ui in ipairs(activeUI) do
    ui:delete()
  end
  activeUI = {}
  local lastLevel = levels[#levels]
  local xAdd = 150
  local yAdd = love.math.random(-100, 100)
  table.insert(levels, {x=lastLevel.x+xAdd, y=lastLevel.y+yAdd})
end)