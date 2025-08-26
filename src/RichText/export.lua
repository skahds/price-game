local texts = {}
local deleteQueue = {}
system.updateStorage("textsTable", texts)
system.updateStorage("defaultFont", system.getFont("defaultFont60"))

local RichText = require("src.RichText.richtext")

system.updateStorage("RichText", RichText)

function main.newRichText(args)
  local font = args.font or system.getStorage("defaultFont")
  local text = RichText.new(font, args.format)
  
  table.insert(texts, {richText=text})
  local textTable = texts[#texts]
  textTable.index = #texts
  for k, v in pairs(args) do
    if k ~= "richText" and k ~= "font" then
      textTable[k] = utils.deepCopy(v)
    end
  end

  function textTable.delete(t)
    for k, text in pairs(deleteQueue) do
      if text.index == t.index then
        return
      end
    end
    table.insert(deleteQueue, t)
    t.insideDeleteQueue = true
  end

  return texts[#texts]
end

function main.updateRichTextText(richtext, newformat)
  richtext.richText:setText(newformat)
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