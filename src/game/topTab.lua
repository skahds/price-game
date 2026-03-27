--the top tab that appears in all scenes when playing the game
local flux = system.getStorage("flux")
local isVisible = false
local uis = {}
local midX = 640
local width = 1300
local renderLayer = 600
local height=60

local function deleteAll(args)
  for k, ent in pairs(args) do
    if type(ent) == "table" and ent.delete then
      ent:delete()
    end
  end
end

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

local function defineTopTabButton(arg)
  main.ui.defineUI(arg.id, {
    width = 48,
    height = 48,
    ox=24,
    oy=24,
    image=arg.image,
    renderLayer = 603,
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
    onMouseReleased = arg.onMouseReleased
  })
end

defineTopTabButton({
  id="topTab:openSetting",
  image="gearIcon",
  onMouseReleased = function ()
    main.openUITab("settings")
  end
})

local runStatsUI = {}
local runStatsItems = {}
local coverWidth, coverHeight = 700, 400

local function clearExistingItem()
  for i=#runStatsItems, 1, -1 do
    local item = runStatsItems[i]
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
  
  runStatsItems = {}
end

local function checkRarity(ent)
  local rarity = ent.definition.rarity.id
  if rarity == "COMMON" or rarity == "RARE" or rarity == "EPIC" or rarity == "STARTER" or rarity == "UNIQUE" then
    return true
  else
    return false
  end
end

local function sortT(t)
  local sortValue = {STARTER=1, COMMON=2, RARE=3, EPIC=4, UNIQUE=5}
  -- sorts by rarity (common first), then sort the ents of the same rarity alphabetically
  table.sort(t, function (ent, ent2)
    local def1 = ent.definition
    local def2 = ent2.definition
    local rarity1 = def1.rarity.id
    local rarity2 = def2.rarity.id
    
    local sort1 = sortValue[rarity1]
    local sort2 = sortValue[rarity2]
    
    if sort1 ~= sort2 then
      return sort1 < sort2
    else
      return def1.name < def2.name
    end
  end)
end

local function spawnItems()
  local contentVertical = 3
  local cardList, newsList, listOfItemsToCreate = {}, {}, {}
  for i, card in ipairs(main.getDeckCards()) do
    if checkRarity(card) then
      table.insert(cardList, card)
    end
  end
  sortT(cardList)

  local chart = system.getStorage("main:chart")
  chart:forAllNews(function (ent)
    if ent.isRelic and checkRarity(ent) then
      table.insert(newsList, ent)
    end
  end)
  sortT(newsList)
  
  for i, ent in ipairs(cardList) do
    table.insert(listOfItemsToCreate, ent)
  end
  for i, ent in ipairs(newsList) do
    table.insert(listOfItemsToCreate, ent)
  end

  local cols = math.ceil(#listOfItemsToCreate / contentVertical)
  for i=1, #listOfItemsToCreate do
    local itemI = i
    local item = listOfItemsToCreate[itemI].definition
    local middleX = 640
    local x = (i - 1) % cols
    local y = math.floor((i - 1) / cols)
    local amountInCol
    if y < 2 then
      amountInCol = cols
    else
      amountInCol = #listOfItemsToCreate - cols * 2
    end

    if item.isCard then
      local cardID = item.id
      if main.meta.isEntityUnlocked(item.id) == false then
        cardID = "lockedCard"
      end
      local c = main.createCard(cardID, {ignoreCardSelect=true}, "misc")

      c.ui.renderLayer = renderLayer+2
      c.ui.x=middleX
      local targetX = (utils.createEvenlySpacedPosition(amountInCol)[x+1]*600) / amountInCol
      flux.to(c.ui, 0.2, {x=640+targetX}):ease("backout")
      c.ui.y=360+(y-1)*90
      c.ui.ox = c.ui.width/2
      c.ui.oy = c.ui.height/2
      table.insert(runStatsItems, c)
    elseif item.isNews then
      local cardID = item.id
      if main.meta.isEntityUnlocked(item.id) == false then
        cardID = "lockedNews"
      end
      local targetX = (utils.createEvenlySpacedPosition(amountInCol)[x+1]*600) / amountInCol
      local n = main.spawnEntity(cardID, {x=middleX, y=360+(y-1)*90})
      flux.to(n.ui, 0.2, {x=640+targetX}):ease("backout")
      n.ui.renderLayer = renderLayer+2
      n.ui.sx = 2
      n.ui.sy = 2
      n.ui.ox = n.ui.width/2
      n.ui.oy = n.ui.height/2
      n.ui.screenSpace = true
      n.screenSpace = true
      table.insert(runStatsItems, n)
    end
  end
end

main.defineUITab("runStats", function ()
  runStatsUI.cover = main.ui.spawnUI("cover", {
    x=640-coverWidth/2,
    y=360-coverHeight/2,
    width = coverWidth,
    height = coverHeight,
    color = {0.6, 0.6, 0.6},
    outline = 10,
    rx=20,
    ry=20,
    outlineColor = {0.4, 0.4, 0.4},
    ignoreUIChecks = false,
    renderLayer = 570})

  spawnItems()
end, function ()
  clearExistingItem()
  deleteAll(runStatsUI)
end)

defineTopTabButton({
  id="topTab:openRunInfo",
  image="topTabStatsIcon",
  onMouseReleased = function ()
    main.openUITab("runStats")
  end
})



system.on("@load", function ()
  uis.topTab = main.ui.spawnUI("topTab", {x=640-width/2, y=-30})

  local gapPerIcon = 10
  local iconSize = 48
  local totalGapForIcon = gapPerIcon+iconSize
  local heightGapForIcon = (height-iconSize)/2
  local startX = 1280-iconSize/2-heightGapForIcon

  uis.setting = main.ui.spawnUI("topTab:openSetting", {x=startX, y=height/2})
  uis.stats = main.ui.spawnUI("topTab:openRunInfo", {x=startX-totalGapForIcon, y=height/2})

  uis.rightText = main.newRichText({format="a",
    y=5, x=0, renderLayer = 603, outline=true, outlineColor={0,0,0}})

  main.hideTopTab()
end)

system.on("@update", function ()
  local money = main.getMoney()
  main.updateRichTextText(uis.rightText, "{moneyColor}$" .. math.floor(money) .. "{/moneyColor}")

  uis.rightText.x = 1280-160 - uis.rightText.richText:getWidth()
end)