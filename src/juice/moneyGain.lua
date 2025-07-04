local RichText = system.getStorage("RichText")
local text = main.newRichText({text="{moneyColor}Points: {/moneyColor}" .. "10", y=200})

system.on("main:moneyChanged", function (change)
  -- text.text.format = "{pointsColor}Points: {/pointsColor}" .. 10
end)