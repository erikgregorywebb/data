# Datasets

This repo contains datasets I've created or collected, mostly via web scraping.

*Note: This is a work in progress. I'm still centralizing ~250 [gists](https://gist.github.com/erikgregorywebb).*

### Categories
- [:movie_camera: Entertainment](#Entertainment)
- [:car: Auto](#Auto)
- [:house: Real Estate](#Real-Estate)

## :movie_camera: Entertainment

### Marvel Cinematic Universe Films

While re-watching parts of the MCU series during paternity leave, I compiled a dataset measuring things like budget, box office sales, and Rotten Tomatoes rating for the 23 movies. Using this data, I created an interactive visual in Tableau allowing comparison of measures across the films in different orders, like release date and chronological order.

> - [Download Data](https://github.com/erikgregorywebb/data/blob/main/data/mcu-movies.csv)
> - [View Analysis](https://unboxed-analytics.com/data-technology/exploring-the-marvel-cinematic-universe-in-tableau/)

<br>

### Billboard Hot 100 Artists
Contains a list of [Billboard Hot 100 Artists](https://www.billboard.com/charts/year-end/2019/hot-100-artists) from 2005 to 2019, scraped from [billboard.com](billboard.com/) on July 19, 2020. There are three columns: year, rank, and artist. 

> - [Download Data](https://github.com/erikgregorywebb/data/blob/main/data/billboard-hot-100-artists-2005to2019.csv)
> - [View Script](https://github.com/erikgregorywebb/data/blob/main/scripts/billboard-scraper.R)
> - [View Analysis](https://unboxed-analytics.com/data-technology/the-rise-of-rap-a-genre-popularity-analysis/)

<br>

### Pitchfork Rap Reviews

List of URLs to reviews for rap albums written by Pitchfork. 2,256 reviews when script was run on June 23, 2020.

> - [Download Data](https://github.com/erikgregorywebb/data/blob/main/data/pitchfork-rap-reviews-2020-06-23.csv)
> - [View Script](https://github.com/erikgregorywebb/data/blob/main/scripts/pitchfork-reviews.R)

<br>

<br>

### Spotify Charts

[Spotify Charts](https://spotifycharts.com) exposes the current top 200 tracks, as well as date drop-down to view historical chart data. Since Spotify Charts has built-in CSV download functionality, a simple R script helped compile and aggregate the daily chart data, which stretches back to early 2017.

> - [Download Data](https://github.com/erikgregorywebb/data/blob/main/data/spotify-charts-daily-2020-10-07.csv)
> - [View Script](https://github.com/erikgregorywebb/data/blob/main/scripts/spotify-charts-scraper.R)

<br>

## :car: Auto

### CarGurus Used Minivan Prices

As one of the most visited car shopping sites in the United States, CarGurus tracks prices for millions of used car listings every year. Looking to get acquainted with prices in the used minivan market, I scraped 20 years’ worth of monthly average price data from CarGurus for five minivan models: Kia Sedona, Toyota Sienna, Chrysler Pacifica, Honda Odyssey, and Dodge Grand Caravan. 

> - [Download Data](https://github.com/erikgregorywebb/data/blob/main/data/cargurus-minivans.csv)
> - [View Script](https://github.com/erikgregorywebb/data/blob/main/scripts/cargurus-scraper.R)
> - [View Analysis](https://unboxed-analytics.com/data-technology/minivan-wars-visualizing-prices-in-the-used-car-market/)

<br>

## :house: Real Estate

### Scarsdale Property Assessments
In 2018 my wife and I moved to New York for the start of a new job. Initially overwhelmed by the scope and pace of the NYC housing market, we were given the very generous and unexpected opportunity by a family friend to live in a house north of the city in Westchester County. Built in the early 1930s, the historic home is situated in central Scarsdale, an affluent suburban town known for high-achieving schools and extravagant real estate. Wishing to analyze the houses of Scarsdale in a more systematic way, I contacted the Scarsdale Village administration and was sent an Excel file with the complete set of residential properties, rich with detail and with few missing values.

> - [Download Data](https://github.com/erikgregorywebb/data/blob/main/data/scarsdale-property-assessment-2019.csv)
> - [View Analysis](https://unboxed-analytics.com/data-technology/mapping-scarsdale-real-estate-data-with-python/)
