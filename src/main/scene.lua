local scenes = {}
local currentScene

function main.defineScene(id, loadFunc, unloadFunc)
  scenes[id] = {load=loadFunc, unload=unloadFunc}
end

local flux = system.getStorage("flux")
local waitTime = 0.3
local dimension = system.getStorage("screenDimension")
local bigScreenCoverPosition = {x=0, y=0}

main.newPipeline("scene")
local pipeline = main.getPipeline("scene")
pipeline.ignoreGameSpeed = true

function main.playScene(id)
  -- local speed = system.getStorage("main:defaultDelayMult")
  if scenes[id] == nil then
    error("scene does not exist")
  end

  flux.to(bigScreenCoverPosition, waitTime, {x=0, y=0})
  if currentScene then
    pipeline:add(waitTime, function ()
      currentScene.unload()
    end)
  end

  pipeline:add(waitTime, function ()
    scenes[id].load()
    currentScene = scenes[id]
    system.updateStorage("main:currentScene", id)
    system.call("main:sceneChanged", id)

    flux.to(bigScreenCoverPosition, waitTime, {x=0, y=-dimension.h}):oncomplete(function ()
      bigScreenCoverPosition.y = dimension.h
    end)
  end)
end

system.on("@draw", function ()
  system.render(9999, function ()
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", bigScreenCoverPosition.x, bigScreenCoverPosition.y, dimension.w, dimension.h)
  end, true)
end)

system.register("scene", 30, function ()
  local scene = system.getStorage("main:currentScene")
  return scene
end, function (scene)
  main.playScene(scene)
end)