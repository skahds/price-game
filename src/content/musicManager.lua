local musicList = {"EveningHarmony"}

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