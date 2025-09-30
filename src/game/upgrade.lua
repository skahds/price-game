function main.changeEntityComponent(card, component, newValue, combinerFunction)
  if main.isComponent(component) == false then
    error(component .. " is not a component")
  end
  
  card[component] = combinerFunction(card[component], newValue)
  system.call("main:changeEntityComponent", card, component, newValue)
end