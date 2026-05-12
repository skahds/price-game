function main.definePlaceableNewsCard(id, card, news)
  card.spawnNews = id .. "News"
  card.description = "Places down\n" .. card.name
  news.name = card.name
  main.defineCard(id, card)
  main.defineNews(id.."News", news)
end

main.starters = {}
main.runModes = {}

function main.defineRunStarter(id, content)
  content.id = id
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

function main.createCardToDraw(id, amount)
  for i=1, amount do
    local card = main.createCard(id, {}, "hand")
    card.ui.isVisible = false
    main.addCardToDraw(card)
  end
end