# FFmpeg

## Synopsis

```bash
ffmpeg [global_options] {[input_options] -i input_url} ... {[output_options] output_url} ...
```

## Inspect Media

```bash
ffprobe file.mp4
```

## Convert Format

```bash
ffmpeg -i input.mp4 output.mkv
```

## Codecs

### Video Codecs

Video codecs are algorithms that compress and decompress digital video.

- Encoding -> Takes raw, gigantic video data and compresses it into a smaller, playable form.
- Decoding -> Expands that compressed video back into frames you can watch.

| Codec            | FFmpeg Name              | Pros                                                               | Cons                                          | Common Uses                           |
| ---------------- | ------------------------ | ------------------------------------------------------------------ | --------------------------------------------- | ------------------------------------- |
| **H.264 / AVC**  | `libx264`                | Great quality/size balance, very compatible, hardware acceleration | Bigger files vs newer codecs                  | YouTube, streaming, general           |
| **H.265 / HEVC** | `libx265`                | \~50% smaller than H.264 at same quality                           | Slower encode, patents, less playback support | 4K streaming, high-efficiency storage |
| **VP9**          | `libvpx-vp9`             | Open source, good efficiency                                       | Slower encode, less hardware support          | Web video, YouTube                    |
| **AV1**          | `libaom-av1` / `svt-av1` | Best compression efficiency, royalty-free                          | Very slow encode, limited hardware decode     | Next-gen streaming                    |
| **MPEG-2**       | `mpeg2video`             | Fast, old, simple                                                  | Large files, poor compression                 | DVDs, legacy broadcast                |
| **ProRes**       | `prores_ks`              | High quality, fast editing                                         | Huge files                                    | Professional video editing            |

### Audio Codecs

| Codec       | FFmpeg Name  | Type     | Pros                                                     | Cons                                |
| ----------- | ------------ | -------- | -------------------------------------------------------- | ----------------------------------- |
| **AAC**     | `aac`        | Lossy    | Widely supported (MP4, MOV), good quality at low bitrate | Patented (but supported in FFmpeg)  |
| **MP3**     | `libmp3lame` | Lossy    | Works almost everywhere                                  | Larger files at same quality vs AAC |
| **Opus**    | `libopus`    | Lossy    | Great for speech/music at very low bitrates              | Not supported on older devices      |
| **Vorbis**  | `libvorbis`  | Lossy    | Open source, good quality                                | Less common now                     |
| **FLAC**    | `flac`       | Lossless | Perfect preservation, smaller than WAV                   | Bigger files than lossy             |
| **PCM/WAV** | `pcm_s16le`  | Lossless | Simple, universal                                        | Huge file sizes                     |

### Codec Control

```bash
ffmpeg -i input.mp4 -c:v libx265 -c:a aac output.mp4
```

- `-c:v` -> video codec
- `-c:a` -> audio codec

## Bitrates

Bitrate is the amount of data used to store or transmit media per second.

It’s usually measured in:

- kbps (kilobits per second) for audio or low-quality video
- Mbps (megabits per second) for HD/4K video

Higher bitrate -> more data per second -> higher potential quality, but bigger file.

Lower bitrate -> smaller file, but if too low, you get compression artifacts (blockiness, blurring, “mosquito noise”).

Quality is not determined by bitrate alone. With efficient codecs (like H.265 or AV1), you can use lower bitrate for the same quality compared to older codecs (like MPEG-2).

### Bitrate-to-Quality Reference Charts

**Video**

| Resolution | Codec | Bitrate (Mbps) | Quality Notes |
| ---------- | ----- | -------------- | ------------------------------------------------------- |
| 480p       | H.264 | 1.0 – 2.0      | Good quality for small screens                          |
| 480p       | H.265 | 0.5 – 1.0      | Same quality at \~50% less bitrate                      |
| 480p       | AV1   | 0.4 – 0.8      | Great quality, smaller than H.264/H.265 at same quality |
| 480p       | VP9   | 0.8 – 1.5      | Good quality, better compression than H.264             |
| 720p       | H.264 | 2.5 – 4.0      | Standard HD quality                                     |
| 720p       | H.265 | 1.5 – 2.5      | Smaller files, similar quality                          |
| 720p       | AV1   | 1.0 – 2.0      | High quality HD, good for streaming                     |
| 720p       | VP9   | 1.5 – 3.0      | Solid HD quality, efficient compression                 |
| 1080p      | H.264 | 4.0 – 8.0      | Full HD, good balance                                   |
| 1080p      | H.265 | 2.5 – 5.0      | Smaller files, same quality                             |
| 1080p      | AV1   | 2.5 – 5.0      | Excellent Full HD quality, roughly half H.264 bitrate   |
| 1080p      | VP9   | 3.5 – 6.0      | High-quality Full HD                                    |
| 2K (1440p) | AV1   | 5.0 – 8.0      | High detail, much smaller than H.264/H.265 files        |
| 2K (1440p) | VP9   | 6.0 – 10.0     | Great quality for detailed content                      |
| 4K (2160p) | H.264 | 15 – 30        | High detail, big files                                  |
| 4K (2160p) | H.265 | 8 – 15         | Same quality at half the bitrate                        |
| 4K (2160p) | AV1   | 8 – 15         | Very high quality UHD, great compression efficiency     |
| 4K (2160p) | VP9   | 10 – 20        | Very high quality UHD streaming                         |

**Audio**

| Usage                | Codec | Bitrate (kbps) | Notes                               |
| -------------------- | ----- | -------------- | ----------------------------------- |
| Speech / Podcasts    | AAC   | 64 – 96        | Good clarity for voice              |
| Music (Standard)     | AAC   | 128 – 192      | Good quality for general music      |
| Music (High Quality) | AAC   | 256 – 320      | Near-CD quality                     |
| Speech / Voice Chat  | Opus  | 32 – 64        | Excellent for low bitrate           |
| Music (Opus)         | Opus  | 96 – 160       | Better than MP3/AAC at low bitrates |

### Bitrate Control

**Constant Bitrate (CBR)** - same bitrate every second.

```bash
-b:v 5M
```

**Variable Bitrate** - bitrate changes depending on scene complexity. Controlled via CRF for two-pass encoding.

CRF is adaptive: complex scenes get more bits, simple scenes get fewer bits.

- Lower CRF -> better quality, bigger file.
- Higher CRF -> lower quality, smaller file.

Scale:

- For H.264 / H.265: 0–51 (0 = lossless, 23 = default, 51 = worst quality)
- For VP9: 0–63 (lower = better)
- For AV1: 0–63 (lower = better, 35 = default)

```bash
ffmpeg -i input.mp4 -c:v libx264 -crf 20 output.mp4
```

**Average Bitrate** - targets an average bitrate but allows flexibility.

```bash
-b:v 5M -maxrate 6M -bufsize 10M
``` 

## Encoding Guides

**Video Codecs:**

- [H.264 Encoding Guide](https://trac.ffmpeg.org/wiki/Encode/H.264)
- [H.265 Encoding Guide](https://trac.ffmpeg.org/wiki/Encode/H.265)
- [VP9 (WebM) Encoding Guide](https://trac.ffmpeg.org/wiki/Encode/VP9)
- [AV1 Encoding Guide](https://trac.ffmpeg.org/wiki/Encode/AV1)

**Audio Codecs:**

- [AAC Encoding Guide](AAC Encoding Guide)
- [MP3 Encoding Guide](https://trac.ffmpeg.org/wiki/Encode/MP3)

## Trim Without Re-encoding

```bash
ffmpeg -ss 00:00:00 -to 00:02:00 -i input.mp4 -c copy clip.mp4
```

- `-ss` -> start time
- `-to` -> end time

Note: `-ss` before `-i` is faster but less accurate; after `-i` is accurate but slower.

## Small Web-Only Compression Example

```bash
ffmpeg -i input.mp4 -c:v libvpx-vp9 -b:v 1M -c:a libopus -b:a 96k output.webm
```
