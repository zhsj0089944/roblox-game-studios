# Boss Combat System

> **Status**: Draft
> **Author**: Game Designer
> **Last Updated**: 2026-06-26
> **Implementation Pillar**: Core Gameplay

## Summary

The Boss Combat System provides challenging PvE encounters that test player skill and reward strategic gameplay. Bosses spawn in designated zones, require coordinated attacks to defeat, and drop valuable loot including score bonuses and rare items.

> **Quick Reference** — Layer: `Core` | Priority: `MVP` | Key Dependencies: `PVP System, Loot System, Score System`

## Overview

Bosses are large, powerful enemies that appear periodically in the game world. Players must work together to defeat them, using timing, positioning, and ability coordination. Each boss has unique attack patterns, health pools, and reward structures.

## Player Fantasy

Players should feel like **heroic warriors** taking down a powerful foe together. The experience should be **thrilling** (dangerous attacks), **rewarding** (valuable loot), and **social** (teamwork required).

## Detailed Design

### Core Rules

1. Bosses spawn in the **Southeast zone** every 10-15 minutes
2. Only **one boss** can exist at a time
3. Bosses have **1000 HP** and take **15 damage per hit**
4. Bosses have **3 attack patterns**: Melee, Charge, Stomp
5. **Kill credit** goes to the player who deals the killing blow
6. **Participation rewards** (50 score) go to all players who dealt damage

### States and Transitions

| State | Entry Condition | Exit Condition | Behavior |
|-------|-----------------|----------------|----------|
| Idle | Spawned | Player within 50m | Patrol randomly |
| Patrol | Idle | Player within 30m | Chase player |
| Chase | Patrol/Idle | Player within 10m | Attack |
| Attack | Chase | Health ≤ 0 or player escaped | Deal damage |
| Dead | Health ≤ 0 | Respawn timer | Drop loot, despawn |

### Interactions with Other Systems

| System | Interaction | Data Flow |
|--------|-------------|-----------|
| PVP System | Boss damage uses DamageEnvironmental() | Boss → PVPSystem → Player HP |
| Score System | Kill reward and participation bonus | Boss → ScoreSystem → Player Score |
| Loot System | Drop table on death | Boss → LootSystem → Player Inventory |
| Tutorial System | First boss kill triggers tutorial step | Boss → TutorialSystem → Progress |

## Formulas

### Boss Damage to Player

```lua
damage = boss_damage * (1 - player_dodge_chance)
```

| Variable | Type | Range | Source | Description |
|----------|------|-------|--------|-------------|
| boss_damage | float | 20-30 | GameConfig | Base boss damage |
| player_dodge_chance | float | 0-0.15 | Evolution Tree | Player dodge rate |

**Expected Output Range**: 0 to 30
**Edge Cases**: If player_dodge_chance > 1, clamp to 0.99 (never 100% dodge)

### Player Damage to Boss

```lua
damage = base_damage * (1 + upgrade_bonus) * (1 + evolution_bonus) * crit_multiplier
```

| Variable | Type | Range | Source | Description |
|----------|------|-------|--------|-------------|
| base_damage | float | 15 | GameConfig | Base damage per hit |
| upgrade_bonus | float | 0-2.0 | Upgrade System | Multiplier upgrade bonus |
| evolution_bonus | float | 0-1.0 | Evolution Tree | Finger evolution bonus |
| crit_multiplier | float | 1.0-1.5 | Crit System | Critical hit multiplier |

**Expected Output Range**: 15 to 90
**Edge Cases**: If all bonuses max, damage = 15 × 3 × 2 × 1.5 = 135 (capped at 100)

### Kill Reward

```lua
reward = base_reward * (1 + vip_bonus)
```

| Variable | Type | Range | Source | Description |
|----------|------|-------|--------|-------------|
| base_reward | float | 2000 | GameConfig | Base kill reward |
| vip_bonus | float | 0-0.5 | VIP System | VIP bonus multiplier |

**Expected Output Range**: 2000 to 3000
**Edge Cases**: None (simple multiplication)

## Edge Cases

| Scenario | Expected Behavior | Reasoning |
|----------|-------------------|-----------|
| Multiple players hit simultaneously | Each gets damage credit | Fair gameplay |
| Player dies during boss fight | Boss resets to patrol | Prevent stuck state |
| Boss dies during player death animation | Player still gets reward | Reward on damage dealt |
| Server shutdown during boss fight | Boss despawns, no rewards | Data safety |
| Player exploits RemoteEvent | Server validates all damage | Anti-cheat |

## Dependencies

| System | Direction | Dependency Nature |
|--------|-----------|-------------------|
| PVP System | Boss depends on PVP | Damage calculation |
| Score System | Score depends on Boss | Kill rewards |
| Loot System | Loot depends on Boss | Drop table |
| Tutorial System | Tutorial depends on Boss | Progress tracking |

## Tuning Knobs

| Parameter | Current Value | Safe Range | Effect of Increase | Effect of Decrease |
|-----------|---------------|------------|--------------------|--------------------|
| Boss HP | 1000 | 500-2000 | Longer fights | Easier fights |
| Boss Damage | 20 | 10-30 | More dangerous | Less threatening |
| Spawn Interval | 10-15 min | 5-30 min | More frequent | Less frequent |
| Kill Reward | 2000 | 1000-5000 | More rewarding | Less rewarding |
| Participation Reward | 50 | 25-100 | More inclusive | Less inclusive |

## Visual/Audio Requirements

| Event | Visual Feedback | Audio Feedback | Priority |
|-------|-----------------|----------------|----------|
| Boss Spawn | Screen shake, warning text | Thunder sound | High |
| Boss Attack | Screen flash, particle effects | Impact sound | High |
| Boss Death | Explosion effect, loot shower | Victory fanfare | Critical |
| Player Hit | Blood effect, camera shake | Hit sound | Medium |

## Game Feel

### Feel Reference

The boss fight should feel like **Monster Hunter** encounters — dangerous, rewarding, and requiring skill. The boss should feel **powerful** (heavy attacks) but **fair** (telegraphed moves). **Not** like a bullet sponge (too much HP) or a pushover (too easy).

### Input Responsiveness

| Action | Max Input-Response Latency (ms) | Frame Budget (60fps) | Notes |
|--------|----------------------------------|----------------------|-------|
| Attack | 50ms | 3 frames | Immediate feedback |
| Dodge | 50ms | 3 frames | Responsive movement |
| Boss Attack | 100ms | 6 frames | Telegraphed, not instant |

### Animation Feel Goals

| Animation | Startup Frames | Active Frames | Recovery Frames | Feel Goal | Notes |
|-----------|----------------|---------------|-----------------|-----------|-------|
| Player Attack | 5 | 10 | 15 | Fast, responsive | Quick recovery |
| Boss Melee | 15 | 20 | 25 | Heavy, powerful | Telegraphed |
| Boss Charge | 20 | 30 | 20 | Fast, dangerous | Evasive |
| Boss Stomp | 25 | 15 | 30 | Area denial | AOE threat |

### Impact Moments

| Impact Type | Duration (ms) | Effect Description | Configurable? |
|-------------|---------------|--------------------|---------------|
| Boss Hit | 100ms | Screen shake + flash | Yes |
| Player Hit | 80ms | Camera shake + blood | Yes |
| Boss Death | 500ms | Screen shake + explosion | Yes |

### Weight and Responsiveness Profile

- **Weight**: Heavy and powerful — bosses feel like tanks
- **Player Control**: High — players can react and dodge
- **Crispness**: Crisp attacks, clear hitboxes
- **Acceleration Model**: Instant start (arcade feel)
- **Failure Feel**: Punishing but fair — clear why you died

### Feel Acceptance Criteria

- [ ] Boss attacks feel **powerful** — players comment on weight
- [ ] Player attacks feel **responsive** — no input lag
- [ ] Boss death feels **epic** — screen effects and loot
- [ ] No reviewers use "floaty" or "unresponsive"
- [ ] At 60fps, no perceivable input delay

## UI Requirements

| Information | Display Location | Update Frequency | Condition |
|-------------|------------------|------------------|-----------|
| Boss Health Bar | Above boss | Real-time | Boss alive |
| Boss Name | Above health bar | Static | Boss alive |
| Damage Numbers | Near hit location | Per hit | Any damage |
| Kill Reward | Screen center | On kill | Boss defeated |
| Participation Reward | Screen center | On kill | Damage dealt |

## Cross-References

| This Document References | Target GDD | Referenced Element | Nature |
|--------------------------|------------|--------------------|----|
| "Damage uses PVPSystem" | `pvp-system.md` | DamageEnvironmental() | Rule Dependency |
| "Rewards use ScoreSystem" | `score-system.md` | addScore() | Data Dependency |
| "Drops use LootSystem" | `loot-system.md` | dropTable | Data Dependency |
| "Progress uses TutorialSystem" | `tutorial-system.md` | advanceStep() | State Trigger |

## Acceptance Criteria

- [ ] Boss spawns every 10-15 minutes in Southeast zone
- [ ] Boss has 3 attack patterns (melee, charge, stomp)
- [ ] Boss takes 15 damage per hit (with bonuses)
- [ ] Kill credit goes to last hitter
- [ ] Participation rewards go to all damage dealers
- [ ] Boss drops loot on death
- [ ] Boss despawns after 5 minutes if not killed
- [ ] No more than 1 boss at a time
- [ ] Performance: Boss system adds ≤5ms per frame
- [ ] No hardcoded values in implementation

## Open Issues

| Issue | Owner | Deadline | Resolution |
|-------|-------|----------|------------|
| Should bosses scale with player count? | Game Designer | TBD | Under discussion |
| What loot should bosses drop? | Economy Designer | TBD | Pending balance check |

---

## Roblox Implementation Notes

### Server/Client Division
- **Server Responsible**: Boss AI, damage calculation, loot drops, rewards
- **Client Responsible**: Visual effects, animations, UI updates
- **RemoteEvent Protocol**: BossSpawn, BossAttack, BossDeath, BossDamage

### DataStore Impact
- **Storage Fields**: totalBossKills, lastBossKillTime
- **Data Size Estimate**: ~50 bytes per player
- **Migration Needs**: None (new system)

### Performance Budget
- **Part Count**: 50-100 parts per boss model
- **Frame Rate Impact**: ≤5ms per frame
- **Memory Impact**: ≤10MB per boss

### Anti-Cheat
- All damage calculations on server
- Validate player position before allowing damage
- Rate limit damage requests
- Log suspicious activity
