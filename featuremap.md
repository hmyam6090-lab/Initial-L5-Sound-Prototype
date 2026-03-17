# L5sound Feature Map (Processing Sound → Love2D)

This table is a markdown conversion from my research mapped out in Google Sheet here: 

[Google Sheet FeatureMap](https://docs.google.com/spreadsheets/d/1tSDe68z31HpRSzVXrHaMLOCtlETNMTz_6bTxoy2Cocg/edit?usp=sharing)

| Processing Sound | Processing Notes | Love2D Implementation | Love2D Notes | Status |
|---|---|---|---|---|
| **Effects** |||||
| **AllPass** |||||
| `gain()` | | `Source:setFilter()` | `Source:setFilter()` only supports HighPass, LowPass, BandPass. AllPass not supported natively. See: https://love2d.org/forums/viewtopic.php?t=82944 | External Libraries/More Complex |
| `process()` | | | | External Libraries/More Complex |
| `stop()` | | | | External Libraries/More Complex |
| **BandPass** |||||
| `bw()` | Processing's filters are more user-friendly (named classes with `freq()`, `res()`). In L5sound we would create analogous classes (e.g. `L5.LowPass`), but internally call `source:setFilter({type="lowpass", ...})`. The mapping of parameters is not one-to-one (Love uses filter gains rather than direct Q factor), so some translation logic is needed. AllPass (phase shift) has no direct equivalent; could be omitted or simulated by combining delays. | `Source:setFilter()` | `Source:setFilter()` only supports HighPass, LowPass, BandPass with limited control (volume, highgain, lowgain only). See: https://love2d.org/forums/viewtopic.php?t=82944 for more support | Needs Love2D Implementation |
| `freq()` | | `Source:setFilter()` | | Needs Love2D Implementation |
| `process()` | | `Source:setFilter()` | | Needs Love2D Implementation |
| `res()` | | `Source:setFilter()` | | Needs Love2D Implementation |
| `set()` | | `Source:setFilter()` | | Needs Love2D Implementation |
| `stop()` | | `Source:setFilter()` | | Needs Love2D Implementation |
| **Delay** |||||
| `feedback()` | Some Processing parameters may not exactly match Love's (e.g. Love's reverb has roomSize, damp, tilt etc.). But overall, core features exist. | `love.audio.setEffect()` | Delay (called echo in Love2D) is one of the built in effects. Define with `love.audio.setEffect(name, {type=<EffectType>, ...})` and apply with `source:setEffect(name)`. See also: https://github.com/orllewin/love2d_modular_love | Direct Wrap |
| `process()` | | `love.audio.setEffect()` | | Direct Wrap |
| `set()` | | `love.audio.setEffect()` | | Direct Wrap |
| `stop()` | | `love.audio.setEffect()` | | Direct Wrap |
| `time()` | | `love.audio.setEffect()` | | Direct Wrap |
| **HighPass** |||||
| `freq()` | Similar to BandPass | `Source:setFilter()` | Similar to BandPass | Needs Love2D Implementation |
| `process()` | | `Source:setFilter()` | | Needs Love2D Implementation |
| `res()` | | `Source:setFilter()` | | Needs Love2D Implementation |
| `set()` | | `Source:setFilter()` | | Needs Love2D Implementation |
| `stop()` | | `Source:setFilter()` | | Needs Love2D Implementation |
| **LowPass** |||||
| `freq()` | Similar to BandPass | `Source:setFilter()` | Similar to BandPass | Needs Love2D Implementation |
| `process()` | | `Source:setFilter()` | | Needs Love2D Implementation |
| `res()` | | `Source:setFilter()` | | Needs Love2D Implementation |
| `set()` | | `Source:setFilter()` | | Needs Love2D Implementation |
| `stop()` | | `Source:setFilter()` | | Needs Love2D Implementation |
| **Reverb** |||||
| `damp()` | Similar to Delay | `love.audio.setEffect()` | Reverb has good support in Love2D. Although the exact implementation isn't the same between Processing and Love2D, feature-parity is achievable. | Direct Wrap |
| `process()` | | `love.audio.setEffect()` | | Direct Wrap |
| `room()` | | `love.audio.setEffect()` | | Direct Wrap |
| `stop()` | | `love.audio.setEffect()` | | Direct Wrap |
| `wet()` | | `love.audio.setEffect()` | | Direct Wrap |
| **Analysis** |||||
| **Amplitude** |||||
| `analyze()` | | `SoundData:getSample()` | Maybe by computing RMS from the sample buffer obtained using `SoundData:getSample()` | External Libraries/More Complex |
| `input()` | Set input to analyze | Storing some kind of reference to Source/SoundData | There could be three possible source types in L5: native Love2D SoundFile (via `Decoder.read()`), custom Oscillators/Noise, and recording input from RecordingDevices (via `RecordingDevice:getData()`) | External Libraries/More Complex |
| **BeatDetector** |||||
| `input()` | | Storing some kind of reference to Source/SoundData | | External Libraries/More Complex |
| `isBeat()` | | Custom implementation or library | References: https://love2d.org/forums/viewtopic.php?t=35986 (2013) and https://love2d.org/forums/viewtopic.php?t=82210 (2016) | External Libraries/More Complex |
| `sensitivity()` | | Adjust detection threshold in custom implementation | | External Libraries/More Complex |
| **FFT** |||||
| `analyzeSample()` | | | lua-fft library: https://github.com/h4rm/luafft. May need conversion since luafft expects audio data as complex values. | External Libraries/More Complex |
| `analyze()` | | | Same as above | External Libraries/More Complex |
| `input()` | | Storing some kind of reference to Source/SoundData | | External Libraries/More Complex |
| **PitchDetector** |||||
| `analyze()` | | `SoundData:getSample()` | | External Libraries/More Complex |
| `input()` | | Storing some kind of reference to Source/SoundData | | External Libraries/More Complex |
| **Waveform** |||||
| `analyze()` | | `SoundData:getSample()` | Seems simple enough to return a copy of PCM samples. | Needs Love2D Implementation |
| `input()` | | Storing some kind of reference to Source/SoundData | | External Libraries/More Complex |
| **I/O** |||||
| **AudioIn** |||||
| `amp()` | Love can access the mic via `RecordingDevice = love.audio.getRecordingDevices()[1]` and `RecordingDevice:start()`. Audio comes in as PCM; pull data using `device:getSoundData()`. (Love 11+.) L5sound could wrap the first mic device as AudioIn and feed PCM into Love's audio output or analysis objects. | `RecordingDevice:setVolume()` | Love2D stores audio input in RecordingDevice. May need a wrapper around Source to use Source methods for Processing Sound feature parity. | Needs Love2D Implementation |
| `pan()` | | `RecordingDevice:setPosition()` | | Needs Love2D Implementation |
| `play()` | | `RecordingDevice:play()` | | Needs Love2D Implementation |
| `set()` | | Wrapper Function | | Needs Love2D Implementation |
| `start()` | | `RecordingDevice:start()` | | Needs Love2D Implementation |
| `stop()` | | `RecordingDevice:stop()` | | Needs Love2D Implementation |
| **MultiChannel** |||||
| `activeChannel()` | Love2D 11.5 does not support access to playback devices. Discussed in https://github.com/love2d/love/issues/1537; implemented and merged for 12.0 only in https://github.com/love2d/love/pull/1805. | | Can look at the 12.0 PR implementation for reference and implement our own or wrap in a more Processing-like way. | External Libraries/More Complex |
| `availableChannels()` | | | | External Libraries/More Complex |
| `usePortAudio()` | | | | External Libraries/More Complex |
| **Sampling** |||||
| **AudioSample** (`SoundData`) |||||
| `amp()` | | `Source:setVolume()` | | Direct Wrap |
| `channels()` | | `SoundData:getChannelCount()` | | Direct Wrap |
| `cueFrame()` | `cueFrame()` is in frames | `Source:seek()` | `Source:seek()` is in seconds | Needs Love2D Implementation |
| `cue()` | `cue()` is in seconds | `Source:seek()` | `Source:seek()` is in seconds | Needs Love2D Implementation |
| `duration()` | | `Source:getDuration()` | | Direct Wrap |
| `frames()` | duration in frames | `Source:getDuration()` | Love2D doesn't directly support `getDuration()` in frames, but straightforward to derive with a known sample rate | Needs Love2D Implementation |
| `jumpFrame()` | | `Source:seek()` | `source:seek()` sets the currently playing position. With queueable source type, can only work on the currently playing buffer. | Direct Wrap |
| `jump()` | | `Source:seek()` | | Direct Wrap |
| `loop()` | Starts playback of the AudioSample in a loop | `Source:setLooping(true)` + `Source:play()` | `Source:setLooping(true)` only sets looping; `loop()` in Processing also plays the sample | Needs Love2D Implementation |
| `pan()` | `pan()` takes range from -1 to 1 | `Source:setPosition()` | `Source:setPosition()` takes x, y, z coordinates | Needs Love2D Implementation |
| `pause()` | | `Source:pause()` | | Direct Wrap |
| `percent()` | Get current playback position in percent. | `Source:tell()` + `Source:getDuration()` | `Source:tell()` returns seconds. `percent()` is just `source:tell() / duration()` | Needs Love2D Implementation |
| `playFor()` | Starts playback for specified duration or to end, whichever comes first. | `love.timer()` + `Source:stop()` | Use `love.timer()` with `Source:stop()` to emulate | Needs Love2D Implementation |
| `play()` | | `Source:play()` | | Direct Wrap |
| `positionFrame()` | | `Source:tell()` | Frame version of `percent()` | Needs Love2D Implementation |
| `position()` | | `Source:tell()` | | Direct Wrap |
| `rate()` | | `Source:setPitch()` | | Direct Wrap |
| `read()` | | `SoundData:getSample()` | | Direct Wrap |
| `resize()` | | ? | No clean way to resize AudioSample other than reconstructing it entirely | External Libraries/More Complex |
| `sampleRate()` | | `SoundData:getSampleRate()` | | Direct Wrap |
| `set()` | Set multiple parameters at once. | Wrapper Function | No direct `set()` in Love2D; straightforward to implement as a wrapper | Needs Love2D Implementation |
| `stop()` | | `Source:stop()` | | Direct Wrap |
| `write()` | | `SoundData:setSample()` | | Direct Wrap |
| **SoundFile** |||||
| `amp()` | | `Source:setVolume()` | | Direct Wrap |
| `channels()` | | `SoundData:getChannelCount()` | | Direct Wrap |
| `cue()` | | `Source:seek()` | `source:seek()` sets the currently playing position. With queueable source type, can only work on the currently playing buffer. | Needs Love2D Implementation |
| `duration()` | | `Source:getDuration()` | | Direct Wrap |
| `frames()` | | `Source:getDuration()` | Same problem as `frames()` for AudioSample | Needs Love2D Implementation |
| `isPlaying()` | | `Source:isPlaying()` | | Direct Wrap |
| `jump()` | | `Source:seek()` | Same note as `cue()` and AudioSample | Direct Wrap |
| `loop()` | | `Source:setLooping(true)` + `Source:play()` | Similar implementation as AudioSample | Needs Love2D Implementation |
| `pan()` | | `Source:setPosition()` | Similar implementation as AudioSample | Direct Wrap |
| `pause()` | | `Source:pause()` | | Direct Wrap |
| `play()` | | `Source:play()` | | Direct Wrap |
| `rate()` | | `Source:setPitch()` | | Direct Wrap |
| `removeFromCache()` | | `removeFromCache()` | May need custom implementation. Probably set the SoundFile instance to nil and call `collectgarbage("collect")`. | Needs Lua Implementation |
| **Noise & Oscillators** |||||
| `Noise` (Brown, Pink, White) | `amp()`, `pan()`, `play()`, `set()`, `stop()` | Custom Love2D implementation | No built-in waveform generators. Recreate by generating sample data manually. Fill SoundData buffer with random data for different noise colors. See example: https://gist.github.com/lee2sman/e18b9bfd7e8c2eeb279ceca76e74a3b5 | Needs Love2D Implementation |
| `Oscillators` (Pulse, SawOsc, SinOsc, SqrOsc, TriOsc) | `amp()`, `freq()`, `pan()`, `play()`, `set()`, `stop()` | Custom Love2D implementation | Same as above | Needs Love2D Implementation |
| **Envelopes** |||||
| `Env` | | Custom Love2D Implementation | No native Love2D envelope. Implement in L5 by modulating `Source:setVolume()` over time using a table of values and a timer. `Env.play()` could start a coroutine or use LOVE's timer to ramp volume. | Needs Love2D Implementation |
| `play()` | | | | Needs Love2D Implementation |
| **Configuration** |||||
| **Sound** |||||
| `inputDevice()` | | `love.audio.getRecordingDevices()` | | Direct Wrap |
| `list()` | | | Easily implemented for recording via `love.audio.getRecordingDevices()` but not supported for playback currently | Needs Lua Implementation |
| `outputDevice()` | | | Implemented in Love2D 12.0 but not officially released yet | Needs Lua Implementation |
| `sampleRate()` | | `love.audio.getSampleRate()` | | Direct Wrap |
| `status()` | | | No direct support in Love2D, but Lua has `collectgarbage("count")` | Needs Lua Implementation |
| `volume()` | | `love.audio.setVolume()` | | Direct Wrap |
