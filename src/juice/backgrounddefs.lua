local frameworkBackground = main.entities.frameworkBackground

local W,H = 3000, 2000

local getShapeColor = function (rng)
  local num = rng:random()
  if num > 2/3 then
    return {1, 0.7, 0.7}
  elseif num > 1/3 then
    return {0.7, 0.7, 1}
  else
    return {1, 1, 1}
  end
end

local function chooseRandom(rng, t)
  local num = rng:random() * (#t-1)
  return t[math.floor(num+0.5)+1]
end

local numberOfShape = 100
local bg = frameworkBackground:new({
  worldX = -W/2, worldY = -H/2,
  worldWidth = W, worldHeight = H,
  objectMovement = {5, -5},
  objectRotation = 0.05,
  backgroundDim = 0.8,


  load = function (self, generateObject)
    local rng = love.math.newRandomGenerator(love.math.getRandomSeed())

    local images = {"basicAdd", "basicSubtract", "basicMultiply", "vision"}
    for i=1, numberOfShape*5 do
      generateObject(self, rng, {type=chooseRandom(rng, images),
      color={1, 1, 1}})
    end
  end,

  backgroundColor = {0.1, 0.1, 0.1},
})

system.on("@update", function ()
  bg:update(system.getStorage("dt"))
end)

system.on("@draw", function ()
  bg:draw()
end)