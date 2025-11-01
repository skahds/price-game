local sfxList = {"boop", "breaker"}

system.on("@update", function ()
  main.audio.forAllCurrentAudio(sfxList, function (audio)
    local volume = system.getStorage("audio:sfxVolume") or 1
    audio:setVolume(volume)
  end)
end)