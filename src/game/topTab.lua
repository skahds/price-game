--the top tab that appears in all scenes when playing the game
local flux = system.getStorage("flux")
local isVisible = false
local uis = {}
local midX = 640
local width = 1300
local renderLayer = 600
local height=60
local gapPerIcon = 10
local iconSize = 48
local totalGapForIcon = gapPerIcon+iconSize
local heightGapForIcon = (height-iconSize)/2

local function deleteAll(args)
  if args == nil then return end
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
    local itemInfo = main.getAllComponentsFromEntity(listOfItemsToCreate[itemI])
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
      local c = main.createCard(cardID, itemInfo, "misc")
      c.ignoreCardSelect = true

      c.ui.renderLayer = renderLayer+2
      c.ui.x=middleX
      local targetX = (utils.createEvenlySpacedPosition(amountInCol)[x+1]*600) / amountInCol
      flux.to(c.ui, 0.2, {x=640+targetX}):ease("backout")
      c.ui.y=360+15+(y-1)*90
      c.ui.ox = c.ui.width/2
      c.ui.oy = c.ui.height/2
      c.ui.sx = 1.3
      c.ui.sy = 1.3
      table.insert(runStatsItems, c)
    elseif item.isNews then
      local cardID = item.id
      local targetX = (utils.createEvenlySpacedPosition(amountInCol)[x+1]*600) / amountInCol
      local n = main.spawnEntity(cardID, {x=middleX, y=360+15+(y-1)*90})
      for k, v in pairs(itemInfo) do
        n[k] = utils.deepCopy(v)
      end
      flux.to(n.ui, 0.2, {x=640+targetX}):ease("backout")
      n.ui.renderLayer = renderLayer+2
      n.ui.sx = 2
      n.ui.sy = 2
      if n.ui:getWidth() > 96 then
        n.ui.sx = 96 / n.ui.width
        n.ui.sy = 96 / n.ui.height
      end
      n.ui.ox = n.ui.width/2
      n.ui.oy = n.ui.height/2
      n.ui.screenSpace = true
      n.screenSpace = true
      table.insert(runStatsItems, n)
    end
  end
end

main.defineUITab("runStats", function ()
  local rightX = 640+coverWidth/2
  local leftX = 640-coverWidth/2
  local y = 360-coverHeight/2
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

  runStatsUI.topText = main.newRichText({
    x=640,
    y=360-coverHeight/2+15,
    format = "RUN INFO",
    renderLayer = renderLayer+2,
    outline=true,
    outlineColor={0,0,0},
  })
  runStatsUI.topText.x = runStatsUI.topText.x - runStatsUI.topText.richText:getWidth()/2

  spawnItems()

  -- creditsMult
  table.insert(runStatsUI, main.ui.spawnUI("cover", {x=leftX-180, y=y, width=180, height=80,
    rx=20, ry=20,
    renderLayer=570,
    color = {0.6, 0.6, 0.6},
    outlineColor = {0.4, 0.4, 0.4}, outline=10}))

  local creditMult = main.getTotalCreditsMultilpier()
  local text = "x" .. math.floor(creditMult*100+0.5)/100 .. " {creditIcon}"
  local t = main.newRichText({
    format = text,
    x = leftX-90,
    y = y+40,
    renderLayer=renderLayer+1,
    font = system.getFont("defaultFont50"),
    outline=true,
    outlineColor={0,0,0},
  })
  t.x = t.x - t.richText:getWidth()/2
  t.y = t.y - t.richText:getHeight()/2
  table.insert(runStatsUI, t)

  --cycle boss
  local currentCycle = system.getStorage("main:currentCycle") or 1
  local cycleBossInfo = system.getStorage("main:cycleBossInfo") or {}

  if cycleBossInfo[currentCycle] ~= nil then
  table.insert(runStatsUI, main.ui.spawnUI("cover", {x=rightX, y=y, width=150, height=160,
    rx=20, ry=20,
    renderLayer=570,
    color = {0.6, 0.6, 0.6},
    outlineColor = {0.4, 0.4, 0.4}, outline=10}))

  local formatForText = {"Cycle " .. currentCycle .. "'s", "Boss"}
  for i=1, 2 do
    local t = main.newRichText({
      format = formatForText[i],
      x = rightX+75,
      y = y+40,
      renderLayer=renderLayer+1,
      font = system.getFont("defaultFont40"),
      outline=true,
      outlineColor={0,0,0},
    })
    t.x = t.x - t.richText:getWidth()/2
    t.y = t.y - t.richText:getHeight()/2
    t.y = t.y + (i-1.5)*45/2
    table.insert(runStatsUI, t)
  end

  if cycleBossInfo[currentCycle] then
    local n = main.spawnEntity(cycleBossInfo[currentCycle], {x=rightX+75, y=y+160-50})
    n.ui.renderLayer = renderLayer+2
    n.ui.sx = 2
    n.ui.sy = 2
    n.ui.ox = n.ui.width/2
    n.ui.oy = n.ui.height/2
    n.ui.screenSpace = true
    n.screenSpace = true
    runStatsUI.bossNews = n
  end
  end

end, function ()
  clearExistingItem()

  if runStatsUI.bossNews then
    runStatsUI.bossNews.ui:delete()
    runStatsUI.bossNews:delete()
  end

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

  local startX = 1280-iconSize/2-heightGapForIcon

  uis.setting = main.ui.spawnUI("topTab:openSetting", {x=startX, y=height/2})
  uis.stats = main.ui.spawnUI("topTab:openRunInfo", {x=startX-totalGapForIcon, y=height/2})
  uis.statsText = main.newRichText({format="a",
    y=5, x=20, renderLayer = 604, outline=true, outlineColor={0,0,0}, font=system.getFont("defaultFont40")})

  uis.rightText = main.newRichText({format="a",
    y=5, x=0, renderLayer = 603, outline=true, outlineColor={0,0,0}})

  uis.leftText = main.newRichText({format="a",
    y=5, x=20, renderLayer = 603, outline=true, outlineColor={0,0,0}})

  main.hideTopTab()
end)

system.on("@update", function ()
  local money = main.getMoney()
  local credits = main.meta.getCredits()
  main.updateRichTextText(uis.rightText, credits .. " {creditIcon}   {moneyColor}$" .. math.floor(money) .. "{/moneyColor}")
  uis.rightText.x = 1280-iconSize/2-heightGapForIcon-totalGapForIcon-40 - uis.rightText.richText:getWidth()

  if uis.statsText then
    main.updateRichTextText(uis.statsText, #main.getDeckCards() or 0)
    uis.statsText.x = uis.stats:getX()+uis.stats:getWidth()-15
    uis.statsText.y = uis.stats:getY()+uis.stats:getHeight()-10
    uis.statsText.ox = uis.statsText.richText:getWidth()/2
    uis.statsText.oy = uis.statsText.richText:getHeight()/2
  end

  local runStats = system.getStorage("main:runStats") or {}
  local starterName = runStats.name or ""
  local currentDay = system.getStorage("main:currentRoute") or 1
  local currentCycle = system.getStorage("main:currentCycle") or 1
  local route = system.getStorage("main:route") or {}
  main.updateRichTextText(uis.leftText, starterName .. " - Cycle " .. currentCycle .. "/" .. #route ..  " | Day " .. currentDay)
end)