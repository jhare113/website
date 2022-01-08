---
title: Alberrative parturine of eggliness
author: James P. Hare
date: '2022-01-08'
slug: []
categories: []
tags: []
description: ''
topics: []
---

So I've been learning about neural networks and how to use TensorFlow. I wanted to get in on the trend of using recurrent neural networks to generate predictive texts (inspired by Jacqueline Nolis' [banned license plate generator](https://jnolis.com/blog/banned_license_plates/)), so I trained one to create text in the style of James Joyce's *Ulysses*. Here's a sample. I think it's a pretty good approximation of the original.

> Stephen, he had murdered to.

> Alberrative parturine of eggliness had been knelt again with uncleaning pacts. She poured before slop, slips for words. Softly. Somewhere. He tops so go suddenly *voglio*. Damn your strength was more since Lord the day before neither for he was blue fellow, not ready to set him to pink year and saw it with means which he halted arphen sad Bloom whose requirements and personal congresslies that he was always for a work of fear not to hurt you see and saw at the king's name was a country bad got off she went bling to how him? He'll be all right she could wrinkled with her cashancy with creamine bundle burying, passed out.

> ---Good Kinch and Joke's head is, Mr Best said.

> The bowl mether in *Abbes*'s and Varelagend Bloom with his hat. Had he then he put the good in her necklike care and walking over it will half know by the wailing soupens or something to come back with drawn quiet thing like that.

It's not exactly coherent, but is it less coherent than the original?

Here's [my code](https://github.com/jamesphare/website/blob/master/content/post/2022-01-08-ulysses-neural-net/Ulysses.ipynb), which follows [this tutorial](https://www.tensorflow.org/text/tutorials/text_generation) very closely.
