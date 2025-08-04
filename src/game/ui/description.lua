local descriptionList = {}

function main.addDescriptionType(func)
  table.insert(descriptionList, func)
end

local function parseDescriptionList(ent)
  local t = {}
  local addToDescription = function (text)
    table.insert(t, text)
  end
  for i, func in ipairs(descriptionList) do
    func(ent, addToDescription)
  end
  return t
end

local function drawDescription(ent, location)
  
end