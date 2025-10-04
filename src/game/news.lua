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
    self.chartOrder = self.chartOrder

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

local function repeatingTriggerNews(news, trigger)
  local pipeline = main.getPipeline("main")
  local chart = system.getStorage("main:chart")

  if main.canTrigger(news, trigger) then
    pipeline:add(0.3, function ()
      main.triggerEnt(news, trigger)

      pipeline:add(0, function ()
        local nextNews
        if news.isAboutToBeDeleted ~= true then
          nextNews = chart:getNews(news.chartOrder + 1)
        else
          nextNews = chart:getNews(news.chartOrder)
        end
        
        if nextNews then
          repeatingTriggerNews(nextNews, trigger)
        else
          system.call("main:repeatingTriggerNewsEnd", trigger)
        end
      end)
    end)
  else
    local nextNews = chart:getNews(news.chartOrder + 1)
    if nextNews then
      repeatingTriggerNews(nextNews, trigger)
    else
      system.call("main:repeatingTriggerNewsEnd", trigger)
    end
  end
end

function main.triggerAllNews(trigger)
  local chart = system.getStorage("main:chart")
  if chart == nil then
    return
  end
  if chart:getNews(1) == nil then
    system.call("main:repeatingTriggerNewsEnd", trigger)
    return
  end
  repeatingTriggerNews(chart:getNews(1), trigger)
end

function main.deleteNews(news)
  if news == nil then
    error("news is nil")
  end
  local chart = system.getStorage("main:chart")
  if chart == nil then
    error("tried to delete news with nil chart")
  end

  local newsOrder = news.chartOrder
  chart:removeNews(newsOrder)
  local newsUI = news.ui
  newsUI:delete()
  news:delete()
end

function main.spawnNews(id, args)
  local chart = system.getStorage("main:chart")
  if chart == nil then
    return
  end

  local news = main.spawnEntity(id, args, true)
  chart:addNews(news)
  news.chartOrder = chart:getNewsAmount()
  return news
end


system.on("main:currentPriceChanged", function ()
  main.triggerAllNews("PRICECHANGE")
end)