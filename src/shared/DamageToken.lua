--!strict

-- DamageTokens class
-- Stores damage dealt by player
-- Used to determine who dealt the most damage and should be awarded the kill

export type DamageToken = {
    Dealer: number,
    Amount: number
}

export type AlphaDamageToken = {
    Dealer: number,
    Amount: number,
    AmountAlpha: number
}

export type DamageTokens = {
    [number]: DamageToken
}

---@class DamageToken
local DamageToken = {}
DamageToken.__index = DamageToken

---@return DamageToken class
function DamageToken.new()
    local self = setmetatable({}, DamageToken)

    self.Tokens = {} :: DamageTokens-- {[number]: {Dealer: Player, Amount: number}}
    
    return self
end

---@param damageAmount number how much damage was dealt
---@param damageDealer Player the player dealing the damage
function DamageToken:TakeDamage(damageAmount: number, damageDealer: Player)
    if #self.Tokens > 0 and self.Tokens[#self.Tokens].Dealer == damageDealer then
        self.Tokens[#self.Tokens].Amount += damageAmount
    else
        table.insert(self.Tokens, {
            Dealer = damageDealer,
            Amount = damageAmount
        })
    end
end

---@param healAmount number the amount of health gained; removes damage from oldest tokens
function DamageToken:Heal(healAmount: number)
    local healRemaining = healAmount

    if #self.Tokens == 0 then
        warn("No Damage Tokens to remove damage from")

        return
    end

    repeat
        local firstToken = self.Tokens[1]

        if firstToken.Amount <= healRemaining then
            healRemaining -= firstToken.Amount
            table.remove(self.Tokens, 1)
        else
            firstToken.Amount -= healRemaining
            healRemaining = 0
        end

    until healRemaining == 0
end

-- Sums the damage tokens as they're stored in order by time.
-- Returns an array of damage tokens in the same format as self.Tokens
-- {[number]: {Dealer: Player, Amount: number}}
function DamageToken:GetSummedTokens(): DamageTokens
    local summedDamageAmounts = {}

    local function getTokenByDealer(damageDealer: Player)
        for _, token in ipairs(summedDamageAmounts) do
            if token.Dealer == damageDealer then
                return token
            end
        end

        local newSummedToken = {Dealer = damageDealer, Amount = 0}

        table.insert(summedDamageAmounts, newSummedToken)

        return newSummedToken
    end
    
    for _, token in ipairs(self.Tokens) do
        local summedToken = getTokenByDealer(token.Dealer)
        summedToken.Amount += token.Amount
    end

    table.sort(summedDamageAmounts, function(a, b)
        return a.Amount < b.Amount
    end)

    return summedDamageAmounts
end

---@return killer Player the player who dealt the most amount of damage
function DamageToken:GetKiller(): Player
    local summedDamageAmounts = self:GetSummedTokens()

    return summedDamageAmounts[1].Dealer
end

---@return sortedTokens table including Amount and AmountAlpha (for calculating assists)
function DamageToken:GetKillerAndAssists(): {[number]: AlphaDamageToken}
    local summedDamageAmounts = self:GetSummedTokens()

    local totalDamage = 0

    for _, token in ipairs(summedDamageAmounts) do
        totalDamage += token.Amount
    end

    for _, token in ipairs(summedDamageAmounts) do
        token.AmountAlpha = totalDamage / token.Amount
    end

    return summedDamageAmounts
end

return DamageToken