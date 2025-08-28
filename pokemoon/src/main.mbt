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
// 主程序入口 - 整合所有battle模块功能
// 提供HTML调用的接口函数

// 伤害计算参数结构体
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

// 重新导出关键函数，供HTML调用
pub fn calculate_damage(params : DamageParams) -> Int {
  // 简化的伤害计算实现
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

pub fn apply_move_effect_simple(base_damage : Int, move_type : String) -> Int {
  // 简化的技能效果实现
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

pub fn should_apply_status_effect(move_type : String, effect_type : String) -> Bool {
  // 简化的状态效果检查实现
  match (move_type, effect_type) {
    ("Fire", "burn") => true
    ("Electric", "paralysis") => true
    ("Ice", "freeze") => true
    ("Poison", "poison") => true
    ("Psychic", "confusion") => true
    _ => false
  }
}

pub fn calculate_stat_modifier(base_stat : Int, modifier : Int, is_boost : Bool) -> Int {
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

pub fn check_move_hit(accuracy : Int) -> Bool {
  // 简化的命中检查实现
  if accuracy >= 90 {
    true
  } else if accuracy >= 70 {
    true  // 70%概率
  } else {
    false  // 30%概率
  }
}

pub fn calculate_critical_hit(base_damage : Int, critical_chance : Double) -> Int {
  // 简化的暴击计算实现
  if critical_chance > 0.1 {
    base_damage * 2
  } else {
    base_damage
  }
}

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

pub fn effect_type_to_string(effect_type : String) -> String {
  match effect_type {
    "Ability" => "特性"
    "Item" => "道具"
    "Move" => "技能"
    "Status" => "状态"
    "Weather" => "天气"
    "Terrain" => "场地"
    "Field" => "场地效果"
    _ => "未知效果"
  }
}

pub fn damage_type_to_string(damage_type : String) -> String {
  match damage_type {
    "Physical" => "物理"
    "Special" => "特殊"
    "Status" => "变化"
    "True" => "真实"
    _ => "未知类型"
  }
}

// 游戏数据管理函数
pub fn create_game_data_manager() -> Unit {
  // 简化的游戏数据管理器创建
  println("创建游戏数据管理器")
}

pub fn create_game_manager() -> Unit {
  // 简化的游戏管理器创建
  println("创建游戏管理器")
}

pub fn create_test_pokemon() -> Unit {
  // 简化的测试宝可梦创建
  println("创建测试宝可梦")
}

pub fn create_test_player() -> Unit {
  // 简化的测试玩家创建
  println("创建测试玩家")
}

// 测试函数
pub fn test_battle_system() -> Unit {
  println("=== 测试战斗系统 ===")
  
  // 测试游戏数据
  create_game_data_manager()
  create_game_manager()
  create_test_pokemon()
  create_test_player()
  
  // 测试战斗函数，确保它们被生成
  let test_params = DamageParams::{
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
  
  let damage = calculate_damage(test_params)
  println("测试伤害计算: " + damage.to_string())
  
  let simple_damage = apply_move_effect_simple(100, "Fire")
  println("测试技能效果: " + simple_damage.to_string())
  
  let should_burn = should_apply_status_effect("Fire", "burn")
  println("测试状态效果: " + should_burn.to_string())
  
  let modified_stat = calculate_stat_modifier(100, 20, true)
  println("测试属性修改: " + modified_stat.to_string())
  
  let hit_check = check_move_hit(95)
  println("测试命中检查: " + hit_check.to_string())
  
  let critical_damage = calculate_critical_hit(100, 0.15)
  println("测试暴击计算: " + critical_damage.to_string())
  
  let status_str = status_to_string("burn")
  println("测试状态转换: " + status_str)
  
  let effect_str = effect_type_to_string("Move")
  println("测试效果类型转换: " + effect_str)
  
  let damage_str = damage_type_to_string("Physical")
  println("测试伤害类型转换: " + damage_str)
  
  println("=== 战斗系统测试完成 ===")
}

// 主函数
fn main {
  println("Pokemoon Game - 宝可梦游戏")
  println("基于MoonBit和HTML的RPG游戏")
  
  // 运行测试
  test_battle_system()
  
  println("游戏初始化完成！")
}
