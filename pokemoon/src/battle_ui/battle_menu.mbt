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
// 菜单类型枚举
enum MenuType {
  MainMenu
  MoveMenu
  PokemonMenu
  ItemMenu
  TeamPreview
  BattleEnd
}

///|
// 菜单项结构
struct MenuItem {
  id: String
  text: String
  action: Function
  enabled: Bool
  visible: Bool
  position: @math.Vec2D
  size: @math.Vec2D
}

///|
// 基础菜单结构
struct BattleMenu {
  // 菜单标识
  id: String
  menu_type: MenuType
  
  // 菜单项
  mut items: Array[MenuItem]
  mut selected_index: Int
  
  // 位置和大小
  position: @math.Vec2D
  size: @math.Vec2D
  
  // 可见性
  mut visible: Bool
  
  // UI 实体
  mut entities: Array[@system.Entity]
  mut background_entity: Option[@system.Entity]
  mut title_entity: Option[@system.Entity]
  
  // 回调函数
  on_show: Option[Function]
  on_hide: Option[Function]
  on_selection_change: Option[Function]
}

///|
// 创建主菜单
fn create_main_menu() -> BattleMenu {
  BattleMenu::{
    id: "main_menu",
    menu_type: MainMenu,
    items: Array::new(),
    selected_index: 0,
    position: @math.Vec2D(60, 200),
    size: @math.Vec2D(200, 150),
    visible: false,
    entities: Array::new(),
    background_entity: None,
    title_entity: None,
    on_show: None,
    on_hide: None,
    on_selection_change: None,
  }
}

///|
// 创建技能菜单
fn create_move_menu() -> BattleMenu {
  BattleMenu::{
    id: "move_menu",
    menu_type: MoveMenu,
    items: Array::new(),
    selected_index: 0,
    position: @math.Vec2D(300, 200),
    size: @math.Vec2D(200, 150),
    visible: false,
    entities: Array::new(),
    background_entity: None,
    title_entity: None,
    on_show: None,
    on_hide: None,
    on_selection_change: None,
  }
}

///|
// 显示菜单
fn show_menu(menu: &mut BattleMenu) -> Unit {
  menu.visible = true
  
  // 创建背景
  if menu.background_entity.is_none() {
    let background = @system.Entity::new()
    @position.positions.set(background, menu.position)
    
    let background_sprite = @sprite.Sprite::new_picture(
      @sprite.Picture::new(
        menu.size,
        "pixel_adventure/Menu/Buttons/Play.png",
      ),
      200,
    )
    @sprite.sprites.set(background, background_sprite)
    @ui.uis.set(background, @ui.Ui::new())
    
    menu.background_entity = Some(background)
    menu.entities.push(background)
  }
  
  // 创建标题
  if menu.title_entity.is_none() {
    let title = @system.Entity::new()
    let title_pos = @math.Vec2D(menu.position.x, menu.position.y - 30)
    @position.positions.set(title, title_pos)
    
    let title_text = @sprite.Sprite::new_text(
      @sprite.Text::new(get_menu_title(menu.menu_type), color="#FFFFFF", font="18px Arial"),
      250
    )
    @sprite.sprites.set(title, title_text)
    @ui.uis.set(title, @ui.Ui::new())
    
    menu.title_entity = Some(title)
    menu.entities.push(title)
  }
  
  // 创建菜单项
  create_menu_items(menu)
  
  // 调用显示回调
  if let Some(callback) = menu.on_show {
    callback()
  }
}

///|
// 隐藏菜单
fn hide_menu(menu: &mut BattleMenu) -> Unit {
  menu.visible = false
  
  // 清理所有实体
  for entity in menu.entities {
    @system.Entity::destroy(entity)
  }
  menu.entities.clear()
  menu.background_entity = None
  menu.title_entity = None
  
  // 调用隐藏回调
  if let Some(callback) = menu.on_hide {
    callback()
  }
}

///|
// 创建菜单项
fn create_menu_items(menu: &mut BattleMenu) -> Unit {
  for (index, item) in menu.items.enumerate() {
    if !item.visible {
      continue
    }
    
    let item_entity = @system.Entity::new()
    let item_pos = @math.Vec2D(
      menu.position.x + 10,
      menu.position.y + 10 + (index as Double * 30)
    )
    @position.positions.set(item_entity, item_pos)
    
    let item_sprite = @sprite.Sprite::new_text(
      @sprite.Text::new(item.text, color="#FFFFFF", font="16px Arial"),
      250
    )
    @sprite.sprites.set(item_entity, item_sprite)
    @ui.uis.set(item_entity, @ui.Ui::new())
    
    menu.entities.push(item_entity)
  }
}

///|
// 获取菜单标题
fn get_menu_title(menu_type: MenuType) -> String {
  match menu_type {
    MainMenu => "Battle Menu"
    MoveMenu => "Choose Move"
    PokemonMenu => "Choose Pokemon"
    ItemMenu => "Choose Item"
    TeamPreview => "Team Preview"
    BattleEnd => "Battle End"
  }
}

///|
// 处理菜单输入
fn handle_menu_input(menu: &mut BattleMenu, key: String) -> Unit {
  match key {
    "ArrowUp" => {
      if menu.selected_index > 0 {
        menu.selected_index = menu.selected_index - 1
        update_menu_selection(menu)
      }
    }
    "ArrowDown" => {
      if menu.selected_index < menu.items.length() - 1 {
        menu.selected_index = menu.selected_index + 1
        update_menu_selection(menu)
      }
    }
    "Enter" | "Space" => {
      confirm_menu_selection(menu)
    }
    "Escape" => {
      hide_menu(menu)
    }
    _ => {}
  }
}

///|
// 更新菜单选择
fn update_menu_selection(menu: &mut BattleMenu) -> Unit {
  // 更新选择指示器
  if let Some(callback) = menu.on_selection_change {
    callback()
  }
}

///|
// 确认菜单选择
fn confirm_menu_selection(menu: &mut BattleMenu) -> Unit {
  if menu.selected_index >= 0 && menu.selected_index < menu.items.length() {
    let item = menu.items[menu.selected_index]
    if item.enabled {
      item.action()
    }
  }
}

///|
// 添加菜单项
fn add_menu_item(menu: &mut BattleMenu, item: MenuItem) -> Unit {
  menu.items.push(item)
}

///|
// 设置菜单项
fn set_menu_items(menu: &mut BattleMenu, items: Array[MenuItem]) -> Unit {
  menu.items = items
  menu.selected_index = 0
}

///|
// 更新菜单
fn update_menu(menu: &mut BattleMenu) -> Unit {
  // 这里可以添加菜单的更新逻辑
  // 比如动画效果、状态更新等
}

///|
// 检查菜单是否可见
fn is_menu_visible(menu: &BattleMenu) -> Bool {
  menu.visible
}

///|
// 获取选中的菜单项
fn get_selected_item(menu: &BattleMenu) -> Option[MenuItem] {
  if menu.selected_index >= 0 && menu.selected_index < menu.items.length() {
    Some(menu.items[menu.selected_index])
  } else {
    None
  }
} 