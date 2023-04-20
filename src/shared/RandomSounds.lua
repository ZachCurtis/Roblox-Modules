export type SoundData = {[number]: {[string]: unknown}}

local SoundService = game:GetService("SoundService")

---@class RandomSounds
local RandomSounds = {}
RandomSounds.__index = RandomSounds

---@param soundData SoundData an array of tables {[string]: unknown} matching Sound property names and types
---@param soundParent BasePart the basepart to parent the sound to for spatial playback, will use SoundService if not provided
---@return RandomSounds class
function RandomSounds.new(soundData: SoundData, soundParent: BasePart?)
    local self = setmetatable({}, RandomSounds)

    self.SoundParent = soundParent
    self.SoundData = soundData

    self.SoundsMade = false

    self.Sounds = {}
    self.CurrentlyPlaying = nil
    self.EndedConnection = nil

    self.Random = Random.new()

    return self
end

-- create the Sound instances given the provided SoundData table
function RandomSounds:MakeSounds()
    for _, soundProp in ipairs(self.SoundData) do
        local sound = Instance.new("Sound")

        for key: string, prop: unknown in pairs(soundProp) do
            sound[key] = prop
        end
        
        sound.Parent = self.SoundParent or SoundService

        table.insert(self.Sounds, sound)
    end

    self.SoundsMade = true
end

-- picks a random sound from the list and plays it
-- stopping the previous sound if already playing
function RandomSounds:PlayRandomSound()
    self:Stop()

    local ranIndex = self.Random:NextInteger(1, #self.Sounds)

    local randomSound = self.Sounds[ranIndex] :: Sound

    self.CurrentlyPlaying = randomSound

    self.EndedConnection = randomSound.Ended:Connect(function()
        self:Stop() -- forces cleanup and disconnect
    end)

    randomSound:Play()
end

function RandomSounds:Stop()
    if self.CurrentlyPlaying and self.CurrentlyPlaying.Playing then
        self.CurrentlyPlaying:Stop()
    end

    self.CurrentlyPlaying = nil

    self:Disconnect()
end

function RandomSounds:Disconnect()
    if self.EndedConnection and self.EndedConnection.Connected then
        self.EndedConnection:Disconnect()
        self.EndedConnection = nil
    end
end

function RandomSounds:Destroy()
    self:Stop()

    if not self.Sounds then return end
    
    for _, sound in ipairs(self.Sounds) do
        sound:Destroy()
    end

    self.Sounds = nil
end

return RandomSounds