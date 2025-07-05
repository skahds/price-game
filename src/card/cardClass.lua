-- card ent isn't shown, it will create its own UI ent
main.entities.card = class(main.entities.basicEnt)
local card = main.entities.card
local basicEnt = main.entities.basicEnt

function card:init(args)
  basicEnt.init(self, args)
end

function card:draw(args)

end