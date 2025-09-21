main.defineCard("amplifier", {
  name = "Amplifier",
  image = "amplifier",
  description = "Next card activated +1 {repeatColor}repeat{/repeatColor}",
  trigger = {"DEPLOY", "POST"},
  price = 2,
  rarity = "RARE",
  
  onActivate = function ()
    main.upgradeNextActivation(function (targetEnt)
      targetEnt.repeatActivation = targetEnt.repeatActivation + 1
    end)
  end
})
