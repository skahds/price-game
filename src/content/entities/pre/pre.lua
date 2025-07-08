main.defineCard("testCard", {
  name = "Test Card",
  -- image = "testBox",
  -- onReleased = function (ent)
  --   main.deleteCard(ent)
  --   local chart = system.getStorage("main:chart")
  --   if chart then
  --     chart.bullPower = chart.bullPower + 0.5
  --   end
  -- end
  trigger = {"POST"},
  onActivate = function (ent)
    local bar = system.getStorage("main:currentBar")
    bar:changePricePIP(0.1)
  end,
})