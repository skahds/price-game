--?
main.enemies = {
  entities={}
}

function main.enemies.getRandomEnemy(arg)
  arg.usedEnt = arg.usedEnt or {}
  local bag = {}
  for i, ent in ipairs(main.enemies.entities) do
    if arg.enemyType and ent.enemyType ~= arg.enemyType then
      goto continue
    end

    for e, usedEnt in ipairs(arg.usedEnt) do
      if usedEnt == arg.id then
        goto continue
      end
    end

    table.insert(bag, ent)

    ::continue::
  end

  return bag[love.math.random(1, #bag)]
end

function main.enemies.getEnemy(id)
  for i, e in ipairs(main.enemies.entities) do
    if id == e.id then
      return e
    end
  end
end

function main.defineEnemy(id, t)
  t.rarity = "ENEMY"
  t.id = id
  t.definition = t
  table.insert(main.enemies.entities, t)
  main.defineNews(id, t)
end

-- enemy is divided by 3, "normal", "elite" and "boss"

main.defineEnemy("oracle", {
  name = "The Oracle",
  image = "oracleEnemy",
  description = "Discard a random card",
  enemyType = "elite",
  trigger = {"EACHTURN"},
  onActivate = function (ent)
    local card = main.getRandomCard()
    if card then
      main.discardCard(card)
    end
  end,
})

main.defineEnemy("trail", {
  name = "The Trail",
  image = "trailNews",
  description = "Creates a Junk in\nthe draw pile",
  descriptionTagEntity = "junk",
  enemyType = "elite",
  trigger = {"EACHTURN"},
  onActivate = function ()
    main.basicSpawnCard("junk", {}, nil, "draw")
  end
})

main.defineEnemy("autonomy", {
  name = "The Autonomy",
  image = "autonomyNews",
  description = "Use a random card in hand",
  enemyType = "elite",
  trigger = {"EACHTURN"},
  onActivate = function ()
    local card = main.getRandomCard(function (card)
      if main.canTriggerFullCheck(card, "DEPLOY") then
        return true
      end
    end)

    if card then
      local energy = (card.overrideEnergy or card.energy)
      main.addEnergy(-energy)
      main.triggerEnt(card, "DEPLOY")
      main.discardCard(card)
      card.overrideEnergy = card.energy
    end
  end
})

main.defineEnemy("regulator", {
  name = "The Regulator",
  image = "regulatorNews",
  description = "Make a random card cost {energyColor}+1 ENERGY",
  enemyType = "elite",
  trigger = {"EACHTURN"},
  onActivate = function (ent)
    local card = main.getRandomCard()
    if card then
      card.overrideEnergy = card.overrideEnergy + 1
    end
  end,
})

main.defineEnemy("straw", {
  name = "The Straw",
  image = "strawNews",
  description = "Every 2nd activation:\nLose {moneyColor}$1{/moneyColor}",
  enemyType = "elite",
  trigger = {"CARDTRIGGER"},
  strawCounter = 2,
  onActivate = function (ent)
    ent.strawCounter = ent.strawCounter - 1
    if ent.strawCounter == 0 then
      main.addMoney(-1)
      ent.strawCounter = 2
    end
    ent.description = "Every 2nd activation:\nLose {moneyColor}$1{/moneyColor}\n(" .. ent.strawCounter .. " activation left)"
  end,
})

main.defineEnemy("fog", {
  name = "The Fog",
  image = "fogNews",
  description = "Creates 11 Junk in\nthe draw pile",
  descriptionTagEntity = "junk",
  enemyType = "boss",
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
  enemyType = "boss",
  trigger = {"ROUND"},
  onActivate = function ()
    local card = main.getRandomCard()
    main.tryDestroyEntity(card)
  end
})

main.defineEnemy("machine", {
  name = "The Machine",
  image = "machineNews",
  description = "Discard a random card",
  enemyType = "boss",
  trigger = {"CARDTRIGGER"},
  rarity = "UNIQUE",
  onActivate = function (ent)
    local card = main.getRandomCard()
    if card then
      main.discardCard(card)
    end
  end,
})


-- idea, only bosses gets "the", normal enemy just have their normal names
-- nameideas: the miracle, the doors, the vestige, the clock, the prophet, the source
-- 

--[[
probably will get up some "boss" enemies that get selected in the select screen like:
-EACH TURN: discard 1 random card
-EACH TURN: make a random card cost +1 ENERGY
-EACH TURN: increase score requirement by 25%
-CARD TRIGGERED: spawn a random news
]]
