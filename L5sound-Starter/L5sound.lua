-- L5sound Prototype 0.1.0 (c) 2026 Hoang Manh Quan
-- A Processing-style sound library for L5 

local Sound = {}
Sound.VERSION = "0.1.0"
local function getset(current, new)
  if new ~= nil then
    return new
  end
  return current
end

---------------------- SOUNDFILE ---------------------

local SoundFile = {}
SoundFile.__index = SoundFile

function SoundFile.new(path, mode)
  mode = mode or "static"
  
  local self = setmetatable({}, SoundFile)
  self._path = path
  self._mode = mode
  self._pan = 0
  
  local source = love.audio.newSource(path, mode)
  self._source = source
  
  return self
end

-- Playback control
function SoundFile:play()
  self._source:play()
  return self
end

function SoundFile:pause()
  self._source:pause()
  return self
end

function SoundFile:stop()
  self._source:stop()
  return self
end

function SoundFile:isPlaying()
  return self._source:isPlaying()
end

-- Volume / Amplitude
function SoundFile:amp(value)
  if value ~= nil then
    self._source:setVolume(value)
    return self
  end
  return self._source:getVolume()
end

-- Playback rate / pitch
function SoundFile:rate(value)
  if value ~= nil then
    self._source:setPitch(value)
    return self
  end
  return self._source:getPitch()
end

-- Panning: -1 (left) to 1 (right)
-- Love2D uses the x, y, z coordinates, so we need to map stereo pan to x coordinate
function SoundFile:pan(value)
  if value ~= nil then
    value = math.max(-1, math.min(1, value))
    self._pan = value
    -- Map to coords: x from -1 (left) to 1 (right), y = 0, z = 0
    self._source:setPosition(value, 0, 0)
    return self
  end
  return self._pan
end

-- Position / Playhead
function SoundFile:jump(seconds)
  self._source:seek(seconds)
  return self
end

function SoundFile:position()
  return self._source:tell()
end

function SoundFile:duration()
  return self._source:getDuration()
end

-- Looping
function SoundFile:loop(enable)
  if enable ~= nil then
    self._source:setLooping(enable)
    if enable then
      self:play()
    end
    return self
  end
  return self._source:isLooping()
end

-- Return underlying Love2D source (for advanced use and direct access to Source methods)
function SoundFile:getSource()
  return self._source
end

---------------------- AUDIOSAMPLE ---------------------

local AudioSample = {}
AudioSample.__index = AudioSample

function AudioSample.new(arg1, arg2, arg3)
  local self = setmetatable({}, AudioSample)
  self._pan = 0
  self._playForDuration = nil  -- For playFor() method
  
  -- Handle different constructor patterns:
  -- AudioSample(numFrames) - create empty buffer (number)
  -- AudioSample(numFrames, stereo) - (number, boolean)
  -- AudioSample(numFrames, stereo, frameRate) - (number, boolean, number)
  -- AudioSample(array, frameRate) - from sample array (table, number) [Processing-style]
  -- AudioSample(path) - from file (string)
  -- AudioSample(soundData) - from SoundData object
  
  if type(arg1) == "number" then
    -- Constructor: numFrames [, stereo [, frameRate]]
    local numFrames = arg1
    local stereo = arg2 or false
    local frameRate = arg3 or 44100
    local channels = stereo and 2 or 1
    
    self._soundData = love.sound.newSoundData(numFrames, frameRate, 16, channels)
    self._path = "buffer"
    
  elseif type(arg1) == "table" and type(arg2) == "number" then
    -- Constructor: array (table here in lua), frameRate 
    local sampleArray = arg1
    local frameRate = arg2
    local numFrames = #sampleArray
    
    self._soundData = love.sound.newSoundData(numFrames, frameRate, 16, 1)
    
    -- Fill buffer with sample data, quite tedious since Love2D SoundData doesn't support bulk writing, so we write sample by sample
    for i = 0, numFrames - 1 do
      self._soundData:setSample(i, sampleArray[i + 1] or 0)
    end
    
    self._path = "buffer"
    
  elseif type(arg1) == "string" then
    -- Constructor: path (loads from file)
    self._soundData = love.sound.newSoundData(arg1)
    self._path = arg1
    
  elseif arg1 and type(arg1.getSampleRate) == "function" then
    -- Constructor: SoundData object
    self._soundData = arg1
    self._path = "buffer"
    
  else
    error("AudioSample.new() requires: numFrames [, stereo [, frameRate]] OR array, frameRate OR path OR SoundData")
  end
  
  -- Create a Source from the SoundData (always static mode)
  self._source = love.audio.newSource(self._soundData)
  
  return self
end

-- Playback control
function AudioSample:play()
  self._source:play()
  return self
end

function AudioSample:pause()
  self._source:pause()
  return self
end

function AudioSample:stop()
  self._source:stop()
  return self
end

function AudioSample:isPlaying()
  return self._source:isPlaying()
end

-- Volume / Amplitude
function AudioSample:amp(value)
  if value ~= nil then
    self._source:setVolume(value)
    return self
  end
  return self._source:getVolume()
end

-- Playback rate / pitch
function AudioSample:rate(value)
  if value ~= nil then
    self._source:setPitch(value)
    return self
  end
  return self._source:getPitch()
end

-- Panning: -1 (left) to 1 (right)
function AudioSample:pan(value)
  if value ~= nil then
    value = math.max(-1, math.min(1, value))
    self._pan = value
    self._source:setPosition(value, 0, 0)
    return self
  end
  return self._pan
end

-- Position / Playhead
function AudioSample:jump(seconds)
  self._source:seek(seconds)
  return self
end

function AudioSample:position()
  return self._source:tell()
end

function AudioSample:duration()
  return self._source:getDuration()
end

-- Looping
function AudioSample:loop(enable)
  if enable ~= nil then
    self._source:setLooping(enable)
    if enable then
      self:play()
    end
    return self
  end
  return self._source:isLooping()
end

-- Sample data access
function AudioSample:sampleRate()
  return self._soundData:getSampleRate()
end

function AudioSample:channels()
  return self._soundData:getChannelCount()
end

function AudioSample:duration()
  return self._source:getDuration()
end

function AudioSample:frames()
  -- Duration in frames = duration in seconds * sample rate
  return math.floor(self:duration() * self:sampleRate())
end

-- Cue methods (alias for jump to specific positions)
function AudioSample:cue(seconds)
  self._source:seek(seconds)
  return self
end

function AudioSample:cueFrame(frameIndex)
  local seconds = frameIndex / self:sampleRate()
  self._source:seek(seconds)
  return self
end

function AudioSample:jumpFrame(frameIndex)
  self:cueFrame(frameIndex)
  return self
end

-- Play for a specific duration then stop
function AudioSample:playFor(duration)
  self:play()
  self._playForDuration = duration
  return self
end

-- Set multiple parameters at once
function AudioSample:set(amp, rate, pan, loop)
  if amp ~= nil then self:amp(amp) end
  if rate ~= nil then self:rate(rate) end
  if pan ~= nil then self:pan(pan) end
  if loop ~= nil then self:loop(loop) end
  return self
end

-- Position in frames
function AudioSample:positionFrame()
  return math.floor(self:position() * self:sampleRate())
end

-- Position as percentage (0-100)
function AudioSample:percent()
  return (self:position() / self:duration()) * 100
end

-- Read sample data (0-based index)
function AudioSample:read(index)
  if type(index) ~= "number" or index < 0 or index >= self:frames() then
    error("AudioSample:read() index out of bounds: " .. tostring(index))
  end
  return self._soundData:getSample(index)
end

-- Write sample data 
function AudioSample:write(index, value)
  if type(index) ~= "number" or index < 0 or index >= self:frames() then
    error("AudioSample:write() index out of bounds: " .. tostring(index))
  end
  if type(value) ~= "number" then
    error("AudioSample:write() value must be a number")
  end
  self._soundData:setSample(index, value)
  return self
end

-- Return the underlying SoundData (for advanced use and direct access to PCM data) 
function AudioSample:getSoundData()
  return self._soundData
end

-- Return underlying Love2D source (for advanced use and direct access to Source methods)
function AudioSample:getSource()
  return self._source
end

---------------------- GLOBAL SOUND CONFIGURATION ---------------------

local SoundConfig = {}

function SoundConfig.volume(value)
  if value ~= nil then
    love.audio.setVolume(value)
    return value
  end
  return love.audio.getVolume()
end

function SoundConfig.sampleRate()
  -- NOT IMPLEMENTED YET
  -- Love2D might not expose this directly, but we can derive from SoundData
  return 44100  -- Standard fallback; could be queried from active sources
end

function SoundConfig.inputDevice(index)
  index = index or 1
  local devices = love.audio.getRecordingDevices()
  if devices and #devices > 0 then
    return devices[index]
  end
  return nil
end

function SoundConfig.outputDevice(index)
  -- NOT YET IMPLEMENTED: Love2D 11.5 does not currently support access to output/playback devices
  -- Love2D 12 does however
end

---------------------- PUBLIC API ---------------------

Sound.SoundFile = SoundFile
Sound.AudioSample = AudioSample
Sound.Config = SoundConfig

-- Constructors for Convenience :D (can call without .new) 
function Sound.SoundFile(path, mode)
  return SoundFile.new(path, mode)
end

function Sound.AudioSample(arg1, arg2, arg3)
  return AudioSample.new(arg1, arg2, arg3)
end

return Sound
