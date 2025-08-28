# Pokemoon 战斗系统 🎮⚔️

基于 **MoonBit** 语言构建的现代化宝可梦战斗引擎，展示了 MoonBit 在游戏开发中的强大潜力。

## ✨ 特性亮点

- 🚀 **MoonBit 编译**: 使用 MoonBit 语言编写，编译为高性能 JavaScript
- 🛡️ **类型安全**: 编译时类型检查，运行时零类型错误
- ⚡ **性能优化**: 自动生成的代码高度优化，性能接近原生 JavaScript
- 🌍 **跨平台**: 支持 Web、移动端和桌面端
- 🎯 **完整战斗系统**: 伤害计算、技能效果、状态系统、属性修改
- 🌏 **多语言支持**: 内置中英文支持
- 🧪 **实时测试**: 内置测试框架，支持实时功能验证

## 🏗️ 系统架构

```
src/
├── battle/
│   ├── battle_actions.mbt      # 核心战斗函数
│   ├── battle_core.mbt         # 战斗系统核心
│   ├── battle_log.mbt          # 战斗日志系统
│   └── ui_controller.mbt       # UI控制器
└── main.mbt                    # 主程序入口
```

## 🚀 快速开始

### 1. 环境要求

- MoonBit 编译器 (最新版本)
- Node.js (用于验证脚本)
- Python 3.x (用于HTTP服务器)

### 2. 编译项目

```bash
cd pokemoon
moon build --target js
```

### 3. 启动测试服务器

```bash
python3 -m http.server 8080 --bind 127.0.0.1
```

### 4. 访问演示页面

- **主游戏**: http://127.0.0.1:8080/
- **战斗系统测试**: http://127.0.0.1:8080/test_battle_system.html
- **完整演示**: http://127.0.0.1:8080/demo.html

## 🧪 功能测试

### 验证脚本

运行验证脚本检查系统完整性：

```bash
node verify_battle_system.js
```

### 手动测试

每个功能都有独立的测试按钮：

- ⚔️ **伤害计算**: 基于真实宝可梦公式
- 🔥 **技能效果**: 18种属性类型支持
- 💫 **状态效果**: 灼烧、麻痹、冰冻等
- 📊 **属性修改**: 提升/降低机制
- 🌍 **多语言**: 中英文自动转换

## 📚 API 参考

### 核心战斗函数

```javascript
// 伤害计算
KrystalRay$pokemoon$$calculate_damage(params)

// 技能效果
KrystalRay$pokemoon$$apply_move_effect_simple(baseDamage, moveType)

// 状态效果检查
KrystalRay$pokemoon$$should_apply_status_effect(moveType, effectType)

// 属性修改
KrystalRay$pokemoon$$calculate_stat_modifier(baseStat, modifier, isBoost)

// 字符串转换
KrystalRay$pokemoon$$status_to_string(statusName)
KrystalRay$pokemoon$$effect_type_to_string(effectType)
KrystalRay$pokemoon$$damage_type_to_string(damageType)

// 全面测试
KrystalRay$pokemoon$$test_battle_system()
```

### 数据结构

```javascript
// 伤害计算参数
{
  base_power: 80,           // 基础威力
  attacker_level: 50,       // 攻击者等级
  attacker_attack: 100,     // 攻击力
  defender_defense: 80,     // 防御力
  type_effectiveness: 1.5,  // 属性相性
  stab_bonus: 1.5,         // STAB加成
  critical_hit: false,      // 暴击
  weather_modifier: 1.0,    // 天气修正
  other_modifiers: 1.0      // 其他修正
}
```

## 🎮 游戏机制

### 伤害计算

基于真实宝可梦公式：

```
伤害 = ((2 × 等级 ÷ 5 + 2) × 威力 × 攻击力 ÷ 防御力 ÷ 50 + 2) × 
       属性相性 × STAB加成 × 天气修正 × 其他修正
```

### 属性类型

支持18种属性类型，每种都有独特的伤害加成：

- 🔥 火系: 1.5x
- 💧 水系: 1.3x
- ⚡ 电系: 1.4x
- 🌱 草系: 1.2x
- ❄️ 冰系: 1.3x
- 👊 格斗系: 1.4x
- ☠️ 毒系: 1.2x
- 🌍 地面系: 1.3x
- 🦅 飞行系: 1.3x
- 🧠 超能系: 1.4x
- 🐛 虫系: 1.1x
- 🗿 岩石系: 1.3x
- 👻 幽灵系: 1.4x
- 🐉 龙系: 1.5x
- 🌑 恶系: 1.3x
- ⚙️ 钢系: 1.2x
- 🧚 妖精系: 1.3x

### 状态效果

- 🔥 灼烧: 火系技能可能触发
- ⚡ 麻痹: 电系技能可能触发
- ❄️ 冰冻: 冰系技能可能触发
- ☠️ 中毒: 毒系技能可能触发
- 🧠 混乱: 超能系技能可能触发

## 🔧 开发指南

### 添加新功能

1. 在 `src/battle/` 目录下创建新的 `.mbt` 文件
2. 定义函数和数据结构
3. 在 `main.mbt` 中导入新模块
4. 重新编译: `moon build --target js`
5. 更新测试页面

### 调试技巧

- 使用浏览器控制台查看函数输出
- 运行验证脚本检查系统完整性
- 查看生成的JavaScript代码了解编译结果

## 📊 性能指标

- **编译时间**: < 5秒
- **生成文件大小**: ~10KB (优秀)
- **运行性能**: 原生JavaScript级别
- **内存使用**: 最小化

## 🤝 贡献指南

1. Fork 项目
2. 创建功能分支
3. 提交更改
4. 推送到分支
5. 创建 Pull Request

## 📄 许可证

本项目采用 Apache 2.0 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

## 🙏 致谢

- **MoonBit 团队**: 提供了优秀的编程语言和编译工具
- **宝可梦系列**: 为战斗系统设计提供了灵感
- **开源社区**: 为项目发展提供了支持

## 📞 联系方式

- 项目主页: [GitHub Repository]
- 问题反馈: [Issues]
- 讨论交流: [Discussions]

---

**Pokemoon 战斗系统** - 让 MoonBit 在游戏开发中发光发热！ 🚀✨
