---
layout: post
title: Your own private stable diffusion on your PC
tags: [macos, llm, terminal, stablediffusion]
---

You want to try own image generator with stable diffusion? I recently took few minutes and tried
`stable-diffusion-xl`. The interface is nice but generation even small images takes on my M1 some time.

1. Download LLMs

    - <https://huggingface.co/stabilityai/stable-diffusion-xl-base-1.0/tree/main> `sd_xl_base_1.0.safetensors`
    - <https://huggingface.co/stabilityai/stable-diffusion-xl-refiner-1.0/tree/main> `sd_xl_refiner_1.0.safetensors`

2. Download Stable diffusion WebUI <https://github.com/AUTOMATIC1111/stable-diffusion-webui>

My first ever image created using this local stable diffusion solution.

<div class="alert alert-info" role="alert">
    <p>Pay attention to the case sensitivity of the letters in the image extension, as it may be different than in my command.</p>
    <p>You can also use instead full of <code>magick mogrify ...</code>, just <code>mogrify ...</code> because after the installation of imagemagic all its sub-programs should be available for you directly in the command line.</p>
</div>

[weblink-imagemagic]: https://imagemagick.org/
[weblink-libheif-macos]: https://www.libde265.org/
[weblink-libheif-alternative]: https://github.com/strukturag/libheif
