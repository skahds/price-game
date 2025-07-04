local texts = {}
system.updateStorage("textsTable", texts)
system.updateStorage("defaultFont", love.graphics.newFont(30))

local RichText = require("src.RichText.richtext")

RichText.addEffect("moneyColor", function(self, args, info)
    -- Default to gold-ish color if no arguments are provided
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
  for k, v in pairs(args) do
    if k ~= "text" and k ~= "font" then
      texts[#texts][k] = utils.deepCopy(v)
    end
  end

  return texts[#texts]
end