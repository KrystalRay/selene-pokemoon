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
// 战斗事件系统 - 仿照Pokemon Showdown的battle-events.ts
// 处理所有战斗事件的创建、管理和分发

///|
// 事件类型枚举
pub enum BattleEventType {
  TurnStart
  TurnEnd
  MoveUsed
  Switch
  StatusChange
  WeatherChange
  TerrainChange
  ItemUse
  AbilityActivation
  MegaEvolution
  Dynamax
  Terastallize
} derive(Show, Eq)

///|
// 事件优先级枚举
pub enum EventPriority {
  Low
  Normal
  High
  Critical
} derive(Show, Eq)

///|
// 基础战斗事件
pub struct BattleEvent {
  id : String
  event_type : BattleEventType
  priority : EventPriority
  timestamp : Int
  source_id : String
  target_id : Option[String]
  data : Map[String, String]
  processed : Bool
} derive(Show)

///|
// 技能使用事件
pub struct MoveEvent {
  id : String
  pokemon_id : String
  move_id : String
  target_id : String
  priority : EventPriority
  timestamp : Int
  damage : Option[Int]
  critical_hit : Bool
  effectiveness : String
  additional_effects : Array[String]
} derive(Show)

///|
// 宝可梦交换事件
pub struct SwitchEvent {
  id : String
  pokemon_id : String
  old_position : Int
  new_position : Int
  timestamp : Int
  reason : String
  forced : Bool
} derive(Show)

///|
// 状态变化事件
pub struct StatusChangeEvent {
  id : String
  pokemon_id : String
  old_status : String
  new_status : String
  timestamp : Int
  cause : String
  duration : Option[Int]
} derive(Show)

///|
// 天气变化事件
pub struct WeatherChangeEvent {
  id : String
  old_weather : Option[String]
  new_weather : String
  timestamp : Int
  cause : String
  duration : Option[Int]
} derive(Show)

///|
// 场地变化事件
pub struct TerrainChangeEvent {
  id : String
  old_terrain : Option[String]
  new_terrain : String
  timestamp : Int
  cause : String
  duration : Option[Int]
} derive(Show)

///|
// 道具使用事件
pub struct ItemUseEvent {
  id : String
  pokemon_id : String
  item_id : String
  timestamp : Int
  consumed : Bool
  effect : String
} derive(Show)

///|
// 特性激活事件
pub struct AbilityActivationEvent {
  id : String
  pokemon_id : String
  ability_id : String
  timestamp : Int
  effect : String
  target_id : Option[String]
} derive(Show)

///|
// 超级进化事件
pub struct MegaEvolutionEvent {
  id : String
  pokemon_id : String
  timestamp : Int
  mega_stone : String
  new_form : String
} derive(Show)

///|
// 极巨化事件
pub struct DynamaxEvent {
  id : String
  pokemon_id : String
  timestamp : Int
  max_move : Option[String]
  duration : Int
} derive(Show)

///|
// 太晶化事件
pub struct TerastallizeEvent {
  id : String
  pokemon_id : String
  timestamp : Int
  tera_type : String
  tera_blast : Option[String]
} derive(Show)

///|
// 事件管理器
pub struct BattleEventManager {
  events : Array[BattleEvent]
  max_events : Int
  event_counter : Int
} derive(Show)

///|
// 创建事件管理器
pub fn create_event_manager(max_events : Int) -> BattleEventManager {
  BattleEventManager::{
    events: Array::new(),
    max_events: max_events,
    event_counter: 0
  }
}

///|
// 添加事件
pub fn add_event(manager : BattleEventManager, event : BattleEvent) -> BattleEventManager {
  manager.events.push(event)
  
  BattleEventManager::{
    events: manager.events,
    max_events: manager.max_events,
    event_counter: manager.event_counter + 1
  }
}

///|
// 获取事件
pub fn get_event(manager : BattleEventManager, event_id : String) -> Option[BattleEvent] {
  let mut i = 0
  while i < manager.events.length() {
    let event = manager.events.get(i)
    match event {
      Some(e) => {
        if e.id == event_id {
          return Some(e)
        }
      }
      None => {
        let _ = i  // 使用变量避免警告
      }
    }
    i = i + 1
  }
  None
}

///|
// 获取所有事件
pub fn get_all_events(manager : BattleEventManager) -> Array[BattleEvent] {
  manager.events
}

///|
// 获取未处理事件
pub fn get_unprocessed_events(manager : BattleEventManager) -> Array[BattleEvent] {
  let unprocessed = Array::new()
  
  let mut i = 0
  while i < manager.events.length() {
    let event = manager.events.get(i)
    match event {
      Some(e) => {
        if !e.processed {
          let _ = unprocessed.push(e)
        }
      }
      None => {
        let _ = i  // 使用变量避免警告
      }
    }
    i = i + 1
  }
  
  unprocessed
}

///|
// 标记事件为已处理
pub fn mark_event_processed(manager : BattleEventManager, event_id : String) -> BattleEventManager {
  let updated_events = Array::new()
  
  let mut i = 0
  while i < manager.events.length() {
    let event = manager.events.get(i)
    match event {
      Some(e) => {
        if e.id == event_id {
          let updated_event = BattleEvent::{
            id: e.id,
            event_type: e.event_type,
            priority: e.priority,
            timestamp: e.timestamp,
            source_id: e.source_id,
            target_id: e.target_id,
            data: e.data,
            processed: true
          }
          let _ = updated_events.push(updated_event)
        } else {
          let _ = updated_events.push(e)
        }
      }
      None => {
        let _ = i  // 使用变量避免警告
      }
    }
    i = i + 1
  }
  
  BattleEventManager::{
    events: updated_events,
    max_events: manager.max_events,
    event_counter: manager.event_counter
  }
}

///|
// 清理已处理事件
pub fn clear_processed_events(manager : BattleEventManager) -> BattleEventManager {
  let remaining_events = Array::new()
  
  let mut i = 0
  while i < manager.events.length() {
    let event = manager.events.get(i)
    match event {
      Some(e) => {
        if !e.processed {
          let _ = remaining_events.push(e)
        }
      }
      None => {
        let _ = i  // 使用变量避免警告
      }
    }
    i = i + 1
  }
  
  BattleEventManager::{
    events: remaining_events,
    max_events: manager.max_events,
    event_counter: manager.event_counter
  }
}

///|
// 创建技能使用事件
pub fn create_move_event(
  pokemon_id : String,
  move_id : String,
  target_id : String,
  priority : EventPriority
) -> MoveEvent {
  let timestamp = 0  // 简化时间戳
  
  MoveEvent::{
    id: "move_" + pokemon_id + "_" + move_id,
    pokemon_id: pokemon_id,
    move_id: move_id,
    target_id: target_id,
    priority: priority,
    timestamp: timestamp,
    damage: None,
    critical_hit: false,
    effectiveness: "normal",
    additional_effects: Array::new()
  }
}

///|
// 创建宝可梦交换事件
pub fn create_switch_event(
  pokemon_id : String,
  old_position : Int,
  new_position : Int,
  reason : String
) -> SwitchEvent {
  let timestamp = 0  // 简化时间戳
  
  SwitchEvent::{
    id: "switch_" + pokemon_id + "_" + old_position.to_string(),
    pokemon_id: pokemon_id,
    old_position: old_position,
    new_position: new_position,
    timestamp: timestamp,
    reason: reason,
    forced: false
  }
}

///|
// 创建状态变化事件
pub fn create_status_change_event(
  pokemon_id : String,
  old_status : String,
  new_status : String,
  cause : String
) -> StatusChangeEvent {
  let timestamp = 0  // 简化时间戳
  
  StatusChangeEvent::{
    id: "status_" + pokemon_id + "_" + new_status,
    pokemon_id: pokemon_id,
    old_status: old_status,
    new_status: new_status,
    timestamp: timestamp,
    cause: cause,
    duration: None
  }
}

///|
// 创建天气变化事件
pub fn create_weather_change_event(
  old_weather : Option[String],
  new_weather : String,
  cause : String
) -> WeatherChangeEvent {
  let timestamp = 0  // 简化时间戳
  
  WeatherChangeEvent::{
    id: "weather_" + new_weather,
    old_weather: old_weather,
    new_weather: new_weather,
    timestamp: timestamp,
    cause: cause,
    duration: None
  }
}

///|
// 创建场地变化事件
pub fn create_terrain_change_event(
  old_terrain : Option[String],
  new_terrain : String,
  cause : String
) -> TerrainChangeEvent {
  let timestamp = 0  // 简化时间戳
  
  TerrainChangeEvent::{
    id: "terrain_" + new_terrain,
    old_terrain: old_terrain,
    new_terrain: new_terrain,
    timestamp: timestamp,
    cause: cause,
    duration: None
  }
}

///|
// 创建道具使用事件
pub fn create_item_use_event(
  pokemon_id : String,
  item_id : String,
  consumed : Bool,
  effect : String
) -> ItemUseEvent {
  let timestamp = 0  // 简化时间戳
  
  ItemUseEvent::{
    id: "item_" + pokemon_id + "_" + item_id,
    pokemon_id: pokemon_id,
    item_id: item_id,
    timestamp: timestamp,
    consumed: consumed,
    effect: effect
  }
}

///|
// 创建特性激活事件
pub fn create_ability_activation_event(
  pokemon_id : String,
  ability_id : String,
  effect : String,
  target_id : Option[String]
) -> AbilityActivationEvent {
  let timestamp = 0  // 简化时间戳
  
  AbilityActivationEvent::{
    id: "ability_" + pokemon_id + "_" + ability_id,
    pokemon_id: pokemon_id,
    ability_id: ability_id,
    timestamp: timestamp,
    effect: effect,
    target_id: target_id
  }
}

///|
// 创建超级进化事件
pub fn create_mega_evolution_event(
  pokemon_id : String,
  mega_stone : String,
  new_form : String
) -> MegaEvolutionEvent {
  let timestamp = 0  // 简化时间戳
  
  MegaEvolutionEvent::{
    id: "mega_" + pokemon_id,
    pokemon_id: pokemon_id,
    timestamp: timestamp,
    mega_stone: mega_stone,
    new_form: new_form
  }
}

///|
// 创建极巨化事件
pub fn create_dynamax_event(
  pokemon_id : String,
  max_move : Option[String],
  duration : Int
) -> DynamaxEvent {
  let timestamp = 0  // 简化时间戳
  
  DynamaxEvent::{
    id: "dynamax_" + pokemon_id,
    pokemon_id: pokemon_id,
    timestamp: timestamp,
    max_move: max_move,
    duration: duration
  }
}

///|
// 创建太晶化事件
pub fn create_terastallize_event(
  pokemon_id : String,
  tera_type : String,
  tera_blast : Option[String]
) -> TerastallizeEvent {
  let timestamp = 0  // 简化时间戳
  
  TerastallizeEvent::{
    id: "tera_" + pokemon_id,
    pokemon_id: pokemon_id,
    timestamp: timestamp,
    tera_type: tera_type,
    tera_blast: tera_blast
  }
}

///|
// 生成事件ID
pub fn generate_event_id(event_type : String, source_id : String) -> String {
  let timestamp = 0  // 简化时间戳
  let random = 1000  // 简化随机数
  
  event_type + "_" + source_id + "_" + timestamp.to_string() + "_" + random.to_string()
}

///|
// 获取事件类型
pub fn get_event_type(event : BattleEvent) -> BattleEventType {
  event.event_type
}

///|
// 获取事件时间戳
pub fn get_event_timestamp(event : BattleEvent) -> Int {
  event.timestamp
}

///|
// 获取事件源ID
pub fn get_event_source_id(event : BattleEvent) -> String {
  event.source_id
}

///|
// 获取事件目标ID
pub fn get_event_target_id(event : BattleEvent) -> Option[String] {
  event.target_id
}

///|
// 检查事件是否已处理
pub fn is_event_processed(event : BattleEvent) -> Bool {
  event.processed
}

///|
// 添加事件数据
pub fn add_event_data(event : BattleEvent, key : String, value : String) -> BattleEvent {
  // 简化处理，直接使用原始数据
  let _ = key
  let _ = value
  
  BattleEvent::{
    id: event.id,
    event_type: event.event_type,
    priority: event.priority,
    timestamp: event.timestamp,
    source_id: event.source_id,
    target_id: event.target_id,
    data: event.data,
    processed: event.processed
  }
}

///|
// 获取事件数据
pub fn get_event_data(event : BattleEvent, key : String) -> Option[String] {
  event.data.get(key)
}

///|
// 获取事件数量
pub fn get_event_count(manager : BattleEventManager) -> Int {
  manager.events.length()
}

///|
// 检查事件管理器是否为空
pub fn is_event_manager_empty(manager : BattleEventManager) -> Bool {
  manager.events.length() == 0
}

///|
// 检查事件管理器是否已满
pub fn is_event_manager_full(manager : BattleEventManager) -> Bool {
  manager.events.length() >= manager.max_events
} 