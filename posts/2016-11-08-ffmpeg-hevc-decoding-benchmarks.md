---
title: FFmpeg HEVC decoding benchmarks
author: Niklas Haas
tags: mpv, ffmpeg, benchmarks
---

Since HEVC software decoding is still very much relevant (especially as
hardware decoding chips are both scarce and limited), I decided to compile a
few of the benchmark numbers I've gotten in the past into a set of graphs.

## Performance boost from OpenHEVC intrinsics

These patches still made a very big difference on current git master. Test was
done using ffmpeg version `N-82299-g0a24587` and
[this patchset](https://raw.githubusercontent.com/haasn/gentoo-conf/1922546a8f9b46f47ea94d2f053470597afcade1/etc/portage/patches/media-video/ffmpeg/openhevc_intrinsics.patch)

![Time to decode 3000 frames ([large](/files/openhevc/full.png), [SVG](/files/openhevc/full.svg))](/files/openhevc/img.png)

Interestingly enough, the intra pred SIMD basically made no difference at all,
even making the result slightly slower, but the IDCT still helped a lot.
Looking at the code, I can't find an obvious explanation for this - the HEVC
intra pred in FFmpeg is still very much C. Perhaps the compiler just does a
good job of optimizing here, or perhaps the OpenHEVC intrinsics are just bad.

Either way, seems like it's best to keep this patch off. I have adjusted
[my own FFmpeg patches](https://github.com/haasn/gentoo-conf/tree/xor/etc/portage/patches/media-video/ffmpeg)
accordingly.

## Time to decode vs. number of threads

In case you're crazy enough to buy a 16-core machine for video processing,
you're not going to get great results out of software decoding after the first
few cores.

Tests were done using ffmpeg version `N-82215-g3932ccc` with both OpenHEVC
intrinsics patches applied.

![Time to decode 3000 frames ([large](/files/ffmpeg-threads/full.png), [SVG](/files/ffmpeg-threads/full.svg))](/files/ffmpeg-threads/img.png)
