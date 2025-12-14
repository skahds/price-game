local renderLayer = 220
local isOpen = false
local listOfItems = {}
local existingItems = {}
local currentPage = 1
local amountOfPage
local contentPerPage = 20
local selectLeft, selectRight
local cover
local currentPageText

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
    contentInThisPage = #listOfItems - contentPerPage * (currentPage-1)
  end

  for i=#existingItems, 1, -1 do
    existingItems[i]:delete()
  end
  
  for i=1, contentInThisPage do
    local itemI = startI+i --yeahyeah it starts at 0 whatever
    local item = listOfItems[itemI].definition
    local x = (i-1)%5
    local y = math.floor((i-1)/5)
    -- todo: discard all this and just change it to spawn card and spawn news grahh
    local img = system.getImage(item.image)
    local scale = 1.7
    if img:getWidth() < 40 then
      scale = 2
    end
    local ui = main.ui.spawnUI("collectionPlaceholder", {name=item.name,x=640+(x-2)*800/5, y=240+(y-1)*110, image = item.image, sx=scale, sy=scale, showDescription = true})
    for k, v in pairs(main.getAllComponentsFromEntity(item)) do
      ui[k] = utils.deepCopy(v)
    end
    ui.width = img:getWidth()
    ui.height = img:getHeight()
    ui.ox = img:getWidth()/2
    ui.oy = img:getHeight()/2
    table.insert(existingItems, ui)
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
  main.updateRichTextText(currentPageText, "page " .. currentPage .. "/" .. amountOfPage)
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
      x=640-150-40,
      y=550,
      renderLayer = 402,
      text="<",
      onButtonClicked = function ()
        buttonClick(-1)
      end
    })

    selectRight = main.ui.spawnUI("collectionSelect", {
      x=640+150-40,
      y=550,
      renderLayer = 402,
      text=">",
      onButtonClicked = function ()
        buttonClick(1)
      end
    })
    
    currentPageText = main.newRichText({
      x=640,
      y=550,
      format = "page " .. currentPage .. "/" .. amountOfPage,
      renderLayer = 402
    })
    currentPageText.x = currentPageText.x - currentPageText.richText:getWidth()/2
    -- currentPageText.y = currentPageText.y - currentPageText.richText:getHeight()/2

    updateContent()
  else
    isOpen = false

    for i=#existingItems, 1, -1 do
      existingItems[i]:delete()
    end

    deleteAll({cover, selectLeft, selectRight, currentPageText})
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