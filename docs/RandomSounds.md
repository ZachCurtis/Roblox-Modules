# RandomSounds
A module for playing a random sound given an array of tables that match Sound instance properties.

## Methods

### Constructor
```lua
local randomSounds = randomSounds.new({
    {
        SoundId = "rbxassetid://1234567890",
        Volume = .4,
        RollOffMode = Enum.RollOffMode.LinearSquare
    },
    {
        SoundId = "rbxassetid://0987654321",
        Volume = .6,
        RollOffMode = Enum.RollOffMode.Inverse
    }
})
```

### MakeSounds
Call to create the Sound instances. Must be called before `RandomSounds:Play()`
```lua
randomSounds:MakeSounds()
```

### PlayRandomSound
Plays a random sound.
```lua
randomSounds:PlayRandomSound()
```

### Stop
Stops the currently playing sound
```lua
randomSounds:Stop()
```

### Disconnect
Cleans up the RBXScriptConnections used internally
```lua
randomSounds:Disconnect()
```

### Destroy
Destroys all sound instances, cleans up all RBXScriptConnections, and drops all references.
```lua
randomSounds:Destroy()
```