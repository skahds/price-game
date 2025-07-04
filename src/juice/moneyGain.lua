local RichText = system.getStorage("RichText")
local text = main.newRichText({text="{pointsColor}Points: {/pointsColor}" .. 10, y=200})

system.on("main:moneyChanged", function (change)
  -- print("change ", change)
end)