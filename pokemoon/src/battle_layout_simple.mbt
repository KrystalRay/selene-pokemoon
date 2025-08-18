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
// 战斗界面布局配置
struct BattleLayout {
  // 屏幕尺寸
  screen_width : Double
  screen_height : Double
  
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
}

///|
// 全局布局配置
let battle_layout : BattleLayout = {
  screen_width: 800.0,
  screen_height: 600.0,
  margin: 20.0,
  padding: 15.0,
  enemy_area_width: 120.0,
  enemy_area_height: 100.0,
  player_area_width: 120.0,
  player_area_height: 100.0,
  menu_area_width: 200.0,
  menu_area_height: 120.0,
  status_area_width: 100.0,
  status_area_height: 80.0
}

// 这些函数已移动到 battle_menu_config.mbt 中
// 请使用 battle_menu_config.mbt 中的相应函数

///|
// 获取状态信息位置（MP, Level等）
fn get_status_info_positions() -> Array[@math.Vec2D] {
  let positions = Array::new()
  let status_pos = get_status_area_position()
  let start_x = status_pos.0 + battle_layout.padding
  let start_y = status_pos.1 + battle_layout.padding
  let spacing = 20.0
  
  // MP, Level, 其他状态信息
  let mut i = 0
  while i < 3 {
    let y = start_y + (i.to_double() * spacing)
    positions.push(@math.Vec2D(start_x, y))
    i = i + 1
  }
  
  positions
}

///|
// 调试布局 - 显示所有位置信息
fn debug_battle_layout() -> Unit {
  println("🎨 战斗布局调试信息:")
  println("   屏幕尺寸: " + battle_layout.screen_width.to_string() + "x" + battle_layout.screen_height.to_string())
  println("   边距: " + battle_layout.margin.to_string())
  println("   内边距: " + battle_layout.padding.to_string())
  
  println("   敌人区域: " + get_enemy_area_position().0.to_string() + ", " + get_enemy_area_position().1.to_string())
  println("   玩家区域: " + get_player_area_position().0.to_string() + ", " + get_player_area_position().1.to_string())
  println("   菜单区域: " + get_menu_area_position().0.to_string() + ", " + get_menu_area_position().1.to_string())
  println("   状态区域: " + get_status_area_position().0.to_string() + ", " + get_status_area_position().1.to_string())
  println("   标题位置: " + get_title_position().0.to_string() + ", " + get_title_position().1.to_string())
  
  let button_positions = get_menu_button_positions()
  let mut i = 0
  while i < button_positions.length() {
    let pos = button_positions[i]
    println("   按钮" + i.to_string() + ": " + pos.0.to_string() + ", " + pos.1.to_string())
    i = i + 1
  }
}

///|
// 创建布局可视化网格
fn create_battle_layout_grid() -> Array[@system.Entity] {
  let grid_entities = Array::new()
  
  // 创建区域边界框
  let areas = [
    (get_enemy_area_position(), battle_layout.enemy_area_width, battle_layout.enemy_area_height, "#FF0000"),
    (get_player_area_position(), battle_layout.player_area_width, battle_layout.player_area_height, "#00FF00"),
    (get_menu_area_position(), battle_layout.menu_area_width, battle_layout.menu_area_height, "#0000FF"),
    (get_status_area_position(), battle_layout.status_area_width, battle_layout.status_area_height, "#FFFF00")
  ]
  
  let mut i = 0
  while i < areas.length() {
    let area = areas[i]
    let pos = area.0
    let width = area.1
    let height = area.2
    let color = area.3
    
    // 创建边界框
    let border_entity = @system.Entity::new()
    let border_sprite = @sprite.Sprite::new_picture(
      @sprite.Picture::new(@math.Vec2D(width, height), color),
      1000
    )
    @sprite.sprites.set(border_entity, border_sprite)
    @position.positions.set(border_entity, pos)
    @ui.uis.set(border_entity, @ui.Ui::new())
    grid_entities.push(border_entity)
    
    i = i + 1
  }
  
  grid_entities
} 