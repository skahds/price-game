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

    if self.load then
      self:load()
    end
    local diff = self.difficulty or 1
    self.reward = main.objectives.createRandomReward(diff)
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
    table.insert(bag, v)
  end
  local def = bag[love.math.random(1, #bag)]
  local obj = def:new(args)
  table.insert(main.objectives.active, obj)
  return obj
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
  for i, v in ipairs(utils.createEvenlySpacedPosition(#main.objectives.active)) do
    local text1 = listOfText[i*2-1]
    local text2 = listOfText[i*2]
    local height = text1.richText:getHeight()
    text1.y = text1.y + height * (v+0.5) * 2 * 1.2
    text2.y = text2.y + height * (v+0.5) * 2 * 1.2
  end

  listOfText.showProgress = arg.showProgress
  return listOfText
end

--call this when u updating the objective richtext in the scene to keep track of it's progress
function main.objectives.updateObjectiveRichtext(listOfText)
  -- perhaps i should check edgecases where listOfText doesn't have as many text as there is active objective, but i think that shouldn't happen
  for i, obj in ipairs(main.objectives.active) do
    local listOfFormat = {obj.description, obj.reward.description}
    if listOfText.showProgress then
      listOfFormat[1] = listOfFormat[1] .. " [" .. obj:getProgress() .. "]"
    end
    for e, form in ipairs(listOfFormat) do
      local text = listOfText[(i-1)*2+e]
      main.updateRichTextText(text, form)
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

--[[
todo:
]]


--
-- REWARDS DEFINITION
--
-- Give $
main.objectives.defineReward("money", {
  minimumDifficulty = 3,
  update = function (obj)
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
  update = function (obj)
    obj.description = "Gives permanent {multColor}+" .. math.floor((obj.difficulty)/2) .. " MULT"
  end,
  claim = function (obj)
    main.spawnNews("multNews", {isRelic=true,defaultMultGain=math.floor((obj.difficulty)/2)})
  end
})

-- todo: add patternUpgrade, cardUpgrade etc


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
    obj.description = "Create " .. amount .. "x " .. name
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