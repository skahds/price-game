main.ui.defineUI("levelSelect", {
  -- change these when spawned
  name = "Level",
  description = "nothing much here",
  image = "levelSelect",
  text = "1",
  showDescription = true,
  width = 64,
  height= 64,
  screenSpace = false,
  onMouseReleased = function (ent)
    if ent.isLastLevel == true then
      main.playScene("play")
    end
    print("y")
  end,
})