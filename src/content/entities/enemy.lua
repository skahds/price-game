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
    
    if arg.ignoreSpawnFilter ~= true and ent.spawnFilter and ent.spawnFilter() == false then
      goto continue
    end

    --ignoredEnt is just an id of the enemy
    if arg.ignoreBag then
      for i, ignoredEnt in ipairs(arg.ignoreBag) do
        if ignoredEnt == ent.id then
          goto continue
        end
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
  onActivate = function (ent)
    local card = main.getRandomCard()
    if card then
      main.discardCard(card)
    end
  end,
})

-- main.defineEnemy("miracle", {
--   name = "The Miracle",
--   image = "miracleNews",
--   description = "IDK",
--   descriptionTagEntity = "junk",
--   enemyType = "boss",
--   trigger = {"ROUND"},
--   rarity = "UNIQUE",
--   onActivate = function (ent, card)
--     main.basicSpawnCard("junk", {}, nil, "draw")
--   end,
-- })

-- do a check, if deck has atleast 1 of these cards that are permanent then it can spawn.
-- the "block" cards
local function specificRarityCheck(rarityID)
  return function ()
    for i, card in ipairs(main.getDeckCards()) do
      if card.rarity.id == rarityID and card.temporary == math.huge then
        return true
      end
    end
    return false
  end
end

main.defineEnemy("source", {
  name = "The Source",
  image = "sourceNews",
  description = "Disable STARTER cards",
  spawnFilter=specificRarityCheck("STARTER"),
  enemyType = "boss",
  trigger = {},
})

main.defineEnemy("outcast", {
  name = "The Outcast",
  image = "outcastNews",
  description = "Disable {commonColor}COMMON{/commonColor} cards",
  spawnFilter=specificRarityCheck("COMMON"),
  enemyType = "boss",
  trigger = {},
})

main.defineEnemy("flow", {
  name = "The Flow",
  image = "flowNews",
  description = "Disable {rareColor}RARE{/rareColor} cards",
  spawnFilter=specificRarityCheck("RARE"),
  enemyType = "boss",
  trigger = {},
})

main.defineEnemy("vestige", {
  name = "The Vestige",
  image = "vestigeNews",
  description = "Disable {epicColor}EPIC{/epicColor} cards",
  spawnFilter=specificRarityCheck("EPIC"),
  enemyType = "boss",
  trigger = {},
})

local blockTable = {
  source="STARTER",
  outcast="COMMON",
  flow="RARE",
  vestige="EPIC"
}
system.answer("main:isEntityDisabled", function (ent)
  local chart = system.getStorage("main:chart")
  local result = false
  if chart then
    chart:forAllNews(function (news)
      if blockTable[news.id] == ent.rarity.id then
        result = true
      end
    end)
  end
  return result
end)


-- idea, only bosses gets "the", normal enemy just have their normal names
-- nameideas: the doors, the vestige, the clock, the prophet
-- 

--[[
probably will get up some "boss" enemies that get selected in the select screen like:
-EACH TURN: discard 1 random card
-EACH TURN: make a random card cost +1 ENERGY
-EACH TURN: increase score requirement by 25%
-CARD TRIGGERED: spawn a random news
]]
