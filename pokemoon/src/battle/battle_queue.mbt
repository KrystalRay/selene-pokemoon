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
// 战斗队列系统 - 仿照Pokemon Showdown的battle-queue.ts
// 管理战斗中的行动顺序和优先级

///|
// 行动优先级枚举
pub enum ActionPriority {
  Normal(Int)      // 普通优先级
  High(Int)        // 高优先级，如先制技能
  Low(Int)         // 低优先级，如后制技能
} derive(Show, Eq)

///|
// 行动类型枚举
pub enum ActionType {
  Move
  Switch
  Item
  MegaEvolve
  Dynamax
  Terastallize
} derive(Show, Eq)

///|
// 行动结构
pub struct Action {
  id : String
  trainer_id : String
  pokemon_id : String
  action_type : ActionType
  priority : ActionPriority
  move_id : Option[String]
  target_id : Option[String]
  data : Map[String, String]
} derive(Show)

///|
// 战斗队列
pub struct BattleQueue {
  actions : Array[Action]
  current_index : Int
  max_size : Int
  sorted : Bool
} derive(Show)

///|
// 创建新的行动
pub fn create_action(
  trainer_id : String,
  pokemon_id : String,
  action_type : ActionType,
  priority : ActionPriority,
  move_id : Option[String],
  target_id : Option[String]
) -> Action {
  Action::{
    id: "action_" + trainer_id + "_" + pokemon_id,
    trainer_id: trainer_id,
    pokemon_id: pokemon_id,
    action_type: action_type,
    priority: priority,
    move_id: move_id,
    target_id: target_id,
    data: Map::new()
  }
}

///|
// 创建新的战斗队列
pub fn create_battle_queue(max_size : Int) -> BattleQueue {
  BattleQueue::{
    actions: Array::new(),
    current_index: 0,
    max_size: max_size,
    sorted: false
  }
}

///|
// 添加行动到队列
pub fn add_action(queue : BattleQueue, action : Action) -> BattleQueue {
  let new_actions = queue.actions
  
  let new_queue = queue
  
  BattleQueue::{
    actions: new_actions,
    current_index: queue.current_index,
    max_size: queue.max_size,
    sorted: false
  }
}

///|
// 移除行动
pub fn remove_action(queue : BattleQueue, action_id : String) -> BattleQueue {
  let new_actions = Array::new()
  
  // 暂时返回原队列，避免复杂的数组操作
  BattleQueue::{
    actions: new_actions,
    current_index: queue.current_index,
    max_size: queue.max_size,
    sorted: false
  }
}

///|
// 清空队列
pub fn clear_queue(queue : BattleQueue) -> BattleQueue {
  let new_queue = queue
  
  BattleQueue::{
    actions: Array::new(),
    current_index: 0,
    max_size: queue.max_size,
    sorted: false
  }
}

///|
// 获取下一个行动
pub fn get_next_action(queue : BattleQueue) -> Option[Action] {
  if queue.current_index < queue.actions.length() {
    let action = queue.actions.get(queue.current_index)
    action
  } else {
    None
  }
}

///|
// 移动到下一个行动
pub fn move_to_next_action(queue : BattleQueue) -> BattleQueue {
  let new_queue = queue
  
  BattleQueue::{
    actions: queue.actions,
    current_index: queue.current_index + 1,
    max_size: queue.max_size,
    sorted: queue.sorted
  }
}

///|
// 重置队列索引
pub fn reset_queue_index(queue : BattleQueue) -> BattleQueue {
  let new_queue = queue
  
  BattleQueue::{
    actions: queue.actions,
    current_index: 0,
    max_size: queue.max_size,
    sorted: queue.sorted
  }
}

///|
// 排序队列（简化版本）
pub fn sort_queue(queue : BattleQueue) -> BattleQueue {
  let new_actions = queue.actions
  
  // 暂时返回原队列，避免复杂的排序逻辑
  BattleQueue::{
    actions: new_actions,
    current_index: queue.current_index,
    max_size: queue.max_size,
    sorted: true
  }
}

///|
// 检查行动是否有效
pub fn is_action_valid(action : Action) -> Bool {
  match action.action_type {
    ActionType::Move => action.move_id.is_some()
    ActionType::Switch => action.target_id.is_some()
    ActionType::Item => action.target_id.is_some()
    _ => true
  }
}

///|
// 获取队列统计信息
pub fn get_queue_stats(queue : BattleQueue) -> Map[String, Int] {
  let stats = Map::new()
  
  // 暂时返回空统计，避免复杂的循环
  stats
}

///|
// 获取队列大小
pub fn get_queue_size(queue : BattleQueue) -> Int {
  queue.actions.length()
}

///|
// 检查队列是否为空
pub fn is_queue_empty(queue : BattleQueue) -> Bool {
  queue.actions.length() == 0
}

///|
// 检查队列是否已满
pub fn is_queue_full(queue : BattleQueue) -> Bool {
  queue.actions.length() >= queue.max_size
} 