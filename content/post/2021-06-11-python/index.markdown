---
title: Python
author: James P. Hare
date: '2021-06-11'
slug: []
categories: []
tags: []
description: ''
topics: []
---

I've started learning Python, so I decided to apply some of my newly developing skills to this [Tidy Tuesday](https://github.com/rfordatascience/tidytuesday/blob/master/data/2021/2021-05-18/readme.md) from a few weeks ago. The data come from the Ask a Manager Survey, which includes earnings information from more than 24,000 self-selecting survey respondents.

The respondents are non-random and skew heavily toward white women in professional jobs in the United States.

While exploring the data, I found, unsurprisingly, that formal education and years of experience in a field seem to have a profound effect on compensation. I decided to visualize these relationships in a heat map.

<img src="images/ask_a_manager.svg" alt="Heat map showing that total compensation tends to increase with more education and more years of experience in a field" width="100%"/>

Source code, in Python this time, available on [GitHub](https://github.com/jamesphare/website/blob/master/content/post/2021-06-11-python/2021_05_18_ask_a_manager.ipynb).
