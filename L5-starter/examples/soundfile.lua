--[[
    SoundFile.

    This is a Soundfile player which allows to play back and manipulate sound files. 

    Adapted from https://processing.org/reference/libraries/sound/SoundFile.html
]]

require("L5")
local Sound = require("l5sound")

function setup()
  size(640, 360)
  -- Load a soundfile from the current directory and play it back
  file = Sound.SoundFile("assets/sample.wav")
  file:play()
end

function draw()

end