local timers = {}
local deleteQueue = {}

function main.wait(second, fun)
  table.insert(timers, {currentTime=0, minimumTime=second, fun=fun, index=#timers+1})
end

system.on("@update", function ()
  for i=#timers, 1, -1 do
    local timer = timers[i]
    timer.currentTime = timer.currentTime + system.getStorage("dt")
    if timer.minimumTime < timer.currentTime then
      timer.fun()
      table.insert(deleteQueue, timer)
    end
  end

  for _, timer in pairs(deleteQueue) do
    local last = timers[#timers]
    if timer.index ~= last.index then
      timers[timer.index] = last
      last.index = timer.index
    end
    timers[#timers] = nil
  end

  deleteQueue = {}
end)

-- the default delay Multiplier so the game could go faster if requested
-- please multiply this with the default swhen possible
system.updateStorage("main:defaultDelayMult", 1)

function main.waitWithMult(second, fun)
  local defaultDelayMult = system.getStorage("main:defaultDelayMult")
  main.wait(second * defaultDelayMult, fun)
end