utils = {}

function utils.copy(t)
  local copy = {}

  for k, v in pairs(t) do
    copy[k] = v
  end

  local mt = getmetatable(t)
  if mt then
    setmetatable(copy, mt)
  end

  return copy
end

function utils.deepCopy(original)
  local copied_tables = {} -- To handle circular references and avoid infinite loops

  local function _copy(obj)
    if type(obj) ~= "table" then
      return obj -- Primitive types are copied by value
    end

    -- If this table has already been copied, return the existing copy
    if copied_tables[obj] then
      return copied_tables[obj]
    end

    local new_table = {}
    copied_tables[obj] = new_table -- Store the new table immediately to handle circular references

    -- Copy values
    for k, v in pairs(obj) do
      new_table[_copy(k)] = _copy(v) -- Recursively copy keys and values
    end

    -- Optionally, copy metatable if desired
    local mt = getmetatable(obj)
    if mt then
      setmetatable(new_table, mt)
    end

    return new_table
  end

  return _copy(original)
end

function utils.shuffle(array)
  -- fisher-yates
  local output = {}
  local random = math.random

  for index = 1, #array do
    local offset = index - 1
    local value = array[index]
    local randomIndex = offset * random()
    local flooredIndex = randomIndex - randomIndex % 1

    if flooredIndex == offset then
      output[#output + 1] = value
    else
      output[#output + 1] = output[flooredIndex + 1]
      output[flooredIndex + 1] = value
    end
  end

  return output
end

function utils.getRectIntersection(r1, r2)
  local x1 = math.max(r1.x, r2.x)
  local y1 = math.max(r1.y, r2.y)
  local x2 = math.min(r1.x + r1.width, r2.x + r2.width)
  local y2 = math.min(r1.y + r1.height, r2.y + r2.height)

  local width = x2 - x1
  local height = y2 - y1

  if width > 0 and height > 0 then
    return {x = x1, y = y1, width = width, height = height}
  else
    return nil
  end
end

function utils.hexToRgba(hex)
  hex = hex:gsub("#","")
  return
    tonumber("0x" .. hex:sub(1,2)) / 255,
    tonumber("0x" .. hex:sub(3,4)) / 255,
    tonumber("0x" .. hex:sub(5,6)) / 255,
    tonumber("0x" .. hex:sub(7,8)) / 255
end

function utils.distanceBetween(x1, x2, y1, y2)
    return math.sqrt( (x2 - x1)^2 + (y2 - y1)^2 )
end