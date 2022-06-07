# source: https://www.cbinsights.com/research-unicorn-companies

library(tidyverse)
library(rvest)

# import
url = 'https://www.cbinsights.com/research-unicorn-companies'
page = read_html(url)
table = page %>% html_table() %>% first()

# clean
unicorns = table %>% 
  mutate(company_id = row_number()) %>%
  select(company_id, company = Company, valuation = `Valuation ($B)`, date_joined = `Date Joined`,
         country = Country, city = City, industry = Industry, select_investors = `Select Investors` )

vcs = unicorns %>%
  select(company_id, company, select_investors) %>%
  mutate(select_investors = strsplit(select_investors, ",")) %>% 
  unnest(select_investors) %>%
  mutate(select_investors = trimws(select_investors))

# export
setwd("~/Downloads")
write_csv(unicorns, 'cb-unicorns-2022-06-06.csv')
write_csv(vcs, 'cb-unicorn-vcs-2022-06-06.csv')
