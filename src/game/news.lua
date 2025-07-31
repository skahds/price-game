local basicEnt = main.entities.basicEnt

-- news ent
--IMPORTANT: this doesn't have an image/sprite themself but has a UI that do
--if image is nil then it just displays nothing (for if it wants to draw its own stuff)
function main.defineNews(id, eType)
  main.entities[id] = class(main.entities.basicEnt)
  local news = main.entities[id]
  function news:init(args)
    for k, v in pairs(eType) do
      self[k] = utils.deepCopy(v)
    end

    self.x = self.x or args.x
    self.y = self.y or args.y

    if self.x == nil or self.y == nil then
      error("news needs XY position")
    end
    self.ui = main.ui.spawnUI("news_ui", {parent=self}, true)
    local ui = self.ui
    ui.x = self.x
    ui.y = self.y

    basicEnt.init(self, args)
  end
end
