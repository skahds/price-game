main.defineNews("discount", {
  name = "Discount",
  image = "discountNews",
  trigger = {"EACHTURN"},
  description = "A random card becomes\nfree for this turn",
  isRelic = true,
  onActivate = function (ent)
    local r = love.math.random(1, #main.card.hand)
    local card = main.getCardInOrder(r)
    card.overrideEnergy = 0
  end,
  rarity = "RARE"
})