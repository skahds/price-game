function main.definePlaceableNewsCard(id, card, news)
  card.spawnNews = id .. "News"
  news.name = card.name
  main.defineCard(id, card)
  main.defineNews(id.."News", news)
end

main.starters = {}

function main.defineRunStarter(content)
  table.insert(main.starters, content)
end

function main.createCardToDraw(id, amount)
  for i=1, amount do
    local card = main.createCard(id, {}, "discard")
    main.addCardToDraw(card)
  end
end