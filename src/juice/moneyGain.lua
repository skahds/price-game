local RichText = system.getStorage("RichText")

system.on("main:moneyChanged", function (change)
  local text = main.newRichText({text="+{moneyColor}" .. math.floor(change+0.5) .. "{/moneyColor}",
  y=100,
  x=200,})
  main.wait(1, function ()
    text:delete()
  end)
end)