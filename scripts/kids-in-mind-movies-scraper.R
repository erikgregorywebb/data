# data source: https://kids-in-mind.com/

# import
library(tidyverse)
library(rvest)

# scrape
urls = sprintf('https://kids-in-mind.com/%s.htm', letters)
datalist = list()
for (i in 1:length(urls)) {
  print(urls[i])
  Sys.sleep(1)
  page = read_html(urls[i])
  datalist[[i]] = page %>% html_nodes('.et_pb_text_2') %>% 
    html_text2() %>% str_split(., pattern = '\n') %>% unlist() %>% tibble()
}
raw = do.call(rbind, datalist)

# clean
movies = raw %>%
  rename(movie = 1) %>%
  #mutate(ratings = str_extract(movie, '\\d\\.\\d\\.\\d')) %>%
  mutate(ratings = str_extract(movie, '\\d+\\.\\d+\\.\\d+')) %>%
  mutate(year = str_extract(movie, '\\[\\d\\d\\d\\d\\]')) %>% mutate(year = str_remove_all(year, '\\[|\\]')) %>%
  mutate(mpaa_rating = str_extract(movie, '\\[[A-Z].*\\]')) %>% mutate(mpaa_rating = str_remove_all(mpaa_rating, '\\[|\\]')) %>%
  mutate(title = str_extract(movie, '.*?\\[')) %>% mutate(title = str_remove_all(title, ' \\[')) %>%
  separate(ratings, into = c('rating_sex_nudity', 'rating_violence_gore', 'rating_language')) %>%
  mutate(rating_sex_nudity = as.numeric(rating_sex_nudity)) %>%
  mutate(rating_violence_gore = as.numeric(rating_violence_gore)) %>%
  mutate(rating_language = as.numeric(rating_language)) %>%
  mutate(id = row_number()) %>%
  select(id, title, year, mpaa_rating, rating_sex_nudity, rating_violence_gore, rating_language)

# export
setwd("~/Downloads")
write_csv(movies, 'kids-in-mind-movies.csv')

# aggregate
movies %>% group_by(year) %>% count() %>% arrange(year)
movies %>% group_by(mpaa_rating) %>% count(sort = T)
movies %>% group_by(rating_sex_nudity) %>% count() %>% arrange(rating_sex_nudity)
movies %>% group_by(rating_violence_gore) %>% count() %>% arrange(rating_violence_gore)
movies %>% group_by(rating_language) %>% count() %>% arrange(rating_language)

# visualize
movies %>%
  filter(mpaa_rating %in% c('G', 'PG', 'PG-13', 'R')) %>%
  ggplot(., aes(x = rating_sex_nudity, y = rating_violence_gore, col = mpaa_rating)) + geom_jitter()

movies %>%
  filter(mpaa_rating %in% c('G', 'PG', 'PG-13', 'R')) %>%
  ggplot(., aes(x = rating_violence_gore, y = rating_language, col = mpaa_rating)) + geom_jitter()

movies %>%
  filter(mpaa_rating %in% c('G', 'PG', 'PG-13', 'R')) %>%
  ggplot(., aes(x = rating_language, y = rating_sex_nudity, col = mpaa_rating)) + geom_jitter()

# cluster
cluster = movies %>%
  filter(!is.na(rating_sex_nudity) & !is.na(rating_violence_gore) &!is.na(rating_language)) %>%
  select(rating_sex_nudity, rating_violence_gore, rating_language) %>%
  kmeans(., 4)

movies %>%
  filter(!is.na(rating_sex_nudity) & !is.na(rating_violence_gore) &!is.na(rating_language)) %>%
  mutate(cluster = cluster$cluster) %>%
  mutate(cluster = as.factor(cluster)) %>%
  ggplot(., aes(x = rating_language, y = rating_sex_nudity, col = cluster)) + geom_jitter()
