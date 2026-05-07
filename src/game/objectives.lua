local flux = system.getStorage("flux")
main.objectives = {
  objective = {},
  rewards = {},
  active = {}
}
-- difficulty and reward randomised based on difficulty
-- reward is claimed at levelEnd claims 

function main.objectives.createReward(id, args)
  args = args or {}
  args.difficulty = args.difficulty or main.objectives.rewards[id].definition.minimumDifficulty
  local obj = main.objectives.rewards[id]:new(args)
  return obj
end

function main.objectives.createRandomReward(difficulty)
  local options = {}
  for k, reward in pairs(main.objectives.rewards) do
    if (reward.minimumDifficulty or 0) <= difficulty and difficulty <= (reward.maximumDifficulty or math.huge) then
      table.insert(options, reward)
    end
  end
  local reward = options[love.math.random(1, #options)]
  return reward:new({difficulty=difficulty})
end

function main.objectives.canBeClaimed(obj)
  return true
  -- if (obj.failFromPass and obj:isPass() == false)
  -- or (obj.failFromPass ~= true and obj:isPass()) then
  --   return true
  -- end
  -- return false
end

function main.objectives.defineObjective(id, oType)
  oType.failFromPass = oType.failFromPass or false -- ie: 'don't use x card' would use true since if it's used the objective fails
  oType.passed = false

  local obj = class()
  oType.id = id
  obj.id = id
  function obj:init(args)
    for k, v in pairs(oType) do
      self[k] = utils.deepCopy(v)
    end
    for k, v in pairs(args) do
      self[k] = utils.deepCopy(v)
    end

    if args.ignoreLoad ~= true then
      if self.load then
        self:load()
      end
    end
    local diff = self.difficulty or 1
    self.reward = self.reward or main.objectives.createRandomReward(diff)
  end
  obj.definition = oType
  
  main.objectives.objective[id] = obj
end

function main.objectives.defineReward(id, rType)
  local obj = class()
  rType.id = id
  obj.id = id
  function obj:init(args)
    for k, v in pairs(rType) do
      self[k] = utils.deepCopy(v)
    end
    for k, v in pairs(args) do
      self[k] = utils.deepCopy(v)
    end

    if self.load then
      self:load()
    end
    if self.update then
      self:update()
    end
  end
  obj.definition = rType
  
  main.objectives.rewards[id] = obj
end

function main.objectives.createObjective(id, args)
  args = args or {}
  local obj = main.objectives.objective[id]:new(args)
  table.insert(main.objectives.active, obj)
  return obj
end

function main.objectives.createRandomObjective(args)
  args = args or {}
  local bag = {}
  for k, v in pairs(main.objectives.objective) do
    if v.filter and v.filter() == false then
      
    else
      table.insert(bag, v)
    end
  end
  local def = bag[love.math.random(1, #bag)]
  local obj = def:new(args)
  table.insert(main.objectives.active, obj)
  return obj
end

function main.objectives.isThereObjectives()
  if main.objectives.active and #main.objectives.active > 0 then
    return true
  end
  return false
end

--arg={showProgress=bool, x,y}
function main.objectives.createObjectiveRichtext(arg)
  local listOfText = {}
  for i, obj in ipairs(main.objectives.active) do
    local listOfFormat = {obj.description, obj.reward.description}
    if arg.showProgress then
      listOfFormat[1] = listOfFormat[1] .. " [" .. obj:getProgress() .. "]"
    end
    for e, form in ipairs(listOfFormat) do
      local t = main.newRichText({
        format = form,
        x=arg.x,
        y=arg.y,
        renderLayer=arg.renderLayer or 100,
        outline=arg.outline or true,
        font=arg.font,
        outlineColor={0,0,0,1},
      })
      local h = t.richText:getHeight()*0.8
      if e == 1 then t.y = t.y - h*0.5 else t.y = t.y + h*0.5 end
      table.insert(listOfText, t)
    end
  end
  local spacings = utils.createEvenlySpacedPosition(#main.objectives.active)
  for i, v in ipairs(spacings) do
    local text1 = listOfText[i*2-1]
    local text2 = listOfText[i*2]
    local height = text1.richText:getHeight()
    if arg.centerY then
      text1.y = text1.y + height * (v) * 2 * 1.2
      text2.y = text2.y + height * (v) * 2 * 1.2
    else
      text1.y = text1.y + height * (v-spacings[1]) * 2 * 1.2
      text2.y = text2.y + height * (v-spacings[1]) * 2 * 1.2
    end
  end
  if arg.centerY then
    local highY = listOfText[1].y
    local lowY = listOfText[#listOfText].y + listOfText[#listOfText].richText:getHeight()
    local middleY = (lowY+highY)/2
    local gap = arg.y - middleY
    for i, text in ipairs(listOfText) do
      text.y = text.y + gap
    end
  end
  if arg.centerX then
    for i, text in ipairs(listOfText) do
      local ox = text.richText:getWidth()/2
      text.ox = ox
    end
  end

  listOfText.showProgress = arg.showProgress
  listOfText.showForClaim = arg.showForClaim
  return listOfText
end

function main.objectives.fluxObjectiveText(listOfText, arg)
  local thingToFlux = {}
  for i=1, #listOfText do
    thingToFlux[i] = {}
  end

  if arg.y then
    local startY = listOfText[1].y
    local targetY = arg.y
    if arg.centerY then
      local highY = listOfText[1].y
      local lowY = listOfText[#listOfText].y + listOfText[#listOfText].richText:getHeight()
      local height = (lowY-highY)/2
      startY = startY + height
    end
    local finishY = targetY-startY
    for i, text in ipairs(listOfText) do
      thingToFlux[i].y = text.y + finishY
    end
  end

  if arg.x then
    local startX = listOfText[1].x
    local targetX = arg.x
    local finishX = targetX-startX
    for i, text in ipairs(listOfText) do
      thingToFlux[i].x = text.x + finishX
    end
  end

  for i, text in ipairs(listOfText) do
    flux.to(text, arg.time, thingToFlux[i])
  end
end

local white, green, red = {1,1,1}, {0.6, 1, 0.6}, {1, 0.3, 0.3}
--call this when u updating the objective richtext in the scene to keep track of it's progress
function main.objectives.updateObjectiveRichtext(listOfText)
  for i, obj in ipairs(main.objectives.active) do
    local color = white
    if obj:isPass() then
      if obj.failFromPass then
        color = red
      else
        color = green
      end
    elseif listOfText.showForClaim then
      if obj.failFromPass then
        color = green
      else
        color = red
      end
    end

    local listOfFormat = {obj.description, obj.reward.description}
    if listOfText.showProgress then
      listOfFormat[1] = listOfFormat[1] .. " [" .. obj:getProgress() .. "]"
    end
    for e, form in ipairs(listOfFormat) do
      local text = listOfText[(i-1)*2+e]
      if text then
        if e==1 then text.color = color end
        main.updateRichTextText(text, form)
      end
    end
  end
end

function main.objectives.progressObjective(id, ...)
  for i, obj in ipairs(main.objectives.active) do
    if obj.id == id then
      obj:progress(...)
    end
  end
end

function main.objectives.claimObjectives()
  for i, obj in ipairs(main.objectives.active) do
    if obj.isClaimed ~= true then
      if main.objectives.canBeClaimed(obj) then
        obj.isClaimed = true
        obj.reward:claim()
        return
      end
    end
  end
end

function main.objectives.areThereClaimableObjectives()
  for i, obj in ipairs(main.objectives.active) do
    if obj.isClaimed ~= true then
      if main.objectives.canBeClaimed(obj) then
        return true
      end
    end
  end
end

function main.objectives.clearObjectives()
  main.objectives.active = {}
end

system.register("objectives", 24, function ()
  local t = {
    obj = {},
  }

  for i, obj in ipairs(main.objectives.active) do
    t.obj[i] = {
      id=obj.id,
      comps = {},
      reward=obj.reward.id,
    }
    for k, v in pairs(obj) do
      if type(v) ~= "table" and type(v) ~= "function" then
        t.obj[i].comps[k] = v
      end
    end
  end

  return t
end, function (t)
  main.objectives.clearObjectives()

  for i, obj in ipairs(t.obj) do
    obj.comps.reward = main.objectives.createReward(obj.reward, {difficulty=obj.comps.difficulty})
    obj.comps.ignoreLoad = true
    main.objectives.createObjective(obj.id, obj.comps)
    obj.comps.ignoreLoad = false
  end
end)

--[[
todo:
]]


--
-- REWARDS DEFINITION
--
-- Give $
main.objectives.defineReward("money", {
  minimumDifficulty = 3,
  load = function (obj)
    obj.description = "Gives {moneyColor}$" .. obj.difficulty-1
  end,
  claim = function (obj)
    main.addMoney(obj.difficulty-1)
  end
})

-- Adds perma mult
main.objectives.defineReward("permamult", {
  minimumDifficulty=2,
  maximumDifficulty=6,
  load = function (obj)
    obj.description = "Gives permanent {multColor}+" .. math.floor((obj.difficulty)/2) .. " MULT"
  end,
  claim = function (obj)
    main.spawnNews("multNews", {isRelic=true,defaultMultGain=math.floor((obj.difficulty)/2),x=0,y=0})
  end
})

-- get an extra card
local rewardList = {
  {claim=function ()
    local bag = system.getStorage("rarity:bag")
    local t = bag:getRandomCardWithInfo({minimumRarity="COMMON", amount=3})
    main.createRewardsOptions(t, {rewardType="card"})
  end,
  description="Choose a {commonColor}COMMON+{/commonColor} card!"},

  {claim=function ()
    local bag = system.getStorage("rarity:bag")
    local t = bag:getRandomCardWithInfo({minimumRarity="RARE", amount=3})
    main.createRewardsOptions(t, {rewardType="card"})
  end,
  description="Choose a {rareColor}RARE+{/rareColor} card!"}
}

local function chooseRarity(diff)
  if diff <= 5 then
    return rewardList[1]
  else
    return rewardList[2]
  end
end

main.objectives.defineReward("card", {
  minimumDifficulty=4,
  maximumDifficulty=8,
  cardReward = nil,
  load = function (obj)
    obj.cardReward = chooseRarity(obj.difficulty)
    obj.description = obj.cardReward.description
  end,
  claim = function (obj)
    if obj.cardReward then
      local reward = system.getStorage("main:endLevelReward")
      table.insert(reward, obj.cardReward)
    end
  end
})

main.objectives.defineReward("patternUpgrade", {
  minimumDifficulty=4,
  maximumDifficulty=8,
  load = function (obj)
    obj.description = "Upgrade a pattern!"
  end,
  claim = function (obj)
    local reward = system.getStorage("main:endLevelReward")
    table.insert(reward, {claim=function ()
      main.createRewardsEditPattern()
    end})
  end
})

main.objectives.defineReward("cardUpgrade", {
  minimumDifficulty=4,
  maximumDifficulty=8,
  load = function (obj)
    obj.description = "Upgrade a card!"
  end,
  claim = function (obj)
    local reward = system.getStorage("main:endLevelReward")
    table.insert(reward, {claim=function ()
      main.createRewardsUpgrade()
    end})
  end
})


-- todo: add patternUpgrade, cardUpgrade etc?


--
-- OBJECTIVE DEFINITION
--
-- make X pattern N times
--ex, 2 star=6, 3 upReversal=5, 2 crows = 3 
local patternDiffList = {
  {id="star", diff=4, increment=2},
  {id="moon", diff=4, increment=2},
  {id="soliders", diff=3, increment=1},
  {id="crows", diff=3, increment=1},
  {id="upReversal", diff=3, increment=1},
  {id="upEngulf", diff=3, increment=1},
  {id="downReversal", diff=3, increment=1},
  {id="downEngulf", diff=3, increment=1},
}

main.objectives.defineObjective("pattern", {
  description = "",
  load = function (obj)
    local pattern = patternDiffList[love.math.random(1, #patternDiffList)]

    local amount
    if pattern.increment < 1.5 then
      amount = love.math.random(2, 3)
    else
      amount = love.math.random(1, 2)
    end
    local difficulty = pattern.diff + pattern.increment*(amount-1)
    local name = main.getPattern(pattern.id).name
    obj.pattern = pattern.id
    obj.currentAmount = 0
    obj.amount = amount
    obj.difficulty = difficulty
    obj.description = "Create " .. amount .. "x " .. name .. " pattern"
  end,
  getProgress = function (obj)
    return obj.currentAmount .. "/" .. obj.amount
  end,
  progress = function (obj, id)
    if obj.pattern == id then
      obj.currentAmount = obj.currentAmount + 1

      if obj.currentAmount >= obj.amount then
        obj.passed = true
      end
    end
  end,
  isPass = function (obj)
    if obj.currentAmount >= obj.amount then
      return true
    end
    return false
  end
})

system.on("main:patternActivated", function (pattern)
  main.objectives.progressObjective("pattern", pattern.id)
end)


-- use less than X card

-- take less than X turn

-- get a N combo, FIX COMBO FIRST

-- don't use X card, eh sounds boring

--

-- use X card less/more than Y times
-- ok so scale the Y with amount of cards in deck
-- scale with amount of cards in deck, scale by amount of that card, disable for cards with temporary, maybe i should have a "check" to see if it's even possible with deck incase there's a case in which there's no card available
main.objectives.defineObjective("cardUsage", {
  description = "",
  failFromPass=true,
  filter = function ()
    print("there are " .. #main.getDeckCards())
    for i, card in ipairs(main.getDeckCards()) do
      if card.temporary == math.huge then
        return true
      end
    end
    return false
  end,
  load = function (obj)
    local factor = 1
    local card = main.getRandomCard("hand", "discard", "draw", function (card)
      if card.temporary == math.huge then
        return true
      end
      return false
    end)
    local amountOfCardInDeck = 0
    for i, c in ipairs(main.getDeckCards()) do
      if c.id == card.id then
        amountOfCardInDeck = amountOfCardInDeck + 1
      end
    end

    factor = factor * (1.12^(amountOfCardInDeck-1))
    local totalCardInDeck = #main.getDeckCards()
    factor = factor * (0.95^(totalCardInDeck-1))
    local extraDiff = love.math.random(8, 12)/10
    factor = factor * extraDiff
    local amountOfCardThreshold = 5 * (factor^1.5)
    amountOfCardThreshold = math.floor(amountOfCardThreshold+0.5)
    amountOfCardThreshold = math.max(1, amountOfCardThreshold)

    obj.card = card.id
    obj.currentAmount = 0
    obj.amount = amountOfCardThreshold
    obj.difficulty = math.floor(6/extraDiff+0.5)
    obj.description = "Trigger " .. card.name .. " less than " .. obj.amount .. " times"
  end,
  getProgress = function (obj)
    return obj.currentAmount .. "/" .. obj.amount
  end,
  progress = function (obj, id)
    if obj.card == id then
      obj.currentAmount = obj.currentAmount + 1

      if obj.currentAmount >= obj.amount then
        obj.passed = true
      end
    end
  end,
  isPass = function (obj)
    if obj.currentAmount >= obj.amount then
      return true
    end
    return false
  end
})

system.on("main:entityTriggered", function (ent)
  if ent.isCard then
    main.objectives.progressObjective("cardUsage", ent.id)
  end
end)