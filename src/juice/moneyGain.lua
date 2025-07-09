system.on("main:moneyChanged", function (change)
  local text = main.newRichText({richText="{moneyColor}" .. math.floor(change+0.5) .. "{/moneyColor}",
  y=200,
  x=20,})
  main.waitWithMult(1, function ()
    text:delete()
  end)
end)

local function addCoolEffect(s)
  return s
  -- return "{basicPulse}" .. s .. "{/basicPulse}"
end

system.on("main:currentPriceChanged", function (bar)
  if bar then
    local change = math.floor(((bar.endPrice / bar.startPrice)-1)*100+0.5)
    local form
    if change > 0 then
      form = addCoolEffect("{greenColor}" .. change .. "%{/greenColor}")
    elseif change < 0 then
      form = addCoolEffect("{redColor}" .. change .. "%{/redColor}")
    else
      form = "0%"
    end

    local text = main.newRichText({richText=form,
    x=bar.x + love.math.random(-20, 20),
    y=bar.y+bar.height + love.math.random(-50, 50),
    screenSpace = false})

    main.waitWithMult(0.5, function ()
      text:delete()
    end)
  end
end)


-- audio related

system.on("main:entityTriggered", function (bar)
  local combo = system.getStorage("main:currentCombo")
  local audio = system.playAudio("boop")
  main.audio.offsetAudioSourcePitch(audio, combo)
end)