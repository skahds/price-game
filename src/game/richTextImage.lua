local images = {}
local RichText = system.getStorage("RichText")

function main.defineRichTextImage(str, imageInStorage, imageName)
  images[str] = imageName
  RichText.defineImage(imageName, imageInStorage)
end

function main.richTextFormatImage(str)
  if str == nil then
    return
  end

  for pattern, value in pairs(images) do
    local escaped = pattern:gsub("([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1")
    
    str = str:gsub(escaped, "{" .. value .. "}" .. pattern)
  end

  return str
end

main.defineRichTextImage("PRICE", "priceIcon", "priceIcon")
main.defineRichTextImage("MULT", "multIcon", "multIcon")
main.defineRichTextImage("ENERGY", "energy", "energyIcon")
main.defineRichTextImage("CARD", "cardIcon", "cardIcon")
main.defineRichTextImage("REPEAT", "repeatIcon", "repeatIcon")
-- RichText.defineImage("energyIcon", "energy")