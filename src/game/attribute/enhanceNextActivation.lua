-- example use: upgrade next card activated with +1 repeat
local enhances = {}

function main.upgradeNextActivation(func, turns)
  turns = turns or 1
  table.insert(enhances, {func=func, turns=turns})
end

-- todo: fix infinite amplifier loop
system.on("main:entityAboutToTrigger", function (ent)
  for _, enhance in ipairs(enhances) do
    enhance.func(ent)
  end

  for i=#enhances, 1, -1 do
    local enhance = enhances[i]
    if enhance.turns > 1 then
      enhance.turns = enhance.turns - 1
    else
      table.remove(enhance, i)
    end
  end

  enhances = {}
end)