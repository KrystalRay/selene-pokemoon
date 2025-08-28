# Battle Actions Module

这个模块实现了 Pokemon Moon 游戏中的战斗动作系统，仿照 Pokemon Showdown 的 battle-actions.ts 设计。

## 功能特性

### 1. 伤害类型系统
- **Physical**: 物理攻击
- **Special**: 特殊攻击  
- **Status**: 变化技能
- **True**: 真实伤害

### 2. 效果类型系统
- **Ability**: 特性效果
- **Item**: 道具效果
- **Move**: 技能效果
- **Status**: 状态效果
- **Weather**: 天气效果
- **Terrain**: 场地效果
- **Field**: 场地效果

### 3. 核心功能

#### 伤害计算
- `calculate_damage()`: 完整的伤害计算公式，考虑等级、属性、类型相性、STAB加成、暴击、天气等因素
- `apply_move_effect_simple()`: 简化的伤害计算，主要考虑基础伤害和类型加成

#### 状态效果
- `should_apply_status_effect()`: 检查是否应该应用状态效果（灼烧、麻痹、冰冻等）
- `status_to_string()`: 状态名称中文化

#### 属性修改
- `calculate_stat_modifier()`: 计算属性提升/降低后的数值
- 支持攻击、防御、特攻、特防、速度等属性

#### 战斗机制
- `check_move_hit()`: 技能命中检查
- `calculate_critical_hit()`: 暴击伤害计算

### 4. 数据结构

#### DamageParams
```moonbit
struct DamageParams {
  base_power : Int           // 基础威力
  attacker_level : Int       // 攻击者等级
  attacker_attack : Int      // 攻击者攻击力
  defender_defense : Int     // 防御者防御力
  type_effectiveness : Double // 类型相性
  stab_bonus : Double        // STAB加成
  critical_hit : Bool        // 是否暴击
  weather_modifier : Double  // 天气修正
  other_modifiers : Double   // 其他修正
}
```

#### MoveEffect
```moonbit
struct MoveEffect {
  id : String                // 效果ID
  name : String              // 效果名称
  effect_type : EffectType   // 效果类型
  duration : Option[Int]     // 持续时间
  description : String       // 效果描述
}
```

## 使用方法

### 基本伤害计算
```moonbit
let params = DamageParams::{
  base_power: 80,
  attacker_level: 50,
  attacker_attack: 100,
  defender_defense: 80,
  type_effectiveness: 1.5,
  stab_bonus: 1.5,
  critical_hit: false,
  weather_modifier: 1.0,
  other_modifiers: 1.0
}

let damage = calculate_damage(params)
```

### 简化技能效果
```moonbit
let damage = apply_move_effect_simple(100, "Fire")  // 火系技能
```

### 状态效果检查
```moonbit
let should_burn = should_apply_status_effect("Fire", "burn")
```

## 设计理念

1. **模块化**: 每个功能都有独立的函数，便于测试和维护
2. **可扩展**: 支持添加新的伤害类型、效果类型和战斗机制
3. **中文化**: 提供中文的状态和效果描述
4. **性能优化**: 使用简化的计算函数处理常见情况

## 未来扩展

- 添加更多状态效果（混乱、睡眠等）
- 实现天气和场地的具体效果
- 添加特性系统
- 实现道具效果
- 添加随机数生成器支持
- 实现更复杂的伤害计算公式

## 注意事项

- 当前版本使用简化的概率计算，实际游戏中应使用随机数生成器
- 部分功能（如属性修改）需要配合可变的数据结构使用
- 建议在实际使用前进行充分的测试 