main.defineComponent("momentary", false)

local pipeline = main.getPipeline("main")

system.on("main:encounterEnd", function ()
  local piles = main.getAllPiles()
  for i, pile in ipairs(piles) do
    for k, card in ipairs(pile) do
      if card.momentary and card.momentary == true then
        main.deleteCard(card)
      end
    end
  end
end)