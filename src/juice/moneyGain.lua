local RichText = system.getStorage("RichText")

system.on("main:moneyChanged", function (change)
  local text = main.newRichText({text="{moneyColor}" .. math.floor(change+0.5) .. "{/moneyColor}",
  y=100,
  x=200,})
  main.wait(1, function ()
    text:delete()
  end)
end)

system.on("main:currentPriceChanged", function (bar)
  if bar then
    local change = math.floor(((bar.endPrice / bar.startPrice)-1)*100+0.5)
    local form
    if change > 0 then
      form = "{greenColor}%" .. change .. "{/greenColor}"
    elseif change < 0 then
      form = "{redColor}%" .. change .. "{/redColor}"
    end
    local text = main.newRichText({text=form,
    x=bar.x,
    y=bar.y+bar.height,
    screenSpace = false})
    main.wait(0.3, function ()
      text:delete()
    end)
  end
end)