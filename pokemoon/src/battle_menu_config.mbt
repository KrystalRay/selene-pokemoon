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
// 战斗菜单配置 - 集中管理所有menu参数和布局
struct BattleMenuConfig {
  // 主战斗菜单配置
  main_menu : MainMenuConfig
  
  // 技能菜单配置
  skill_menu : SkillMenuConfig
  
  // 屏幕尺寸配置
  screen : ScreenConfig
  
  // 布局配置
  layout : LayoutConfig
}

///|
// 主战斗菜单配置
struct MainMenuConfig {
  // 基础属性
  visible : Bool
  selected_index : Int
  selected_option : MenuOption
  
  // 几何属性 - 需要动态调整
  mut position : @math.Vec2D
  mut width : Double
  mut height : Double
  
  // 样式配置
  background_color : String
  border_color : String
  text_color : String
  indicator_color : String
  
  // 按钮配置
  button_spacing : Double
  button_height : Double
  button_padding : Double
}

///|
// 技能菜单配置
struct SkillMenuConfig {
  // 基础属性
  visible : Bool
  selected_index : Int
  
  // 几何属性 - 需要动态调整
  mut position : @math.Vec2D
  mut width : Double
  mut height : Double
  
  // 样式配置
  background_color : String
  border_color : String
  text_color : String
  indicator_color : String
  title_color : String
  
  // 技能项配置
  skill_spacing : Double
  skill_height : Double
  skill_padding : Double
  title_height : Double
}

///|
// 屏幕配置
struct ScreenConfig {
  width : Double
  height : Double
  title_height : Double
  prompt_height : Double
}

///|
// 布局配置
struct LayoutConfig {
  // 边距和间距
  margin : Double
  padding : Double
  
  // 区域尺寸
  enemy_area_width : Double
  enemy_area_height : Double
  player_area_width : Double
  player_area_height : Double
  menu_area_width : Double
  menu_area_height : Double
  status_area_width : Double
  status_area_height : Double
  
  // 位置偏移
  title_offset_y : Double
  enemy_offset_y : Double
  player_offset_y : Double
  menu_offset_y : Double
  status_offset_y : Double
}

///|
// 全局战斗菜单配置实例
let battle_menu_config : BattleMenuConfig = {
  // 主菜单配置
  main_menu: MainMenuConfig::{
    visible: false,
    selected_index: 0,
    selected_option: Fight,
    position: @math.Vec2D(50.0, 400.0),
    width: 170.0,
    height: 115.0,
    background_color: "#1a1a1a",
    border_color: "#4ECDC4",
    text_color: "#FFFFFF",
    indicator_color: "#4ECDC4",
    button_spacing: 25.0,
    button_height: 20.0,
    button_padding: 10.0
  },
  
  // 技能菜单配置
  skill_menu: SkillMenuConfig::{
    visible: false,
    selected_index: 0,
    position: @math.Vec2D(250.0, 400.0),
    width: 220.0,
    height: 200.0,
    background_color: "#1a1a1a",
    border_color: "#4ECDC4",
    text_color: "#FFFFFF",
    indicator_color: "#4ECDC4",
    title_color: "#FFFFFF",
    skill_spacing: 30.0,
    skill_height: 25.0,
    skill_padding: 25.0,
    title_height: 20.0
  },
  
  // 屏幕配置
  screen: ScreenConfig::{
    width: 800.0,
    height: 600.0,
    title_height: 32.0,
    prompt_height: 18.0
  },
  
  // 布局配置
  layout: LayoutConfig::{
    margin: 20.0,
    padding: 15.0,
    enemy_area_width: 120.0,
    enemy_area_height: 100.0,
    player_area_width: 120.0,
    player_area_height: 100.0,
    menu_area_width: 200.0,
    menu_area_height: 120.0,
    status_area_width: 100.0,
    status_area_height: 80.0,
    title_offset_y: 20.0,
    enemy_offset_y: 50.0,
    player_offset_y: 50.0,
    menu_offset_y: 170.0,
    status_offset_y: 170.0
  }
}

///|
// ===== 布局位置计算函数 =====

///|
// 获取敌人区域位置（左上角）
fn get_enemy_area_position() -> @math.Vec2D {
  @math.Vec2D(
    battle_menu_config.layout.margin,
    battle_menu_config.layout.margin + battle_menu_config.layout.enemy_offset_y
  )
}

///|
// 获取玩家区域位置（右上角）
fn get_player_area_position() -> @math.Vec2D {
  @math.Vec2D(
    battle_menu_config.screen.width - battle_menu_config.layout.margin - battle_menu_config.layout.player_area_width,
    battle_menu_config.layout.margin + battle_menu_config.layout.player_offset_y
  )
}

///|
// 获取菜单区域位置（左下角，敌人下方）
fn get_menu_area_position() -> @math.Vec2D {
  @math.Vec2D(
    battle_menu_config.layout.margin,
    battle_menu_config.layout.margin + battle_menu_config.layout.enemy_offset_y + battle_menu_config.layout.enemy_area_height + 20.0
  )
}

///|
// 获取状态区域位置（右下角，玩家下方）
fn get_status_area_position() -> @math.Vec2D {
  @math.Vec2D(
    battle_menu_config.screen.width - battle_menu_config.layout.margin - battle_menu_config.layout.status_area_width,
    battle_menu_config.layout.margin + battle_menu_config.layout.player_offset_y + battle_menu_config.layout.player_area_height + 20.0
  )
}

///|
// 获取标题位置（顶部中心）
fn get_title_position() -> @math.Vec2D {
  @math.Vec2D(
    battle_menu_config.screen.width / 2.0,
    battle_menu_config.layout.margin + battle_menu_config.layout.title_offset_y
  )
}

///|
// 获取提示文本位置（标题下方）
fn get_prompt_position() -> @math.Vec2D {
  let title_pos = get_title_position()
  @math.Vec2D(title_pos.0, title_pos.1 + 40.0)
}

///|
// 获取菜单按钮位置（垂直排列）
fn get_menu_button_positions() -> Array[@math.Vec2D] {
  let positions = Array::new()
  let start_x = battle_menu_config.layout.margin + battle_menu_config.layout.padding
  let start_y = battle_menu_config.screen.height - battle_menu_config.layout.margin - battle_menu_config.layout.menu_area_height + battle_menu_config.layout.padding
  let button_height = 25.0
  let spacing = button_height + battle_menu_config.layout.padding
  
  // 四个按钮：Fight, Bag, Pokemon, Run
  let button_count = 4
  let mut i = 0
  while i < button_count {
    let y = start_y + (i.to_double() * spacing)
    positions.push(@math.Vec2D(start_x, y))
    i = i + 1
  }
  
  positions
}

///|
// 获取技能菜单位置（屏幕中心）
fn get_skill_menu_position() -> @math.Vec2D {
  @math.Vec2D(
    battle_menu_config.screen.width / 2.0 - 100.0,
    battle_menu_config.screen.height / 2.0 - 80.0
  )
}

///|
// 获取HP文本位置
fn get_hp_text_position(is_enemy : Bool) -> @math.Vec2D {
  if is_enemy {
    // 敌人HP - 敌人区域下方
    let enemy_pos = get_enemy_area_position()
    @math.Vec2D(
      enemy_pos.0 + battle_menu_config.layout.padding,
      enemy_pos.1 + battle_menu_config.layout.enemy_area_height + battle_menu_config.layout.padding
    )
  } else {
    // 玩家HP - 玩家区域下方
    let player_pos = get_player_area_position()
    @math.Vec2D(
      player_pos.0 + battle_menu_config.layout.padding,
      player_pos.1 + battle_menu_config.layout.player_area_height + battle_menu_config.layout.padding
    )
  }
}

///|
// ===== 配置访问函数 =====

///|
fn get_main_menu_config() -> MainMenuConfig {
  battle_menu_config.main_menu
}

///|
fn get_skill_menu_config() -> SkillMenuConfig {
  battle_menu_config.skill_menu
}

///|
fn get_screen_config() -> ScreenConfig {
  battle_menu_config.screen
}

///|
fn get_layout_config() -> LayoutConfig {
  battle_menu_config.layout
}

///|
fn get_main_menu_position() -> @math.Vec2D {
  battle_menu_config.main_menu.position
}

///|
fn get_main_menu_size() -> @math.Vec2D {
  @math.Vec2D(battle_menu_config.main_menu.width, battle_menu_config.main_menu.height)
}

///|
fn get_skill_menu_size() -> @math.Vec2D {
  @math.Vec2D(battle_menu_config.skill_menu.width, battle_menu_config.skill_menu.height)
}

///|
// ===== 动态调整函数 =====

///|
// 动态调整菜单尺寸
fn adjust_menu_sizes() -> Unit {
  let screen_width = battle_menu_config.screen.width
  let screen_height = battle_menu_config.screen.height
  
  // 调整主菜单尺寸
  battle_menu_config.main_menu.width = screen_width * 0.33
  battle_menu_config.main_menu.height = screen_height * 0.3
  
  // 调整技能菜单尺寸
  battle_menu_config.skill_menu.width = screen_width * 0.35
  battle_menu_config.skill_menu.height = screen_height * 0.25
  
  println("📏 菜单尺寸已调整:")
  println("  主菜单: " + battle_menu_config.main_menu.width.to_string() + " x " + battle_menu_config.main_menu.height.to_string())
  println("  技能菜单: " + battle_menu_config.skill_menu.width.to_string() + " x " + battle_menu_config.skill_menu.height.to_string())
}

///|
// 重新定位菜单
fn reposition_menus() -> Unit {
  // 重新定位主菜单
  let new_main_menu_x = 50.0
  let new_main_menu_y = 400.0
  battle_menu_config.main_menu.position = @math.Vec2D(new_main_menu_x, new_main_menu_y)
  
  // 重新定位技能菜单
  let skill_menu_x = new_main_menu_x + battle_menu_config.main_menu.width + 30.0
  let skill_menu_y = new_main_menu_y
  battle_menu_config.skill_menu.position = @math.Vec2D(skill_menu_x, skill_menu_y)
  
  println("📍 菜单位置已重新定位:")
  println("  主菜单: (" + battle_menu_config.main_menu.position.0.to_string() + ", " + battle_menu_config.main_menu.position.1.to_string() + ")")
  println("  技能菜单: (" + battle_menu_config.skill_menu.position.0.to_string() + ", " + battle_menu_config.skill_menu.position.1.to_string() + ")")
}

///|
// 验证菜单边界
fn validate_menu_boundaries() -> Bool {
  let screen_width = battle_menu_config.screen.width
  let screen_height = battle_menu_config.screen.height
  
  // 检查主菜单边界
  let main_menu_right = battle_menu_config.main_menu.position.0 + battle_menu_config.main_menu.width
  let main_menu_bottom = battle_menu_config.main_menu.position.1 + battle_menu_config.main_menu.height
  
  let main_menu_valid = battle_menu_config.main_menu.position.0 >= 0.0 && 
                       battle_menu_config.main_menu.position.1 >= 0.0 &&
                       main_menu_right <= screen_width &&
                       main_menu_bottom <= screen_height
  
  // 检查技能菜单边界
  let skill_menu_right = battle_menu_config.skill_menu.position.0 + battle_menu_config.skill_menu.width
  let skill_menu_bottom = battle_menu_config.skill_menu.position.1 + battle_menu_config.skill_menu.height
  
  let skill_menu_valid = battle_menu_config.skill_menu.position.0 >= 0.0 && 
                        battle_menu_config.skill_menu.position.1 >= 0.0 &&
                        skill_menu_right <= screen_width &&
                        skill_menu_bottom <= screen_height
  
  println("🔍 菜单边界验证:")
  println("  主菜单: " + (if main_menu_valid { "✅ 在屏幕内" } else { "❌ 超出屏幕" }))
  println("  技能菜单: " + (if skill_menu_valid { "✅ 在屏幕内" } else { "❌ 超出屏幕" }))
  
  return main_menu_valid && skill_menu_valid
} 