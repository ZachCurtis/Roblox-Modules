# DamageToken
A module for tracking how much damage each player dealt to something. Useful for resolving who deserves the kill, as well as scaling experience awarded for assists.

## Methods

### Constructor
```lua
local damageToken = DamageToken.new()
```

### TakeDamage
How much damage to take, as well as who dealt it
```lua
damageToken:TakeDamage(damageAmount, dealingPlayer)
```

### Heal
How much health was gained. Removes damage dealt from the oldest DamageTokens
```lua
damageToken:Heal(healAmount)
```

### GetSummedTokens
Returns a sorted array of DamageTokens ({[number]: {Dealer: Player, Amount: number}}) that have been summed so only 1 token exists per dealing player
```lua
local summedTokens = damageToken:GetSummedTokens()
```

### GetKiller
Returns the player who dealt the most damage overall.
```lua
local killer = damageToken:GetKiller()
```

### GetKillerAndAssists
Returns an AlphaDamageToken array, sorted by most damage dealt. Matches the fields of the DamageToken syntax but includes a third field `AmountAlpha` which is the alpha value (number 0 - 1 where .5 is 50% and 1 is 100%) of how much damage total this player dealt. Useful for calculating assists.
```lua
local killerAndAssistsTokens = damageToken:GetKillerAndAssists()
```