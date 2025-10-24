local musicList = {"StrangeWorlds", "GentleBreeze", "SunlightThroughLeaves", "ForgottenBiomes"}
system.updateStorage("audio:musicVolume", 1)

system.on("@load", function ()
  local rnd = love.math.random(1, #musicList)
  local music = musicList[rnd]
  system.playAudio(music)
end)

system.on("audio:audioFinished", function (id)
  if utils.isEInTable(id, musicList) then
    local rnd = love.math.random(1, #musicList)
    local music = musicList[rnd]
    system.playAudio(music)
  end
end)

system.on("@update", function ()
  main.audio.forAllCurrentAudio(musicList, function (audio)
    local volume = system.getStorage("audio:musicVolume")
    audio:setVolume(volume)
  end)
end)