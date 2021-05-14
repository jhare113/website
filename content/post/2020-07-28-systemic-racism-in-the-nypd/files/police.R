library(tidyverse)
library(sf)

#Police precinct map from NYC Open Data https://data.cityofnewyork.us/Public-Safety/Police-Precincts/78dh-3ptz#revert
nyc_precincts <-
        read_sf(
                "~/Documents/2020/nypd_allegations/data/Police Precincts/geo_export_cfbe857e-58ec-4848-b99b-1f33fd967621.shp"
        )

#Alleged misconduct from ProPublica
allegations <-
        read_csv("~/Documents/2020/nypd_allegations/data/allegations_20200726939.csv")

#Let's limit this to substantiated allegations
allegations <- allegations %>%
        filter(board_disposition != "Unsubstantiated" &
                       board_disposition != "Exonerated")

precinct_allegations <- allegations %>%
        filter(precinct < 124 & precinct > 0) %>%
        group_by(precinct) %>%
        summarise(n = n()) %>%
        left_join(nyc_precincts)

ggplot(precinct_allegations) +
        geom_sf(aes(fill = n, geometry = geometry)) +
        labs(title = "Substantiated NYPD Misconduct by Precinct, 1985 to 2020",
             subtitle = "Miscondunct affects some neighborhoods more than others",
             caption = "Source: ProPublica") +
        theme(
                legend.position = c(0, 1),
                legend.justification = c(-.4, 1.1),
                legend.title = element_blank(),
                axis.text.x = element_blank(),
                axis.ticks.x = element_blank(),
                axis.text.y = element_blank(),
                axis.ticks.y = element_blank(),
                panel.grid.major = element_blank(),
                panel.grid.minor = element_blank(),
                panel.background = element_blank()
        ) +
        scale_fill_continuous(type = "viridis")

ggsave("content/post/2020-07-28-systemic-racism-in-the-nypd/files/plot1.png")

cops <- allegations %>%
        group_by(unique_mos_id) %>%
        summarise(ethnicity = mos_ethnicity,
                  type = "Accused Officers")

ethnicity <- allegations %>%
        group_by(complaint_id) %>%
        summarise(ethnicity = complainant_ethnicity,
                  type = "Complainants") %>%
        rbind(cops) %>%
        filter(!(is.na(ethnicity)),
               ethnicity != "Unknown",
               ethnicity != "Refused")

remove(cops)

ggplot(ethnicity) +
        geom_bar(aes(ethnicity, fill = ethnicity)) +
        facet_wrap( ~ type, scales = "free_x") +
        coord_flip() +
        labs(
                title = "Substantiated NYPD Misconduct by Ethnicity, 1985 to 2020",
                subtitle = "White police engage in most misconduct, most of their victims are Black",
                caption = "Does not include cases where ethnicity is unkown
             Source: ProPublica",
                x = NULL,
                y = NULL
        ) +
        theme(
                panel.grid.major = element_blank(),
                panel.grid.minor = element_blank(),
                panel.background = element_blank(),
                axis.ticks.y = element_blank(),
                legend.position = "none"
        ) +
        scale_fill_brewer()

ggsave("content/post/2020-07-28-systemic-racism-in-the-nypd/files/plot2.png")

allegations %>%
        filter(!(is.na(complainant_ethnicity)),
               complainant_ethnicity != "Unknown",
               complainant_ethnicity != "Refused") %>%
        ggplot() +
        geom_bar(aes(complainant_ethnicity, fill = complainant_ethnicity)) +
        facet_wrap(~ mos_ethnicity, scales = "free_x") +
        coord_flip() +
        labs(title = "Substaniated NYPD Misconduct by Ethnicity, 1985 to 2020",
             subtitle = "Grouped by Officer's Ethnicity",
             caption = "Does not include cases where ethnicity is unkown
             Source: ProPublica",
             x = NULL,
             y = NULL) +
        theme(panel.grid.major = element_blank(), 
              panel.grid.minor = element_blank(),
              panel.background = element_blank(),
              axis.ticks.y = element_blank(),
              legend.position = "none") +
        scale_fill_brewer()

ggsave("content/post/2020-07-28-systemic-racism-in-the-nypd/files/plot3.png")

allegations %>%
        filter(!(is.na(complainant_ethnicity)),
               complainant_ethnicity != "Unknown",
               complainant_ethnicity != "Refused") %>%
        mutate(mos_gender = if_else(mos_gender == "F", "Women", "Men")) %>%
        ggplot() +
        geom_bar(aes(complainant_ethnicity, fill = complainant_ethnicity)) +
        facet_wrap(~ mos_gender, scales = "free_x") +
        coord_flip() +
        labs(title = "Substantiated NYPD Misconduct by Ethnicity, 1985 to 2020",
             subtitle = "Grouped by Officer's Gender",
             caption = "Does not include cases where ethnicity is unkown
             Only binary gender recorded
             Source: ProPublica",
             x = NULL,
             y = NULL) +
        theme(panel.grid.major = element_blank(), 
              panel.grid.minor = element_blank(),
              panel.background = element_blank(),
              axis.ticks.y = element_blank(),
              legend.position = "none") +
        scale_fill_brewer()

ggsave("content/post/2020-07-28-systemic-racism-in-the-nypd/files/plot4.png")
