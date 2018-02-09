---
title: How to benchmark mpv's raw throughput
author: Niklas Haas
tags: video, mpv, tips
---

mpv exports pass timers which allow you to benchmark the performance in
theory, but in practice these are very unreliable in multiple scenarios:

1. Some drivers group the timer queries into the wrong command buffer, causing
   the first measured pass to include the time spent waiting for the vsync.
2. Some drivers overlap the timer durations for jobs running in parallel, thus
   leading to an over-counting of the time spent on each pass.
3. Some drivers just flat out refuse to report timer results at all.
4. Some timers (and in particular, the vulkan code) outsource asynchronous
   commands to different queues, not all of which even support timers; leading
   to passes being measured as 0μs despite taking time in reality.

Instead, a more comparable way to benchmark the raw throughput of mpv is to
uncap the framerate and see how fast you can push frames. The most basic way
to accomplish this is with a profile like this:

```ini
[bench]
audio=no
untimed=yes
video-sync=display-desync
vulkan-swap-mode=immediate
opengl-swapinterval=0
d3d11-sync-interval=0
osd-msg1="FPS: ${estimated-display-fps}"
```

## Disclaimer / caveats

1. This relies on you being able to uncap the rendering. Some systems don't
   support this configuration correctly. On some systems you need to use
   `--vulkan-swap-mode=mailbox` instead. On other systems, you have no way of
   disabling OpenGL vsync at all; or you need to force it off in the driver.
   Obviously, if the measured FPS is exactly equal to your display FPS (e.g.
   60 Hz), the results are invalid.

2. This requires your CPU to be able to decode the file as fast as you're
   trying to render it. So if you're using this with really light settings,
   you'd end up rendering at like 3000 fps and maxing out on the decoding
   speed. Obviously, such scenarios are unrealistic. This test only really
   makes sense when GPU rendering is the bottleneck; i.e. when you're using
   heavy scalers.

3. The display-sync logic still applies. This means that, for example, if the
   video is 24 fps and your display identifies itself as 60 fps. mpv will draw
   one fresh frame followed by two redraws of the same frame (which are just
   cheap blits), specifics depending on the exact pattern needed to
   synchronize the two framerates. So as a result, your estimated FPS will be
   way higher than your GPU is actually doing work. For example, it may report
   300 fps when in reality your GPU is only processing ~100 frames per second.
   In essence, what's happening is that it's measuring the number of vsyncs it
   can output per second - not the number of video frames it can render. To
   solve this, you can either use `--display-fps` to trick the display sync code
   into simulating a lower or higher display FPS,[^displayfps] or you can use
   `--speed` to make the video faster or slower. For example, to display
   a 24 Hz video on a 60 Hz display you can use `-speed 2.5` to lock the video
   framerate to the display framerate.

4. Actually drawing the OSD can cause the performance to decrease. Although
   in this case, the difference shouldn't be that big, it makes a big
   difference when using [stats.lua](https://github.com/Argon-/mpv-stats),
   especially at high screen resolutions. So I recommend sticking to the
   `osd-msg1`, or perhaps switching to `term-status-msg` instead if needed.

[^displayfps]: This is actually useful if you want to see if you could, for
example, upgrade from a 60 Hz monitor to a 144 Hz monitor without framedrops.
If you can render with `--display-fps=144 --profile=bench` at 144 FPS or more,
then you're good to go. (For this type of content)
