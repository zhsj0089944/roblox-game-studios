# Roblox Game Studios 快速参考

## 命令速查

| 命令 | 用途 | 何时使用 |
|------|------|----------|
| `/roblox-gdd [name]` | 创建 GDD | 设计新系统时 |
| `/roblox-adr [title]` | 记录架构决策 | 做重要技术决策时 |
| `/roblox-economy [name]` | 创建经济模型 | 设计经济系统时 |
| `/roblox-design-review [path]` | 审查设计文档 | GDD 写完后 |
| `/roblox-code-review [path]` | 审查代码 | 代码写完后 |
| `/roblox-balance-check [system]` | 检查数值平衡 | 修改数值后 |

## 工作流模板

### 新系统开发流程
```
1. /roblox-gdd system-name
   ↓ 填写设计文档
2. /roblox-design-review design/gdd/system-name.md
   ↓ 审查通过
3. /roblox-adr system-architecture
   ↓ 记录架构决策
4. 实现代码
   ↓
5. /roblox-code-review src/SystemName.lua
   ↓ 审查通过
6. /roblox-balance-check system-name
   ↓ 平衡检查通过
7. 测试
```

### 数值调整流程
```
1. 修改 GameConfig.lua
   ↓
2. /roblox-balance-check affected-system
   ↓ 检查平衡
3. 测试验证
   ↓
4. 提交
```

## Roblox 关键检查清单

### 服务器/客户端分离
- [ ] 数值计算在服务器
- [ ] 视觉效果在客户端
- [ ] RemoteEvent 通知客户端本地修改
- [ ] 不直接修改 Part 视觉属性

### DataStore 安全
- [ ] 所有操作有重试机制
- [ ] pcall 错误处理
- [ ] 数据大小 < 4MB
- [ ] Session Lock 防双开

### 性能
- [ ] 物体数量 ≤ 1700
- [ ] 热路径无内存分配
- [ ] 帧率 ≥ 60fps

### 数值设计
- [ ] 所有数值从 GameConfig 读取
- [ ] 公式有变量表和范围
- [ ] 边界情况有处理
- [ ] 无魔法数字

## 常见问题速查

### 问题：服务器修改属性影响所有玩家
**解决**: 服务器只发 RemoteEvent，客户端本地修改

### 问题：DataStore 数据丢失
**解决**: 添加重试机制 + BindToClose 处理

### 问题：积分溢出
**解决**: 限制最大值或使用加法叠加

### 问题：进度断层
**解决**: 平滑费用曲线

### 问题：必点路径
**解决**: 调整数值使各路径平衡

## 模板位置

- GDD: `templates/gdd-template.md`
- ADR: `templates/adr-template.md`
- 经济: `templates/economy-template.md`
- 测试: `templates/test-plan-template.md`

## 相关技能

- **roblox-free-assets**: 获取美术资源
- **roblox-http-push**: 推送大文件到 Studio
- **roblox-bone-animation**: 骨骼动画
- **roblox-vfx-planner**: VFX 特效

## 文件组织

```
project/
├── design/
│   ├── gdd/              # 游戏设计文档
│   ├── adr/              # 架构决策记录
│   └── balance/          # 平衡检查报告
├── GameConfig.lua        # 所有数值配置
├── GameManager.server.lua # 服务器入口
└── ...
```
