# Initial-L5-Sound-Prototype

L5sound is a Processing-style sound library design for L5 (Lua + Love2D backend).

This repository is a prototype and a stab at an initial L5Sound Library

## Documents

- [Feature Mapping](featuremap.md): Processing Sound capabilities mapped to Love2D primitives on markdown table
- [Feature Map Google Sheets](featuremap.md): A Google Sheets Document to visualize the feature mapping bettter
- [API Draft](api.md): proposed L5sound class/method surface

# L5sound Prototype Usage Guide

L5sound is a Processing-style sound library for L5 (Lua + Love2D). It's designed to be dropped alongside L5.lua as a single file module.

## Installation

### Method 1: Import l5sound into your L5 project

1. Copy `l5sound.lua` to your L5 project directory (same level as `L5.lua`)
2. Require it at the top of your sketch: `local Sound = require("l5sound")`

### Method 2: Fork the repo and work!

This repository comes with a copy of the L5Starter along with the prototype l5sound library!

## Basic Usage

### Playing a Sound File

```lua
require("L5")
local Sound = require("l5sound")

local backgroundMusic

function setup()
  size(400, 300)
  -- Load and play a sound file
  backgroundMusic = Sound.SoundFile("path/to/your/sound.wav", "stream")
  backgroundMusic:play()
end

function draw()
  background(100)
  
  if backgroundMusic:isPlaying() then
    text("Now Playing", 20, 20)
  end
end
```

### Making a AudioSample (Sine Wave)

```lua
require("L5")
local Sound = require("l5sound")

function setup()
  size(640, 360)
  background(255)

  -- Create an array and manually write a single sine wave oscillation into it. 
  local resolution = 1000
  local sinewave = {}
  for i = 1, resolution do 
    sinewave[i] = math.sin(2 * math.pi * i / resolution )
  end
  
  -- Create the audiosample based on the data, set framerate to play 200 oscillations/second
  sample = Sound.AudioSample(sinewave, 200 * resolution)
  
  -- Play the sample in a loop (but don't make it too loud)
  sample:amp(0.2)
  sample:loop(true)
end

function draw()

end
```

## Implementation Plan

1. Inventory & Mapping Table: Finalize a detailed table of Processing Sound APIs vs Love2D equivalents. I’ve sketched this in [API Draft](api.md) and [Feature Mapping](featuremap.md)

2. Core playback classes: Implement L5.SoundFile using love.audio.newSource, test with example sketches (e.g. port a Processing Sound example that plays a file). Should be fairly straightforward as Love2D already supports alot of playback features natively, with the possible exception of AudioSample.resize() in Processing Sound, I haven't been able to figure a clean way to resize the audio sample other than reconstructing it everytime

3. Oscillators and Noise: Prototype a queueable sine oscillator. While there are no built-in waveform generators. we can recreate these by generating sample data manually. A sine example could be adapted from [Lee's Example](https://gist.github.com/lee2sman/e18b9bfd7e8c2eeb279ceca76e74a3b5): write code to fill a SoundData of e.g. 0.1s of 440 Hz wave, queue it repeatedly. Verify stable audio. Then encapsulate as L5.SinOsc class with freq(), amp(), etc. Do the same for all the other Oscillators/Noise

3. Effects: Wrap some Love effects. Test creating a delay or reverb in Love and applying to a sound. Then make L5.Delay class to simplify usage (e.g. L5.Delay.delay(timeSec), L5.Delay.feedback(f), and L5.Delay.process(source)). Effects are pretty well supported in Love2D, despite param differences in the Processing's Delay and Reverb compared to love.audio.setEffect(). A good example of how to implement these effects is documented in this example of ModularLove, a port of ModularPlay that has some great examples of these effects: [ModularLove](https://github.com/orllewin/love2d_modular_love?tab=readme-ov-file)

4. Filters: Use Source:setFilter({type=...}). Make L5.LowPass, etc., classes that take a source and call setFilter internally. Processing’s filters are more user-friendly (named classes with freq(), res()). In L5sound we would likely create analogous classes (e.g. L5.LowPass), but internally call source:setFilter({type="lowpass", ...}). The mapping of parameters is not one-to-one (Love uses filter gains rather than direct Q factor), so some translation logic is needed. AllPass (phase shift) has no direct equivalent; could be omitted or simulated by combining delays. In Love2D, Source:setFilter( settings ) seems to only supports three basic filters: HighPass, LowPass, and BandPass in a very limited way. You can only pass the volume, highgain and lowgain values through the "settings" table allowing little control. Researching [Sone - Love2D Sound Library](https://love2d.org/forums/viewtopic.php?t=82944) for more support to achieve feature parity

5. Audio input: Write an L5.AudioIn that starts recording, test with a simple VU meter (Amplitude analyzer) to verify microphone capture. Love2D 11.5 doesn't support access to playback devices yet (due for release in Love2D 12.0) in this [PR](https://github.com/love2d/love/pull/1805.) and [Issue]( https://github.com/love2d/love/issues/1537). We can possibly look at the implementation of access to playback devices in the mentioned PR for reference and implement our own version of it or wrap around/implement in a more native Processinglike way

6. Analysis (FFT, Amp): Integrate luafft library. For example, use love.sound.newDecoder(source):read() to get PCM data from a Source, or tap SoundData if static. if we're using [luafft library](https://github.com/h4rm/luafft), we might need to implement some sort of conversion? since luafft expects that the audio data be given as complex values

7. Documentation and Examples: For each feature ported, we should create L5 examples (mirroring Processing Sound examples), serving both as a test and tutorial. E.g. a sketch with an oscillator, a delay effect, an analyzer visual, etc.

8. Testing & Refinement: Test on all platforms (Windows, Mac, Linux) and older hardware.