main.objectives = {
  definitions = {}
}
-- difficulty and reward randomised based on difficulty

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
    -- todo: assign a reward
  end
  
  table.insert(main.objectives.definitions, obj)
end

function main.objectives.getRandomObjective()
  local def = main.objectives.definitions[love.math.random(1, #main.objectives.definitions)]
  local obj = def:new({})
  return obj
end

--[[
todo: when defining reward, have a "minimum difficulty" var
so the defineReward.load would take (difficulty) and set itself up a reward to claim and description
]]

-- make X pattern N times
local patternDiffList = {
  {id="star", diff=4, increment=2},
  {id="moon", diff=4, increment=2},
  {id="soliders", diff=2, increment=1},
  {id="crows", diff=2, increment=1},
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
    if pattern.diff > 1.5 then
      amount = love.math.random(2, 3)
    else
      amount = love.math.random(1, 2)
    end
    local difficulty = pattern.diff + pattern.increment*amount
    local name = main.getPattern(pattern.id).name
    obj.pattern = pattern.id
    obj.amount = amount
    obj.difficulty = difficulty
    obj.description = "Create " .. name .. " pattern " .. amount .. " times"
  end
})

system.on("@load", function ()
  main.wait(0.1, function ()
    local test = main.objectives.getRandomObjective()
    for k, v in pairs(test) do
      print(k, v)
    end
  end)
end)



-- use less than X card

-- take less than X turn

-- get a N combo

-- don't use X card

-- use X card less/more than Y times 