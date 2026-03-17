--[[
    AudioSample.

    This is an AudioSample player which allows to play back and manipulate audio samples.
    
    If you want to pre-load your audio sample with an audio file from disk you can do so 
    using the SoundFile subclass.

    Adapted from https://processing.org/reference/libraries/sound/AudioSample.html
]]

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