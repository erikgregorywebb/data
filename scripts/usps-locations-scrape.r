library(tidyverse)
library(rvest)
library(janitor)

# scrape list of ny state zip codes
url = 'https://www.zip-codes.com/state/ny.asp'
page = read_html(url)
raw_zips = page %>% html_table() %>% nth(. ,3)

# tidy zip code list
zips_clean = raw_zips %>% 
  janitor::row_to_names(., 1) %>%
  rename(zipcode = `ZIP Code`, city = City, county = County, type = Type) %>%
  mutate(zipcode = gsub("\\D", "", zipcode)) %>%
  filter(type == 'Standard')
ny_zips = zips_clean %>% pull(zipcode)

# define headers to scrape usps.com
headers = c(
  `authority` = "tools.usps.com",
  `accept` = "application/json, text/javascript, */*; q=0.01",
  `accept-language` = "en-US,en;q=0.9",
  `content-type` = "application/json;charset=UTF-8",
  `dnt` = "1",
  `origin` = "https://tools.usps.com",
  `referer` = "https://tools.usps.com/find-location.htm",
  `sec-ch-ua` = '"Google Chrome";v="119", "Chromium";v="119", "Not?A_Brand";v="24"',
  `sec-ch-ua-mobile` = "?0",
  `sec-ch-ua-platform` = '"macOS"',
  `sec-fetch-dest` = "empty",
  `sec-fetch-mode` = "cors",
  `sec-fetch-site` = "same-origin",
  `user-agent` = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36",
  `x-requested-with` = "XMLHttpRequest"
)

# define scraping function
get_usps_locations = function(zipcode) {
  data = sprintf('{"maxDistance":"100","lbro":"","requestType":"PO","requestServices":"","requestRefineTypes":"","requestRefineHours":"","requestZipCode":"%s","requestZipPlusFour":""}', zipcode)
  tryCatch({
    r =  httr::POST(url = "https://tools.usps.com/UspsToolsRestServices/rest/POLocator/findLocations", httr::add_headers(.headers=headers), httr::set_cookies(.cookies = cookies), body = data)
    content = rawToChar(r$content) %>% fromJSON()
    df = tibble(content$locations)
    print(paste('Locations scraped for ', zipcode, sep = ''))
    return(df)
  }, error = function(e) {
    cat("Error occurred: ", e$message, "\n")
    print('zipcode')
  })
}

# loop over all ny zip codes, write each to .csv
setwd("~/Downloads/usps-locations")
for (i in 1:length(ny_zips)) {
  Sys.sleep(3)
  print(paste('Attempting scrape for ', ny_zips[i], sep = ''))
  temp = get_usps_locations(ny_zips[i]) %>% select(location_id = locationID, location_name = locationName, location_tupe = locationType, 
                  radius, address = address1, city, state, zip_5 = zip5, zip_4 = zip4, latitude, longitude, phone, parking) %>%
    mutate(scrape_zip = ny_zips[i])
  write_csv(temp, paste('usps-locations-', ny_zips[i], '.csv', sep = ''))
}

# if the scrape fails, figure out what's next in line
setwd("~/Downloads/usps-locations")
scraped_files = list.files()
scraped_zips = gsub("\\D", "", scraped_files)
up_next = ny_zips[!(ny_zips %in% scraped_zips)]

setwd("~/Downloads/usps-locations")
for (i in 1:length(up_next)) {
  Sys.sleep(5)
  print(paste('Attempting scrape for ', up_next[i], sep = ''))
  temp = get_usps_locations(up_next[i]) %>% select(location_id = locationID, location_name = locationName, location_tupe = locationType, 
                                                   radius, address = address1, city, state, zip_5 = zip5, zip_4 = zip4, latitude, longitude, phone, parking) %>%
    mutate(scrape_zip = up_next[i])
  write_csv(temp, paste('usps-locations-', up_next[i], '.csv', sep = ''))
}

# combine files to create one location dataset  
datalist = list()
for (i in 1:length(scraped_files)) {
  print(scraped_files[i])
  datalist[[i]] = read_csv(scraped_files[i]) %>% select(-scrape_zip)
}
raw = do.call(rbind, datalist)

# de-duplicate
print(paste('Original: ',  nrow(raw), ' Distinct: ', nrow(distinct(raw)), sep = ''))
ny_locations = distinct(raw)

# save a copy
setwd("~/Downloads")
write_csv(ny_locations, 'ny-post-office-locations.csv')
