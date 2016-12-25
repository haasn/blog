---
title: Falsehoods programmers believe about [video stuff]
author: Niklas Haas
tags: mpv, video
---

Inspired by numerous other such lists of falsehoods.

# Falsehoods programmers believe about..

## .. video decoding

* decoding is bit-exact, so the decoder used does not affect the quality
* since H.264 decoding is bit-exact, the decoder used does not affect the quality
* hardware decoding means I don't have to worry about performance
* hardware decoding is always faster than software decoding
* a H.264 hardware decoder can decode all H.264 files
* a H.264 software decoder can decode all H.264 files
* video decoding is easily parallelizable

## .. video playback

* the display's refresh rate will be an integer multiple of the video file's
  frame rate
* the display's clock will be in sync with the audio clock
* I can accurately measure the display's clock
* I can accurately measure the audio clock
* I can exclusively use the audio clock for timing
* I can exclusively use the video clock for timing
* my hardware contexts will survive the user's coffee break
* my hardware contexts will never disappear in the middle of playback
* I can always request a new hardware context after my previous one
  disappeared
* it's okay to error and quit if I can't request a hardware context
* hardware decoding and video playback will happen on the same device
* transferring frames from one device to another is easy
* the user will not notice 3:2 pulldown
* the user will not notice the odd dropped or duplicated frame
* all video frames will be unique
* all video frames will be decoded in order
* all video sources can be seeked in
* the user will never want to seek to non-keyframes
* seeking to a position will produce the same output as decoding to a position
* I can seek to a specific frame number
* videos have a fixed frame rate
* all frame timestamps are precise
* all frame timestamps are precise in modern formats like .mkv
* all frame timestamps are monotonically increasing
* all frame timestamps are monotonically increasing as long as you don't seek
* all frame timestamps are unique
* the duration of the final video frame is always known
* users will not notice if I skip the final video frame
* users will never want to play videos in reverse

## .. video/image files

* all video files have 8-bit per channel color
* all video files have 8-bit or 10-bit per channel color
* fine, but at least all channels are going to have the same number of bits
* all samples are going to fit into a 32-bit integer
* every pixel consists of three samples
* every pixel consists of three or four samples
* fine, every pixel consists of n samples
* all images files are sRGB
* all video files are BT.601 or BT.709
* all image files are either sRGB or contain an ICC profile
* 4:2:0 is the only way to subsample images
* all image files contain correct tags indicating their color space
* interlaced video files no longer exist
* the chroma location is the same for every YCbCr file
* all HD videos are BT.709
* video files will have the same refresh rate throughout the stream
* video files will have the same resolution throughout the stream
* video files will have the same color space throughout the stream
* video files will have the same pixel format throughout the stream
* fine, videos will have the same video codec throughout the stream
* the video and audio tracks will start at the same time
* the video and audio tracks will both be present throughout the stream
* I can start playing an audio file at the first decoded sample, and stop playing it
  at the last
* virtual timelines can be implemented on the demuxer level

## .. image scaling

* the GPU's built-in bilinear scaling is sufficient for everybody
* bicubic scaling is sufficient for everybody
* the image can just be scaled in its native color space
* I should linearize before scaling
* I shouldn't linearize before scaling
* upscaling is the same as downscaling
* the quality of scaling algorithms can be objectively measured
* the slower a scaling algorithm is to compute, the better it will be
* upscaling algorithms can invent information that doesn't exist in the image
* my scaling ratio is going to be the same in the x axis and the y axis
* chroma upscaling isn't as important as luma upscaling
* chroma and luma can/should be scaled separately
* I can ignore sub-pixel offsets when scaling and aligning planes
* I should always take sub-pixel offsets into account when scaling
* images contain no information above the Nyquist frequency
* images contain no information outside the TV signal range

## .. color spaces

* all colors are specified in (R,G,B) triples
* all colors are specified in RGB or CMYK
* fine, all colors are specified in RGB, CMYK, HSV, HSL, YCbCr or XYZ
* there is only one RGB color space
* there is only one YCbCr color space for each RGB color space
* fine, there is only one YCbCr color space for each RGB color space up to
  linear isomorphism
* an RGB triple unambiguously specifies a color
* an RGB triple + primaries unambiguously specifies a color
* fine, a CIE XYZ triple unambiguously specifies a color
* black is RGB (0,0,0), and white is RGB (255,255,255)
* all color spaces have the same white point
* color spaces are defined by the RGB primaries and white point
* my users are not going to notice the difference between BT.601 and BT.709
* there's only one BT.601 color space
* TV range YCbCr is the same thing as TV range RGB
* full-range YCbCr doesn't exist

## .. color conversion

* I don't need to convert an image's colors before displaying it on the screen
* all color spaces are just linearly related
* there's only one way to convert between color spaces
* I can just clip out-of-gamut colors after conversion
* there's only one way to pull 10-bit colors up to 16-bit precision
* linearization happens after RGB conversion
* I can freely convert between color spaces as long as I allow
  out-of-gamut colors
* converting between color spaces is a mathematical process so it doesn't
  depend on the display
* converting from A to B is just the inverse of converting from B to A
* the OOTF is conceptually part of the OETF
* the OOTF is conceptually part of the EOTF
* all CMMs implement color conversion correctly
* all professional CMMs implement color conversion correctly
* I don't need to dither after converting if the target colorspace is the same
  bit depth or higher

## .. video output

* the graphics API will dither my output for me
* there's only one way to dither output
* I need to dither to whatever my backbuffer precision is
* dithering with random noise looks good
* dithering artifacts are not visible at 6-bit precision
* dithering artifacts are not visible at 7-bit precision
* dithering artifacts are not visible at 8-bit precision
* temporal dithering is better than static dithering
* OpenGL is well-supported on all operating systems
* OpenGL is well-supported on any operating system
* waiting until the next vsync is easy in OpenGL
* video drivers correctly implement the texture formats they advertise
* I can accurately measure vsync timings
* vsync timings are consistent for a fixed refresh rate
* all displays with the same rate will vsync at the same time
* I can control the window size and position

## .. displays

* all displays are 60 Hz
* all refresh rates are integers
* all displays have a fixed refresh rate
* all displays are sRGB
* all displays are approximately sRGB
* displays have an infinite contrast
* all displays have a contrast of around 1000:1
* all displays have a white point of D65
* all displays have square pixels
* all displays use 8-bit per channel color
* all displays are PC displays
* my users will provide an ICC profile for their display
* my users will only use a single display
* my users will only use a single display for the duration of a video
* all ICC profiles for displays will have the same rendering intent
* all ICC profiles for displays will be black-scaled
* all ICC profiles for displays won't be black-scaled

## .. subtitles

* all subtitle files are UTF-8 encoded
* all subtitles are stored/rendered as RGB
* I can paint RGB subtitles on top of my RGB video files
* I don't need to worry about color management for subtitles
* the subtitle color space will be the same as the video color space
* rendering subtitles at the output resolution is better than rendering them
  at the video resolution
* there's an ASS specification
