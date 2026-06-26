# Usage Examples

Real-world examples of using Roblox Game Studios in Roblox development projects.

## 📋 Table of Contents

- [Example 1: Boss Combat System](#example-1-boss-combat-system)
- [Example 2: Economy System](#example-2-economy-system)
- [Example 3: DataStore Migration](#example-3-datastore-migration)
- [Example 4: Performance Optimization](#example-4-performance-optimization)
- [Example 5: Code Review](#example-5-code-review)

---

## Example 1: Boss Combat System

### Scenario

You want to design and implement a Boss Combat system for your Roblox game.

### Step 1: Create GDD

```bash
# Copy GDD template
cp templates/gdd-template.md design/gdd/boss-combat.md

# Fill in the design
# Or use AI skill: /roblox-gdd boss-combat
```

**Key sections to fill:**
- Player Fantasy: "Feel like heroic warriors taking down a powerful foe"
- Detailed Rules: Boss spawns, attack patterns, damage calculation
- Formulas: Boss damage, player damage, kill rewards
- Edge Cases: Multiple players, server shutdown, anti-cheat
- Tuning Knobs: HP, damage, spawn interval, rewards

See [examples/gdd-boss-combat.md](../examples/gdd-boss-combat.md) for a complete example.

### Step 2: Review Design

```bash
# Review the GDD
/roblox-design-review design/gdd/boss-combat.md
```

**Review checks:**
- ✅ All required sections present
- ✅ Formulas complete with variable tables
- ✅ Edge cases documented
- ✅ Roblox-specific considerations included

### Step 3: Record Architecture Decision

```bash
# Record state machine decision
/roblox-adr boss-state-machine
```

**Decision:**
- Use state machine for boss AI (Idle → Patrol → Chase → Attack → Dead)
- Server-authoritative (all logic on server)
- RemoteEvent for client notifications

### Step 4: Implement Code

```lua
-- GameConfig.lua
local GameConfig = {
    Boss = {
        health = 1000,
        damage = 20,
        speed = 16,
        spawnInterval = {600, 900}, -- 10-15 minutes
        killReward = 2000,
        participationReward = 50,
    },
}

-- BossManager.lua
local BossManager = {}
BossManager.__index = BossManager

local BossState = {
    IDLE = "Idle",
    PATROL = "Patrol",
    CHASE = "Chase",
    ATTACK = "Attack",
    DEAD = "Dead",
}

function BossManager.new()
    local self = setmetatable({}, BossManager)
    self.state = BossState.IDLE
    self.health = GameConfig.Boss.health
    self.boss = nil
    return self
end

function BossManager:spawn(position)
    -- Create boss model
    self.boss = createBossModel()
    self.boss:PivotTo(CFrame.new(position))
    self.boss.Parent = workspace
    
    -- Set state
    self.state = BossState.IDLE
    self.health = GameConfig.Boss.health
    
    -- Notify clients
    RemoteEvent:FireAllClients("BossSpawned", {
        position = position,
        health = self.health,
    })
end

function BossManager:takeDamage(damage, player)
    -- Validate damage
    if damage <= 0 then return end
    
    -- Apply damage
    self.health = self.health - damage
    
    -- Notify clients
    RemoteEvent:FireAllClients("BossDamaged", {
        health = self.health,
        damage = damage,
        player = player.Name,
    })
    
    -- Check death
    if self.health <= 0 then
        self:onDeath(player)
    end
end

function BossManager:onDeath(killer)
    -- Calculate rewards
    local killReward = GameConfig.Boss.killReward
    local participationReward = GameConfig.Boss.participationReward
    
    -- Give kill reward
    giveScore(killer, killReward)
    
    -- Give participation rewards
    for _, player in ipairs(getParticipants()) do
        if player ~= killer then
            giveScore(player, participationReward)
        end
    end
    
    -- Drop loot
    dropLoot(self.boss:GetPivot().Position)
    
    -- Notify clients
    RemoteEvent:FireAllClients("BossKilled", {
        killer = killer.Name,
        killReward = killReward,
        participationReward = participationReward,
    })
    
    -- Clean up
    self:destroy()
end

function BossManager:destroy()
    if self.boss then
        self.boss:Destroy()
        self.boss = nil
    end
    
    self.state = BossState.DEAD
end

return BossManager
```

### Step 5: Review Code

```bash
# Review the implementation
/roblox-code-review src/BossManager.lua
```

**Review findings:**
- ✅ Server-authoritative (all logic on server)
- ✅ RemoteEvent notifications (not direct property changes)
- ✅ Error handling (validate damage, check death)
- ⚠️ Missing: Rate limiting on damage requests
- ⚠️ Missing: Anti-cheat validation

### Step 6: Check Balance

```bash
# Check boss balance
/roblox-balance-check boss
```

**Balance check results:**
- Boss HP: 1000 (healthy)
- Boss Damage: 20 (healthy)
- Kill Reward: 2000 (healthy)
- Participation Reward: 50 (healthy)
- Edge case: Boss too easy with 5+ players → Consider scaling

---

## Example 2: Economy System

### Scenario

You want to design and balance your game's economy system.

### Step 1: Create Economy Model

```bash
# Copy economy template
cp templates/economy-template.md design/economy/economy-model.md

# Fill in the model
# Or use AI skill: /roblox-economy economy
```

**Key sections:**
- Currencies: Score (soft), EP (progression)
- Sources: Touch objects, kill boss, refine reset
- Sinks: Upgrades, evolutions, wall unlocks
- Balance Targets: Time to first purchase, hourly earn rate
- Progression Curves: Upgrade costs, EP allocation

### Step 2: Validate with Balance Check

```bash
# Check economy balance
/roblox-balance-check economy
```

**Balance check findings:**

| Metric | Expected | Actual | Status |
|--------|----------|--------|--------|
| Time to first upgrade | 10 minutes | 8 minutes | ✅ Good |
| Hourly earn rate (mid-game) | 1000/hr | 1200/hr | ⚠️ Slightly high |
| EP per refine | 10-50 | 15-45 | ✅ Good |
| Sink/source ratio | 0.7-0.9 | 0.8 | ✅ Good |

**Recommendations:**
- Reduce base score from 10 to 8 (lowers hourly earn rate)
- Add more sinks (cosmetic shop, prestige upgrades)

### Step 3: Adjust and Re-check

```lua
-- GameConfig.lua - Adjusted values
local GameConfig = {
    Objects = {
        baseScore = 8, -- Reduced from 10
    },
    
    Economy = {
        -- Add new sinks
        cosmeticShop = {
            enabled = true,
            items = {...},
        },
    },
}
```

```bash
# Re-check balance
/roblox-balance-check economy
```

**New results:**
- Hourly earn rate: 960/hr ✅ (within target)
- Sink/source ratio: 0.85 ✅ (within target)

---

## Example 3: DataStore Migration

### Scenario

You need to add a new field to player data without breaking existing saves.

### Step 1: Record Architecture Decision

```bash
# Record migration strategy
/roblox-adr data-migration-strategy
```

**Decision:**
- Use `migrateData()` function
- Add default values for new fields
- Backward compatible (old data still works)
- No forced reset

### Step 2: Implement Migration

```lua
-- DataStoreManager.lua
local CURRENT_VERSION = 2

local function migrateData(data)
    -- Version 1 → 2: Add lastBurstTime
    if not data.version or data.version < 2 then
        data.lastBurstTime = 0
        data.totalBaseScore = 0
        data.vipScoreMultiplier = 1
        data.version = 2
    end
    
    -- Future migrations go here
    -- if data.version < 3 then
    --     -- migrate to v3
    --     data.version = 3
    -- end
    
    return data
end

local function loadPlayerData(player)
    local key = "Player_" .. player.UserId
    
    local success, data = pcall(function()
        return DataStore:GetAsync(key)
    end)
    
    if not success then
        warn("Failed to load data for", player.Name)
        return createDefaultData()
    end
    
    -- Apply migrations
    if data then
        data = migrateData(data)
    else
        data = createDefaultData()
    end
    
    return data
end
```

### Step 3: Test Migration

```lua
-- Test migration function
local function testMigration()
    -- Test: Old data (version 1)
    local oldData = {
        score = 1000,
        ep = 50,
        upgrades = {1, 1, 1, 1},
        evolutions = {0, 0, 0, 0, 0, 0},
    }
    
    local migrated = migrateData(oldData)
    
    assert(migrated.lastBurstTime == 0, "Should add lastBurstTime")
    assert(migrated.totalBaseScore == 0, "Should add totalBaseScore")
    assert(migrated.version == 2, "Should update version")
    
    -- Test: New data (version 2)
    local newData = {
        score = 2000,
        ep = 100,
        upgrades = {2, 1, 1, 1},
        evolutions = {1, 0, 0, 0, 0, 0},
        lastBurstTime = 123456,
        totalBaseScore = 5000,
        version = 2,
    }
    
    migrated = migrateData(newData)
    assert(migrated.lastBurstTime == 123456, "Should preserve existing value")
    assert(migrated.version == 2, "Should not change version")
    
    print("✓ Migration tests passed")
end

testMigration()
```

### Step 4: Deploy and Monitor

```bash
# Check for any issues
/roblox-balance-check economy

# Monitor DataStore errors
-- Add logging for migration failures
if not success then
    warn("Migration failed for", player.Name, ":", err)
    Analytics:reportError("MigrationFailed", {
        player = player.UserId,
        error = err,
    })
end
```

---

## Example 4: Performance Optimization

### Scenario

Your game has FPS drops when many objects are on screen.

### Step 1: Profile the Problem

```bash
# Use performance check
/roblox-balance-check performance
```

**Findings:**
- Part count: 2500 (exceeds 1700 budget)
- FPS: 45 (below 60 target)
- Hot path: `getPartsInRadius()` allocating 100 tables/frame

### Step 2: Optimize

```lua
-- ❌ Before: Allocate new table every frame
local function getPartsInRadius(position, radius)
    local parts = {} -- New allocation!
    
    for _, part in ipairs(workspace:GetPartBoundsInRadius(position, radius)) do
        table.insert(parts, part)
    end
    
    return parts
end

-- ✅ After: Reuse table
local partsCache = {}

local function getPartsInRadius(position, radius)
    table.clear(partsCache) -- Reuse table
    
    local overlapParams = OverlapParams.new()
    overlapParams.FilterType = Enum.RaycastFilterType.Include
    overlapParams.FilterDescendantsInstances = {workspace.Objects}
    
    workspace:GetPartBoundsInRadius(position, radius, overlapParams, partsCache)
    
    return partsCache
end
```

### Step 3: Object Pooling

```lua
-- ✅ Object pooling for frequently created/destroyed objects
local ObjectPool = {}
ObjectPool.__index = ObjectPool

function ObjectPool.new(createFunc, resetFunc, initialSize)
    local self = setmetatable({}, ObjectPool)
    self.createFunc = createFunc
    self.resetFunc = resetFunc
    self.pool = {}
    self.active = {}
    
    -- Pre-populate pool
    for i = 1, initialSize do
        table.insert(self.pool, createFunc())
    end
    
    return self
end

function ObjectPool:get()
    local obj
    
    if #self.pool > 0 then
        obj = table.remove(self.pool)
    else
        obj = self.createFunc()
    end
    
    self.active[obj] = true
    return obj
end

function ObjectPool:release(obj)
    if not self.active[obj] then return end
    
    self.active[obj] = nil
    self.resetFunc(obj)
    table.insert(self.pool, obj)
end

-- Usage
local bulletPool = ObjectPool.new(
    function() return createBullet() end,
    function(bullet) bullet.CFrame = CFrame.new(0, -1000, 0) end,
    100
)

-- Get bullet
local bullet = bulletPool:get()
bullet.CFrame = gun.CFrame

-- Release bullet (after hit or timeout)
task.delay(5, function()
    bulletPool:release(bullet)
end)
```

### Step 4: Verify Improvement

```bash
# Re-check performance
/roblox-balance-check performance
```

**New results:**
- Part count: 1500 ✅ (within budget)
- FPS: 60 ✅ (at target)
- Allocations: 0/frame ✅ (no allocations in hot path)

---

## Example 5: Code Review

### Scenario

You want to review a teammate's code before merging.

### Step 1: Run Code Review

```bash
# Review the code
/roblox-code-review src/NewFeature.lua
```

### Step 2: Review Report

```markdown
## Code Review: NewFeature.lua

### File Type: Server Module
### Review Time: 2026-06-26

### Roblox Architecture Compliance: ⚠️ Issues Found
- Line 45: Server modifies Part.Color (syncs to all clients)
  - Fix: Use RemoteEvent to notify client, client modifies locally

### DataStore Safety: ✅ Safe
- Retry mechanism implemented (lines 20-35)
- Error handling with pcall (line 22)
- Session Lock checked (line 15)

### RemoteEvent Protocol: ⚠️ Issues Found
- Line 80: Generic event name "Update"
  - Fix: Rename to "FeatureUpdated"
- Line 85: No validation of client data
  - Fix: Add data validation before processing

### Code Quality: 7/10
- Good: Clear naming, proper structure
- Issue: Missing function documentation
- Issue: No edge case handling for empty input

### SOLID Principles: ✅ Followed
- Single Responsibility: Module handles only feature logic
- Interface: Clear public API

### Performance: ✅ Good
- No allocations in hot paths
- Services cached at top

### Positive Observations
- Good error handling with pcall
- Clean module structure
- Proper use of metatables

### Must Fix
1. Server modifies visual property (Line 45)
2. Generic RemoteEvent name (Line 80)
3. Missing client data validation (Line 85)

### Suggested Improvements
1. Add function documentation
2. Handle edge cases (empty input, nil values)
3. Add unit tests

### Verdict: Needs Revision
```

### Step 3: Fix Issues

```lua
-- Fix 1: Don't modify visual property on server
-- ❌ Before
part.Color = Color3.new(1, 0, 0)

-- ✅ After
RemoteEvent:FireClient(player, "ChangeColor", part, Color3.new(1, 0, 0))

-- Fix 2: Rename RemoteEvent
-- ❌ Before
RemoteEvent:FireClient(player, "Update", data)

-- ✅ After
RemoteEvent:FireClient(player, "FeatureUpdated", data)

-- Fix 3: Validate client data
-- ❌ Before
RemoteEvent.OnServerEvent:Connect(function(player, action, data)
    processAction(player, action, data)
end)

-- ✅ After
RemoteEvent.OnServerEvent:Connect(function(player, action, data)
    if not validateAction(action) then
        warn("Invalid action from", player.Name)
        return
    end
    
    if not validateData(data) then
        warn("Invalid data from", player.Name)
        return
    end
    
    processAction(player, action, data)
end)
```

### Step 4: Re-review

```bash
# Re-review after fixes
/roblox-code-review src/NewFeature.lua
```

**New results:**
- Roblox Architecture: ✅ Compliant
- RemoteEvent Protocol: ✅ Proper naming and validation
- Code Quality: 9/10
- Verdict: **Approved**

---

## Summary

These examples show how to use Roblox Game Studios in real scenarios:

1. **Boss Combat** — Design → Review → Implement → Review → Balance
2. **Economy System** — Design → Balance Check → Adjust → Re-check
3. **DataStore Migration** — Record Decision → Implement → Test → Deploy
4. **Performance Optimization** — Profile → Optimize → Verify
5. **Code Review** — Review → Fix Issues → Re-review

**Key Takeaways:**
- Always start with design (GDD)
- Record important decisions (ADR)
- Review code before merging
- Check balance after changing values
- Test thoroughly before shipping

For more examples, see the [examples/](../examples/) folder.
