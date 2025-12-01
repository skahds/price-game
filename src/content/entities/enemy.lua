--?
main.enemies = {
  entities={}
}

function main.enemies.getRandomEnemy()
  return main.enemies.entities[love.math.random(1, #main.enemies.entities)]
end

function main.defineEnemy(id, t)
  t.rarity = "UNIQUE"
  t.id = id
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
    main.discardCard(card)
  end,
})

main.defineEnemy("regulator", {
  name = "The Regulator",
  image = "regulatorEnemy",
  description = "make a random card cost {energyColor}+1 ENERGY",
  trigger = {"EACHTURN"},
  onActivate = function (ent)
    local card = main.getRandomCard()
    card.overrideEnergy = card.overrideEnergy + 1
  end,
})

--[[
probably will get up some "boss" enemies that get selected in the select screen like:
-EACH TURN: discard 1 random card
-EACH TURN: make a random card cost +1 ENERGY
-EACH TURN: increase score requirement by 25%
-CARD TRIGGERED: spawn a random news
]]
