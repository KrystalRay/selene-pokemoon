// Copyright 2025 International Digital Economy Academy
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

///|
// 战斗动作系统 - 仿照Pokemon Showdown的battle-actions.ts
// 处理所有战斗中的具体动作，如技能使用、状态变化等

///|
// 伤害类型枚举
pub enum DamageType {
  Physical
  Special
  Status
  True
} derive(Show, Eq)

///|
// 效果类型枚举
pub enum EffectType {
  Ability
  Item
  Move
  Status
  Weather
  Terrain
  Field
} derive(Show, Eq)

///|
// 技能效果
pub struct MoveEffect {
  id : String
  name : String
  effect_type : EffectType
  duration : Option[Int]
  description : String
} derive(Show)

///|
// 状态效果
pub struct StatusEffect {
  id : String
  name : String
  effect_type : EffectType
  duration : Option[Int]
  description : String
} derive(Show)

///|
// 伤害计算参数
pub struct DamageParams {
  base_power : Int
  attacker_level : Int
  attacker_attack : Int
  defender_defense : Int
  type_effectiveness : Double
  stab_bonus : Double
  critical_hit : Bool
  weather_modifier : Double
  other_modifiers : Double
} derive(Show)

///|
// 计算技能伤害
pub fn calculate_damage(params : DamageParams) -> Int {
  let base_damage = (2 * params.attacker_level / 5 + 2) * 
                    params.base_power * 
                    params.attacker_attack / 
                    params.defender_defense / 50 + 2
  
  let final_damage = base_damage.to_double() * 
                     params.type_effectiveness * 
                     params.stab_bonus * 
                     params.weather_modifier * 
                     params.other_modifiers
  
  if params.critical_hit {
    (final_damage * 2.0).to_int()
  } else {
    final_damage.to_int()
  }
}

///|
// 应用技能效果（简化版本）
pub fn apply_move_effect_simple(
  base_damage : Int,
  move_type : String
) -> Int {
  // 简化的伤害计算，只考虑基础伤害和类型
  let type_multiplier = match move_type {
    "Fire" => 1.5
    "Water" => 1.3
    "Electric" => 1.4
    "Grass" => 1.2
    "Ice" => 1.3
    "Fighting" => 1.4
    "Poison" => 1.2
    "Ground" => 1.3
    "Flying" => 1.3
    "Psychic" => 1.4
    "Bug" => 1.1
    "Rock" => 1.3
    "Ghost" => 1.4
    "Dragon" => 1.5
    "Dark" => 1.3
    "Steel" => 1.2
    "Fairy" => 1.3
    _ => 1.0
  }
  
  (base_damage.to_double() * type_multiplier).to_int()
}

///|
// 检查是否应该应用状态效果
pub fn should_apply_status_effect(move_type : String, effect_type : String) -> Bool {
  // 简化的状态效果检查
  match (move_type, effect_type) {
    ("Fire", "burn") => true
    ("Electric", "paralysis") => true
    ("Ice", "freeze") => true
    ("Poison", "poison") => true
    ("Psychic", "confusion") => true
    _ => false
  }
}

///|
// 计算属性提升/降低
pub fn calculate_stat_modifier(
  base_stat : Int,
  modifier : Int,
  is_boost : Bool
) -> Int {
  if is_boost {
    base_stat + modifier
  } else {
    let reduced = base_stat - modifier
    if reduced < 1 {
      1
    } else {
      reduced
    }
  }
}

///|
// 检查技能命中
pub fn check_move_hit(accuracy : Int) -> Bool {
  // 简化的命中检查，实际应该使用随机数生成器
  // 这里暂时返回固定值用于演示
  if accuracy >= 90 {
    true
  } else if accuracy >= 70 {
    true  // 70%概率
  } else {
    false  // 30%概率
  }
}

///|
// 计算暴击
pub fn calculate_critical_hit(base_damage : Int, critical_chance : Double) -> Int {
  // 简化的暴击计算
  if critical_chance > 0.1 {
    base_damage * 2
  } else {
    base_damage
  }
}

///|
// 状态转字符串
pub fn status_to_string(status_name : String) -> String {
  match status_name {
    "normal" => "正常"
    "poison" => "中毒"
    "burn" => "灼烧"
    "freeze" => "冰冻"
    "paralysis" => "麻痹"
    "sleep" => "睡眠"
    "fainted" => "濒死"
    _ => "未知状态"
  }
}

///|
// 效果类型转字符串
pub fn effect_type_to_string(effect_type : EffectType) -> String {
  match effect_type {
    Ability => "特性"
    Item => "道具"
    Move => "技能"
    Status => "状态"
    Weather => "天气"
    Terrain => "场地"
    Field => "场地效果"
  }
}

///|
// 伤害类型转字符串
pub fn damage_type_to_string(damage_type : DamageType) -> String {
  match damage_type {
    Physical => "物理"
    Special => "特殊"
    Status => "变化"
    True => "真实"
  }
}

///|
// 测试函数 - 验证基本功能
pub fn test_battle_actions() -> Unit {
  // 测试伤害计算
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
  println("Calculated damage: " + damage.to_string())
  
  // 测试简化技能效果
  let simple_damage = apply_move_effect_simple(100, "Fire")
  println("Simple fire move damage: " + simple_damage.to_string())
  
  // 测试状态效果检查
  let should_burn = should_apply_status_effect("Fire", "burn")
  println("Should apply burn: " + should_burn.to_string())
  
  // 测试属性修改
  let modified_stat = calculate_stat_modifier(100, 20, true)
  println("Modified stat (boost): " + modified_stat.to_string())
  
  // 测试命中检查
  let hit_check = check_move_hit(95)
  println("Move hit check: " + hit_check.to_string())
  
  // 测试暴击计算
  let critical_damage = calculate_critical_hit(100, 0.15)
  println("Critical hit damage: " + critical_damage.to_string())
  
  // 测试字符串转换
  let status_str = status_to_string("burn")
  println("Status string: " + status_str)
  
  let effect_str = effect_type_to_string(EffectType::Move)
  println("Effect type string: " + effect_str)
  
  let damage_str = damage_type_to_string(DamageType::Physical)
  println("Damage type string: " + damage_str)
} 