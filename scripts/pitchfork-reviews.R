library(tidyverse)
library(rvest)

datalist = list()
row_count = 1
for (i in 1:188) {
  Sys.sleep(3)
  print(paste('Page ', i, ' of 188', sep = ''))
  url = paste('https://pitchfork.com/reviews/albums/?genre=rap&page=', i, sep = '')
  download.file(url, 'page.html')
  page = read_html('page.html')
  reviews = page %>% html_nodes('.review')
  for (j in 1:length(reviews)) {
    # extract fields
    page_no = i
    review_no = j
    artist = reviews[j] %>% html_node('.review__title-artist li') %>% html_text()
    album = reviews[j] %>% html_node('.review__title-album') %>% html_text()
    genre = reviews[j] %>% html_node('.genre-list__link') %>% html_text()
    author = reviews[j] %>% html_node('.display-name--linked') %>% html_text()
    publish_date = reviews[j] %>% html_node('.pub-date') %>% html_text()
    bnm = reviews[j] %>% html_node('.review__meta-bnm') %>% html_text()
    cover_art = reviews[j] %>% html_node('img') %>% html_attr('src')
    url = reviews[j] %>% html_node("a") %>% html_attr('href')
    
    # save as row
    temp = tibble(page_no, review_no, artist, album, genre, author, publish_date, bnm, cover_art, url)
    datalist[[row_count]] = temp
    row_count = row_count + 1
    glimpse(temp)
  }
}
raw = do.call(rbind, datalist) # show have 188 * 12 rows = 2,256
