---
name: roblox-game-studios
description: "Roblox 游戏开发全栈框架。提供 GDD 模板、架构决策记录、数值平衡检查、代码审查、设计文档审查等专业游戏开发工作流。当需要设计新系统、审查代码、检查数值平衡、记录架构决策时使用。"
argument-hint: "[command] [args]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, Bash, AskUserQuestion
---

# Roblox Game Studios — AI 游戏开发工作室

## 核心理念

**结构化开发，数据驱动，协作决策。** 这不是一个自动化框架，而是一套专业游戏开发工作流，帮助你更系统地设计、实现和验证 Roblox 游戏系统。

## 可用命令

### 📋 设计阶段

| 命令 | 说明 | 用法 |
|------|------|------|
| `/roblox-gdd` | 创建/审查游戏设计文档 | `/roblox-gdd [system-name]` |
| `/roblox-adr` | 记录架构决策 | `/roblox-adr [title]` |
| `/roblox-economy` | 创建经济模型文档 | `/roblox-economy [system-name]` |

### 🔍 审查阶段

| 命令 | 说明 | 用法 |
|------|------|------|
| `/roblox-design-review` | 审查设计文档完整性 | `/roblox-design-review [path-to-gdd]` |
| `/roblox-code-review` | Roblox 代码审查 | `/roblox-code-review [path-to-file]` |
| `/roblox-balance-check` | 数值平衡检查 | `/roblox-balance-check [system-name]` |

### 🏗️ 实现阶段

| 命令 | 说明 | 用法 |
|------|------|------|
| `/roblox-implement` | 按 GDD 实现系统 | `/roblox-implement [gdd-path]` |
| `/roblox-test` | 生成测试计划 | `/roblox-test [system-name]` |

## 工作流示例

### 场景 1：设计新系统

```
1. /roblox-gdd boss-combat
   → 生成 GDD 模板，填写 Boss 战斗系统设计

2. /roblox-design-review design/gdd/boss-combat.md
   → 审查设计文档完整性、一致性、可实现性

3. /roblox-adr boss-state-machine
   → 记录 Boss 状态机的架构决策

4. /roblox-implement design/gdd/boss-combat.md
   → 按设计文档实现代码

5. /roblox-code-review src/BossManager.lua
   → 审查实现代码质量

6. /roblox-balance-check boss-combat
   → 检查 Boss 数值平衡
```

### 场景 2：检查现有系统

```
1. /roblox-balance-check economy
   → 检查积分/EP 经济系统平衡

2. /roblox-code-review GameConfig.lua
   → 审查配置文件架构

3. /roblox-adr data-persistence-strategy
   → 记录数据持久化架构决策
```

## 模板位置

- **GDD 模板**: `templates/gdd-template.md`
- **ADR 模板**: `templates/adr-template.md`
- **经济模型模板**: `templates/economy-template.md`
- **测试计划模板**: `templates/test-plan-template.md`

## 与现有技能的集成

- **roblox-free-assets**: 获取图标、音效等美术资源
- **roblox-http-push**: 推送大文件到 Studio
- **roblox-bone-animation**: 骨骼动画处理
- **roblox-vfx-planner**: VFX 特效规划

## Roblox 特有注意事项

### 服务器/客户端架构
- **服务器修改属性会同步到所有客户端** — per-player 效果必须客户端本地修改
- **RemoteEvent 通信** — 服务器只发通知，客户端本地执行
- **DataStore 限制** — 请求频率、大小限制、Session Lock

### 性能关键点
- **物体数量** — 基准 800 + 55/人，上限 1700
- **帧率** — 目标 60fps，热路径避免分配
- **内存** — 监控 Part 数量、Texture 内存

### 数值设计原则
- **数据驱动** — 所有数值在 GameConfig.lua，不硬编码
- **公式文档化** — 每个公式必须有变量表、范围、边界情况
- **平衡检查** — 修改数值后必须跑 `/roblox-balance-check`

## 文件组织建议

```
project/
├── design/
│   ├── gdd/                    # 游戏设计文档
│   │   ├── systems-index.md    # 系统索引
│   │   ├── boss-combat.md
│   │   ├── economy.md
│   │   └── ...
│   ├── adr/                    # 架构决策记录
│   │   ├── ADR-0001-data-persistence.md
│   │   └── ...
│   └── balance/                # 平衡检查报告
│       ├── balance-check-economy-2026-06-26.md
│       └── ...
├── GameConfig.lua              # 所有游戏数值
├── GameManager.server.lua      # 服务器入口
└── ...
```

## 协作协议

所有命令都遵循 **提问 → 提供选项 → 用户决策 → 起草 → 用户批准** 的流程。AI 是顾问，用户是决策者。

## 开始使用

运行任意命令即可开始。例如：
```
/roblox-gdd my-new-system
```

系统会引导你完成整个流程。
