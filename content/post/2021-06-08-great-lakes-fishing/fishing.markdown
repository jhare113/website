---
title: "Fishing"
author: "James P. Hare"
date: "6/8/2021"
output: github_document
---


```r
knitr::opts_chunk$set(echo = TRUE)

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
library(hare)
library(ggrepel)

theme_set(theme_james())

fishing <-
        readr::read_csv(
                'https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-06-08/fishing.csv',
                col_types = cols(
                        year = col_double(),
                        lake = col_character(),
                        species = col_character(),
                        grand_total = col_double(),
                        comments = col_character(),
                        region = col_character(),
                        values = col_double()
                )
        )
stocked <-
        readr::read_csv(
                'https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-06-08/stocked.csv',
                col_types = cols(
                        .default = col_character(),
                        SID = col_double(),
                        YEAR = col_double(),
                        MONTH = col_double(),
                        DAY = col_double(),
                        LATITUDE = col_double(),
                        LONGITUDE = col_double(),
                        GRID = col_double(),
                        NO_STOCKED = col_double(),
                        YEAR_CLASS = col_double(),
                        AGEMONTH = col_double(),
                        MARK_EFF = col_character(),
                        TAG_NO = col_character(),
                        TAG_RET = col_character(),
                        LENGTH = col_double(),
                        WEIGHT = col_character(),
                        CONDITION = col_double(),
                        VALIDATION = col_double()
                )
        )
```


```r
#Let's tell the story of stocking salmon in Lake Michigan
stocked_michigan <- stocked |>
        filter(LAKE == "MI",
               SPECIES == "COS" |
                       SPECIES == "CHS" |
                       SPECIES == "ATS") |> #filter to three salmon species
        group_by(YEAR) |>
        summarise(stocked = sum(NO_STOCKED))

#Let's tell the story of alewife production in Lake Michigan
fish_production <- fishing |>
        filter(!is.na(values),
               lake == "Michigan",
               species == "Alewife") |>
        group_by(year, species) |>
        summarise(production = sum(values)) |> 
        #create text labels
        add_column(label = NA) |>
        mutate(label = case_when(year == 1988 ~ "Zebra mussels discovered",
                                 year == 1966 ~ "Salmon introduced to\ncontrol alewife population"))
```

```
## `summarise()` has grouped output by 'year'. You can override using the `.groups` argument.
```


```r
#set colors for two line charts
stocked_color <- "#1a2c42"
production_color <- "#be2f29"

#set coefficient for bringing two line charts into the same scale
coeff <- 100

ggplot() +
        geom_line(data = stocked_michigan,
                  mapping = aes(YEAR, stocked),
                  color = stocked_color) +
        geom_line(
                data = fish_production,
                mapping = aes(year, production * coeff),
                color = production_color
        ) + #data modified to fit chart scale
        geom_label_repel(data = fish_production, 
                         aes(label = label, x = year, y = production * coeff),
                         seed = 18,
                         min.segment.length = 0,
                         box.padding = 1.5,
                         arrow = arrow(length = unit(0.02, "npc"))) +
        scale_y_continuous(
                #create left axis
                labels = scales::label_comma(),
                name = "Salmon stocked",
                #create right axis
                sec.axis = sec_axis( ~ . / coeff, #scale modified to match data
                                     name = "Alewife production (thousands of pounds)",
                                     labels = scales::label_comma())
        ) +
        theme(
                axis.title.y = element_text(color = stocked_color),
                axis.title.y.right = element_text(color = production_color)
        ) +
        labs(title = "Salmon Continues to Be Stocked in Lake Michigan",
             subtitle = "Alewife production has been devestated by invasive mussels",
             caption = "jamesphare.org\nSource: Great Lakes Fishery Commission",
             x = "Year")
```

```
## Warning: Removed 57 rows containing missing values (geom_label_repel).
```

<img src="/post/2021-06-08-great-lakes-fishing/fishing_files/figure-html/visualize-1.png" width="672" />

