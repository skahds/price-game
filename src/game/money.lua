-- the money used in shops to buy stuff
function main.addMoney(amt)
  local money = system.getStorage("main:money")
  money = money + amt
  system.updateStorage("main:money", money)
  system.call("main:moneyChanged", amt)
end

function main.getMoney()
  local money = system.getStorage("main:money")
  return money
end