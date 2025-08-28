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
// 状态机系统 - 简化版本，使用mbt支持的语法
// 管理游戏状态转换和状态历史

///|
// 状态转换记录
pub struct StateTransition {
  from_state : String
  to_state : String
  timestamp : Int
  reason : String
} derive(Show)

///|
// 状态机管理器
pub struct StateMachine {
  current_state : String
  previous_state : String
  transition_count : Int
  max_history_size : Int
} derive(Show)

///|
// 创建新的状态机
pub fn create_state_machine(initial_state : String, max_history : Int) -> StateMachine {
  StateMachine::{
    current_state: initial_state,
    previous_state: initial_state,
    transition_count: 0,
    max_history_size: max_history
  }
}

///|
// 执行状态转换
pub fn transition_to(
  machine : StateMachine,
  new_state : String,
  reason : String
) -> StateMachine {
  StateMachine::{
    current_state: new_state,
    previous_state: machine.current_state,
    transition_count: machine.transition_count + 1,
    max_history_size: machine.max_history_size
  }
}

///|
// 获取当前状态
pub fn get_current_state(machine : StateMachine) -> String {
  machine.current_state
}

///|
// 获取上一个状态
pub fn get_previous_state(machine : StateMachine) -> String {
  machine.previous_state
}

///|
// 检查是否可以转换到指定状态
pub fn can_transition_to(machine : StateMachine, target_state : String) -> Bool {
  // 简化的状态转换检查
  // 实际应用中应该有更复杂的规则
  machine.current_state != target_state
}

///|
// 获取转换次数
pub fn get_transition_count(machine : StateMachine) -> Int {
  machine.transition_count
}

///|
// 重置状态机
pub fn reset_state_machine(
  machine : StateMachine,
  new_initial_state : String
) -> StateMachine {
  StateMachine::{
    current_state: new_initial_state,
    previous_state: new_initial_state,
    transition_count: 0,
    max_history_size: machine.max_history_size
  }
}

///|
// 检查状态机是否处于指定状态
pub fn is_in_state(machine : StateMachine, state_name : String) -> Bool {
  machine.current_state == state_name
}

///|
// 获取状态机信息字符串
pub fn get_state_machine_info(machine : StateMachine) -> String {
  "Current: " + machine.current_state + 
  ", Previous: " + machine.previous_state + 
  ", Transitions: " + machine.transition_count.to_string()
}

///|
// 测试状态机功能
pub fn test_state_machine() -> Unit {
  println("=== 测试状态机系统 ===")
  
  // 创建状态机
  let machine = create_state_machine("Menu", 10)
  println("✓ 状态机创建成功: " + get_state_machine_info(machine))
  
  // 执行状态转换
  let machine2 = transition_to(machine, "Game", "用户点击开始游戏")
  println("✓ 状态转换成功: " + get_state_machine_info(machine2))
  
  // 再次转换
  let machine3 = transition_to(machine2, "Battle", "进入战斗")
  println("✓ 第二次转换成功: " + get_state_machine_info(machine3))
  
  // 检查状态
  let in_battle = is_in_state(machine3, "Battle")
  println("✓ 当前是否在战斗状态: " + in_battle.to_string())
  
  // 检查转换可能性
  let can_go_menu = can_transition_to(machine3, "Menu")
  println("✓ 是否可以回到菜单: " + can_go_menu.to_string())
  
  // 重置状态机
  let reset_machine = reset_state_machine(machine3, "Menu")
  println("✓ 状态机重置成功: " + get_state_machine_info(reset_machine))
} 