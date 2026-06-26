# Getting Started with Roblox Game Studios

Welcome to Roblox Game Studios! This guide will help you get started with the framework and show you how to use it in your Roblox development workflow.

## 📋 Prerequisites

Before using Roblox Game Studios, you should have:

- **Roblox Studio** installed (latest version)
- **Basic understanding** of Roblox development (Server/Client, DataStore, RemoteEvent)
- **AI coding assistant** (Claude, ChatGPT, GitHub Copilot, etc.)
- **Git** installed (for cloning the repository)

## 🚀 Installation

### Option 1: Clone Repository (Recommended)

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/roblox-game-studios.git

# Navigate to the directory
cd roblox-game-studios
```

### Option 2: Download ZIP

1. Go to the [GitHub repository](https://github.com/YOUR_USERNAME/roblox-game-studios)
2. Click "Code" → "Download ZIP"
3. Extract the ZIP file

### Option 3: Use as Reference

You can also use the templates and examples as reference without installing anything. Just browse the repository on GitHub.

## 📁 Understanding the Structure

```
roblox-game-studios/
├── skills/                    # AI skill definitions
│   ├── balance-check.md       # Balance check skill
│   ├── code-review.md         # Code review skill
│   └── design-review.md       # Design review skill
├── templates/                 # Document templates
│   ├── gdd-template.md        # Game Design Document
│   ├── adr-template.md        # Architecture Decision Record
│   ├── economy-template.md    # Economy Model
│   └── test-plan-template.md  # Test Plan
├── scripts/                   # Utility scripts
│   └── validate-gdd.sh        # GDD validation
├── references/                # Quick references
│   └── quick-reference.md     # Command cheat sheet
├── docs/                      # Documentation
│   ├── getting-started.md     # This file
│   ├── best-practices.md      # Roblox best practices
│   └── examples.md            # Usage examples
└── examples/                  # Example files
    └── gdd-boss-combat.md     # Example GDD
```

## 🎯 Quick Start

### Step 1: Design a New System

Let's design a Boss Combat system:

```bash
# Copy the GDD template
cp templates/gdd-template.md design/gdd/boss-combat.md

# Edit the template with your design
# Fill in all sections: Overview, Player Fantasy, Detailed Design, etc.
```

Or use the AI skill (if your AI assistant supports it):
```
/roblox-gdd boss-combat
```

### Step 2: Review the Design

After writing the GDD, review it:

```bash
# Use the design review skill
/roblox-design-review design/gdd/boss-combat.md
```

This will check:
- ✅ Completeness (all required sections)
- ✅ Internal consistency
- ✅ Roblox-specific feasibility
- ✅ Formula correctness
- ✅ Edge cases

### Step 3: Record Architecture Decisions

If you make important technical decisions, record them:

```bash
# Create an ADR
cp templates/adr-template.md design/adr/ADR-0001-boss-state-machine.md

# Or use the skill
/roblox-adr boss-state-machine
```

### Step 4: Implement the Code

Write your code following the design document. Use `GameConfig.lua` for all values:

```lua
-- GameConfig.lua
local GameConfig = {
    Boss = {
        health = 1000,
        damage = 20,
        spawnInterval = {600, 900}, -- 10-15 minutes
        killReward = 2000,
        participationReward = 50,
    },
}
```

### Step 5: Review the Code

After implementation, review the code:

```bash
# Use the code review skill
/roblox-code-review src/BossManager.lua
```

This will check:
- ✅ Server/Client separation
- ✅ DataStore safety
- ✅ RemoteEvent protocols
- ✅ Performance
- ✅ Error handling

### Step 6: Check Balance

After changing any values, check balance:

```bash
# Use the balance check skill
/roblox-balance-check boss
```

This will validate:
- ✅ Boss HP vs player damage
- ✅ Reward amounts
- ✅ Difficulty curve
- ✅ Economy impact

## 📚 Example Workflow

Here's a complete workflow example:

### 1. Design Phase
```bash
# Create GDD
/roblox-gdd economy-system

# Review design
/roblox-design-review design/gdd/economy-system.md

# Record decision
/roblox-adr dual-currency-design
```

### 2. Implementation Phase
```bash
# Write code in Roblox Studio
# Use GameConfig.lua for all values

# Review code
/roblox-code-review src/EconomyManager.lua
```

### 3. Balance Phase
```bash
# Check economy balance
/roblox-balance-check economy

# Adjust values in GameConfig.lua
# Re-check balance
/roblox-balance-check economy
```

### 4. Testing Phase
```bash
# Create test plan
cp templates/test-plan-template.md tests/economy-test-plan.md

# Fill in test cases
# Run tests in Roblox Studio
```

## 🎯 Core Concepts

### 1. Data-Driven Design

All values should be in `GameConfig.lua`:

```lua
-- ✅ Good
local BOSS_DAMAGE = config.Boss.damage

-- ❌ Bad
local BOSS_DAMAGE = 20  -- Why 20? Who changes it?
```

### 2. Server/Client Separation

```lua
-- Server: Calculate, validate, store
RemoteEvent:FireClient(player, "ScoreUpdated", newScore)

-- Client: Display, animate, respond
RemoteEvent.OnClientEvent:Connect(function(event, data)
    if event == "ScoreUpdated" then
        updateScoreUI(data)
    end
end)
```

### 3. Structured Workflow

```
Design → Architecture → Implementation → Review → Balance → Test
  GDD        ADR           Code        code-review  balance-check  test-plan
```

### 4. Collaborative Decision-Making

AI is the advisor. User is the decision-maker.

## 🔧 Customization

### Adapting Templates

You can customize templates to fit your project:

1. **Copy the template**
   ```bash
   cp templates/gdd-template.md my-gdd-template.md
   ```

2. **Modify sections**
   - Add sections specific to your game
   - Remove sections you don't need
   - Adjust checklists

3. **Use your customized template**
   ```bash
   cp my-gdd-template.md design/gdd/new-system.md
   ```

### Creating Custom Skills

You can create your own skills:

1. **Create a new skill file**
   ```bash
   mkdir skills/my-skill
   echo "# My Skill" > skills/my-skill/SKILL.md
   ```

2. **Define the skill**
   - Purpose
   - Commands
   - Workflow
   - Checks

3. **Use your skill**
   ```bash
   /my-skill [arguments]
   ```

## 📖 Next Steps

Now that you understand the basics:

1. **Read Best Practices** — See [best-practices.md](best-practices.md)
2. **Explore Examples** — See [examples.md](examples.md)
3. **Try the Templates** — Start with a simple system
4. **Join the Community** — Share your experiences

## 🆘 Getting Help

If you're stuck:

1. **Check Documentation** — Browse the `docs/` folder
2. **Search Issues** — Look for similar problems on GitHub
3. **Ask Questions** — Use GitHub Discussions
4. **Read Examples** — See how others use the framework

## 🎉 You're Ready!

You now understand how to use Roblox Game Studios. Start designing your next game system!

**Remember**: 
- Start with design (GDD)
- Record decisions (ADR)
- Review everything (code-review, design-review)
- Check balance (balance-check)
- Test thoroughly (test-plan)

Good luck with your Roblox game! 🎮
