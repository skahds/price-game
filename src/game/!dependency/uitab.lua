local loadFuncs = {}
local unloadFuncs = {}
local currentTab = ""

function main.defineUITab(id, loadFunc, unloadFunc)
  loadFuncs[id] = loadFunc
  unloadFuncs[id] = unloadFunc
end

local function unloadAll()
  for i, func in pairs(unloadFuncs) do
    func()
  end
end

function main.openUITab(id, forceOpen)
  if forceOpen == nil then
    if currentTab ~= id then
      unloadAll()
      currentTab = id
      loadFuncs[id]()
    else
      unloadAll()
      currentTab = nil
    end

    return
  end
  
  if forceOpen == true then
    if currentTab ~= id then
      unloadAll()
      currentTab = id
      loadFuncs[id]()
    end
  else
    if currentTab == id then
      unloadAll()
      currentTab = nil
    end
  end
end

function main.closeAllUITabs()
  unloadAll()
  currentTab = nil
end