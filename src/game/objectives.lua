main.objectives = {
  definitions = {},
  rewards = {}
}
-- difficulty and reward randomised based on difficulty
-- reward is claimed at levelEnd claims 

function main.objectives.createRandomReward(difficulty)
  local options = {}
  for i, reward in ipairs(main.objectives.rewards) do
    if (reward.minimumDifficulty or 0) <= difficulty and difficulty <= (reward.maximumDifficulty or math.huge) then
      table.insert(options, reward)
    end
  end
  local reward = options[love.math.random(1, #options)]
  return reward:new({difficulty=difficulty})
end

function main.objectives.defineObjective(oType)
  local obj = class()
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
  
  table.insert(main.objectives.definitions, obj)
end

function main.objectives.defineReward(rType)
  local obj = class()
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
  
  table.insert(main.objectives.rewards, obj)
end

function main.objectives.createRandomObjective()
  local def = main.objectives.definitions[love.math.random(1, #main.objectives.definitions)]
  local obj = def:new({})
  return obj
end

--[[
todo: when defining reward, have a "minimum difficulty" var
so the defineReward.load would take (difficulty) and set itself up a reward to claim and description
]]


--
-- REWARDS DEFINITIONS
--
-- Give $
main.objectives.defineReward({
  minimumDifficulty = 3,
  update = function (obj)
    obj.description = "Gives {moneyColor}$" .. obj.difficulty-1
  end,
  claim = function (obj)
    main.addMoney(obj.difficulty-1)
  end
})

-- Adds perma mult
main.objectives.defineReward({
  minimumDifficulty=2,
  maximumDifficulty=6,
  update = function (obj)
    obj.description = "Gives permanent {multColor}+" .. math.floor((obj.difficulty)/2) .. " MULT"
  end,
  claim = function (obj)
    main.spawnNews("multNews", {isRelic=true,defaultMultGain=math.floor((obj.difficulty)/2)})
  end
})


--
-- OBJECTIVE DEFINITIONS
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

main.objectives.defineObjective({
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
    obj.amount = amount
    obj.difficulty = difficulty
    obj.description = "Create " .. name .. " pattern " .. amount .. " times"
  end
})

-- use less than X card

-- take less than X turn

-- get a N combo

-- don't use X card

-- use X card less/more than Y times 