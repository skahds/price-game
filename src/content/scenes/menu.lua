local play

local function deleteAll(args)
  for k, ent in pairs(args) do
    if ent.delete then
      ent:delete()
    end
  end
end

main.defineScene("menu", function ()
  play = main.ui.spawnUI("menuPlay", {x=640-150, y=360}, true)
end, function ()
  deleteAll({play})
end)