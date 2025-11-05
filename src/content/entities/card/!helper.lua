function main.definePlaceableNewsCard(id, card, news)
  card.spawnNews = id .. "News"
  news.name = card.name
  main.defineCard(id, card)
  main.defineNews(id.."News", news)
end