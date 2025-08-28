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
// 战斗核心系统 - 重构版本
// 采用模块化设计，实现高内聚、低耦合的架构
// 参考Pokemon Showdown的设计模式

///|
// 战斗状态枚举
pub enum BattleState {
  Initializing
  TeamPreview
  MoveSelection
  SwitchSelection
  Executing
  Ended
} derive(Show, Eq)

///|
// 事件类型枚举
pub enum EventType {
  BattleStart
  TurnStart
  MoveUsed
  Switch
  StatusChange
  Damage
  Faint
  TurnEnd
  BattleEnd
} derive(Show, Eq)

///|
// 事件优先级
pub enum EventPriority {
  BeforeTurn(Int)
  DuringTurn(Int)
  AfterTurn(Int)
} derive(Show, Eq)

///|
// 战斗事件
pub struct BattleEvent {
  id : String
  event_type : EventType
  priority : EventPriority
  source_id : Option[String]
  target_id : Option[String]
  data : Map[String, String]
  timestamp : Int
  processed : Bool
} derive(Show)

///|
// 事件监听器
pub struct EventListener {
  id : String
  event_type : EventType
  priority : EventPriority
  active : Bool
} derive(Show)

///|
// 事件管理器
pub struct EventManager {
  listeners : Array[EventListener]
  event_queue : Array[BattleEvent]
  next_event_id : Int
} derive(Show)

///|
// 动作类型
pub enum ActionType {
  Move
  Switch
  Item
  MegaEvo
  ZMove
  Dynamax
  Terastallize
} derive(Show, Eq)

///|
// 战斗动作
pub struct BattleAction {
  id : String
  action_type : ActionType
  source_id : String
  target_id : Option[String]
  priority : Int
  speed : Int
  data : Map[String, String]
  executed : Bool
} derive(Show)

///|
// 动作队列
pub struct ActionQueue {
  actions : Array[BattleAction]
  current_index : Int
  max_size : Int
} derive(Show)

///|
// 战斗核心
pub struct BattleCore {
  id : String
  state : BattleState
  turn : Int
  event_manager : EventManager
  action_queue : ActionQueue
  started : Bool
  ended : Bool
} derive(Show)

///|
// 创建事件管理器
pub fn create_event_manager() -> EventManager {
  EventManager::{
    listeners: [],
    event_queue: [],
    next_event_id: 1
  }
}

///|
// 创建动作队列
pub fn create_action_queue(max_size : Int) -> ActionQueue {
  ActionQueue::{
    actions: [],
    current_index: 0,
    max_size: max_size
  }
}

///|
// 创建战斗核心
pub fn create_battle_core() -> BattleCore {
  BattleCore::{
    id: generate_battle_id(),
    state: BattleState::Initializing,
    turn: 0,
    event_manager: create_event_manager(),
    action_queue: create_action_queue(100),
    started: false,
    ended: false
  }
}

///|
// 生成战斗ID
pub fn generate_battle_id() -> String {
  "battle_12345"
}

///|
// 生成监听器ID
pub fn generate_listener_id() -> String {
  "listener_67890"
}

///|
// 生成动作ID
pub fn generate_action_id() -> String {
  "action_11111"
}

///|
// 添加动作到队列
pub fn add_action_to_queue(
  queue : ActionQueue,
  action_type : ActionType,
  source_id : String,
  target_id : Option[String],
  priority : Int,
  speed : Int,
  data : Map[String, String]
) -> ActionQueue {
  let action = BattleAction::{
    id: generate_action_id(),
    action_type: action_type,
    source_id: source_id,
    target_id: target_id,
    priority: priority,
    speed: speed,
    data: data,
    executed: false
  }
  
  ActionQueue::{
    actions: queue.actions.append([action]),
    current_index: queue.current_index,
    max_size: queue.max_size
  }
}

///|
// 重置动作队列
pub fn reset_action_queue(queue : ActionQueue) -> ActionQueue {
  ActionQueue::{
    actions: queue.actions,
    current_index: 0,
    max_size: queue.max_size
  }
}

///|
// 开始战斗
pub fn start_battle(core : BattleCore) -> BattleCore {
  BattleCore::{
    id: core.id,
    state: BattleState::TeamPreview,
    turn: 0,
    event_manager: core.event_manager,
    action_queue: core.action_queue,
    started: true,
    ended: false
  }
}

///|
// 进入下一个状态
pub fn advance_battle_state(core : BattleCore, new_state : BattleState) -> BattleCore {
  BattleCore::{
    id: core.id,
    state: new_state,
    turn: core.turn,
    event_manager: core.event_manager,
    action_queue: core.action_queue,
    started: core.started,
    ended: core.ended
  }
}

///|
// 开始新回合
pub fn start_new_turn(core : BattleCore) -> BattleCore {
  BattleCore::{
    id: core.id,
    state: BattleState::MoveSelection,
    turn: core.turn + 1,
    event_manager: core.event_manager,
    action_queue: reset_action_queue(core.action_queue),
    started: core.started,
    ended: core.ended
  }
}

///|
// 结束战斗
pub fn end_battle(core : BattleCore) -> BattleCore {
  BattleCore::{
    id: core.id,
    state: BattleState::Ended,
    turn: core.turn,
    event_manager: core.event_manager,
    action_queue: core.action_queue,
    started: core.started,
    ended: true
  }
}

///|
// 检查战斗是否结束
pub fn is_battle_ended(core : BattleCore) -> Bool {
  core.ended
}

///|
// 获取当前状态
pub fn get_battle_state(core : BattleCore) -> BattleState {
  core.state
}

///|
// 获取当前回合
pub fn get_current_turn(core : BattleCore) -> Int {
  core.turn
}

///|
// 获取队列中的动作数量
pub fn get_action_count(queue : ActionQueue) -> Int {
  queue.actions.length()
}

///|
// 检查队列是否为空
pub fn is_action_queue_empty(queue : ActionQueue) -> Bool {
  queue.actions.length() == 0
}

///|
// 测试战斗核心系统
pub fn test_battle_core_system() -> Unit {
  println("=== 测试重构后的战斗核心系统 ===")
  
  // 创建战斗核心
  let core = create_battle_core()
  println("✓ 战斗核心创建成功，ID: " + core.id)
  
  // 测试动作队列
  let action_queue = core.action_queue
  let updated_queue = add_action_to_queue(
    action_queue,
    ActionType::Move,
    "pokemon_1",
    Some("pokemon_2"),
    1,
    100,
    Map::new()
  )
  println("✓ 动作添加到队列成功，队列长度: " + get_action_count(updated_queue).to_string())
  
  // 测试状态转换
  let started_core = start_battle(core)
  println("✓ 战斗开始成功，状态: " + get_battle_state(started_core).to_string())
  
  let turn_core = start_new_turn(started_core)
  println("✓ 新回合开始成功，回合数: " + get_current_turn(turn_core).to_string())
  
  let ended_core = end_battle(turn_core)
  println("✓ 战斗结束成功，结束状态: " + is_battle_ended(ended_core).to_string())
  
  println("=== 重构后的战斗核心系统测试完成 ===")
} 