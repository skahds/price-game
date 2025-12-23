Steam = require 'luasteam'

if not Steam.init() then
  error("Failed initializing steam")
end

function Steam.friends.onGameOverlayActivated(data)
  if data.active then
    print("Steam overlay now active")
  else
    print("Steam overlay now inactive")
  end
end

print("My app id is " .. Steam.utils.getAppID())