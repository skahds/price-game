unpack = table.unpack or unpack

system.events = {}
system.storage = {}
system.questions = {}

---calls all event
---@param event string
---@param ... any
function system.call(event, ...)
  if system.events[event] then
    for i, func in ipairs(system.events[event]) do
      func(...)
    end
  end
end

---gets called by event
---@param event string
---@param func function
function system.on(event, func)
  if not system.events[event] then
    system.events[event] = {}
  end
  table.insert(system.events[event], func)
end

---gets from system.storage; however where i get stuff i like
---@param name string
---@return usystemnown
function system.getStorage(name)
  return system.storage[name]
end

---updates system.storage; however where i store stuff i like
---@param name string
---@param newVar any
function system.updateStorage(name, newVar)
  system.storage[name] = newVar
end

---question bus
---@param name string
---@param combiner function
---@param ... any
function system.ask(name, combiner, ...)
  local currentAnswer
  for i, answers in ipairs(system.questions[name]) do
    if currentAnswer then
      currentAnswer = combiner(answers(...), currentAnswer)
    else
      currentAnswer = answers(...)
    end
  end
  return currentAnswer
end

function system.answer(name, func)
  if not system.questions[name] then
    system.questions = {}
  end
  table.insert(system.questions[name], func)
end
