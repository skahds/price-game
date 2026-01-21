local flux = system.getStorage("flux")
local renderLayer =  100
local spawnX = 500
local uis = {}
local existingItems = {}
-- 4 space for card, 2 space for relics?
local items = {card={}, relic={}}
local info = {shelfLine = 0} -- for the uis here

local function deleteAll(args)
  for k, ent in pairs(args) do
    if ent and ent.delete then
      ent:delete()
    end
  end
end

local function clearExistingItem()
  for i=#existingItems, 1, -1 do
    local item = existingItems[i]
    if item.isCard then
      main.deleteCard(item)
    elseif item.isNews then
      item.ui:delete()
      item:delete()
    elseif item.isPatternsCard then
      item.ui:delete()
      item:delete()
    end
  end
  
  existingItems = {}
end

system.on("@load", function ()
  local bag = {}
  for k, ent in pairs(main.entities) do
    if ent.definition and (ent.definition.isCard or ent.definition.isNews) then
      table.insert(bag, ent.definition)
    end
  end

  for i=1, 4 do
    local rand = love.math.random(1, #bag)
    local t = bag[rand]
    if t.isCard then
      table.insert(items.card, t)
    elseif t.isNews then
      table.insert(items.relic, t)
    end
    table.remove(bag[rand])
  end
end)

local function createItem(item, info)
  if item.isCard then
    local c = main.createCard(item.id, {ignoreCardSelect=true}, "misc")
    c.ui.renderLayer = renderLayer+2
    c.ui.x=spawnX
    flux.to(c.ui, 0.2, {x=info.x}):ease("backout")
    c.ui.y=340+(info.y-1)*130
    c.ui.ox = c.ui.width/2
    c.ui.oy = c.ui.height/2
    print("created ", c.ui.x, c.ui.y)
    table.insert(existingItems, c)
  elseif item.isNews then
    local n = main.spawnEntity(item.id, {x=spawnX, y=340+(info.y-1)*130})
    flux.to(n.ui, 0.2, {x=info.x}):ease("backout")
    n.ui.renderLayer = renderLayer+2
    n.ui.sx = 2
    n.ui.sy = 2
    n.ui.ox = n.ui.width/2
    n.ui.oy = n.ui.height/2
    n.ui.screenSpace = true
    n.screenSpace = true
    table.insert(existingItems, n)
  end
end

main.defineScene("metashop", function ()
  local i = 0
  local horizontalAmount = 2
  -- todo: change the x.. probably make a table "slots"? or just handle them nicely whatever
  for e, item in ipairs(items.card) do
    i=i+1
    local x = (i-1)%horizontalAmount
    local y = math.floor((i-1)/horizontalAmount)
    createItem(item, {x=spawnX+(x-1.5)*800/horizontalAmount, y=y})
  end
  for e, item in ipairs(items.relic) do
    i=i+1
    local x = (i-1)%horizontalAmount
    local y = math.floor((i-1)/horizontalAmount)
    createItem(item, {x=spawnX+(x-1.5)*800/horizontalAmount, y=y})
  end

  main.hideCharts()

  flux.to(info, 0.3, {shelfLine = 300})
end, function ()
  local chart = system.getStorage("main:chart")
  if chart == nil then
    main.spawnChart({bearPower = 0.1, bullPower = 0.1})
    chart = system.getStorage("main:chart")
    local pos = chart:getCurrentPricePos()
  end

  deleteAll(uis)
  clearExistingItem()

  info.shelfLine = 0
end)

system.on("@draw", function ()
  if system.getStorage("main:currentScene") ~= "metashop" then
    return
  end

  system.render(renderLayer, function ()
    love.graphics.setColor(0.4, 0.24, 0.24)
    love.graphics.setLineWidth(5)
    local w = info.shelfLine
    love.graphics.line(spawnX-w/2, 100, spawnX+w/2, 100)

    -- love.graphics.draw(system.getImage("metashopBox"), spawnX-100, 200, 0, 1.4, 1.4)
  end, true)
end)