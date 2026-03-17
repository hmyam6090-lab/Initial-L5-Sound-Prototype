# L5 Sound Reference (API Template)

> Processing-style sound API for L5 (Lua / Love2D backend).

Legend:
- `[X]` = MVP target (implement first)
- `[ ]` = later phase / advanced

## STRUCTURE

* [X] `local Sound = require("l5.sound")`
* [X] `SoundFile(path, mode?)`
* [X] `AudioSample(pathOrSoundData)`
* [X] `AudioIn(device?)`
* [X] `Env(attack, sustainTime, sustainLevel, release)`
* [X] `SinOsc(freq?, amp?, pan?)`
* [ ] `SawOsc()`, `SqrOsc()`, `TriOsc()`, `Pulse()`
* [ ] `WhiteNoise()`, `PinkNoise()`, `BrownNoise()`
* [X] `Delay()`, `Reverb()`, `LowPass()`
* [ ] `HighPass()`, `BandPass()`, `AllPass()`
* [X] `Amplitude()`
* [ ] `FFT()`, `Waveform()`, `BeatDetector()`, `PitchDetector()`

## PLAYBACK

### SoundFile

* [X] `play()`
* [X] `pause()`
* [X] `stop()`
* [X] `isPlaying()`
* [X] `amp()`
* [X] `rate()`
* [X] `jump()`
* [X] `duration()`
* [ ] `loop()` -- Processing behavior parity (`setLooping + play`)
* [ ] `cue()`
* [ ] `frames()`
* [ ] `pan()` -- map to `Source:setPosition`
* [ ] `removeFromCache()`

### AudioSample

* [X] `play()`
* [X] `pause()`
* [X] `stop()`
* [X] `amp()`
* [X] `rate()`
* [X] `jump()`
* [X] `position()`
* [X] `duration()`
* [X] `sampleRate()`
* [X] `channels()`
* [X] `read()`
* [X] `write()`
* [ ] `loop()`
* [ ] `cue()`
* [ ] `cueFrame()`
* [ ] `jumpFrame()`
* [ ] `positionFrame()`
* [ ] `percent()`
* [ ] `playFor()`
* [ ] `frames()`
* [ ] `pan()`
* [ ] `set()`
* [ ] `resize()`

## SYNTHESIS

### Oscillators

* [X] `SinOsc:play()`
* [X] `SinOsc:stop()`
* [X] `SinOsc:freq()`
* [X] `SinOsc:amp()`
* [X] `SinOsc:pan()`
* [X] `SinOsc:set()`
* [ ] `SawOsc`, `SqrOsc`, `TriOsc`, `Pulse` parity

### Noise

* [ ] `WhiteNoise:play(), stop(), amp(), pan(), set()`
* [ ] `PinkNoise:play(), stop(), amp(), pan(), set()`
* [ ] `BrownNoise:play(), stop(), amp(), pan(), set()`

### Envelope

* [X] `Env:play(target)`
* [ ] `Env:set()`

## EFFECTS / FILTERS

### Effects

* [X] `Delay:process(source)`
* [X] `Delay:time()`
* [X] `Delay:feedback()`
* [X] `Delay:stop()`
* [X] `Reverb:process(source)`
* [X] `Reverb:room()`
* [X] `Reverb:damp()`
* [X] `Reverb:wet()`
* [X] `Reverb:stop()`

### Filters

* [X] `LowPass:process(source)`
* [X] `LowPass:freq()`
* [X] `LowPass:res()`
* [X] `LowPass:stop()`
* [ ] `HighPass` parity
* [ ] `BandPass` parity
* [ ] `AllPass` (advanced, no direct native equivalent)

## ANALYSIS

* [X] `Amplitude:input(sourceOrInput)`
* [X] `Amplitude:analyze()`
* [ ] `Waveform:input()`
* [ ] `Waveform:analyze()`
* [ ] `FFT:input()`
* [ ] `FFT:analyze()`
* [ ] `FFT:analyzeSample()`
* [ ] `BeatDetector:input()`
* [ ] `BeatDetector:sensitivity()`
* [ ] `BeatDetector:isBeat()`
* [ ] `PitchDetector:input()`
* [ ] `PitchDetector:analyze()`

## I/O

### AudioIn

* [X] `start()`
* [X] `stop()`
* [ ] `play()`
* [ ] `amp()`
* [ ] `pan()`
* [ ] `set()`

## CONFIGURATION

### Sound (global)

* [X] `Sound.volume(value?)`
* [X] `Sound.sampleRate()`
* [X] `Sound.inputDevice(indexOrName?)`
* [ ] `Sound.list(kind?)`
* [ ] `Sound.outputDevice(indexOrName?)`
* [ ] `Sound.status()`

## MVP NOTES

* Keep Love 11.5 compatibility first.
* Use queueable source for synthesis (`SinOsc` first).
* Use Love effects API for `Delay` / `Reverb`.
* Treat FFT/beat/pitch as phase 2.
