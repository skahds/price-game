function main.definePlaceableNewsCard(id, card, news)
  card.spawnNews = id .. "News"
  news.name = card.name
  main.defineCard(id, card)
  main.defineNews(id.."News", news)
end

main.starters = {}
main.runModes = {}
main.runModifiers = {}

function main.defineRunStarter(content)
  table.insert(main.starters, content)
end

-- contents = {definition={name, news={"this", "that"}}, this={news...}, that={news...}}
function main.defineRunMode(contents)
  local def = contents.definition
  table.insert(main.runModes, def)

  for k, t in pairs(contents) do
    if k ~= "definition" then
      main.defineNews(k, t)
    end
  end
end

function main.defineModifiers(content)
  content.amount = 0
  table.insert(main.runModifiers, content)
end


function main.createCardToDraw(id, amount)
  for i=1, amount do
    local card = main.createCard(id, {}, "hand")
    card.ui.isVisible = false
    main.addCardToDraw(card)
  end
end