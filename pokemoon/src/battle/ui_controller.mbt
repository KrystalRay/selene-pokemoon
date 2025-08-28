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
// UI控制器 - 实现游戏画面与HTML UI的交互
// 保持高内聚、低耦合的模块化设计

///|
// 游戏状态枚举
pub enum GameState {
  Initializing
  Ready
  Battle
  Menu
  Paused
  GameOver
} derive(Show, Eq)

///|
// 交互事件类型
pub enum InteractionEvent {
  ButtonClick(String)
  KeyPress(String)
  MouseClick(Int, Int)
  StateChange(GameState)
  BattleAction(String)
} derive(Show)

///|
// UI元素状态
pub struct UIElement {
  id: String
  visible: Bool
  enabled: Bool
  text: String
  position_x: Int
  position_y: Int
} derive(Show)

///|
// 游戏交互管理器
pub struct GameInteractionManager {
  current_state: GameState
  ui_elements: Array[UIElement]
  event_handlers: Array[String]
} derive(Show)

///|
// 创建新的交互管理器
pub fn create_interaction_manager() -> GameInteractionManager {
  GameInteractionManager::{
    current_state: GameState::Initializing,
    ui_elements: [],
    event_handlers: []
  }
}

///|
// 更新游戏状态
pub fn update_game_state(
  manager: GameInteractionManager,
  new_state: GameState
) -> GameInteractionManager {
  GameInteractionManager::{
    current_state: new_state,
    ui_elements: manager.ui_elements,
    event_handlers: manager.event_handlers
  }
}

///|
// 添加UI元素
pub fn add_ui_element(
  manager: GameInteractionManager,
  element: UIElement
) -> GameInteractionManager {
  let new_elements = manager.ui_elements + [element]
  GameInteractionManager::{
    current_state: manager.current_state,
    ui_elements: new_elements,
    event_handlers: manager.event_handlers
  }
}

///|
// 处理按钮点击事件
pub fn handle_button_click(
  button_id: String,
  current_state: GameState
) -> String {
  match (button_id, current_state) {
    ("damage-test", _) => "触发伤害计算测试"
    ("move-test", _) => "触发技能效果测试"
    ("status-test", _) => "触发状态效果测试"
    ("stat-test", _) => "触发属性修改测试"
    ("string-test", _) => "触发字符串转换测试"
    ("all-test", _) => "触发全面测试"
    ("start-battle", GameState::Ready) => "开始战斗"
    ("pause-game", GameState::Battle) => "暂停游戏"
    ("resume-game", GameState::Paused) => "恢复游戏"
    ("main-menu", _) => "返回主菜单"
    _ => "未知按钮操作"
  }
}

///|
// 处理键盘事件
pub fn handle_key_press(key: String, current_state: GameState) -> String {
  match (key, current_state) {
    ("Space", GameState::Battle) => "暂停/恢复战斗"
    ("Escape", _) => "返回上级菜单"
    ("Enter", GameState::Ready) => "开始游戏"
    ("ArrowUp", GameState::Battle) => "向上移动"
    ("ArrowDown", GameState::Battle) => "向下移动"
    ("ArrowLeft", GameState::Battle) => "向左移动"
    ("ArrowRight", GameState::Battle) => "向右移动"
    _ => "按键未绑定"
  }
}

///|
// 处理鼠标点击事件
pub fn handle_mouse_click(x: Int, y: Int, current_state: GameState) -> String {
  // 简化的鼠标点击处理，实际应该检查UI元素边界
  if x >= 100 && x <= 300 && y >= 100 && y <= 150 {
    "点击了标题区域"
  } else if x >= 50 && x <= 200 && y >= 200 && y <= 250 {
    "点击了按钮区域"
  } else {
    "点击了空白区域"
  }
}

///|
// 获取当前状态描述
pub fn get_state_description(state: GameState) -> String {
  match state {
    Initializing => "游戏初始化中..."
    Ready => "游戏就绪，可以开始"
    Battle => "战斗进行中"
    Menu => "菜单界面"
    Paused => "游戏暂停"
    GameOver => "游戏结束"
  }
}

///|
// 检查状态转换是否有效
pub fn is_valid_state_transition(
  current: GameState,
  target: GameState
) -> Bool {
  match (current, target) {
    (Initializing, Ready) => true
    (Ready, Battle) => true
    (Ready, Menu) => true
    (Battle, Paused) => true
    (Battle, GameOver) => true
    (Paused, Battle) => true
    (Paused, Menu) => true
    (Menu, Ready) => true
    (GameOver, Ready) => true
    _ => false
  }
}

///|
// 创建默认UI元素配置
pub fn create_default_ui_config() -> Array[UIElement] {
  [
    UIElement::{
      id: "damage-test",
      visible: true,
      enabled: true,
      text: "测试伤害计算",
      position_x: 10,
      position_y: 10
    }
  ]
}

///|
// 测试UI控制器功能
pub fn test_ui_controller() -> Unit {
  println("🧪 测试UI控制器功能...");
  
  // 创建交互管理器
  let manager = create_interaction_manager();
  println("✅ 交互管理器创建成功");
  
  // 测试状态更新
  let updated_manager = update_game_state(manager, GameState::Ready);
  println("✅ 游戏状态更新为: " + get_state_description(updated_manager.current_state));
  
  // 测试按钮点击处理
  let button_result = handle_button_click("damage-test", updated_manager.current_state);
  println("✅ 按钮点击处理: " + button_result);
  
  // 测试键盘事件处理
  let key_result = handle_key_press("Enter", updated_manager.current_state);
  println("✅ 键盘事件处理: " + key_result);
  
  // 测试鼠标点击处理
  let mouse_result = handle_mouse_click(150, 125, updated_manager.current_state);
  println("✅ 鼠标点击处理: " + mouse_result);
  
  // 测试状态转换验证
  let valid_transition = is_valid_state_transition(GameState::Ready, GameState::Battle);
  println("✅ 状态转换验证: Ready -> Battle = " + valid_transition.to_string());
  
  println("🎉 UI控制器测试完成！");
} 