local audios = {}

function system.getAudio(id)
  if system.audio[id] == nil then
    error("audio " .. id .. " does not exist")
  end
  return system.audio[id]
end

function system.playAudio(id)
  local audio = system.getAudio(id)

  local clone = audio:clone()
  if clone then
    clone:play()
    table.insert(audios, {id=id, clone=clone})
    return clone
  end
end

main.audio = {}
function main.audio.offsetAudioSourcePitch(source, semitonesOffset)
    local currentPitch = source:getPitch()
    local newPitch = currentPitch * (2 ^ (semitonesOffset / 12))
    source:setPitch(newPitch)
end

system.on("@update", function ()
  for i=#audios, 1, -1 do
    local audioTable = audios[i]
    local audio = audioTable.clone
    if audio:isPlaying() then
      return
    end
    system.call("audio:audioFinished", audioTable.id)
    table.remove(audios, i)
  end
end)