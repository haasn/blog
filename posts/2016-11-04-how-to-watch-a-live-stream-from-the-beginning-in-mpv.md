---
title: How to watch a live stream from the beginning in mpv
author: Niklas Haas
tags: mpv, tips
---

If you try watching a video recording on twitch etc. while it's still ‘live’,
mpv/youtube-dl will play the live video instead of starting from the
beginning.

The fix is straightforward: By appending `?t=0m` you can force it to start at
the beginning:


```bash
mpv 'https://www.twitch.tv/example/v/12345?t=0'
```

This is also useful for a second purpose: seeking. Normally, by trying to seek
a live stream like this in mpv you will end up buffering and downloading
forever. (I'm not exactly sure what's going on since the mpv cache is so
opaque, but I have to imagine it's actually trying to download all the data
you skipped past)

By changing it to e.g. `?t=20m` you can seek to 20 minutes in the stream.
