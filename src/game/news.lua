local basicEnt = main.entities.basicEnt

-- news ent
--IMPORTANT: this doesn't have an image/sprite themself but has a UI that do
--if image is nil then it just displays nothing (for if it wants to draw its own stuff)
function main.defineNews(id, eType)
  eType.isNews = true
  
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
    if self.image then
      ui.image = self.image
      self.image = nil
    end

    basicEnt.init(self, args)
  end
end

function main.triggerAllNews(trigger)
  local chart = system.getStorage("main:chart")
  local pipeline = main.getPipeline("main")
  if chart == nil then
    return
  end
  chart:forAllNews(function (news)
    if news.trigger == nil then
      return
    end
    if main.canTrigger(news, trigger) then
      pipeline:add(0.3, function ()
        main.triggerEnt(news, trigger)
      end)
    end
  end)
end



system.on("main:currentPriceChanged", function ()
  main.triggerAllNews("PRICECHANGE")
end)