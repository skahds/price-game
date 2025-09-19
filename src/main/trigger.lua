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
  local bypass = false
  if trigger == nil then
    bypass = true
  end
  if main.canTrigger(ent, trigger) or bypass then
    if ent.onActivate then
      ent:onActivate()
    end
    
    system.call("main:entityTriggered", ent)
    return true
  end
end