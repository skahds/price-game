function main.changeEntityComponent(ent, component, newValue, combinerFunction)
  if main.isComponent(component) == false then
    error(component .. " is not a component")
  end
  
  ent[component] = combinerFunction(ent[component], newValue)
  system.call("main:changeEntityComponent", ent, component, newValue)
end