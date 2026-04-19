local success, luasteam = pcall(require, "luasteam")

if success == false then
  love.window.showMessageBox(
    "Luasteam failed to initialize",
    "Restarting the game might fix this issue"
  )
  return
end

Steam = luasteam

if not Steam.init() then
  love.event.quit()
  return
end

function Steam.friends.onGameOverlayActivated(data)
  if data.active then
    print("Steam overlay now active")
  else
    print("Steam overlay now inactive")
  end
end