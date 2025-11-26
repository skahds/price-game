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
  local n = #array
  local random = love.math.random

  -- Perform the Fisher-Yates shuffle in-place
  for i = n, 2, -1 do
    -- Pick a random index j from 1 to i (inclusive)
    local j = random(i)
    
    -- Swap array[i] and array[j]
    array[i], array[j] = array[j], array[i]
  end
  
  return array
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

function utils.isEInTable(e, t)
  for k, v in pairs(t) do
    if v == e then
      return true
    end
  end
  return false
end

--angle in degree
function utils.rotatePoint(x, y, angle, p, q)
    local radians = math.rad(angle)
    local cosAngle = math.cos(radians)
    local sinAngle = math.sin(radians)
    -- Translate point so center is at origin
    x, y = x - p, y - q
    -- Apply rotation matrix
    local rotatedX = cosAngle * x - sinAngle * y
    local rotatedY = sinAngle * x + cosAngle * y
    -- Translate back
    return rotatedX + p, rotatedY + q
end

function utils.lerpColor(c1, c2, t)
  return {
    c1[1] + (c2[1] - c1[1]) * t,
    c1[2] + (c2[2] - c1[2]) * t,
    c1[3] + (c2[3] - c1[3]) * t
  }
end

---@return table
function utils.seperateSlashN(text)
  local t = {}

  while true do
    local ss, se = string.find(text, "\n")
    if ss then
      local firstPart = string.sub(text, 1, ss)
      table.insert(t, firstPart)
      text = string.sub(text, se+1, #text)
    else
      table.insert(t, text)
      break
    end
  end

  return t
end

---@param t table
---@return string
function utils.combineSlashN(t)
  local s = ""
  for i, text in ipairs(t) do
    if i ~= 1 and i ~= #t then
      if i ~= 2 then
        s = s .. "\n".. text
      else
        s = s .. text
      end
    end
  end
  return s
end