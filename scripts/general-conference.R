library(tidyverse)
library(rvest)

# get list of .rds files
base_url = 'https://github.com/bryanwhiting/generalconference/tree/main/data/sessions'
page = read_html(base_url)
all_files = page %>% html_nodes('a') %>% html_attr('href')
rds_files_names = basename(all_files[str_detect(all_files, '.rds')])
rds_files = sprintf('https://github.com/bryanwhiting/generalconference/blob/main/data/sessions/%s?raw=true', rds_files_names)

# loop: downloading importing, unnesting, and joining
datalist = list()
for (i in 1:length(rds_files)) {
  Sys.sleep(3)
  print(basename(rds_files[i]))
  download.file(rds_files[i], basename(rds_files[i]))
  raw = readRDS(basename(rds_files[i]))
  temp = raw %>%
    tidyr::unnest(sessions) %>%
    tidyr::unnest(talks) %>%
    tidyr::unnest(paragraphs)
  datalist[[i]] = temp
}
raw = do.call(rbind, datalist)

# clean
glimpse(raw)
gf = raw %>% rename(title = title1)

# export
setwd("~/Downloads")
write_csv(gf, 'general-conference-speeches-april-71-to-april-2021.csv')
