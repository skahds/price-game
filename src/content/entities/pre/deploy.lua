main.defineCard("amplifier", {
  name = "Amplifier",
  image = "amplifier",
  description = "Next activation {repeatColor}+1 repeat{/repeatColor}",
  trigger = {"ROUND"},
  price = 3,
  rarity = "RARE",
  
  onActivate = function ()
    main.upgradeNextActivation(function (targetEnt)
      targetEnt.repeatActivation = targetEnt.repeatActivation + 1
    end)
  end
})

main.defineCard("magnifyingGlass", {
  name = "Magnifying Glass",
  image = "magnifyingGlass",
  description = "News in area gains {pointColor}+4 points",
  mouseHeldArea = {size=100, fixed=false},
  trigger = {"DEPLOY"},
  price = 2,
  onActivate = function (ent)
    local chart = system.getStorage("main:chart")
    local mouse = system.getStorage("mouse")

    chart:forAllNews(function (news)
      local size = ent.mouseHeldArea.size
      local area = {x=mouse.x-size/2, y=mouse.y-size/2, width=size, height=size}
      if main.AABB_check(news.ui, area) then
        main.changeEntityComponent(news, "defaultPointGain", 4, combiner.ADD)
      end
    end)
  end
})

main.defineCard("void", {
  name = "Void",
  image = "void",
  description = "Destroy card to the right",
  trigger = {"DEPLOY"},
  temporary = 1,
  price = 2,
  rarity = "RARE",
  
  filter = function (ent)
    local target = main.getCardBesides(ent, 1)
    if target then
      return true
    end
  end,

  onActivate = function (ent)
    local target = main.getCardBesides(ent, 1)
    main.tryDestroyEntity(target)
  end
})

main.defineCard("vision", {
  name = "Vision",
  image = "vision",
  defaultDrawCard = 2,
  trigger = {"DEPLOY"},
  price = 2,
  rarity = "RARE",
})

main.defineCard("sacrifice", {
  name = "Sacrifice",
  image = "sacrifice",
  description = "Discard cards in hand",
  defaultDrawCard = 4,
  trigger = {"DEPLOY"},
  price = 3,
  rarity = "RARE",
  onActivate = function ()
    main.discardCurrentCardsInHand()
  end
})

main.defineCard("unit", {
  name = "Unit",
  image = "unit",
  description = "Spawns a relic news\nwhich gives {multColor}+2 mult",
  trigger = {"DEPLOY"},
  temporary = 1,
  price = 2,
  onActivate = function (ent)
    local chart = system.getStorage("main:chart")
    local pos = chart:getCurrentPricePos()

    if pos == nil then
      return
    end

    local xoffset = love.math.random(-40, 40)
    local yoffset = love.math.random(-40, 40)
    main.spawnNews("multNews", {x=pos.x+xoffset, y=pos.y+yoffset, isRelic=true})
  end
})