system.on("main:moneyChanged", function (change)
  local text = main.newRichText({richText="{moneyColor}" .. math.floor(change+0.5) .. "{/moneyColor}",
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
      form = "{greenColor}" .. change .. "%{/greenColor}"
    elseif change < 0 then
      form = "{redColor}" .. change .. "%{/redColor}"
    else
      form = "0%"
    end

    local text = main.newRichText({richText=form,
    x=bar.x + love.math.random(-50, 50),
    y=bar.y+bar.height + love.math.random(-50, 50),
    screenSpace = false})

    main.wait(0.3, function ()
      text:delete()
    end)
  end
end)