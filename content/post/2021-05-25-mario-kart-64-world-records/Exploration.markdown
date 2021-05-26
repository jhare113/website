---
title: Mario Kart 64 Exploration and Code
author: James P. Hare
date: "5/26/2021"
---


```r
library(tidyverse)
```

```
## ── Attaching packages ─────────────────────────────────────── tidyverse 1.3.1 ──
```

```
## ✓ ggplot2 3.3.3     ✓ purrr   0.3.4
## ✓ tibble  3.1.2     ✓ dplyr   1.0.6
## ✓ tidyr   1.1.3     ✓ stringr 1.4.0
## ✓ readr   1.4.0     ✓ forcats 0.5.1
```

```
## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
## x dplyr::filter() masks stats::filter()
## x dplyr::lag()    masks stats::lag()
```

```r
library(lubridate)
```

```
## 
## Attaching package: 'lubridate'
```

```
## The following objects are masked from 'package:base':
## 
##     date, intersect, setdiff, union
```

```r
library(ggrepel)
library(extrafont)
```

```
## Registering fonts with R
```

```r
records <-
        readr::read_csv(
                'https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-05-25/records.csv',
                col_types = cols(
                        track = col_character(),
                        type = col_character(),
                        shortcut = col_character(),
                        player = col_character(),
                        system_played = col_character(),
                        date = col_date(format = "%Y-%m-%d"),
                        time_period = col_character(),
                        time = col_double(),
                        record_duration = col_double()
                )
        )
drivers <-
        readr::read_csv(
                'https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-05-25/drivers.csv',
                col_types = cols(
                        position = col_double(),
                        player = col_character(),
                        total = col_double(),
                        year = col_date(format = "%Y"),
                        records = col_double(),
                        nation = col_character()
                )
        )
```


```r
records <- records %>% 
        mutate(shortcut = case_when(shortcut == "Yes" ~ "Shortcut",
                                    shortcut == "No" ~ "No shortcut"))

drivers <- drivers %>% 
        select(player, nation) %>% 
        distinct()

records <- left_join(records, drivers, by = "player")

remove(drivers)
```


```r
#What is the longest standing world record?

longest_standing <- records %>% 
        group_by(track, type, shortcut) %>% 
        filter(time == min(time)) %>% #choose only current records
        arrange(desc(record_duration)) %>% 
        head(10) %>%
        mutate("record" = paste(player, track, type, shortcut, system_played, sep = ", "))

ggplot(longest_standing) +
        geom_col(aes(reorder(record, record_duration), record_duration)) + 
        coord_flip()
```

<img src="/post/2021-05-25-mario-kart-64-world-records/Exploration_files/figure-html/longest_standing-1.png" width="672" />

```r
remove(longest_standing)
```


```r
#Which track is the fastest
fastest_track <- records %>% 
        group_by(track, type, shortcut) %>%
        summarize(time = min(time))
```

```
## `summarise()` has grouped output by 'track', 'type'. You can override using the `.groups` argument.
```

```r
#Fastest single lap with shortcut
fastest_track %>% 
        filter(shortcut == "Shortcut",
               type == "Single Lap") %>% 
ggplot(aes(reorder(track, desc(time)), time)) +
        geom_col() +
        coord_flip()
```

<img src="/post/2021-05-25-mario-kart-64-world-records/Exploration_files/figure-html/unnamed-chunk-1-1.png" width="672" />


```r
#Fastest single lap without shortcut
fastest_track %>% 
        filter(shortcut == "No shortcut",
               type == "Single Lap") %>% 
ggplot(aes(reorder(track, desc(time)), time)) +
        geom_col() +
        coord_flip()
```

<img src="/post/2021-05-25-mario-kart-64-world-records/Exploration_files/figure-html/unnamed-chunk-2-1.png" width="672" />

```r
#Fastest race with shortcut
fastest_track %>% 
        filter(shortcut == "Shortcut",
               type == "Three Lap") %>% 
ggplot(aes(reorder(track, desc(time)), time)) +
        geom_col() +
        coord_flip()
```

<img src="/post/2021-05-25-mario-kart-64-world-records/Exploration_files/figure-html/unnamed-chunk-3-1.png" width="672" />


```r
#Fastest race without shortcut
fastest_track %>% 
        filter(shortcut == "No shortcut",
               type == "Three Lap") %>% 
ggplot(aes(reorder(track, desc(time)), time)) +
        geom_col() +
        coord_flip()
```

<img src="/post/2021-05-25-mario-kart-64-world-records/Exploration_files/figure-html/unnamed-chunk-4-1.png" width="672" />

```r
remove(fastest_track)
```


```r
#How did the world records develop over time?

#Full race
records %>% 
        filter(type == "Three Lap") %>% 
ggplot(aes(date, time, color = shortcut)) +
        geom_line() +
        facet_wrap(vars(track), scales = "free_y")
```

<img src="/post/2021-05-25-mario-kart-64-world-records/Exploration_files/figure-html/unnamed-chunk-5-1.png" width="672" />


```r
#Single Lap
records %>% 
        filter(type == "Single Lap") %>% 
ggplot(aes(date, time, color = shortcut)) +
        geom_line() +
        facet_wrap(vars(track), scales = "free_y")
```

<img src="/post/2021-05-25-mario-kart-64-world-records/Exploration_files/figure-html/unnamed-chunk-6-1.png" width="672" />

So far, I find the development of full-race world records over time to be the most interesting plot. Let's take some time to improve this plot.


```r
#choose tracks with interesting shortcuts
interesting_shortcuts <- records %>%
        filter(
                type == "Three Lap",
                shortcut == "Shortcut",
                track == "Rainbow Road" |
                        track == "Toad's Turnpike" |
                        track == "Wario Stadium" |
                        track == "Yoshi Valley"
        )

#create text labels
labels <- interesting_shortcuts %>%
        group_by(track) %>%
        mutate("improvement" = time - lag(time)) %>%
        slice_min(improvement)

plot_label <- paste(
        sep = "",
        "Track: ",
        labels$track,
        "\n",
        "Player: ",
        labels$player,
        "\n",
        "Date: ",
        format(labels$date, "%B %d, %Y"),
        "\n",
        "Improvement: ",
        abs(labels$improvement),
        " seconds"
)


ggplot(interesting_shortcuts, aes(date, time, color = track)) +
        geom_line() +
        geom_label_repel(
                aes(label = plot_label, x = date, y = time),
                data = labels,
                seed = 12,
                size = 2,
                min.segment.length = 0,
                show.legend = FALSE,
                force_pull = 0,
                max.overlaps = 4,
                family = "Press Start 2P"
        ) +
        scale_y_continuous() +
        labs(
                title = "On Some Tracks New Shortcuts Yield Massive Improvements",
                subtitle = "Mario Kart 64 full-race world records over time",
                y = "Time in Seconds",
                x = "Date",
                caption = "jamesphare.org\nSources: Benedikt Claus, Mario Kart World Records",
                color = ""
        ) +
        theme_minimal() +
        theme(legend.position = "none",
              text = element_text(family = "Press Start 2P",
                                  size = 7))
```

<img src="/post/2021-05-25-mario-kart-64-world-records/Exploration_files/figure-html/unnamed-chunk-7-1.png" width="672" />
