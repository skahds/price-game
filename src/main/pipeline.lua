local pipelines = {}

local pipeline = class()
function pipeline:init(id)
  pipelines[id] = self

  self.pipeline = {}
  self.timer = 0
end

function pipeline:add(time, action)
  table.insert(self.pipeline, {time=time, action=action})
end

function pipeline:insert(time, order, action)
  self.timer = 0
  table.insert(self.pipeline, order, {time=time, action=action})
end

function pipeline:finishCurrentAction()
  local script = self.pipeline[1]
  if script == nil then
    return
  end

  table.remove(self.pipeline, 1)
  script.action()
  self.timer = 0
end

function pipeline:skipCurrentAction()
  table.remove(self.pipeline, 1)
  self.timer = 0
end

function pipeline:update()
  if #self.pipeline < 1 then
    return
  end
  -- print(self.timer)
  local dt = system.getStorage("dt")
  self.timer = self.timer + dt
  if self.pipeline[1].time < self.timer then
    self:finishCurrentAction()
  end
end

----
system.on("@update", function ()
  for _, pipeline in pairs(pipelines) do
    pipeline:update()
  end
end)

function main.newPipeline(id)
  pipeline:new(id)
end

function main.getPipeline(id)
  return pipelines[id]
end

-- some basic pipelines
main.newPipeline("main")