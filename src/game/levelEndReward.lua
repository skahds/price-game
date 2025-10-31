local pipeline = main.getPipeline("main")

function main.createRewardsOptions(rewards)
  for i, option in ipairs(rewards) do

    main.createCard(option, {}, "reward")

    main.card.updateAllCardPositionBackToOriginalPosition("reward", {x=640, y=280})
  end
end

system.on("main:cardClicked", function (ent, button)
  if button ~= 1 then
    return
  end

  if ent == nil then
    return
  end

  if ent.ownerShip == "reward" then
    main.transferOwnership(ent, "hand")
  else
    return
  end
  
  for i=#main.card.reward, 1, -1 do
    pipeline:add(0.15, function ()
      local card = main.card.reward[i]
      main.deleteCard(card)
    end)
  end
end)

system.on("@draw", function ()
  if #main.card.reward > 0 then
    local t = main.printRichText({
      x=0,
      y=100,
      format = "Pick a reward!"
    })
    t.x = 640-t.richText:getWidth()/2
  end
end)