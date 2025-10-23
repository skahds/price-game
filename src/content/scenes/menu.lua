local play
local credits
local logo
local discord

local function deleteAll(args)
  for k, ent in pairs(args) do
    if ent.delete then
      ent:delete()
    end
  end
end

local flux = system.getStorage("flux")
main.defineScene("menu", function ()
  logo = main.ui.spawnUI("logo", {x=640-220, y=-300}, true)
  flux.to(logo, 2, {y=100})
  play = main.ui.spawnUI("menuPlay", {x=640-100, y=390}, true)
  credits = main.ui.spawnUI("credits", {x=20, y=20}, true)
  discord = main.ui.spawnUI("discord", {x=20, y=720-150}, true)
end, function ()
  deleteAll({play, credits, logo, discord})
  main.ui.guidebook()
end)