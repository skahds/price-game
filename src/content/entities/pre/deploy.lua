main.defineCard("amplifier", {
  name = "Amplifier",
  image = "amplifier",
  description = "Next activation +1 {repeatColor}repeat{/repeatColor}",
  trigger = {"DEPLOY", "POST"},
  price = 2,
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
  description = "News in area gains {pointColor}+3{/pointColor} points",
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
        main.changeEntityComponent(news, "defaultPointGain", 3, combiner.ADD)
      end
    end)
  end
})