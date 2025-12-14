local renderLayer = 220
local isOpen = false
local listOfItems = {}
local existingItems = {}
local currentPage = 1
local amountOfPage
local contentPerPage = 20
local selectLeft, selectRight
local cover

local function checkRarity(ent)
  local rarity = ent.definition.rarity.id
  if rarity == "COMMON" or rarity == "RARE" or rarity == "EPIC" or rarity == "STARTER" then
    return true
  else
    return false
  end
end

system.on("@load", function ()
  for k, ent in pairs(main.entities) do
    if ent.definition and ent.definition.isNews and checkRarity(ent) then
      table.insert(listOfItems, ent)
    end
  end

  for k, ent in pairs(main.entities) do
    if ent.definition and ent.definition.isCard and checkRarity(ent) then
      table.insert(listOfItems, ent)
    end
  end
  amountOfPage = math.floor(#listOfItems/contentPerPage)+1
end)

local function deleteAll(arg)
  for k, ent in ipairs(arg) do
    ent:delete()
  end
end

local function updateContent()
  local startI = (currentPage-1) * contentPerPage
  local contentInThisPage = contentPerPage
  if currentPage == amountOfPage then
    contentInThisPage = #listOfItems - contentPerPage * currentPage
  end

  for i=1, contentInThisPage do
    local itemI = startI+i-1 --yeahyeah it starts at 0 whatever
    local item = listOfItems[itemI]
    local x = itemI%5
    local y = math.floor(itemI/5)
    main.ui.spawnUI("collectionPlaceholder", {x=100+x*100, y=100+y*100})
  end
end

local function buttonClick(n)
  if n > 0 and currentPage ~= amountOfPage then
    currentPage = currentPage + 1
    updateContent()
  elseif n < 0 and currentPage ~= 1 then
    currentPage = currentPage - 1
    updateContent()
  end
end

local function openCollection()
  if isOpen == false then
    isOpen = true
    
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
      renderLayer = 400})

    selectLeft = main.ui.spawnUI("collectionSelect", {
      x=640-130-40,
      y=550,
      renderLayer = 402,
      text="<",
      onButtonClicked = function ()
        buttonClick(-1)
      end
    })

    selectRight = main.ui.spawnUI("collectionSelect", {
      x=640+130-40,
      y=550,
      renderLayer = 402,
      text=">",
      onButtonClicked = function ()
        buttonClick(1)
      end
    })
    updateContent()
  else
    isOpen = false

    deleteAll({cover, selectLeft, selectRight})
  end
end

main.ui.defineButton("openCollection", {
  width = 250,
  height = 100,
  color = {0.95, 0.7, 0.3},
  renderLayer = 101,
  screenSpace = true,
  text = "COLLECTION",
  audio = "breaker",
  onButtonClicked = function (ent)
    openCollection()
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

main.ui.defineUI("collectionPlaceholder", {
  width = 30,
  height = 30,
  renderLayer = 403,
  screenSpace = true,
})