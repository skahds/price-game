function main.createCard(id, args)
  return main.spawnEntity(id, {}, true)
end

function main.defineCard(id, eType)
  -- card ent isn't shown, it will create its own UI ent
  -- card ent
  main.entities[id] = class(main.entities.basicEnt)
  local card = main.entities[id]
  local basicEnt = main.entities.basicEnt

  function card:init(args)
    basicEnt.init(self, args)
    for k, v in pairs(eType) do
      self[k] = utils.deepCopy(v)
    end

    self.isCard = true

    self.screenSpace = true
    local image = self.image or "blank_card"
    
    self.cardUI = main.ui.spawnUI("card_ui", {image=image, x=100, y=100}, true)
  end

  function card:draw(args)

  end
end