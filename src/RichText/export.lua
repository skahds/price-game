local texts = {}
local temporaryTextsFrameOne = {}
local temporaryTextsFrameTwo = {}
local deleteQueue = {}
system.updateStorage("textsTable", texts)
system.updateStorage("defaultFont", system.getFont("defaultFont60"))

local RichText = require("src.RichText.richtext")

system.updateStorage("RichText", RichText)

-- the formatting code (ie: turning text into scientific notation, 5000 to 5.000) is made by ai
local SCI_NOTATION_THRESHOLD = 1000000000

local function format_number_string(n_input, original_str)
  local num = tonumber(n_input)

  if not num then
    return tostring(n_input)
  end

  if math.abs(num) >= SCI_NOTATION_THRESHOLD then
    return string.format("%.1e", num)
  end

  -- Check if original string had explicit + sign
  local sign = ""
  if original_str and original_str:match("^%+") then
    sign = "+"
  elseif num < 0 then
    sign = "-"
  end
  
  local abs_num = math.abs(num)
  local integer_part, fractional_part = math.modf(abs_num)
  local integer_str = tostring(math.floor(integer_part))

  local s_reversed = integer_str:reverse()
  local separated_reversed = s_reversed:gsub("(%d%d%d)", "%1.")
  local formatted = separated_reversed:reverse()

  formatted = formatted:gsub("^%.", "")

  formatted = sign .. formatted
  if math.abs(fractional_part) > 0.0000001 then
    local decimal_part = string.format("%.2f", math.abs(fractional_part)):sub(2)
    formatted = formatted .. decimal_part
  end

  return formatted
end

local function format_mixed_string(text_input)
  local text_input = tostring(text_input)
  local pattern = "([+-]?%d+%.?%d*)"

  local formatted_text = text_input:gsub(pattern, function(matched_number_str)
    local num = tonumber(matched_number_str)
    if num then
      return format_number_string(num, matched_number_str)
    else
      return matched_number_str
    end
  end)
  return formatted_text
end

function main.newRichText(args)
  local font = args.font or system.getStorage("defaultFont")
  local format = format_mixed_string(args.format)
  local text = RichText.new(font, format)
  
  table.insert(texts, {richText=text})
  local textTable = texts[#texts]
  textTable.index = #texts
  for k, v in pairs(args) do
    if k ~= "richText" and k ~= "font" then
      textTable[k] = utils.deepCopy(v)
    end
  end

  text.richTextTable = textTable

function textTable.delete(t)
  if t.insideDeleteQueue then
    return
  end
  table.insert(deleteQueue, t)
  t.insideDeleteQueue = true
end

  return texts[#texts]
end

system.on("@update", function ()
  for i=#temporaryTextsFrameTwo, 1, -1 do
    local richtext = temporaryTextsFrameTwo[i]
    richtext:delete()
  end
  temporaryTextsFrameTwo = {}

  for i=#temporaryTextsFrameOne, 1, -1 do
    local richtext = temporaryTextsFrameOne[i]
    table.insert(temporaryTextsFrameTwo, richtext)
    table.remove(temporaryTextsFrameOne, #temporaryTextsFrameOne)
  end
  temporaryTextsFrameOne = {}
end)

function main.printRichText(args)
  local richText = main.newRichText(args)
  table.insert(temporaryTextsFrameOne, richText)
  return richText
end

function main.updateRichTextText(richtext, newformat)
  newformat = format_mixed_string(newformat)
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