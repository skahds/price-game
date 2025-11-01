-- all the cards here
local bag = class()
function bag:init()
  
  self.rarities = {}
  self.bag = {
    -- {rarity=rarityClass, card="Volatility"}
  }
  system.updateStorage("rarity:bag", self)
end

function bag:addCardEtype(eType)
  if eType.rarity == nil then
    error(eType.name .. " doesn't have a rarity to put in bag")
  end
  -- local rarity = self:getRarity(eType.rarity)
  
  table.insert(self.bag, {rarity=eType.rarity, card=eType.id})
end

function bag:getRarity(rarity)
  if self.rarities[rarity] == nil then
    error("rarity " .. rarity .. " doesn't exist")
  end
  return self.rarities[rarity]
end

function bag:getRandomCard(filter)
  filter = filter or function() return true end

  local range = {}
  local totalWeight = 0
  for k, t in pairs(self.bag) do
    if filter(t) == true then
      totalWeight = totalWeight + t.rarity.chanceWeight
      table.insert(range, t)
    end
  end

  if totalWeight == 0 then
    error("rarity total weight can't be 0")
  end

  local rand = love.math.random(1, totalWeight)
  local num = 0

  for k, t in ipairs(range) do
    num = num + t.rarity.chanceWeight
    if num >= rand then
      return t.card
    end
  end
end

function bag:getRandomCardWithRarity(rarity)
  local c = self:getRandomCard(function (t)
    if t.rarity.chanceWeight == self:getRarity(rarity).chanceWeight then
      return true
    end
  end)
  return c
end

bag:new()

-- arg has format (for richtext), and chanceWeight
local function defineRarity(name, arg)
  local bag = system.getStorage("rarity:bag")
  arg.id = name
  bag.rarities[name] = arg
end

defineRarity("COMMON", {chanceWeight=10, format="{commonColor}COMMON"})
defineRarity("RARE", {chanceWeight=6, format="{rareColor}RARE"})
defineRarity("EPIC", {chanceWeight=2, format="{epicColor}EPIC"})

local rarity = class()
function rarity:init(card)
  if card.rarity == nil then
    card.rarity = "COMMON"
  end

  local bag = system.getStorage("rarity:bag")
  local rarity = bag:getRarity(card.rarity)
  card.rarity = rarity
  bag:addCardEtype(card)
end

system.updateStorage("rarity:rarityClass", rarity)