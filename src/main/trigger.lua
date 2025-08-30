function main.canTrigger(ent, trigger)
  if ent and ent.trigger then
    if utils.isEInTable(trigger, ent.trigger) == false then
      return false
    end
    return true
  end
  return false
end

function main.triggerEnt(ent, trigger)
  if trigger == nil then
    error("trigger can't be nil")
  end
  if main.canTrigger(ent, trigger) then
    if ent.onActivate then
      ent:onActivate()
    end
    
    system.call("main:entityTriggered", ent)
  end
  return true
end