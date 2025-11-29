local sfxList = {"boop", "breaker"}

for i, sfx in ipairs(sfxList) do
  main.audio.setDefaultAudioFunction(sfx, function (audio)
    local volume = system.getStorage("audio:sfxVolume") or 1
    audio:setVolume(volume)
  end)
end

system.on("@update", function ()
  main.audio.forAllCurrentAudio(sfxList, function (audio)
    local volume = system.getStorage("audio:sfxVolume") or 1
    audio:setVolume(volume)
  end)
end)