# Roblox Development Best Practices

This guide covers best practices for Roblox game development, with a focus on patterns validated by Roblox Game Studios.

## 📋 Table of Contents

- [Server/Client Architecture](#serverclient-architecture)
- [DataStore Patterns](#datastore-patterns)
- [RemoteEvent Design](#remoteevent-design)
- [Performance Optimization](#performance-optimization)
- [Code Organization](#code-organization)
- [Game Design](#game-design)
- [Testing](#testing)

---

## Server/Client Architecture

### The Golden Rule

**Server modifies logic. Client modifies visuals.**

```lua
-- ✅ Correct: Server calculates, client displays
-- Server (ServerScript)
local function updateScore(player, points)
    local newScore = playerData[player.UserId].score + points
    playerData[player.UserId].score = newScore
    
    -- Send to client
    RemoteEvent:FireClient(player, "ScoreUpdated", newScore)
end

-- Client (LocalScript)
RemoteEvent.OnClientEvent:Connect(function(event, data)
    if event == "ScoreUpdated" then
        -- Update UI only
        scoreLabel.Text = tostring(data)
    end
end)

-- ❌ Wrong: Server modifies visual (syncs to ALL clients)
-- Server
part.Color = Color3.new(1, 0, 0)  -- ALL players see this!
```

### Why This Matters

When the server changes a property on a Part, **all clients see the change**. This is by design in Roblox's networking model. For per-player effects (like unlocking walls), you must:

1. Server sends RemoteEvent to specific player
2. Client receives event
3. Client modifies local visual

```lua
-- Server: Notify specific player
ZoneWallRemote:FireClient(player, "WallUnlocked", wallId)

-- Client: Hide wall locally
ZoneWallRemote.OnClientEvent:Connect(function(event, data)
    if event == "WallUnlocked" then
        local wall = workspace.MapExtras["qiang" .. data]
        if wall and wall:IsA("BasePart") then
            wall.Transparency = 1
        end
    end
end)
```

### Server Responsibilities

- ✅ Game logic (damage, rewards, progression)
- ✅ Data persistence (DataStore)
- ✅ Anti-cheat validation
- ✅ State management
- ❌ Visual effects (use RemoteEvent)
- ❌ UI updates (use RemoteEvent)

### Client Responsibilities

- ✅ Visual effects (particles, animations)
- ✅ UI updates (labels, buttons)
- ✅ Input handling (mouse, keyboard, touch)
- ✅ Local sound effects
- ❌ Game logic (can be cheated)
- ❌ Data persistence (server only)

---

## DataStore Patterns

### Always Use Retry

```lua
-- ✅ Correct: Retry mechanism
local function retrySetAsync(key, data, maxRetries)
    maxRetries = maxRetries or 3
    
    for i = 1, maxRetries do
        local success, err = pcall(function()
            DataStore:SetAsync(key, data)
        end)
        
        if success then
            return true
        end
        
        warn("SetAsync failed, attempt", i, ":", err)
        
        if i < maxRetries then
            task.wait(1) -- Wait before retry
        end
    end
    
    return false
end

-- ❌ Wrong: No retry, no error handling
DataStore:SetAsync(key, data)  -- May fail silently
```

### Handle Session Lock

```lua
-- ✅ Correct: Session Lock implementation
local function loadPlayerData(player)
    local key = "Player_" .. player.UserId
    
    local success, data = pcall(function()
        return DataStore:GetAsync(key)
    end)
    
    if not success then
        warn("Failed to load data for", player.Name)
        return createDefaultData()
    end
    
    -- Check session lock
    if data and data.serverId then
        if data.serverId ~= game.JobId then
            -- Player is in another server
            warn("Player", player.Name, "is in another server")
            return nil -- Will kick player
        end
    end
    
    -- Set session lock
    data = data or createDefaultData()
    data.serverId = game.JobId
    
    return data
end
```

### BindToClose

```lua
-- ✅ Correct: Save all data on server shutdown
game:BindToClose(function()
    print("Server shutting down, saving all player data...")
    
    local saveTasks = {}
    
    for userId, data in pairs(playerData) do
        table.insert(saveTasks, task.spawn(function()
            retrySetAsync("Player_" .. userId, data, 5)
        end))
    end
    
    -- Wait for all saves to complete
    for _, task in ipairs(saveTasks) do
        task.wait()
    end
    
    print("All player data saved")
end)
```

### Data Size Limits

- **Single request**: 4MB maximum
- **Key length**: 50 characters maximum
- **Request rate**: 60 requests/minute per player

```lua
-- ✅ Good: Compact data structure
local playerData = {
    s = 0,           -- score (short name)
    e = 0,           -- ep
    u = {1,1,1,1},   -- upgrades
    v = {0,0,0,0,0,0}, -- evolutions
    w = {},          -- unlocked walls
    r = 0,           -- total resets
}

-- ❌ Bad: Verbose data structure
local playerData = {
    score = 0,
    evolutionPoints = 0,
    upgrades = {
        range = 1,
        multiplier = 1,
        field = 1,
        launch = 1,
    },
    -- ... much larger
}
```

---

## RemoteEvent Design

### Clear Event Names

```lua
-- ✅ Good: Descriptive names
RemoteEvent:FireClient(player, "ScoreUpdated", newScore)
RemoteEvent:FireClient(player, "BossSpawned", bossData)
RemoteEvent:FireClient(player, "WallUnlocked", wallId)

-- ❌ Bad: Generic names
RemoteEvent:FireClient(player, "Update", data)
RemoteEvent:FireClient(player, "Event", payload)
RemoteEvent:FireClient(player, "Message", content)
```

### Validate Client Input

```lua
-- ✅ Good: Server validates all client input
RemoteEvent.OnServerEvent:Connect(function(player, action, data)
    -- Validate action
    if not validActions[action] then
        warn("Invalid action from", player.Name, ":", action)
        return
    end
    
    -- Validate data
    if action == "PurchaseUpgrade" then
        if not data or not data.upgradeId then
            warn("Missing upgradeId from", player.Name)
            return
        end
        
        if not validatePurchase(player, data.upgradeId) then
            warn("Invalid purchase from", player.Name)
            return
        end
        
        -- Process purchase
        processPurchase(player, data.upgradeId)
    end
end)

-- ❌ Bad: Trust client data
RemoteEvent.OnServerEvent:Connect(function(player, action, data)
    -- No validation!
    if action == "PurchaseUpgrade" then
        processPurchase(player, data.upgradeId)  -- data could be fake
    end
end)
```

### Rate Limiting

```lua
-- ✅ Good: Rate limit RemoteEvent calls
local lastCallTime = {}
local CALL_COOLDOWN = 0.1 -- 100ms

RemoteEvent.OnServerEvent:Connect(function(player, action, data)
    local now = tick()
    local lastCall = lastCallTime[player.UserId] or 0
    
    if now - lastCall < CALL_COOLDOWN then
        warn("Rate limited:", player.Name)
        return
    end
    
    lastCallTime[player.UserId] = now
    
    -- Process action
    handleAction(player, action, data)
end)
```

---

## Performance Optimization

### Cache Frequently Accessed Values

```lua
-- ✅ Good: Cache services and values
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local config = require(ReplicatedStorage.GameConfig)
local heartbeat = RunService.Heartbeat

-- ❌ Bad: GetService every frame
RunService.Heartbeat:Connect(function()
    local config = require(game:GetService("ReplicatedStorage").GameConfig)
    -- ...
end)
```

### Avoid Allocations in Hot Paths

```lua
-- ✅ Good: Reuse tables
local partsCache = {}

local function getPartsInRadius(position, radius)
    table.clear(partsCache)
    
    local overlapParams = OverlapParams.new()
    overlapParams.FilterType = Enum.RaycastFilterType.Include
    overlapParams.FilterDescendantsInstances = {workspace.Objects}
    
    workspace:GetPartsInPart(hitbox, partsCache)
    
    return partsCache
end

-- ❌ Bad: Allocate new table every call
local function getPartsInRadius(position, radius)
    local parts = {} -- New allocation every call!
    
    -- ... fill parts
    
    return parts
end
```

### Use Appropriate Wait Methods

```lua
-- ✅ Good: Use task.wait()
task.wait(1) -- Waits 1 second

-- ❌ Bad: Use wait() (deprecated)
wait(1) -- Deprecated, less precise

-- ✅ Good: Use task.spawn for parallel work
task.spawn(function()
    -- Runs in parallel
end)

-- ❌ Bad: Use coroutine.wrap (less reliable)
coroutine.wrap(function()
    -- Less reliable
end)()
```

### Memory Management

```lua
-- ✅ Good: Clean up connections
local connection
connection = heartbeat:Connect(function()
    -- ...
end)

-- Later, when done:
connection:Disconnect()
connection = nil

-- ✅ Good: Use Destroy() for instances
local part = Instance.new("Part")
-- Later:
part:Destroy() -- Cleans up all connections

-- ❌ Bad: Leave connections open
heartbeat:Connect(function()
    -- This connection lives forever!
end)
```

---

## Code Organization

### Module Pattern

```lua
-- ✅ Good: Clear module structure
local PlayerManager = {}
PlayerManager.__index = PlayerManager

function PlayerManager.new(player)
    local self = setmetatable({}, PlayerManager)
    self.player = player
    self.data = nil
    self.connections = {}
    return self
end

function PlayerManager:loadData()
    -- Load data
end

function PlayerManager:saveData()
    -- Save data
end

function PlayerManager:destroy()
    -- Clean up
    for _, conn in ipairs(self.connections) do
        conn:Disconnect()
    end
end

return PlayerManager

-- ❌ Bad: Global functions
function loadPlayerData(player)
    -- ...
end

function savePlayerData(player)
    -- ...
end
```

### Naming Conventions

```lua
-- Variables: camelCase
local playerHealth = 100
local maxEnemies = 50

-- Constants: UPPER_SNAKE_CASE
local MAX_HEALTH = 100
local BOSS_DAMAGE = 20

-- Functions: camelCase (verbs)
local function calculateDamage(base, multiplier)
    return base * multiplier
end

-- Classes: PascalCase
local PlayerManager = {}
local EnemyController = {}

-- Boolean variables: is/has/can prefix
local isAlive = true
local hasShield = false
local canJump = true
```

### File Organization

```
src/
├── server/
│   ├── GameManager.server.lua     -- Main server script
│   ├── DataStoreManager.lua       -- Data persistence
│   ├── PVPSystem.lua              -- Combat system
│   └── ...
├── client/
│   ├── PlayerController.client.lua -- Main client script
│   ├── UI/
│   │   ├── HUD.lua
│   │   ├── Menu.lua
│   │   └── ...
│   └── ...
├── shared/
│   ├── GameConfig.lua             -- All game values
│   ├── Constants.lua              -- Shared constants
│   └── ...
└── modules/
    ├── PlayerManager.lua
    ├── EnemyManager.lua
    └── ...
```

---

## Game Design

### Data-Driven Design

```lua
-- ✅ Good: All values in config
-- GameConfig.lua
local GameConfig = {
    Boss = {
        health = 1000,
        damage = 20,
        speed = 16,
        spawnInterval = {600, 900},
    },
    
    Player = {
        baseHealth = 100,
        baseSpeed = 16,
        baseDamage = 20,
    },
}

-- Usage
local bossHealth = config.Boss.health

-- ❌ Bad: Hardcoded values
local bossHealth = 1000  -- Why 1000? Who changes it?
```

### Formula Documentation

```lua
-- ✅ Good: Documented formulas
-- Score calculation formula:
-- score = base × (1 + itemBonus) × (1 + multUp) × (1 + evoTouch) × eventMult × vipMult
--
-- Variables:
--   base: Base score from object (1-100)
--   itemBonus: Item bonus multiplier (0-0.5)
--   multUp: Upgrade multiplier (0-2.0)
--   evoTouch: Evolution touch bonus (0-1.0)
--   eventMult: Event multiplier (0.5-3.0)
--   vipMult: VIP multiplier (1.0-2.0)
--
-- Expected range: 0.5 to 600
-- Edge case: Cap at 1000 to prevent overflow

local function calculateScore(data, object, eventMult)
    local base = object.baseScore or 1
    local itemBonus = object.itemBonus or 0
    local multUp = getUpgradeMultiplier(data.upgrades.multiplier)
    local evoTouch = getEvolutionBonus(data.evolutions.finger)
    local vipMult = data.isVIP and 1.5 or 1.0
    
    local score = base * (1 + itemBonus) * (1 + multUp) * (1 + evoTouch) * eventMult * vipMult
    
    return math.min(math.floor(score), 1000) -- Cap at 1000
end

-- ❌ Bad: Undocumented formula
local function calculateScore(data, object, eventMult)
    return object.baseScore * (1 + object.itemBonus) * -- ... what?
end
```

### Edge Case Handling

```lua
-- ✅ Good: Handle edge cases explicitly
local function divideResources(total, players)
    -- Edge case: No players
    if not players or #players == 0 then
        return 0
    end
    
    -- Edge case: Zero total
    if total <= 0 then
        return 0
    end
    
    -- Edge case: More players than resources
    if #players > total then
        -- Give 1 to each, rest to first player
        local perPlayer = math.floor(total / #players)
        local remainder = total % #players
        
        for i, player in ipairs(players) do
            local amount = perPlayer + (i <= remainder and 1 or 0)
            giveResource(player, amount)
        end
        
        return total
    end
    
    -- Normal case
    local perPlayer = math.floor(total / #players)
    for _, player in ipairs(players) do
        giveResource(player, perPlayer)
    end
    
    return total
end

-- ❌ Bad: No edge case handling
local function divideResources(total, players)
    local perPlayer = total / #players -- Division by zero if no players!
    for _, player in ipairs(players) do
        giveResource(player, perPlayer)
    end
end
```

---

## Testing

### Unit Testing

```lua
-- ✅ Good: Unit tests for core functions
local function testScoreCalculation()
    -- Test case 1: Normal calculation
    local data = {upgrades = {multiplier = 1}, evolutions = {finger = 0}}
    local object = {baseScore = 10, itemBonus = 0}
    local eventMult = 1.0
    
    local score = calculateScore(data, object, eventMult)
    assert(score == 10, "Expected 10, got " .. score)
    
    -- Test case 2: With bonuses
    data.upgrades.multiplier = 2
    object.itemBonus = 0.5
    eventMult = 2.0
    
    score = calculateScore(data, object, eventMult)
    assert(score == 60, "Expected 60, got " .. score)
    
    -- Test case 3: Edge case - zero base
    object.baseScore = 0
    score = calculateScore(data, object, eventMult)
    assert(score == 0, "Expected 0, got " .. score)
    
    print("✓ testScoreCalculation passed")
end

-- Run tests
local function runAllTests()
    testScoreCalculation()
    -- Add more tests
    print("All tests passed!")
end

runAllTests()
```

### Integration Testing

```lua
-- ✅ Good: Test module interactions
local function testBossCombatIntegration()
    -- Setup
    local player = createTestPlayer()
    local boss = createTestBoss()
    
    -- Test: Player hits boss
    local damage = calculateDamage(player, boss)
    boss.health = boss.health - damage
    
    assert(boss.health < boss.maxHealth, "Boss should take damage")
    
    -- Test: Boss dies
    boss.health = 0
    local rewards = calculateRewards(boss, player)
    
    assert(rewards.score > 0, "Should get score reward")
    assert(rewards.ep > 0, "Should get EP reward")
    
    print("✓ testBossCombatIntegration passed")
end
```

### Performance Testing

```lua
-- ✅ Good: Performance benchmarks
local function benchmarkScoreCalculation()
    local iterations = 10000
    local startTime = tick()
    
    for i = 1, iterations do
        calculateScore(testData, testObject, 1.0)
    end
    
    local endTime = tick()
    local duration = endTime - startTime
    
    print(string.format("Score calculation: %.2f μs per call", 
        (duration / iterations) * 1000000))
    
    -- Should be < 1 μs per call
    assert(duration / iterations < 0.000001, "Too slow!")
end
```

---

## Checklist

Before shipping, verify:

### Server/Client
- [ ] Server never modifies visual properties
- [ ] Client never makes trust decisions
- [ ] RemoteEvent protocols documented
- [ ] Anti-cheat validation implemented

### DataStore
- [ ] Retry mechanism on all operations
- [ ] Session Lock implemented
- [ ] BindToClose saves all data
- [ ] Data size < 4MB

### Performance
- [ ] No allocations in hot paths
- [ ] Services cached
- [ ] Connections cleaned up
- [ ] FPS ≥ 60

### Code Quality
- [ ] No hardcoded values
- [ ] Formulas documented
- [ ] Edge cases handled
- [ ] Error handling complete

### Testing
- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] Performance benchmarks pass
- [ ] Manual testing complete

---

## Resources

- [Roblox Developer Hub](https://create.roblox.com/docs)
- [Luau Language Reference](https://luau-lang.org)
- [Roblox API Reference](https://create.roblox.com/docs/reference/engine)
- [Roblox Best Practices](https://create.roblox.com/docs/scripting/scripts/best-practices)

---

**Remember**: These are guidelines, not rules. Adapt them to your project's needs. The goal is **quality code** that's **maintainable**, **performant**, and **secure**.
