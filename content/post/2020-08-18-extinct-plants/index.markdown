---
title: Extinct Plants
author: James P. Hare
date: '2020-08-18'
slug: extinct-plants
categories: []
tags: []
---





For this week's [Tidy Tuesday](https://github.com/rfordatascience/tidytuesday/blob/70f22df34ec00013b0b27bea143e871426638521/data/2020/2020-08-18/readme.md), I'm exploring data from the International Union for Conservation of Nature on extinct plants, including both species which are totally extinct and those which survive only under cultivation.

As I explored the data on these 500 species (see my [notes](https://github.com/jamesphare/tidytuesday/blob/4558c9e0535d177b7e60483d4f4cdaf23f235532/20200818/extinct_plants_notes.md)), a handful of stories leaped out at me that I thought could best be communicated through simple, bold graphics. The first is how much plant extinction has taken place in Africa and in Madagascar in particular.

<img src="{{< blogdown/postref >}}index_files/figure-html/continent-1.png" width="672" />

Then when we focus on Madagascar as the site of so much loss, it becomes clear that much of this plant extinction took place during the mid-twentieth century, between 1920 and 1960, corresponding to the final decades of French colonial rule.

<img src="{{< blogdown/postref >}}index_files/figure-html/century-1.png" width="672" />

Finally, the causes of these extinctions are mainly habitat destruction for agriculture and aquaculture along with biological resource use. Natural system modifications (which includes things like dam construction and land reclamation) also contribute to extinctions.

<img src="{{< blogdown/postref >}}index_files/figure-html/threats-1.png" width="672" />

While Madagascar's unique flora have faced and continue to face many threats, it's hard to look at these data and not see the profound damage caused by the French colonial regime's export-driven agricultural policies.

As usual, my code is available on [GitHub](https://github.com/jamesphare/website/blob/master/content/post/2020-08-18-extinct-plants/index.Rmarkdownd).
