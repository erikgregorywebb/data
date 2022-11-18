
library(tidyverse)
library(rvest)
library(stringr)

# scape all the article links
all_links = c()
url = 'https://www.theneedledrop.com/articles?category=Reviews'
while (url != 'end') {
  Sys.sleep(3)
  page = read_html(url)
  links = page %>% html_nodes('a') %>% html_attr('href')
  all_links = c(all_links, links)
  print(length(all_links))
  
  # check for offset
  offset = links[links %>% str_detect('offset')]
  if (!is.na(offset)) {
    url = paste('https://www.theneedledrop.com', links[links %>% str_detect('offset') 
                                                       & links %>% str_detect('reverse', negate = TRUE)
                                                       & links %>% str_detect('offset-', negate = TRUE)], sep = '')
    print(url)
  }
  else
    url = 'end'
}
album_review_links = paste('https://www.theneedledrop.com', 
                           unique(all_links[all_links %>% str_detect('/articles/20') & all_links %>% str_detect('#comments', negate = TRUE)]),
                           sep = '')
album_review_links = album_review_links[album_review_links %>% str_detect('https://www.theneedledrop.comhttp://www.theneedledrop.com/articles', negate = TRUE)]

# export a copy to be safe
setwd("~/Downloads")
write_csv(tibble(url = album_review_links), 'the-needle-drop-review-urls.csv')

# get details for each alubm review
datalist = list()
for (i in 1:length(album_review_links)) {
  Sys.sleep(3)
  url = album_review_links[i]
  print(url)
  try({
    page = read_html(url)
    title = page %>% html_nodes('.entry-title a') %>% html_text()
    date = page %>% html_nodes('.entry-header-date-link') %>% html_text()
    tags = page %>% html_nodes('.entry-meta') %>% html_text()
    datalist[[i]] = tibble(title = title, date = date, tags = tags, url = album_review_links[i])
    print(title)
  })
}
raw = do.call(rbind, datalist)          
