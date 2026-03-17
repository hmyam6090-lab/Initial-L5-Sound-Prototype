# L5 Sound Reference (API Template)

> Processing-style sound API for L5.

Legend:
- Implementation: `[ ]` = Not Done, `[X]` = Done
- Testing: `[ ]` = Not Tested, `[T]` = Tested
- `*` = Prioritized

## STRUCTURE

* [X] [T] `local Sound = require("l5sound")*`
* [X] [ ] `SoundFile(path, mode?)*` -- Missing cache() arg option
* [X] [ ] `AudioSample(pathOrSoundData)*` -- Feature parity not fully tested, overridden arg constructors clunky
* [ ] [ ] `AudioIn(device?)`
* [ ] [ ] `Env(attack, sustainTime, sustainLevel, release)`
* [ ] [ ] `SinOsc(freq?, amp?, pan?)*`
* [ ] [ ] `SawOsc()`, `SqrOsc()`, `TriOsc()`, `Pulse()`
* [ ] [ ] `WhiteNoise()`, `PinkNoise()`, `BrownNoise()`
* [ ] [ ] `Delay()`, `Reverb()`, `LowPass()`
* [ ] [ ] `HighPass()`, `BandPass()`, `AllPass()`
* [ ] [ ] `Amplitude()`
* [ ] [ ] `FFT()`, `Waveform()`, `BeatDetector()`, `PitchDetector()`

## PLAYBACK

### SoundFile

* [X] [T] `play()*`
* [X] [ ] `pause()*`
* [X] [ ] `stop()*`
* [X] [ ] `isPlaying()*`
* [X] [ ] `amp()*`
* [X] [ ] `rate()*`
* [X] [ ] `jump()*`
* [X] [ ] `duration()*`
* [X] [T] `loop()*` -- Processing behavior parity (`setLooping + play`)
* [ ] [ ] `cue()*`
* [ ] [ ] `frames()`
* [X] [ ] `pan()*` -- map to `Source:setPosition`
* [ ] [ ] `removeFromCache()`

### AudioSample

* [X] [T] `play()*`
* [X] [ ] `pause()*`
* [X] [T] `stop()*`
* [X] [T] `amp()*`
* [X] [ ] `rate()*`
* [X] [ ] `jump()*`
* [X] [ ] `position()*`
* [X] [ ] `duration()*`
* [X] [ ] `sampleRate()*`
* [X] [ ] `channels()*`
* [X] [ ] `read()*`
* [X] [ ] `write()*`
* [X] [ ] `loop()*`
* [X] [ ] `cue()*`
* [X] [ ] `cueFrame()`
* [X] [ ] `jumpFrame()`
* [X] [ ] `positionFrame()`
* [X] [ ] `percent()`
* [X] [ ] `playFor()*`
* [X] [ ] `frames()*`
* [X] [ ] `pan()*`
* [X] [ ] `set()`
* [X] [ ] `resize()`

## SYNTHESIS

### Oscillators

* [ ] [ ] `SinOsc:play()*`
* [ ] [ ] `SinOsc:stop()*`
* [ ] [ ] `SinOsc:freq()*`
* [ ] [ ] `SinOsc:amp()*`
* [ ] [ ] `SinOsc:pan()*`
* [ ] [ ] `SinOsc:set()*`
* [ ] [ ] `SawOsc`, `SqrOsc`, `TriOsc`, `Pulse` parity

### Noise

* [ ] [ ] `WhiteNoise:play(), stop(), amp(), pan(), set()`
* [ ] [ ] `PinkNoise:play(), stop(), amp(), pan(), set()`
* [ ] [ ] `BrownNoise:play(), stop(), amp(), pan(), set()`

### Envelope

* [ ] [ ] `Env:play(target)`
* [ ] [ ] `Env:set()`

## EFFECTS / FILTERS

### Effects

* [ ] [ ] `Delay:process(source)`
* [ ] [ ] `Delay:time()`
* [ ] [ ] `Delay:feedback()`
* [ ] [ ] `Delay:stop()`
* [ ] [ ] `Reverb:process(source)`
* [ ] [ ] `Reverb:room()`
* [ ] [ ] `Reverb:damp()`
* [ ] [ ] `Reverb:wet()`
* [ ] [ ] `Reverb:stop()`

### Filters

* [ ] [ ] `LowPass:process(source)`
* [ ] [ ] `LowPass:freq()`
* [ ] [ ] `LowPass:res()`
* [ ] [ ] `LowPass:stop()`
* [ ] [ ] `HighPass` parity
* [ ] [ ] `BandPass` parity
* [ ] [ ] `AllPass` (advanced, no direct native equivalent)

## ANALYSIS

* [ ] [ ] `Amplitude:input(sourceOrInput)`
* [ ] [ ] `Amplitude:analyze()`
* [ ] [ ] `Waveform:input()`
* [ ] [ ] `Waveform:analyze()`
* [ ] [ ] `FFT:input()`
* [ ] [ ] `FFT:analyze()`
* [ ] [ ] `FFT:analyzeSample()`
* [ ] [ ] `BeatDetector:input()`
* [ ] [ ] `BeatDetector:sensitivity()`
* [ ] [ ] `BeatDetector:isBeat()`
* [ ] [ ] `PitchDetector:input()`
* [ ] [ ] `PitchDetector:analyze()`

## I/O

### AudioIn

* [ ] [ ] `start()`
* [ ] [ ] `stop()`
* [ ] [ ] `play()`
* [ ] [ ] `amp()`
* [ ] [ ] `pan()`
* [ ] [ ] `set()`

## CONFIGURATION

### Sound (global)

* [ ] [ ] `Sound.volume(value?)`
* [ ] [ ] `Sound.sampleRate()`
* [ ] [ ] `Sound.inputDevice(inde OrName?)`
* [ ] [ ] `Sound.list(kind?)`
* [ ] [ ] `Sound.outputDevice(inde OrName?)`
* [ ] [ ] `Sound.status()`

## MVP NOTES

* Keep Love 11.5 compatibility first.
* Use queueable source for synthesis (`SinOsc` first).
* Use Love effects API for `Delay` / `Reverb`.
* Treat FFT/beat/pitch as phase 2.
