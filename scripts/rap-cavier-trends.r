# import packages
library(tidyverse)
library(aws.s3)
library(dplyr)
library(lubridate)
library(scales)

# set AWS credentials
Sys.setenv("AWS_ACCESS_KEY_ID" = "key-here",
           "AWS_SECRET_ACCESS_KEY" = "secret-key-here",
           "AWS_DEFAULT_REGION" = "us-east-1")

# define function to read .csv file from S3
read_s3_csv <- function(bucket, file) {
  object <- get_object(object = file, bucket = bucket, parse_response = FALSE, check_region = FALSE)
  read.csv(text = rawToChar(object), stringsAsFactors = FALSE)
}

# specify bucket name and directory
bucket_name <- "egw-data-dumps"
subdirectory <- "spotify-playlist-history/"

# get list of all objects inspecified directory
all_objects <- get_bucket(bucket_name, prefix=subdirectory)
csv_objects <- Filter(function(x) grepl(".csv$", x$Key), all_objects)
files <- sapply(csv_objects, function(x) x$Key)

# read and combine allfiles
combined_data <- lapply(files, function(file) read_s3_csv(bucket_name, file)) %>% bind_rows()
raw = tibble(combined_data)

# save a copy
setwd("~/Downloads")
write_csv(raw, paste('spotify-rap-cavier-raw-', Sys.Date(), '.csv', sep = ''))

# clean, deduplicate
rap_cavier = raw %>%
  filter(playlist_id == '37i9dQZF1DX0XUsuxWHRQd') %>%
  mutate(pk = paste(track_playlist_position, '-', artist_track_position, sep = '')) %>%
  mutate(current_datetime = ymd_hms(current_datetime)) %>%
  mutate(date = date(current_datetime)) %>% 
  mutate(track_added_at = date(track_added_at)) %>%
  mutate(track_release_date = date(ymd(track_release_date))) %>%
  group_by(date, pk) %>%
  arrange(current_datetime) %>%
  mutate(row_number = row_number()) %>% ungroup() %>%
  filter(row_number == 1) %>%
  select(-current_datetime, -pk, -row_number) %>%
  filter(date >= '2023-01-01' & date <= '2024-01-01') %>%
  mutate(track_name_clean = str_replace(track_name, " \\s*\\([^\\)]+\\)", ""))
glimpse(rap_cavier)

# save a copy
setwd("~/Downloads")
write_csv(raw, paste('spotify-rap-cavier-', Sys.Date(), '.csv', sep = ''))

# visual spot check
rap_cavier %>%
  filter(date >= '2023-01-01' & date <= '2024-01-01') %>%
  group_by(date) %>% summarise(distinct_tracks = n_distinct(track_id)) %>%
  ggplot(., aes(x = date, y = distinct_tracks)) + geom_line()

rap_cavier %>% distinct(artist_id) %>% nrow() # 303 distinct artists
rap_cavier %>% distinct(track_id) %>% nrow() # 590 distinct tracks
rap_cavier %>% filter(date >= '2023-01-01' & date <= '2024-01-01') %>% distinct(date) %>% nrow() # 351 days

# influence: how many days represented?
total_days= rap_cavier %>% distinct(date) %>% nrow()
rap_cavier %>%
  group_by(artist_name) %>% 
  summarise(distinct_days = n_distinct(date)) %>% ungroup() %>%
  mutate(percent_represented = distinct_days / total_days) %>%
  arrange(desc(percent_represented)) %>% View()

# chart 1
chart_1 = rap_cavier %>%
  filter(artist_name %in% c('Drake', 'Future', 'Gucci Mane', 'Travis Scott')) %>%
  ggplot(., aes(x = date, y = track_playlist_position, col = track_name_clean)) + 
  labs(x = '', y = 'Track Playlist Position', 
       title = 'Track Positions, Rappers with 100% Coverage', 
       subtitle = "Spotify's RapCavier Playlist | January 1 to December 27, 2023",
       caption = 'Unboxed Analytics | @erikgregorywebb') +
  geom_point() + 
  geom_line() +
  scale_y_reverse() +
  scale_x_date(date_labels = "%b") +
  facet_wrap(~artist_name, nrow = 2, ncol = 2) +
  theme(legend.position="none") +
  theme(text = element_text(size=14))

# save chart 1
setwd("~/Downloads")
png('rap_cavier_chart_1.png', width = 10, height = 6, units = 'in', res = 600)
chart_1
dev.off()

# chart 2
chart_2 = rap_cavier %>%
  #filter(artist_name %in% c('Drake', 'Future', 'Gucci Mane', 'Travis Scott')) %>%
  filter(artist_name %in% c('Gucci Mane')) %>%
  ggplot(., aes(x = date, y = track_playlist_position, col = track_name_clean)) + 
  labs(x = '', y = 'Track Playlist Position', 
       title = 'Track Positions, Gucci Mane', subtitle = "Spotify's RapCavier Playlist | January 1 to December 27, 2023",
       caption = 'Unboxed Analytics | @erikgregorywebb') +
  geom_point() + 
  geom_line() +
  scale_y_reverse() +
  scale_x_date(date_labels = "%b") +
  theme(legend.title=element_blank()) +
  #facet_wrap(~artist_name, nrow = 2, ncol = 2) +
  theme(text = element_text(size=14))
chart_2

# save chart 2
setwd("~/Downloads")
png('rap_cavier_chart_2.png', width = 10, height = 6, units = 'in', res = 600)
chart_2
dev.off()

# chart 3
chart_3 = rap_cavier %>%
  group_by(artist_name) %>% 
  summarise(distinct_days = n_distinct(date)) %>% ungroup() %>%
  mutate(percent_represented = distinct_days / total_days) %>%
  arrange(desc(percent_represented)) %>%
  mutate(row_number = row_number()) %>%
  ggplot(., aes(x = row_number, y = percent_represented)) + 
  geom_line() +
  labs(x = 'Artist Rank', y = '% of days represented on RapCavier',
       title = 'Distribution of "Influence" Score',
       subtitle = "Spotify's RapCavier Playlist | January 1 to December 27, 2023") +
  scale_y_continuous(labels = percent) +
  scale_x_continuous(breaks=seq(0, 250, 25)) +
  theme(legend.title=element_blank()) +
  theme(text = element_text(size=14))

# save chart 3
setwd("~/Downloads")
png('rap_cavier_chart_3.png', width = 10, height = 6, units = 'in', res = 600)
chart_3
dev.off()

# density
rap_cavier %>%
  group_by(artist_name, date) %>% 
  summarise(total_tracks = n_distinct(track_id)) %>% ungroup() %>%
  arrange(desc(total_tracks)) %>% View()

# chart 4
chart_4 = rap_cavier %>%
  group_by(artist_name, date) %>% 
  summarise(total_tracks = n_distinct(track_id)) %>% ungroup() %>%
  arrange(total_tracks) %>%
  filter(total_tracks >= 5) %>%
  mutate(total_tracks = as.factor(total_tracks)) %>%
  #ggplot(., aes(x = date, y = artist_name, col = total_tracks)) +
  ggplot(., aes(x = date, y = factor(artist_name, levels = rev(c("21 Savage", "Drake", "Future", "Lil Wayne", "Travis Scott", "Young Thug", "Lil Baby"))), col = total_tracks)) +
  geom_jitter(height = .1) +
  scale_x_date(date_labels = "%b") +
  labs(x = '', y = '',
       title = 'High Density Periods, 5+ Tracks',
       subtitle = "Spotify's RapCavier Playlist | January 1 to December 27, 2023",
       caption = 'Unboxed Analytics | @erikgregorywebb', color = 'Tracks') +
  theme(legend.title=element_blank()) +
  theme(text = element_text(size=14))

# save chart 4
png('rap_cavier_chart_4.png', width = 10, height = 6, units = 'in', res = 600)
chart_4
dev.off()

# get tracks
rap_cavier %>%
  filter(artist_name == '21 Savage' & date == '2023-06-23') %>%
  select(track_name)
rap_cavier %>%
  filter(artist_name == 'Drake' & date == '2023-10-07') %>%
  select(track_name)

# longevity
rap_cavier %>%
  group_by(track_name) %>% 
  summarise(distinct_days = n_distinct(date),
            first_at = min(date), last_at = max(date)) %>% ungroup() %>%
  arrange(desc(distinct_days))

# chart 5
chart_5 = rap_cavier %>%
  filter(track_name == 'fukumean') %>% 
  ggplot(., aes(x = date, y = track_playlist_position)) + 
  geom_point() + geom_line() +
  scale_y_reverse() + 
  scale_x_date(date_labels = "%b") +
  labs(x = '', y = 'Track Playlist Position', 
       title = 'f*kumean (Gunna) Playlist Position',
       subtitle = "Spotify's RapCavier | 2023",
       caption = 'Unboxed Analytics | @erikgregorywebb', color = 'Tracks') +
  theme(legend.title=element_blank()) +
  theme(text = element_text(size=14))

# save chart 5
png('rap_cavier_chart_5.png', width = 10, height = 6, units = 'in', res = 600)
chart_5
dev.off()

# chart 6
chart_6 = rap_cavier %>%
  filter(track_name_clean %in% c('fukumean', 'Turn Yo Clic Up', 'Search & Rescue', '500lbs', 'I KNOW ?', 'Paint The Town Red', 'MELTDOWN', 'Private Landing', 'Superhero [with Future & Chris Brown]', 'All My Life')) %>% 
  mutate(track_name_clean = ifelse(track_name_clean == 'Superhero [with Future & Chris Brown]', 'Superhero', track_name_clean)) %>%
  ggplot(., aes(x = date, y = track_playlist_position, col = track_name_clean)) + 
  geom_point() + geom_line() +
  scale_y_reverse() + 
  scale_x_date(date_labels = "%b") +
  labs(x = '', y = 'Track Playlist Position',
       title = 'Longevity: Top 10 Tracks',
       subtitle = "Spotify's RapCavier Playlist | January 1 to December 27, 2023",
       caption = 'Unboxed Analytics | @erikgregorywebb', color = 'Tracks') +
  facet_wrap(~track_name_clean, nrow = 2, ncol = 5) +
  theme(legend.position="none") +
  theme(legend.title=element_blank()) +
  theme(text = element_text(size=14))

# save chart 6
png('rap_cavier_chart_6.png', width = 10, height = 6, units = 'in', res = 600)
chart_6
dev.off()

# top longevity
rap_cavier %>%
  group_by(track_name) %>% 
  summarise(distinct_days = n_distinct(date),
            first_at = min(date), last_at = max(date)) %>% ungroup() %>%
  left_join(x = ., y = rap_cavier %>% filter(artist_track_position == 1) %>% distinct(track_name, artist_name)) %>%
  filter(last_at <= '2023-12-26') %>%
  group_by(artist_name) %>%
  summarise(median_longevity = median(distinct_days), 
            avg_longevity = mean(distinct_days),
            distinct_tracks = n_distinct(track_name)) %>%
  ungroup() %>% 
  filter(distinct_tracks > 2) %>%
  arrange(desc(avg_longevity))
