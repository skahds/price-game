local renderLayer = 220
local flux = system.getStorage("flux")
local listOfItems = {}
local existingItems = {}
local currentPage = 1
local amountOfPage
local contentPerPage = 12
local contentHorizontal = 4
local selectLeft, selectRight
local close
local cover
local topText, currentPageText

local function checkRarity(ent)
  local rarity = ent.definition.rarity.id
  if rarity == "COMMON" or rarity == "RARE" or rarity == "EPIC" or rarity == "STARTER" then
    return true
  else
    return false
  end
end

local function sortT(t)
  local sortValue = {STARTER=1, COMMON=2, RARE=3, EPIC=4}
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

system.on("@load", function ()
  local newsList = {}
  for k, ent in pairs(main.entities) do
    if ent.definition and ent.definition.isNews and checkRarity(ent) then
      table.insert(newsList, ent)
    end
  end
  sortT(newsList)

  local cardList = {}
  for k, ent in pairs(main.entities) do
    if ent.definition and ent.definition.isCard and checkRarity(ent) then
      table.insert(cardList, ent)
    end
  end
  sortT(cardList)

  for i, item in ipairs(newsList) do
    table.insert(listOfItems, item)
  end
  
  for i, item in ipairs(cardList) do
    table.insert(listOfItems, item)
  end

  local listOfEnemy = {}
  for i, enemy in ipairs(main.enemies.entities) do
    table.insert(listOfEnemy, enemy)
  end
  table.sort(listOfEnemy, function (a, b)
    return a.name < b.name
  end)
  for i, item in ipairs(listOfEnemy) do
    table.insert(listOfItems, item)
  end

  local listOfOriginalPattern = {}
  local listOfUpgradePattern = {}
  for i, card in ipairs(main.patternsCardEntities) do
    local def = card.definition
    if def.ignoreForPick ~= true then
      if def.category == "default" then
        table.insert(listOfOriginalPattern, card)
      elseif def.category == "upgrade" then
        table.insert(listOfUpgradePattern, card)
      end
    end
  end
  table.sort(listOfOriginalPattern, function (a, b)
    return a.definition.name < b.definition.name
  end)
  table.sort(listOfUpgradePattern, function (a, b)
    return a.definition.name < b.definition.name
  end)
  for i, item in ipairs(listOfOriginalPattern) do
    table.insert(listOfItems, item)
  end
  for i, item in ipairs(listOfUpgradePattern) do
    table.insert(listOfItems, item)
  end

  amountOfPage = math.floor(#listOfItems/contentPerPage)+1
end)

local function deleteAll(args)
  if args == nil then return end
  for k, ent in pairs(args) do
    if type(ent) == "table" and ent.delete then
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

local function updateContent()
  local startI = (currentPage-1) * contentPerPage
  local contentInThisPage = contentPerPage
  if currentPage == amountOfPage then
    contentInThisPage = #listOfItems - contentPerPage * (currentPage-1)
  end

  clearExistingItem()
  
  for i=1, contentInThisPage do
    local itemI = startI+i --yeahyeah it starts at 0 whatever
    local item = listOfItems[itemI].definition
    local middleX = 640
    local x = (i-1)%contentHorizontal
    local y = math.floor((i-1)/contentHorizontal)
    if item.isCard then
      local cardID = item.id
      if main.meta.isEntityUnlocked(item.id) == false then
        cardID = "lockedCard"
      end
      local c = main.createCard(cardID, {ignoreCardSelect=true}, "misc")

      c.ui.renderLayer = renderLayer+2
      c.ui.x=middleX
      flux.to(c.ui, 0.2, {x=640+(x-1.5)*800/contentHorizontal}):ease("backout")
      c.ui.y=340+(y-1)*130
      c.ui.ox = c.ui.width/2
      c.ui.oy = c.ui.height/2
      table.insert(existingItems, c)
    elseif item.isNews then
      local cardID = item.id
      if main.meta.isEntityUnlocked(item.id) == false then
        cardID = "lockedNews"
      end
      local n = main.spawnEntity(cardID, {x=middleX, y=340+(y-1)*130})
      flux.to(n.ui, 0.2, {x=640+(x-1.5)*800/contentHorizontal}):ease("backout")
      n.ui.renderLayer = renderLayer+2
      n.ui.sx = 2
      n.ui.sy = 2
      n.ui.ox = n.ui.width/2
      n.ui.oy = n.ui.height/2
      n.ui.screenSpace = true
      n.screenSpace = true
      table.insert(existingItems, n)
    elseif item.isPatternsCard then
      local c = main.spawnPatternsCard(item.id, {})
      local ui = main.createPatternsUIForCard(c)
      c.ui = ui
      ui.renderLayer = renderLayer+2
      ui.x=middleX
      flux.to(ui, 0.2, {x=640+(x-1.5)*800/contentHorizontal}):ease("backout")
      ui.y=340+(y-1)*130
      ui.ox = ui.width/2
      ui.oy = ui.height/2
      table.insert(existingItems, c)
    end
  end
end

local function buttonClick(n)
  if n > 0 and currentPage ~= amountOfPage then
    currentPage = currentPage + 1
    updateContent()
  elseif n < 0 and currentPage ~= 1 then
    currentPage = currentPage - 1
    updateContent()
  elseif n > 0 and currentPage == amountOfPage then
    currentPage = 1
    updateContent()
  elseif n < 0 and currentPage == 1 then
    currentPage = amountOfPage
    updateContent()
  end
  main.updateRichTextText(currentPageText, "page " .. currentPage .. "/" .. amountOfPage)
end

main.defineUITab("collection", function ()
  cover = main.ui.spawnUI("cover", {
    x=640-400,
    y=360-300,
    width = 800,
    height = 600,
    color = {0.6, 0.6, 0.6},
    outline = 10,
    rx=20,
    ry=20,
    outlineColor = {0.4, 0.4, 0.4},
    ignoreUIChecks = false,
    renderLayer = renderLayer})

  selectLeft = main.ui.spawnUI("collectionSelect", {
    x=640-150-40,
    y=550,
    renderLayer = renderLayer+2,
    text="<",
    onButtonClicked = function ()
      buttonClick(-1)
    end
  })

  selectRight = main.ui.spawnUI("collectionSelect", {
    x=640+150-40,
    y=550,
    renderLayer = renderLayer+2,
    text=">",
    onButtonClicked = function ()
      buttonClick(1)
    end
  })
  
  currentPageText = main.newRichText({
    x=640,
    y=590,
    format = "page " .. currentPage .. "/" .. amountOfPage,
    renderLayer = renderLayer+2,
    outline=true,
    outlineColor={0,0,0},
  })
  currentPageText.x = currentPageText.x - currentPageText.richText:getWidth()/2
  currentPageText.y = currentPageText.y - currentPageText.richText:getHeight()/2

  topText = main.newRichText({
    x=640,
    y=80,
    format = "Collection",
    renderLayer = renderLayer+1,
    font = system.getFont("defaultFont80"),
    outline=true,
    outlineColor={0,0,0},
  })
  topText.x = topText.x - topText.richText:getWidth()/2

  close = main.ui.spawnUI("collectionClose", {
    x=940,
    y=80,
    renderLayer = renderLayer+2,
  })

  updateContent()
end, function ()
  clearExistingItem()
  deleteAll({cover, selectLeft, selectRight, currentPageText, close, topText})
end)

main.ui.defineButton("openCollection", {
  width = 250,
  height = 100,
  color = {0.95, 0.7, 0.3},
  renderLayer = 101,
  screenSpace = true,
  text = "COLLECTION",
  audio = "breaker",
  onButtonClicked = function (ent)
    main.openUITab("collection")
  end
})

main.ui.defineButton("collectionSelect", {
  width = 80,
  height = 80,
  color = {0.8, 0.8, 0.8},
  renderLayer = 102,
  screenSpace = true,
  text = "<",
  audio = "breaker",
})

main.ui.defineButton("collectionClose", {
  width = 60,
  height = 60,
  color = {0.7, 0.4, 0.4},
  renderLayer = 101,
  screenSpace = true,
  text = "X",
  audio = "breaker",
  onButtonClicked = function (ent)
    main.openUITab("collection", false)
  end
})