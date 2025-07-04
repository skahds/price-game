local texts = {}
local deleteQueue = {}
system.updateStorage("textsTable", texts)
system.updateStorage("defaultFont", love.graphics.newFont(30))

local RichText = require("src.RichText.richtext")

RichText.addEffect("moneyColor", function(self, args, info)
    local r = args.r or 1
    local g = args.g or 0.8
    local b = args.b or 0
    local a = args.a or 1
    self:setColor(r, g, b, a)
end)

system.updateStorage("RichText", RichText)

function main.newRichText(args)
  local font = args.font or system.getStorage("defaultFont")
  local text = RichText.new(font, args.text)
  
  table.insert(texts, {text=text})
  local textTable = texts[#texts]
  textTable.index = #texts
  for k, v in pairs(args) do
    if k ~= "text" and k ~= "font" then
      textTable[k] = utils.deepCopy(v)
    end
  end

  function textTable.delete(t)
    table.insert(deleteQueue, t)
  end

  return texts[#texts]
end





system.on("@update", function ()
  for i=#deleteQueue, 1, -1 do
    local text = deleteQueue[i]
    local last = texts[#texts]
    if text.index ~= last.index then
      texts[text.index] = last
      last.index = text.index
    end
    texts[#texts] = nil
  end
  deleteQueue = {}
end)