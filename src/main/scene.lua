local scenes = {}
local currentScene

function main.defineScene(id, loadFunc, unloadFunc)
  scenes[id] = {load=loadFunc, unload=unloadFunc}
end

function main.playScene(id)
  if scenes[id] == nil then
    error("scene does not exist")
  end

  if currentScene then
    currentScene.unload()
  end

  scenes[id].load()
  currentScene = scenes[id]
  system.call("main:sceneChanged", id)
  system.updateStorage("main:currentScene", id)
end