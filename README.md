# Datasets

This repo contains datasets I've created or collected, mostly via web scraping.

### Categories
- [:movie_camera: Entertainment](#Entertainment)
- [:car: Auto](#Auto)
- [:house: Real Estate](#Real-Estate)
- [💰 Finance](#Finance)
- [:church: Religion](#Religion)
- [🗒️ Miscellaneous](#Miscellaneous)

## :movie_camera: Entertainment

### Marvel Cinematic Universe Films

While re-watching parts of the MCU series during paternity leave, I compiled a dataset measuring things like budget, box office sales, and Rotten Tomatoes rating for the 23 movies. Using this data, I created an interactive visual in Tableau allowing comparison of measures across the films in different orders, like release date and chronological order.

> - [Download Data](https://github.com/erikgregorywebb/data/blob/main/data/mcu-movies.csv)
> - [View Analysis](https://unboxed-analytics.com/data-technology/exploring-the-marvel-cinematic-universe-in-tableau/)

### Billboard Hot 100 Artists
Contains a list of [Billboard Hot 100 Artists](https://www.billboard.com/charts/year-end/2019/hot-100-artists) from 2005 to 2019, scraped from [billboard.com](billboard.com/) on July 19, 2020. There are three columns: year, rank, and artist. 

> - [Download Data](https://github.com/erikgregorywebb/data/blob/main/data/billboard-hot-100-artists-2005to2019.csv)
> - [View Script](https://github.com/erikgregorywebb/data/blob/main/scripts/billboard-scraper.R)
> - [View Analysis](https://unboxed-analytics.com/data-technology/the-rise-of-rap-a-genre-popularity-analysis/)

### Pitchfork Rap Reviews

List of URLs to reviews for rap albums written by Pitchfork. 2,256 reviews when script was run on June 23, 2020.

> - [Download Data](https://github.com/erikgregorywebb/data/blob/main/data/pitchfork-rap-reviews-2020-06-23.csv)
> - [View Script](https://github.com/erikgregorywebb/data/blob/main/scripts/pitchfork-reviews.R)

### Spotify Charts

[Spotify Charts](https://spotifycharts.com) exposes the current top 200 tracks, as well as date drop-down to view historical chart data. Since Spotify Charts has built-in CSV download functionality, a simple R script helped compile and aggregate the daily chart data, which stretches back to early 2017.

> - [Download Data](https://github.com/erikgregorywebb/data/blob/main/data/spotify-charts-daily-2020-10-07.csv)
> - [View Script](https://github.com/erikgregorywebb/data/blob/main/scripts/spotify-charts-scraper.R)

### Kids-In-Mind Movie Ratings

As stated on thier [website](https://kids-in-mind.com/about.htm), the purpose of kids-in-mind.com is "to provide parents and other adults with objective and complete information about a film’s content so that they can decide, based on their own value system, whether they should watch a movie with or without their kids, or at all." This dataset contains data for 5,525 movies, including `title`, `year`, `mpaa_rating`, and ratings assigned by the editors. It was scraped on March 5, 2022.

> - [Download Data](https://github.com/erikgregorywebb/data/blob/main/data/kids-in-mind-movies.csv)
> - [View Script](https://github.com/erikgregorywebb/data/blob/main/scripts/kids-in-mind-movies-scraper.R)

### Personal Last.fm "Scrobble" History

[Last.fm](https://last.fm/) is one of the best ways to track the music you listen to. Last.fm connects to music [streaming services](https://www.last.fm/about/trackmymusic) and tracks listening behavior via ["scrobbling"](https://www.businessinsider.com/guides/tech/what-is-last-fm-scrobbling). Using Ben Foxall's convenient `lastfm-to-csv` [service](https://benjaminbenben.com/lastfm-to-csv/), I exported the list of 52,036 tracks I've listened to on Spotify between April 2017 and January 2023. Looking to visual personal genre trends over time, this was enriched (adding a `artist_primary_genre` field) using the [Spotify API](https://developer.spotify.com/console/get-search-item/) and `spotifyr` [package](https://www.rcharlie.com/spotifyr/).

> - [Download Data (Original)](https://github.com/erikgregorywebb/data/blob/main/data/last-fm-history-2023-01-22.csv)

### Spotify's Rap Caviery History

With over 15 million listeners, Spotify’s [RapCaviar](https://open.spotify.com/playlist/37i9dQZF1DX0XUsuxWHRQd) has been called “the most influential playlist in music.” RapCaiver is curated by Spotify’s editorial team and updated daily to represent the latest and greatest hip-hop and rap tracks. For the last year, I’ve saved a daily snapshot of the playlist using the Spotify API to empirically determine the biggest rappers in hip hop today.

> - [Download Data](https://github.com/erikgregorywebb/data/blob/main/data/spotify-rap-cavier-2023-12-27.csv)
> - [View Script](https://github.com/erikgregorywebb/data/blob/main/scripts/rap-cavier-trends.r)
> - [View Analysis](https://unboxed-analytics.com/data-technology/hip-hop-heavyweights/)

## :car: Auto

### CarGurus Used Minivan Prices

As one of the most visited car shopping sites in the United States, CarGurus tracks prices for millions of used car listings every year. Looking to get acquainted with prices in the used minivan market, I scraped 20 years’ worth of monthly average price data from CarGurus for five minivan models: Kia Sedona, Toyota Sienna, Chrysler Pacifica, Honda Odyssey, and Dodge Grand Caravan. 

> - [Download Data](https://github.com/erikgregorywebb/data/blob/main/data/cargurus-minivans.csv)
> - [View Script](https://github.com/erikgregorywebb/data/blob/main/scripts/cargurus-scraper.R)
> - [View Analysis](https://unboxed-analytics.com/data-technology/minivan-wars-visualizing-prices-in-the-used-car-market/)

## 💰 Finance

### Freddie Mac Mortgage Rates

> - [Download Data](https://github.com/erikgregorywebb/github-actions-demo/tree/main/data)
> - [View Script](https://github.com/erikgregorywebb/github-actions-demo/blob/main/freddiemac.py)
> - [View Analysis](https://unboxed-analytics.com/data-technology/github-actions-for-data-analysts/)

### CB Insights Unicorn Companies

> - [Download Data](https://github.com/erikgregorywebb/data/blob/main/data/cb-unicorns-2022-06-06.csv)
> - [View Script](https://github.com/erikgregorywebb/data/blob/main/scripts/cb-unicorns.R)

### Apple App Store Finance App Rankings
> - [Download Data](https://github.com/erikgregorywebb/data/blob/main/data/app-store-finance-rankings-2023-11-10.csv)
> - [View Script](https://github.com/erikgregorywebb/data/blob/main/scripts/apple-app-store-rankings.r)

## :house: Real Estate

### Scarsdale Property Assessments
In 2018 my wife and I moved to New York for the start of a new job. Initially overwhelmed by the scope and pace of the NYC housing market, we were given the very generous and unexpected opportunity by a family friend to live in a house north of the city in Westchester County. Built in the early 1930s, the historic home is situated in central Scarsdale, an affluent suburban town known for high-achieving schools and extravagant real estate. Wishing to analyze the houses of Scarsdale in a more systematic way, I contacted the Scarsdale Village administration and was sent an Excel file with the complete set of residential properties, rich with detail and with few missing values.

> - [Download Data](https://github.com/erikgregorywebb/data/blob/main/data/scarsdale-property-assessment-2019.csv)
> - [View Analysis](https://unboxed-analytics.com/data-technology/mapping-scarsdale-real-estate-data-with-python/)

## :church: Religion

### General Conference Speeches

My friend @bryanwhiting published an [R package](https://github.com/bryanwhiting/generalconference) that compiles ~50 years worth of speeches from sessions of [General Conference](https://www.churchofjesuschrist.org/study/general-conference?lang=eng) from the Church of Jesus Christ of Latter-Day Saints.

> - [Download Data](https://drive.google.com/file/d/1BSisfqMb1HWyDxm6eYosWiv7s_KT2BYi/view?usp=sharing)
> - [View Script](https://github.com/erikgregorywebb/data/blob/main/scripts/general-conference.R)

## 🗒️ Miscellaneous

### NY Post Office Locations

As of November 11, 2023 when scraped.

> - [Download Data](https://github.com/erikgregorywebb/data/blob/main/data/ny-post-office-locations.csv)
> - [View Script](https://github.com/erikgregorywebb/data/blob/main/scripts/usps-locations-scrape.r)
