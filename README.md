# Roblox Game Studios

<div align="center">

**Professional Game Development Framework for Roblox**

*Transform your AI coding assistant into a structured game development studio*

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Roblox](https://img.shields.io/badge/Platform-Roblox-00A2FF?logo=roblox&logoColor=white)](https://www.roblox.com)
[![Luau](https://img.shields.io/badge/Language-Luau-00A2FF)](https://luau-lang.org)
[![AI-Powered](https://img.shields.io/badge/AI-Powered-FF6B6B)](https://en.wikipedia.org/wiki/Artificial_intelligence)

[English](#english) | [中文](#中文)

</div>

---

<a name="english"></a>

## 🎮 What is Roblox Game Studios?

**Roblox Game Studios** is a professional game development framework that brings structure, quality, and best practices to Roblox game development using AI coding assistants.

Inspired by [Claude Code Game Studios](https://github.com/Donchitos/Claude-Code-Game-Studios), this framework adapts proven game development workflows specifically for the **Roblox platform**, covering:

- 📋 **Game Design Documents (GDD)** — Structured templates for designing game systems
- 🏗️ **Architecture Decision Records (ADR)** — Document important technical decisions
- 💰 **Economy Models** — Balance your game economy with data-driven templates
- 🔍 **Code Reviews** — Roblox-specific code quality checks
- ⚖️ **Balance Checks** — Validate game math and progression curves
- 🧪 **Test Plans** — Comprehensive testing strategies for Roblox games

### Why Use This?

**Before**: Scattered design docs, hardcoded values, inconsistent code quality, balance issues discovered after launch.

**After**: Structured workflow from design → architecture → implementation → review → balance → test. Every system documented, every value configurable, every decision recorded.

---

## ✨ Features

### 🎯 6 Core Commands

| Command | Purpose | When to Use |
|---------|---------|-------------|
| `/roblox-gdd [name]` | Create Game Design Document | Designing new systems |
| `/roblox-adr [title]` | Record Architecture Decision | Making technical decisions |
| `/roblox-economy [name]` | Create Economy Model | Designing economy systems |
| `/roblox-design-review [path]` | Review Design Document | After writing GDD |
| `/roblox-code-review [path]` | Review Code | After implementation |
| `/roblox-balance-check [system]` | Check Balance | After changing values |

### 📝 4 Professional Templates

- **GDD Template** (220 lines) — Complete game design document with Roblox implementation notes
- **ADR Template** (176 lines) — Architecture decision record with Roblox-specific considerations
- **Economy Template** (183 lines) — Economy model with formulas, faucets, sinks, and balance targets
- **Test Plan Template** (280 lines) — Comprehensive testing with unit, integration, multiplayer, and performance tests

### 🛠️ Roblox-Specific Features

- **Server/Client Architecture** — Checks proper separation (server calculates, client displays)
- **DataStore Safety** — Retry mechanisms, error handling, Session Lock
- **RemoteEvent Protocols** — Clear event naming, data structure documentation, anti-cheat validation
- **Performance Budgets** — Part count ≤1700, FPS ≥60, memory monitoring
- **Data-Driven Design** — All values from `GameConfig.lua`, no hardcoding

---

## 🚀 Quick Start

### Installation

```bash
# Clone the repository
git clone https://github.com/zhsj0089944/roblox-game-studios.git

# Copy to your skills directory
cp -r roblox-game-studios/skills/* /path/to/your/skills/directory/

# Or use as reference
cd roblox-game-studios
```

### Usage

```bash
# Design a new Boss combat system
/roblox-gdd boss-combat

# Record architecture decision for state machine
/roblox-adr boss-state-machine

# Check economy balance after changing GameConfig.lua
/roblox-balance-check economy

# Review code quality
/roblox-code-review src/BossManager.lua
```

### Workflow Example

```
1. /roblox-gdd boss-combat
   → Generate GDD template, fill in Boss combat design

2. /roblox-design-review design/gdd/boss-combat.md
   → Review design completeness, consistency, feasibility

3. /roblox-adr boss-state-machine
   → Record state machine architecture decision

4. Implement code (manual)

5. /roblox-code-review src/BossManager.lua
   → Review code quality, Roblox best practices

6. /roblox-balance-check boss-combat
   → Validate Boss values, damage, health, rewards
```

---

## 📁 Project Structure

```
roblox-game-studios/
├── skills/                          # AI skill definitions
│   ├── balance-check/
│   │   └── SKILL.md                 # Balance check skill
│   ├── code-review/
│   │   └── SKILL.md                 # Code review skill
│   └── design-review/
│       └── SKILL.md                 # Design review skill
├── templates/                       # Document templates
│   ├── gdd-template.md              # Game Design Document
│   ├── adr-template.md              # Architecture Decision Record
│   ├── economy-template.md          # Economy Model
│   └── test-plan-template.md        # Test Plan
├── scripts/                         # Utility scripts
│   └── validate-gdd.sh              # GDD validation script
├── references/                      # Quick references
│   └── quick-reference.md           # Command cheat sheet
├── docs/                            # Documentation
│   ├── getting-started.md           # Getting started guide
│   ├── best-practices.md            # Roblox best practices
│   └── examples.md                  # Usage examples
├── examples/                        # Example files
│   ├── gdd-boss-combat.md           # Example GDD
│   ├── adr-data-persistence.md      # Example ADR
│   └── economy-model.md             # Example economy
├── README.md                        # This file
├── LICENSE                          # MIT License
├── CONTRIBUTING.md                  # Contribution guidelines
└── CHANGELOG.md                     # Version history
```

---

## 🎯 Core Principles

### 1. Roblox-Native

Every template, checklist, and workflow is designed specifically for Roblox:

- **Server/Client Separation** — "Server modifies visual properties syncs to ALL clients!"
- **DataStore Limits** — 4MB per request, rate limiting, Session Lock
- **Performance Budgets** — Part count, FPS, memory constraints
- **RemoteEvent Best Practices** — Clear protocols, anti-cheat validation

### 2. Data-Driven Design

```lua
-- ✅ Correct: All values from config
local BOSS_DAMAGE = config.Boss.damage

-- ❌ Wrong: Hardcoded values
local BOSS_DAMAGE = 20  -- Why 20? Who changes it?
```

### 3. Structured Workflow

```
Design → Architecture → Implementation → Review → Balance → Test
  GDD        ADR           Code        code-review  balance-check  test-plan
```

### 4. Collaborative Decision-Making

All commands follow: **Ask → Options → User Decides → Draft → User Approves**

AI is the advisor. User is the decision-maker.

---

## 📚 Templates Deep Dive

### Game Design Document (GDD)

**220 lines** covering:

- **Player Fantasy** — What should players feel?
- **Detailed Rules** — Programmers can implement without guessing
- **Formulas** — All math with variable tables, ranges, edge cases
- **Edge Cases** — Explicit handling for anomalies
- **Tuning Knobs** — Adjustable values with safe ranges
- **Game Feel** — Responsiveness, weight, rhythm
- **Roblox Implementation** — Server/client split, DataStore impact, performance budget

### Architecture Decision Record (ADR)

**176 lines** covering:

- **Problem Statement** — What are we solving?
- **Constraints** — Technical, time, resource limitations
- **Decision** — Specific technical approach
- **Alternatives** — Considered but rejected options
- **Consequences** — Positive, negative, neutral
- **Roblox Compatibility** — Engine version, API risks, validation needs

### Economy Model

**183 lines** covering:

- **Currencies** — Type, earn/sink rates, caps
- **Sources (Faucets)** — All earn paths
- **Sinks (Drains)** — All spend paths
- **Balance Targets** — Time, rates, ratios
- **Progression Curves** — Upgrade costs, evolution tree allocation
- **Loot Tables** — Probabilities, pity timers, rarities
- **Ethical Guardrails** — No pay-to-win, transparent rates

### Test Plan

**280 lines** covering:

- **Unit Tests** — Independent function modules
- **Integration Tests** — Module interactions
- **Multiplayer Tests** — Multi-player scenarios
- **Boundary Tests** — Edge values and anomalies
- **Performance Tests** — FPS, memory, request time
- **Security Tests** — Anti-cheat, data safety
- **Automation** — Testable test cases

---

## 🔧 Roblox Best Practices

### Server/Client Architecture

```lua
-- ✅ Correct: Server calculates, client displays
-- Server
RemoteEvent:FireClient(player, "ScoreUpdated", newScore)

-- Client
RemoteEvent.OnClientEvent:Connect(function(event, data)
    if event == "ScoreUpdated" then
        updateScoreUI(data)
    end
end)

-- ❌ Wrong: Server modifies visual (syncs to ALL clients)
part.Transparency = 0.5  -- All players see change
```

### DataStore Safety

```lua
-- ✅ Correct: Retry mechanism + error handling
local function retrySetAsync(key, data, maxRetries)
    for i = 1, maxRetries do
        local ok, err = pcall(function()
            DataStore:SetAsync(key, data)
        end)
        if ok then return true end
        warn("SetAsync failed, retry", i, err)
        task.wait(1)
    end
    return false
end

-- ❌ Wrong: No retry, no error handling
DataStore:SetAsync(key, data)  -- May fail, lose data
```

### Performance Optimization

```lua
-- ✅ Correct: Cache frequent values
local RunService = game:GetService("RunService")
local heartbeat = RunService.Heartbeat

-- ❌ Wrong: Create new objects every frame
RunService.Heartbeat:Connect(function()
    local vec = Vector3.new(1, 0, 0)  -- Allocate every frame
    -- ...
end)
```

---

## 🙏 Acknowledgments

This project was inspired by and builds upon:

### Claude Code Game Studios

**Special thanks** to [Donchitos](https://github.com/Donchitos) for creating [Claude Code Game Studios](https://github.com/Donchitos/Claude-Code-Game-Studios), which provided the foundational concepts for structured AI-assisted game development.

Their work on:
- Multi-tier agent architecture (Directors → Leads → Specialists)
- 73 slash commands for complete development workflows
- 41 document templates for professional game design
- Quality hooks and validation scripts

...inspired us to create a Roblox-specific adaptation that brings these professional practices to the Roblox development community.

### Roblox Community

Thanks to the Roblox developer community for:
- Best practices for Server/Client architecture
- DataStore patterns and anti-cheat strategies
- Performance optimization techniques
- Luau language features and idioms

### Game Development Community

Inspired by professional game development practices:
- **MDA Framework** (Mechanics, Dynamics, Aesthetics)
- **Flow Theory** by Mihaly Csikszentmihalyi
- **Architecture Decision Records** (ADR) from ThoughtWorks
- **Data-Driven Design** patterns

---

## 📖 Documentation

- [Getting Started Guide](docs/getting-started.md) — First steps with Roblox Game Studios
- [Best Practices](docs/best-practices.md) — Roblox development best practices
- [Usage Examples](docs/examples.md) — Real-world usage examples
- [Quick Reference](references/quick-reference.md) — Command cheat sheet

---

## 🤝 Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

### How to Contribute

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Commit** your changes (`git commit -m 'Add amazing feature'`)
4. **Push** to the branch (`git push origin feature/amazing-feature`)
5. **Open** a Pull Request

### What We're Looking For

- 🐛 Bug fixes and improvements
- 📝 Better documentation and examples
- 🎯 New Roblox-specific checks and validations
- 🌍 Translations (中文, 日本語, 한국어, etc.)
- 💡 Feature suggestions and ideas

---

## 📄 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

---

## 🌟 Star History

If you find this project helpful, please give it a star! ⭐

[![Star History Chart](https://api.star-history.com/svg?repos=zhsj0089944/roblox-game-studios&type=Date)](https://star-history.com/#zhsj0089944/roblox-game-studios&Date)

---

<a name="中文"></a>

## 🎮 什么是 Roblox Game Studios？

**Roblox Game Studios** 是一个专业的游戏开发框架，为 Roblox 游戏开发带来结构化、高质量和最佳实践。

受 [Claude Code Game Studios](https://github.com/Donchitos/Claude-Code-Game-Studios) 启发，这个框架专门为 **Roblox 平台** 适配了成熟的游戏开发工作流，覆盖：

- 📋 **游戏设计文档（GDD）** — 设计游戏系统的结构化模板
- 🏗️ **架构决策记录（ADR）** — 记录重要的技术决策
- 💰 **经济模型** — 用数据驱动的模板平衡游戏经济
- 🔍 **代码审查** — Roblox 特定的代码质量检查
- ⚖️ **平衡检查** — 验证游戏数学和进度曲线
- 🧪 **测试计划** — Roblox 游戏的全面测试策略

### 为什么使用这个？

**之前**：分散的设计文档、硬编码数值、不一致的代码质量、上线后才发现的平衡问题。

**之后**：从设计 → 架构 → 实现 → 审查 → 平衡 → 测试的结构化工作流。每个系统都有文档，每个数值都可配置，每个决策都有记录。

---

## ✨ 核心特性

### 🎯 6 个核心命令

| 命令 | 用途 | 何时使用 |
|------|------|----------|
| `/roblox-gdd [名称]` | 创建游戏设计文档 | 设计新系统时 |
| `/roblox-adr [标题]` | 记录架构决策 | 做技术决策时 |
| `/roblox-economy [名称]` | 创建经济模型 | 设计经济系统时 |
| `/roblox-design-review [路径]` | 审查设计文档 | 写完 GDD 后 |
| `/roblox-code-review [路径]` | 审查代码 | 实现代码后 |
| `/roblox-balance-check [系统]` | 检查平衡 | 修改数值后 |

### 📝 4 个专业模板

- **GDD 模板**（220 行）— 完整的游戏设计文档，包含 Roblox 实现备注
- **ADR 模板**（176 行）— 架构决策记录，包含 Roblox 特有考虑
- **经济模型模板**（183 行）— 经济模型，包含公式、来源、消耗、平衡目标
- **测试计划模板**（280 行）— 全面测试，包含单元、集成、多人、性能测试

### 🛠️ Roblox 特有功能

- **服务器/客户端架构** — 检查是否正确分离（服务器计算，客户端显示）
- **DataStore 安全** — 重试机制、错误处理、Session Lock
- **RemoteEvent 协议** — 清晰的事件命名、数据结构文档、反作弊验证
- **性能预算** — Part 数量 ≤1700、FPS ≥60、内存监控
- **数据驱动设计** — 所有数值从 `GameConfig.lua` 读取，无硬编码

---

## 🚀 快速开始

### 安装

```bash
# 克隆仓库
git clone https://github.com/zhsj0089944/roblox-game-studios.git

# 复制到你的技能目录
cp -r roblox-game-studios/skills/* /path/to/your/skills/directory/

# 或者作为参考使用
cd roblox-game-studios
```

### 使用

```bash
# 设计新的 Boss 战斗系统
/roblox-gdd boss-combat

# 记录状态机架构决策
/roblox-adr boss-state-machine

# 修改 GameConfig.lua 后检查经济平衡
/roblox-balance-check economy

# 审查代码质量
/roblox-code-review src/BossManager.lua
```

---

## 🎯 核心原则

### 1. Roblox 原生

每个模板、检查清单和工作流都是专门为 Roblox 设计的：

- **服务器/客户端分离** — "服务器修改属性会同步到所有客户端！"
- **DataStore 限制** — 每次请求 4MB、频率限制、Session Lock
- **性能预算** — Part 数量、FPS、内存约束
- **RemoteEvent 最佳实践** — 清晰的协议、反作弊验证

### 2. 数据驱动设计

```lua
-- ✅ 正确：所有数值从配置读取
local BOSS_DAMAGE = config.Boss.damage

-- ❌ 错误：硬编码数值
local BOSS_DAMAGE = 20  -- 为什么是 20？谁来改？
```

### 3. 结构化工作流

```
设计 → 架构 → 实现 → 审查 → 平衡 → 测试
 GDD     ADR     代码   code-review  balance-check  test-plan
```

### 4. 协作决策

所有命令遵循：**提问 → 选项 → 用户决策 → 起草 → 用户批准**

AI 是顾问，用户是决策者。

---

## 🙏 致谢

本项目受以下项目启发并建立在其基础之上：

### Claude Code Game Studios

**特别感谢** [Donchitos](https://github.com/Donchitos) 创建了 [Claude Code Game Studios](https://github.com/Donchitos/Claude-Code-Game-Studios)，为结构化 AI 辅助游戏开发提供了基础概念。

他们的工作包括：
- 多层代理架构（导演 → 主管 → 专家）
- 73 个斜杠命令覆盖完整开发工作流
- 41 个专业游戏设计文档模板
- 质量钩子和验证脚本

...启发我们创建了专门针对 Roblox 平台的适配版本，将这些专业实践带给 Roblox 开发社区。

### Roblox 社区

感谢 Roblox 开发者社区提供的：
- 服务器/客户端架构最佳实践
- DataStore 模式和反作弊策略
- 性能优化技术
- Luau 语言特性和惯用法

### 游戏开发社区

受专业游戏开发实践启发：
- **MDA 框架**（机制、动态、美学）
- **心流理论**（米哈里·契克森米哈赖）
- **架构决策记录**（ADR）来自 ThoughtWorks
- **数据驱动设计** 模式

---

## 📄 许可证

本项目采用 MIT 许可证 — 详见 [LICENSE](LICENSE) 文件。

---

## 🤝 贡献

欢迎贡献！请参阅 [CONTRIBUTING.md](CONTRIBUTING.md) 了解指南。

### 如何贡献

1. **Fork** 仓库
2. **创建** 功能分支（`git checkout -b feature/amazing-feature`）
3. **提交** 更改（`git commit -m 'Add amazing feature'`）
4. **推送** 到分支（`git push origin feature/amazing-feature`）
5. **打开** Pull Request

### 我们在寻找

- 🐛 Bug 修复和改进
- 📝 更好的文档和示例
- 🎯 新的 Roblox 特定检查和验证
- 🌍 翻译（English, 日本語, 한국어 等）
- 💡 功能建议和想法

---

## 📞 联系我们

- **Issues**: [GitHub Issues](https://github.com/zhsj0089944/roblox-game-studios/issues)
- **Discussions**: [GitHub Discussions](https://github.com/zhsj0089944/roblox-game-studios/discussions)
- **Twitter**: [@musiersj]

---

## 🌟 支持我们

如果这个项目对你有帮助，请给我们一个星标！⭐

**关键词**: Roblox, Game Development, AI, GDD, Luau, Game Design, Architecture Decision Record, Economy Balance, Code Review, Test Plan, Roblox Studio, DataStore, RemoteEvent, Server/Client Architecture, Game Feel, Player Experience
