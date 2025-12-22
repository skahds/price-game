--?
main.enemies = {
  entities={}
}

function main.enemies.getRandomEnemy()
  return main.enemies.entities[love.math.random(1, #main.enemies.entities)]
end

function main.enemies.getEnemy(id)
  for i, e in ipairs(main.enemies.entities) do
    if id == e.id then
      return e
    end
  end
end

function main.defineEnemy(id, t)
  t.rarity = "UNIQUE"
  t.id = id
  t.definition = t
  table.insert(main.enemies.entities, t)
  main.defineNews(id, t)
end

main.defineEnemy("oracle", {
  name = "The Oracle",
  image = "oracleEnemy",
  description = "Discard a random card",
  trigger = {"EACHTURN"},
  onActivate = function (ent)
    local card = main.getRandomCard()
    if card then
      main.discardCard(card)
    end
  end,
})

main.defineEnemy("regulator", {
  name = "The Regulator",
  image = "regulatorEnemy",
  description = "Make a random card cost {energyColor}+1 ENERGY",
  trigger = {"EACHTURN"},
  onActivate = function (ent)
    local card = main.getRandomCard()
    if card then
      card.overrideEnergy = card.overrideEnergy + 1
    end
  end,
})

main.defineEnemy("fog", {
  name = "The Fog",
  image = "fogNews",
  description = "Creates 11 Junk in\nthe draw pile",
  descriptionTagEntity = "junk",
  trigger = {"ENCOUNTER"},
  onActivate = function ()
    for i=1, 11 do
      main.basicSpawnCard("junk", {}, nil, "draw")
    end
  end
})

main.defineEnemy("trap", {
  name = "The Trap",
  image = "trapNews",
  description = "Destroy a random card",
  trigger = {"ROUND"},
  onActivate = function ()
    local card = main.getRandomCard()
    main.tryDestroyEntity(card)
  end
})

main.defineEnemy("machine", {
  name = "The Machine",
  image = "machineNews",
  trigger = {"EACHTURN"},
  defaultEnergyGain = -1,
})

--[[
probably will get up some "boss" enemies that get selected in the select screen like:
-EACH TURN: discard 1 random card
-EACH TURN: make a random card cost +1 ENERGY
-EACH TURN: increase score requirement by 25%
-CARD TRIGGERED: spawn a random news
]]
