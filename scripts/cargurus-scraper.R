  # data source: https://www.cargurus.com/Cars/price-trends/

  library(tidyverse)
  library(dplyr)
  library(httr)
  library(jsonlite)
  library(broom)
  library(lubridate)
  library(scales)

  # disble scientific notation (add it back with options(scipen=0))
  options(scipen=999)

  # define headers
  headers = c(
    `User-Agent` = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:88.0) Gecko/20100101 Firefox/88.0',
    `Accept` = 'application/json, text/javascript, */*; q=0.01',
    `Accept-Language` = 'en-US,en;q=0.5',
    `Referer` = 'https://www.cargurus.com/Cars/price-trends/Honda-Odyssey-d592',
    `X-Requested-With` = 'XMLHttpRequest',
    `DNT` = '1',
    `Connection` = 'keep-alive',
    `TE` = 'Trailers'
  )

  # define function to extract data from api
  getPriceData = function(entityid) {
    # import
    params = list(`entityIds` = entityid, `startDate` = '12/8/2010', `endDate` = '6/5/2021')
    res = httr::GET(url = 'https://www.cargurus.com/Cars/price-trends/priceIndexJson.action', httr::add_headers(.headers=headers), query = params)

    # extract
    content = fromJSON(rawToChar(res$content))
    raw = tidy(content$data[[1]])

    # clean
    table = raw %>%
      mutate(unix = substr(as.character(X1), 1, 10)) %>%
      mutate(datetime = as_datetime(as.integer(unix))) %>%
      mutate(entityid = entityid) %>%
      select(entityid, datetime, price = X2, entityid = entityid)

    return(table)
  }

  # demo
  getPriceData('c31187')

  # import list of cargurus.com entities (local file)
  setwd("~/Downloads")
  cargurus = read_csv('cargurus-entityids.csv')
  entityids = cargurus %>% pull(id)

  # loop over all car make/model/year combinations
  datalist = list()
  for (i in 1:length(entityids)) {
    Sys.sleep(2)
    print(entityids[i])
    datalist[[i]] = getPriceData(entityids[i])
  }
  raw = do.call(rbind, datalist)

  # join
  minivans = left_join(x = raw, y = cargurus, by = c('entityid' = 'id')) %>% 
    select(make, model, year, entityid, datetime, price)

  # plot 1
  plot1 = minivans %>%
    filter(year %in% 2015:2019) %>%
    mutate(year = factor(year, levels = 2015:2019)) %>%
    mutate(name = paste(make, model, sep = ' ')) %>%
    ggplot(., aes(x = datetime, y = price, col = year)) +
    geom_point(size = 1.5) + geom_line(size = .2) +  
    #geom_smooth(method = "lm", colour = "orange", se = FALSE) + 
    facet_wrap(~name, ncol = 5) +
    theme(legend.position = 'top') +
    scale_y_continuous(labels = dollar) +
    labs(col = '', x = '', y = '', title = 'Minivan Wars', 
         subtitle = 'Average Price by Make-Model | 2015-2019',
         caption = 'Data Source: cargurus.com | Vis: @erikgregorywebb') + 
    theme(text = element_text(size = 13)) +
    theme(plot.title=element_text(face='bold'))

  # export as png
  png('minivan-wars-1.png', width = 9, height = 6, units = 'in', res = 400)
  plot1
  dev.off()

  # export file
  write_csv(minivans, 'cargurus-minivans.csv')
