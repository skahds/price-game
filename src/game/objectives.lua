main.objectives = {
  definitions = {}
}
-- difficulty and reward randomised based on difficulty


function main.objectives.defineObjective(arg)
  table.insert(main.objectives.definitions, arg)
end

function main.objectives.getRandomObjective()
  local obj = main.objectives.definitions[love.math.random(1, #main.objectives.definitions)]
  return obj
end

-- make an X pattern
main.objectives.defineObjective({
  description = "",
})

-- use less than X card

-- take less than X turn

-- get a N combo

-- don't use X card

-- use X card less/more than Y times 