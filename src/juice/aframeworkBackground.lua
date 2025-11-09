local frameworkBackground = class(main.entities.basicEnt)
main.entities.frameworkBackground = frameworkBackground

local function generateObject(self, rng, args)
  local size = args.size or rng:random(3, 8)/10

  local object = {
    x = args.x or self.worldX + rng:random() * self.worldWidth,
    y = args.y or self.worldY + rng:random() * self.worldHeight,
    rot = args.rot or rng:random(-314, 314)/100,
    size = size,
    layerIndex = args.layerIndex or rng:random(5, 9)/10,
    image = args.type,
    color = args.color,
    rotationUpdate = args.rotationUpdate or self.objectRotation
  }
  table.insert(self.objects, object)
end

function frameworkBackground:init(args)
  print("thing")
  self.objects = {}

  self.backgroundColor = args.backgroundColor
  self.backgroundDim = args.backgroundDim or 0
  self.worldX = args.worldX
  self.worldY = args.worldY
  self.worldWidth = args.worldWidth
  self.worldHeight = args.worldHeight
  self.objectMovement = args.objectMovement or {0, 0}
  self.objectRotation = args.objectRotation or 0


  local cam = main.getCamera()
  self.initialCamX, self.initialCamY = cam.x, cam.y

  args.load(self, generateObject)


  table.sort(self.objects, function (a, b)
    return a.layerIndex < b.layerIndex
  end)
end


local function distToHorizontalEdge(self, object)
  local center = self.worldX + self.worldWidth/2
  local distFromCenter = math.abs(center - object.x)
  local distToEdge = self.worldWidth/2 - distFromCenter
  return distToEdge
end

local function distToVerticalEdge(self, object)
  local center = self.worldY + self.worldHeight/2
  local distFromCenter = math.abs(center - object.y)
  local distToEdge = self.worldHeight/2 - distFromCenter
  return distToEdge
end

local function updateObject(self, object, dt)
  if distToHorizontalEdge(self, object) < -10 then
    if self.objectMovement[1] < 0 then
      object.x = self.worldX+self.worldWidth + 5
    else
      object.x = self.worldX - 5
    end
  end
  if distToVerticalEdge(self, object) < -10 then
    if self.objectMovement[2] < 0 then
      object.y = self.worldY+self.worldHeight + 5
    else
      object.y = self.worldY - 5
    end
  end
  object.x = object.x + object.layerIndex * self.objectMovement[1] * dt
  object.y = object.y + object.layerIndex * self.objectMovement[2] * dt


  if self.objectRotation then
    object.rot = object.rot + object.rotationUpdate * dt
  end
end


function frameworkBackground:update(dt)
  for _, object in ipairs(self.objects)do
    updateObject(self, object, dt)
  end
end



local lg = love.graphics

local function drawObject(self, object)
  lg.setColor(object.color)
  local cam = main.getCamera()
  local cx, cy = -cam.x, -cam.y
  cx = cx - self.initialCamX
  cy = cy - self.initialCamY
  -- system.render(1, function ()
    love.graphics.draw(system.getImage(object.image),
      object.x+(cx/3*(object.layerIndex^2)),
      object.y+(cy/3*(object.layerIndex^2)),
      object.rot, object.size, object.size)
  -- end, true)
end


function frameworkBackground:draw()

  system.render(1, function ()
  love.graphics.setColor(self.backgroundColor)
  love.graphics.rectangle("fill", self.worldX, self.worldY, self.worldWidth, self.worldHeight)
  for _, object in ipairs(self.objects) do
    drawObject(self, object)
  end
  --background dim
  love.graphics.setColor(self.backgroundColor[1], self.backgroundColor[2], self.backgroundColor[3], self.backgroundDim)
  love.graphics.rectangle("fill", self.worldX, self.worldY, self.worldWidth, self.worldHeight)

  end, true)
end