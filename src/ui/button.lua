function main.ui.defineButton(id, eType)
  function eType.onMouseReleased(ent)
    if ent.onButtonClicked then
      ent:onButtonClicked()
    end
    if ent.onButtonDownImage and ent.onButtonUpImage then
      ent.image = ent.onButtonDownImage
      main.wait(0.5, function ()
        ent.image = ent.onButtonUpImage
      end)
    end
  end

  eType.image = eType.image or eType.onButtonUpImage

  main.ui.defineUI(id, eType)
end