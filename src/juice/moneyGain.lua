-- system.on("main:priceChanged", function (change)
--   local text = main.newRichText({format="{priceColor}" .. math.floor(change+0.5) .. "{/priceColor}",
--   y=250,
--   x=80,
--   outline = true,
--   renderLayer = 205,})
--   main.waitWithMult(1, function ()
--     text:delete()
--   end)
-- end)

local function addCoolEffect(s)
  return s
  -- return "{basicPulse}" .. s .. "{/basicPulse}"
end

system.on("main:currentPriceChanged", function (change)
  local bar = system.getStorage("main:currentBar")
  if bar then
    local change = math.floor(change+0.5)
    local form
    if change > 0 then
      form = addCoolEffect("{brightGreenColor}+" .. change .. "{/brightGreenColor}")
    elseif change < 0 then
      form = addCoolEffect("{brightRedColor}" .. change .. "{/brightRedColor}")
    else
      form = "0"
    end

    local size = love.math.random()/2+0.75

    local text = main.newRichText({format=form,
    x=bar.x + love.math.random(-20, 20),
    y=bar.y+bar.height + love.math.random(-30, 30),
    r=(love.math.random()-0.5)*math.pi/3,
    sx=size,
    sy=size,
    outline = true,
    screenSpace = false})
    text.ox = text.richText:getWidth()/2
    text.oy = text.richText:getHeight()/2

    local flux = system.getStorage("flux")
    local randomSpin = (love.math.random()-0.5)*3
    local randomSizeIncrease = love.math.random()
    flux.to(text, 0.7, {r=text.r+randomSpin})
    flux.to(text, 0.6, {sx=size+randomSizeIncrease, sy=size+randomSizeIncrease})

    main.waitWithMult(0.35, function ()
      text:delete()
    end)
  end
end)

system.on("main:multChanged", function (change)
  local bar = system.getStorage("main:currentBar")
  if bar then
    local form = "{multColor}x" .. math.floor(change+0.5) .. "{/multColor}"
    local size = love.math.random()/2+0.75

    local text = main.newRichText({format=form,
    x=bar.x + love.math.random(-20, 20),
    y=bar.y+bar.height + love.math.random(-30, 30),
    r=(love.math.random()-0.5)*math.pi/3,
    sx=size,
    sy=size,
    outline = true,
    screenSpace = false})
    text.ox = text.richText:getWidth()/2
    text.oy = text.richText:getHeight()/2

    local flux = system.getStorage("flux")
    local randomSpin = (love.math.random()-0.5)*3
    local randomSizeIncrease = love.math.random()
    flux.to(text, 0.7, {r=text.r+randomSpin})
    flux.to(text, 0.6, {sx=size+randomSizeIncrease, sy=size+randomSizeIncrease})

    main.waitWithMult(0.35, function ()
      text:delete()
    end)
  end
end)


-- audio related

-- system.on("main:entityTriggered", function (ent)
--   if ent.isCard == nil then
--     return
--   end
--   local combo = system.getStorage("main:currentCombo")
--   local audio = system.playAudio("boop")
--   main.audio.offsetAudioSourcePitch(audio, combo)
-- end)