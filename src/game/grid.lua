main.grid = {gridSize = 32}

local gridSize = main.grid.gridSize

function main.grid.snapToGrid(x, y)
  return math.floor(x/gridSize)*gridSize, math.floor(y/gridSize)*gridSize
end

function main.grid.toGrid(x, y)
  return math.floor(x/gridSize), math.floor(y/gridSize)
end

function main.grid.entityToGrid(ent)
  local x, y = main.grid.snapToGrid(ent.x, ent.y)
  local w, h = math.floor(ent.width/32), math.floor(ent.height/32)
  return x/32, y/32, w, h
end

function main.grid.gridToPos(gridX, gridY)
  return gridX*gridSize, gridY*gridSize
end

-- assume all news on chart is snapped to grid
function main.grid.getNewsInGrid(gridX, gridY, width, height)
  width = width or 1
  height = height or 1
  local t = {}
  local chart = system.getStorage("main:chart")
  if chart == nil then
    return
  end
  chart:forAllNews(function (ent)
    local x, y, w, h = main.grid.entityToGrid(ent)
    local x1, y1, w1, h1 = main.normalizeRect(x, y, w, h)
    local x2, y2, w2, h2 = main.normalizeRect(gridX, gridY, width, height)
    if x1 < x2 + w2 and
      x1 + w1 > x2 and
      y1 < y2 + h2 and
      y1 + h1 > y2 then
        table.insert(t, ent)
      end
  end)
  if #t > 0 then
    return t
  else
    return
  end
end

function main.grid.getClosestAvailableGrid(targetX, targetY, width, height, maxRadius)
  width = width or 1
  height = height or 1
  maxRadius = maxRadius or 10
  
  local startX, startY = main.grid.toGrid(targetX, targetY)
  
  if not main.grid.getNewsInGrid(startX, startY, width, height) then
    return startX, startY
  end
  
  for radius = 1, maxRadius do
    local cardinals = {
      {0, -radius},   -- up
      {0, radius},    -- down
      {-radius, 0},   -- left
      {radius, 0},    -- right
    }
    
    for _, offset in ipairs(cardinals) do
      local checkX = startX + offset[1]
      local checkY = startY + offset[2]
      
      if not main.grid.getNewsInGrid(checkX, checkY, width, height) then
        return checkX, checkY
      end
    end
    
    for dx = -radius, radius do
      for dy = -radius, radius do
        if not (dx == 0 and dy == 0) and 
            not (dx == 0 and math.abs(dy) == radius) and
            not (dy == 0 and math.abs(dx) == radius) then
          if math.abs(dx) == radius or math.abs(dy) == radius then
            local checkX = startX + dx
            local checkY = startY + dy
            
            if not main.grid.getNewsInGrid(checkX, checkY, width, height) then
              return checkX, checkY
            end
          end
        end
      end
    end
  end
  
  return nil
end