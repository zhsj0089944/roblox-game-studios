---
name: roblox-code-review
description: "Roblox Luau 代码审查：架构合规、SOLID 原则、性能优化、服务器/客户端分离、DataStore 安全、RemoteEvent 协议。审查代码质量和 Roblox 最佳实践。"
argument-hint: "[path-to-file-or-directory]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Bash, Task, AskUserQuestion
---

## Phase 1: 加载目标文件

完整读取目标文件。读取 `DESIGN.md` 了解项目架构标准。

---

## Phase 2: 识别文件类型

确定文件类型和对应的审查重点：

| 文件类型 | 审查重点 |
|----------|----------|
| `.server.lua` | 服务器逻辑、DataStore 安全、RemoteEvent 处理 |
| `.client.lua` | 客户端逻辑、UI 更新、本地效果 |
| `GameConfig.lua` | 数值配置、数据结构、公式定义 |
| `*Manager.lua` | 系统架构、状态管理、生命周期 |
| `*System.lua` | 系统设计、接口定义、模块耦合 |
| `*UI.lua` | UI 架构、响应式更新、性能 |

---

## Phase 3: Roblox 架构合规检查

### 服务器/客户端分离 ✅❌

```lua
-- ✅ 正确：服务器计算，客户端显示
-- 服务器
RemoteEvent:FireClient(player, "ScoreUpdated", newScore)

-- 客户端
RemoteEvent.OnClientEvent:Connect(function(event, data)
    if event == "ScoreUpdated" then
        updateScoreUI(data)
    end
end)

-- ❌ 错误：服务器修改视觉属性（会同步到所有客户端）
part.Transparency = 0.5  -- 所有玩家都会看到变化
```

**检查清单**：
- [ ] 服务器不修改 Part 的视觉属性（Color, Transparency, Material）
- [ ] per-player 效果通过 RemoteEvent 通知客户端本地修改
- [ ] 数值计算在服务器，防止作弊
- [ ] 客户端不做信任决策（伤害、积分、EP）

### DataStore 安全 ✅❌

```lua
-- ✅ 正确：重试机制 + 错误处理
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

-- ❌ 错误：无重试，无错误处理
DataStore:SetAsync(key, data)  -- 可能失败丢失数据
```

**检查清单**：
- [ ] 所有 DataStore 操作有重试机制
- [ ] 错误处理完善（pcall 包装）
- [ ] Session Lock 防双开
- [ ] 数据大小 < 4MB
- [ ] 请求频率不超限
- [ ] BindToClose 处理

### RemoteEvent 协议 ✅❌

```lua
-- ✅ 正确：明确的事件类型和数据结构
RemoteEvent:FireClient(player, "RefineComplete", {
    epGained = 100,
    totalEP = 500
})

-- ❌ 错误：模糊的事件名和数据
RemoteEvent:FireClient(player, "Update", data)  -- 什么 Update？
```

**检查清单**：
- [ ] 事件名明确（"RefineComplete" 而非 "Update"）
- [ ] 数据结构有文档
- [ ] 服务器验证所有客户端输入
- [ ] 防止 RemoteEvent 滥用（频率限制）

---

## Phase 4: Luau 代码质量检查

### 代码规范 ✅❌

```lua
-- ✅ 正确：清晰的命名和结构
local PlayerManager = {}
PlayerManager.__index = PlayerManager

function PlayerManager.new(player)
    local self = setmetatable({}, PlayerManager)
    self.player = player
    self.data = nil
    return self
end

-- ❌ 错误：混乱的命名和结构
local pm = {}
function pm:init(p)
    self.p = p
    self.d = nil
end
```

**检查清单**：
- [ ] 变量名清晰（`playerHealth` 而非 `ph`）
- [ ] 函数名动词开头（`calculateDamage` 而非 `damage`）
- [ ] 常量全大写（`MAX_HEALTH`）
- [ ] 模块有清晰的接口定义
- [ ] 注释解释"为什么"而非"是什么"

### 性能优化 ✅❌

```lua
-- ✅ 正确：缓存频繁访问的值
local RunService = game:GetService("RunService")
local heartbeat = RunService.Heartbeat

-- ❌ 错误：每帧创建新对象
RunService.Heartbeat:Connect(function()
    local vec = Vector3.new(1, 0, 0)  -- 每帧分配
    -- ...
end)
```

**检查清单**：
- [ ] 热路径无内存分配
- [ ] 频繁访问的服务/值已缓存
- [ ] 使用 `task.spawn` 而非 `coroutine.wrap`
- [ ] 避免 `wait()`，使用 `task.wait()`
- [ ] 使用 `GetDescendants()` 而非递归遍历

### 错误处理 ✅❌

```lua
-- ✅ 正确：完善的错误处理
local function loadPlayerData(player)
    local success, data = pcall(function()
        return DataStore:GetAsync(player.UserId)
    end)

    if not success then
        warn("Failed to load data for", player.Name, data)
        return createDefaultData()
    end

    return data or createDefaultData()
end

-- ❌ 错误：无错误处理
local function loadPlayerData(player)
    return DataStore:GetAsync(player.UserId)  -- 可能返回 nil 或报错
end
```

**检查清单**：
- [ ] pcall 包装所有外部调用（DataStore, HttpService）
- [ ] nil 检查完善
- [ ] 错误有日志记录
- [ ] 有降级方案（默认值）

---

## Phase 5: SOLID 原则检查

### 单一职责 ✅❌

```lua
-- ✅ 正确：每个模块职责单一
local ScoreCalculator = {}  -- 只负责计算
local ScoreUI = {}          -- 只负责显示
local ScoreData = {}        -- 只负责数据

-- ❌ 错误：一个模块做所有事
local ScoreManager = {}     -- 计算 + 显示 + 数据 + 网络
```

**检查清单**：
- [ ] 每个模块只做一件事
- [ ] 修改一个功能不需要改多个文件
- [ ] 模块可以独立测试

### 接口隔离 ✅❌

```lua
-- ✅ 正确：小而专一的接口
local ICombatSystem = {
    takeDamage = function(self, amount, source) end,
    getHealth = function(self) end,
}

local IUpgradeSystem = {
    purchaseUpgrade = function(self, upgradeId) end,
    getUpgradeLevel = function(self, upgradeId) end,
}

-- ❌ 错误：大而全的接口
local IGameSystem = {
    takeDamage = function() end,
    getHealth = function() end,
    purchaseUpgrade = function() end,
    getUpgradeLevel = function() end,
    spawnBoss = function() end,
    -- ... 100 个方法
}
```

**检查清单**：
- [ ] 接口小而专一
- [ ] 消费者只依赖它需要的方法
- [ ] 修改接口不影响不相关的消费者

---

## Phase 6: 游戏特定检查

### 状态管理 ✅❌

```lua
-- ✅ 正确：明确的状态机
local BossState = {
    IDLE = "Idle",
    PATROL = "Patrol",
    CHASE = "Chase",
    ATTACK = "Attack",
    DEAD = "Dead"
}

-- ❌ 错误：隐式状态（用多个布尔值）
boss.isChasing = true
boss.isAttacking = false
boss.isDead = false  -- 可能同时为 true？
```

**检查清单**：
- [ ] 状态机有明确的状态定义
- [ ] 状态转换有验证
- [ ] 无无效状态组合
- [ ] 状态变化有日志（调试用）

### 数值配置 ✅❌

```lua
-- ✅ 正确：所有数值从配置读取
local config = require(game.ReplicatedStorage.GameConfig)
local BOSS_DAMAGE = config.Boss.damage

-- ❌ 错误：硬编码数值
local BOSS_DAMAGE = 20  -- 为什么是 20？谁来改？
```

**检查清单**：
- [ ] 所有数值从 GameConfig 读取
- [ ] 无魔法数字
- [ ] 数值有注释说明设计意图
- [ ] 数值变化不需要改代码

---

## Phase 7: 输出审查报告

```markdown
## 代码审查: [文件/系统名称]

### 文件类型: [server/client/config/manager]
### 审查时间: [YYYY-MM-DD]

### Roblox 架构合规: [通过 / 问题发现]
[列出具体问题和行号]

### DataStore 安全: [安全 / 风险]
[列出安全问题]

### RemoteEvent 协议: [规范 / 问题]
[列出协议问题]

### 代码质量: [X/10]
[列出质量问题]

### SOLID 原则: [符合 / 违反]
[列出违反项]

### 性能: [良好 / 需优化]
[列出性能问题]

### 正面观察
[做得好的地方]

### 必须修改
[阻塞性问题]

### 建议改进
[非阻塞性优化]

### 判定: [通过 / 需修改 / 大改]
```

---

## Phase 8: 下一步

使用 `AskUserQuestion`：
- 提示："代码审查完成 — 判定: [通过 / 需修改 / 大改]。如何继续？"
- 选项：
  - 如果通过：
    - `[A] 运行 /roblox-balance-check 检查数值`
    - `[B] 到此为止`
  - 如果需修改：
    - `[A] 修复问题后重新运行 /roblox-code-review`
    - `[B] 记录问题稍后处理`
    - `[C] 到此为止`

---

## 常见 Roblox 代码问题

### 1. 服务器修改视觉属性
```lua
-- ❌ 错误
part.Color = Color3.new(1, 0, 0)  -- 所有玩家看到变化

-- ✅ 正确
RemoteEvent:FireClient(player, "ChangeColor", part, Color3.new(1, 0, 0))
```

### 2. DataStore 无重试
```lua
-- ❌ 错误
DataStore:SetAsync(key, data)

-- ✅ 正确
retrySetAsync(key, data, 3)
```

### 3. 热路径内存分配
```lua
-- ❌ 错误
Heartbeat:Connect(function()
    local parts = workspace:GetPartsInPart(hitbox)  -- 每帧分配
end)

-- ✅ 正确
local partsCache = {}
Heartbeat:Connect(function()
    table.clear(partsCache)
    workspace:GetPartsInPart(hitbox, partsCache)
end)
```

### 4. RemoteEvent 无验证
```lua
-- ❌ 错误
RemoteEvent.OnServerEvent:Connect(function(player, action, data)
    if action == "buy" then
        -- 直接执行，不验证
    end
end)

-- ✅ 正确
RemoteEvent.OnServerEvent:Connect(function(player, action, data)
    if action == "buy" then
        if not validatePurchase(player, data) then
            warn("Invalid purchase from", player.Name)
            return
        end
        -- 执行购买
    end
end)
```
