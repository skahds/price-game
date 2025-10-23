local isShown = false
local cover, back, guideSelectLeft, guideSelectRight, number
local currentPage = 1

--image width, height = 400, 300
local pages = {
  {
    image="guideSlider",
    size={445, 200},
    text="3"
  },  {
    image="guideSlider",
    size={445, 200},
    text="2"
  },  {
    image="guideSlider",
    size={445, 200},
    text="1"
  }
}

local function deleteAll(arg)
  for k, ent in ipairs(arg) do
    ent:delete()
  end
end

local function buttonClick(n)
  currentPage=math.max(math.min(currentPage+n, #pages), 1)
end

local dimension = system.getStorage("screenDimension")
local width = 700
local height = 500

function main.ui.guidebook()
  if isShown == false then
    isShown = true
    cover = main.ui.spawnUI("cover", {
      x=dimension.w/2-width/2,
      y=dimension.h/2-height/2,
      width = width,
      height = height,
      color = {0.6, 0.6, 0.6},
      outline = 20,
      outlineColor = {0.2, 0.2, 0.2},
      ignoreUIChecks = false,
      renderLayer = 390}, true)

    back = main.ui.spawnUI("guideBack", {
      x=dimension.w/2+width/2-40-40,
      y=dimension.h/2-height/2+20,
      renderLayer = 392,
    }, true)

    guideSelectLeft = main.ui.spawnUI("guideSelect", {
      x=dimension.w/2-width/4-20,
      y=dimension.h/2+height/3-20,
      renderLayer = 392,
      text="<",
      onButtonClicked = function ()
        buttonClick(-1)
      end
    }, true)

    guideSelectRight = main.ui.spawnUI("guideSelect", {
      x=dimension.w/2+width/4-20,
      y=dimension.h/2+height/3-20,
      renderLayer = 392,
      text=">",
      onButtonClicked = function ()
        buttonClick(1)
      end
    }, true)
    
    number = main.newRichText({format="0",
      x=0,
      y=0,
    renderLayer = 392,})
  else
    deleteAll({cover, back, guideSelectLeft, guideSelectRight, number})
    isShown = false
  end
end

system.on("@update", function ()
  if number == nil then
    return
  end
  number.x = dimension.w/2 - number.richText:getWidth()/2
  number.y = dimension.h/2+height/3 - number.richText:getHeight()/2
  main.updateRichTextText(number, currentPage .. "/" .. #pages)
end)

system.on("@draw", function ()
  if isShown == false then
    return
  end

  local page = pages[currentPage]
  local w, h = page.size[1], page.size[2]
  local x, y = dimension.w/2-w/2, dimension.h/2 - height/2+30
  system.render(392, function ()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(system.getImage(page.image), x, y)
  end, true)

  main.printRichText({
    format = page.text,
    x=x,
    y=y+h+20,
    renderLayer = 392
  })
end)

main.ui.defineButton("guideBack", {
  width = 60,
  height = 60,
  color = {0.7, 0.4, 0.4},
  renderLayer = 101,
  screenSpace = true,
  text = "X",
  audio = "breaker",
  onButtonClicked = function (ent)
    main.ui.guidebook()
  end
})

main.ui.defineButton("guideSelect", {
  width = 40,
  height = 40,
  color = {0.7, 0.4, 0.4},
  renderLayer = 101,
  screenSpace = true,
  audio = "breaker",
})