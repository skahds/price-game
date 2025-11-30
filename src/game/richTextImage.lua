local images = {}
local RichText = system.getStorage("RichText")

function main.defineRichTextImage(str, image)
  images[str] = image
  RichText.defineImage(image, image)
end

function main.richTextFormatImage(str)
  if str == nil then
    return
  end

  for pattern, value in pairs(images) do
    local escaped = pattern:gsub("([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1")
    
    str = str:gsub(escaped, "{" .. value .. "} " .. pattern)
  end
  
  return str
end

main.defineRichTextImage("PRICE", "basicAdd")
main.defineRichTextImage("MULT", "basicMultiply")
main.defineRichTextImage("ENERGY", "energy")
