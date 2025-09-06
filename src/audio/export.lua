local audios = {}
local audioCreateFuncs = {}

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
    if clone.setResamplingRatio then
      clone.setPitch = clone.setResamplingRatio
      clone.getPitch = clone.getResamplingRatio
    end

    clone:play()
    table.insert(audios, {id=id, clone=clone})
    if audioCreateFuncs[id] then
      for i, func in ipairs(audioCreateFuncs[id]) do
        func(clone)
      end
    end

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

function main.audio.setDefaultAudioFunction(id, func)
  if audioCreateFuncs[id] == nil then
    audioCreateFuncs[id] = {}
  end
  table.insert(audioCreateFuncs[id], func)
end

function main.audio.forAllCurrentAudio(idTable, func)
  for i=#audios, 1, -1 do
    local audioTable = audios[i]
    if utils.isEInTable(audioTable.id, idTable) then
      local audio = audioTable.clone
      func(audio)
    end
  end
end