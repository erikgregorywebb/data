library(aws.s3)
library(tidyverse)
library(lubridate)

# set AWS credentials
Sys.setenv("AWS_ACCESS_KEY_ID" = "key_here",
           "AWS_SECRET_ACCESS_KEY" = "secret_key_here",
           "AWS_DEFAULT_REGION" = "us-east-1") # e.g., us-west-2

# define function to read a CSV file from S3
read_s3_csv <- function(bucket, file) {
  object <- get_object(object = file, bucket = bucket, parse_response = FALSE, check_region = FALSE)
  read.csv(text = rawToChar(object), stringsAsFactors = FALSE)
}

# specify your bucket name and directory
bucket_name <- "egw-data-dumps"
directory_name <- "apple-app-store/" # Ensure this ends with a slash

# get list of all objects in the specified directory
csv_objects <- Filter(function(x) grepl(".csv$", x$Key), all_objects)
files <- sapply(csv_objects, function(x) x$Key)

# read and combine all CSV files
combined_data <- lapply(files, function(file) read_s3_csv(bucket_name, file)) %>% bind_rows()
raw = tibble(combined_data)

# save a copy
setwd("~/Downloads/")
write_csv(raw, paste('apple-app-store-export-raw-', Sys.Date(), '.csv', sep = ''))
write_csv(head(raw, 10), paste('apple-app-store-export-raw-sample-', Sys.Date(), '.csv', sep = ''))

# clean
rh = raw %>%
  mutate(
    rank = str_extract(label, "^Number \\d+"),
    app_name = str_match(label, "\\. (.+?)\\.")[, 2],
    company_name = str_match(label, "\\. ([^\\.]+)\\.$")[, 2],
    rank = gsub("Number ", "", rank),
    app_id = sub(".*/([^/]+)/?$", "\\1", link)) %>% 
  mutate(scraped_at = ymd_hms(scraped_at)) %>%
  select(rank, app_id, app_name, company_name, link, raw_label = label, scraped_at) %>%
  mutate(scraped_date = date(scraped_at)) %>%
  group_by(rank, scraped_date) %>% mutate(row_number = row_number()) %>% ungroup() %>%
  filter(row_number == 1)

# export the list of apps to explore categorization options
rh %>% group_by(app_name) %>% count(sort = T) %>% select(app_name) %>% write_csv(., 'apps.csv')

# export
write_csv(rh, paste('app-store-finance-rankings-', Sys.Date(), '.csv', sep = ''))
