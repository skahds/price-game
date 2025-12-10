-- all the cards here
local bag = class()
function bag:init()
  
  self.rarities = {}
  self.cardBag = {
    -- {rarity=rarityClass, card="Volatility"}
  }
  self.newsBag = {}
  system.updateStorage("rarity:bag", self)
end

function bag:addCardEtype(eType)
  if eType.rarity == nil then
    error(eType.name .. " doesn't have a rarity to put in bag")
  end
  
  table.insert(self.cardBag, {rarity=eType.rarity, card=eType.id})
end

function bag:addNewsEtype(eType)
  if eType.rarity == nil then
    error(eType.name .. " doesn't have a rarity to put in bag")
  end
  
  table.insert(self.newsBag, {rarity=eType.rarity, news=eType.id})
end


function bag:getRarity(rarity)
  if self.rarities[rarity] == nil then
    error("rarity " .. rarity .. " doesn't exist")
  end
  return self.rarities[rarity]
end

function bag:getRandomCard(filter)
  filter = filter or function() return true end

  local cardsByRarity = {}
  local availableRarities = {}
  
  for k, t in pairs(self.cardBag) do
    if filter(t) == true then
      local rarityId = t.rarity.id
      if not cardsByRarity[rarityId] then
        cardsByRarity[rarityId] = {}
        table.insert(availableRarities, t.rarity)
      end
      table.insert(cardsByRarity[rarityId], t.card)
    end
  end

  -- Stage 1: Pick a rarity tier based on chanceWeight
  local totalWeight = 0
  for _, rarity in ipairs(availableRarities) do
    totalWeight = totalWeight + rarity.chanceWeight
  end

  local rand = love.math.random(1, totalWeight)
  local num = 0
  local selectedRarity = nil

  for _, rarity in ipairs(availableRarities) do
    num = num + rarity.chanceWeight
    if num >= rand then
      selectedRarity = rarity.id
      break
    end
  end

  -- Stage 2: Pick a random card from that rarity tier
  local cardsInRarity = cardsByRarity[selectedRarity]
  local randomIndex = love.math.random(1, #cardsInRarity)
  return cardsInRarity[randomIndex]
end

function bag:getRandomCardWithInfo(info)
  local amount = info.amount or 1
  local result = {}

  for i=1, amount do
    local c = self:getRandomCard(function (t)
      if info.rarity then
        if t.rarity.chanceWeight == self:getRarity(info.rarity).chanceWeight then
          
        else
          return false
        end
      end

      if info.minimumRarity then
        if t.rarity.chanceWeight > self:getRarity(info.minimumRarity).chanceWeight then
          return false
        end
      end

      for _, already in ipairs(result) do
        if already == t.card then
          return false
        end
      end

      return true
    end)

    table.insert(result, c)
  end

  return result
end

function bag:getRandomNews(filter)
  filter = filter or function() return true end
  local newsByRarity = {}
  local availableRarities = {}
  
  for k, t in pairs(self.newsBag) do
    if filter(t) == true then
      local rarityId = t.rarity.id
      if not newsByRarity[rarityId] then
        newsByRarity[rarityId] = {}
        table.insert(availableRarities, t.rarity)
      end
      table.insert(newsByRarity[rarityId], t.news)
    end
  end

  -- Stage 1: Pick a rarity tier based on chanceWeight
  local totalWeight = 0
  for _, rarity in ipairs(availableRarities) do
    totalWeight = totalWeight + rarity.chanceWeight
  end

  local rand = love.math.random(1, totalWeight)
  local num = 0
  local selectedRarity = nil

  for _, rarity in ipairs(availableRarities) do
    num = num + rarity.chanceWeight
    if num >= rand then
      selectedRarity = rarity.id
      break
    end
  end

  -- Stage 2: Pick a random news from that rarity tier
  local newsInRarity = newsByRarity[selectedRarity]
  local randomIndex = love.math.random(1, #newsInRarity)
  return newsInRarity[randomIndex]
end

function bag:getRandomNewsWithInfo(info)
  local amount = info.amount or 1
  local result = {}

  for i=1, amount do
    local c = self:getRandomNews(function (t)
      if info.rarity then
        if t.rarity.chanceWeight == self:getRarity(info.rarity).chanceWeight then
          
        else
          return false
        end
      end

      if info.minimumRarity then
        if t.rarity.chanceWeight > self:getRarity(info.minimumRarity).chanceWeight then
          return false
        end
      end

      for _, already in ipairs(result) do
        if already == t.news then
          return false
        end
      end

      return true
    end)

    table.insert(result, c)
  end

  return result
end

bag:new()

-- arg has format (for richtext), and chanceWeight
local function defineRarity(name, arg)
  local bag = system.getStorage("rarity:bag")
  arg.id = name
  bag.rarities[name] = arg
end

defineRarity("COMMON", {chanceWeight=10, format="{commonColor}COMMON{/commonColor}"})
defineRarity("RARE", {chanceWeight=6, format="{rareColor}RARE{/rareColor}"})
defineRarity("EPIC", {chanceWeight=2, format="{epicColor}EPIC{/epicColor}"})
defineRarity("UNIQUE", {chanceWeight=0, format="UNIQUE"})
defineRarity("STARTER", {chanceWeight=0, format="STARTER"})

local rarity = class()
function rarity:init(ent)
  if ent.rarity == nil then
    if ent.isCard then
      ent.rarity = "COMMON"
    elseif ent.isNews then
      ent.rarity = "UNIQUE"
    end
  end

  local bag = system.getStorage("rarity:bag")
  local rarity = bag:getRarity(ent.rarity)
  ent.rarity = rarity
  if ent.isCard then
    bag:addCardEtype(ent)
  elseif ent.isNews then
    bag:addNewsEtype(ent)
  end
end

system.updateStorage("rarity:rarityClass", rarity)