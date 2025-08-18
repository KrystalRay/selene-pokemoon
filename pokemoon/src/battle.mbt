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
// 战斗状态枚举
enum BattleState {
  InBattle
  NotInBattle
} derive(Show)

///|
// 菜单选项枚举
enum MenuOption {
  Fight
  Bag
  Pokemon
  Run
} derive(Show, Eq, Hash)

///|
// 主战斗菜单
struct MainBattleMenu {
  mut visible : Bool
  mut selected_index : Int
  entities : Array[@system.Entity]
  background_entity : Option[@system.Entity]
  title_entity : Option[@system.Entity]
  indicator_entity : Option[@system.Entity]
  
  // 几何属性
  position : @math.Vec2D
  width : Double
  height : Double
  
  // 主战斗菜单特有字段
  mut selected_option : MenuOption
  button_entities : Map[MenuOption, @system.Entity]
  button_text_entities : Map[MenuOption, @system.Entity]
}

///|
// 技能菜单
struct SkillMenu {
  mut visible : Bool
  mut selected_index : Int
  mut entities : Array[@system.Entity]
  mut background_entity : Option[@system.Entity]
  mut title_entity : Option[@system.Entity]
  mut indicator_entity : Option[@system.Entity]
  
  // 几何属性
  mut position : @math.Vec2D
  width : Double
  height : Double
  
  // 技能菜单特有字段
  mut skills : Array[Skill]
  mut skill_entities : Array[@system.Entity]
}

///|
// 战斗系统组件
struct BattleSystem {
  mut state : BattleState
  mut battle_entities : Array[@system.Entity]
  // 使用新的菜单系统
  main_menu : MainBattleMenu
  skill_menu : SkillMenu
  mut enemy_hp : Int
  mut player_hp : Int
  enemy_max_hp : Int
  player_max_hp : Int
  mut enemy_hp_entity : Option[@system.Entity]
  mut player_hp_entity : Option[@system.Entity]
  // 调试相关
  mut debug_entities : Array[@system.Entity]
}

///|
// 全局战斗系统实例
let battle_system : BattleSystem = {
  state: NotInBattle,
  battle_entities: Array::new(),
  main_menu: MainBattleMenu::{
    visible: false,
    selected_index: 0,
    entities: Array::new(),
    background_entity: None,
    title_entity: None,
    indicator_entity: None,
    position: @math.Vec2D(50.0, 400.0),
    width: 170.0,
    height: 115.0,
    selected_option: Fight,
    button_entities: Map::new(),
    button_text_entities: Map::new()
  },
  skill_menu: SkillMenu::{
    visible: false,
    selected_index: 0,
    entities: Array::new(),
    background_entity: None,
    title_entity: None,
    indicator_entity: None,
    position: @math.Vec2D(250.0, 400.0),
    width: 220.0,
    height: 200.0,
    skills: Array::new(),
    skill_entities: Array::new()
  },
  enemy_hp: 100,
  player_hp: 100,
  enemy_max_hp: 100,
  player_max_hp: 100,
  enemy_hp_entity: None,
  player_hp_entity: None,
  debug_entities: Array::new()
}

///|
// 技能数据结构
struct Skill {
  name : String
  damage : Int
  description : String
  mp_cost : Int
}

///|
// 初始化技能数据
fn init_skills() -> Unit {
  let skills = Array::new()
  skills.push(Skill::{ name: "Tackle", damage: 15, description: "A basic attack", mp_cost: 0 })
  skills.push(Skill::{ name: "Ember", damage: 25, description: "A fire attack", mp_cost: 5 })
  skills.push(Skill::{ name: "Thunder", damage: 35, description: "An electric attack", mp_cost: 10 })
  skills.push(Skill::{ name: "Hyper Beam", damage: 50, description: "A powerful beam", mp_cost: 20 })
  
  battle_system.skill_menu.skills = skills
}

///|
// 进入战斗状态
fn enter_battle() -> Unit {
  battle_system.state = InBattle
  battle_system.main_menu.selected_option = Fight
  // 重置HP
  battle_system.enemy_hp = 100
  battle_system.player_hp = 100
  
  // 使用几何属性调整菜单尺寸和位置
  adjust_menu_sizes()
  reposition_menus()
  
  // 创建战斗界面实体
  create_battle_entities()
  // 创建菜单调试边界框
  create_menu_debug_boundaries()
  // 显示菜单几何信息
  show_menu_geometry_info()
  // 调试布局信息
  debug_battle_layout()
}

///|
// 退出战斗状态
fn exit_battle() -> Unit {
  battle_system.state = NotInBattle
  // 清理战斗界面实体
  cleanup_battle_entities()
}

///|
// 基础菜单管理函数 - 展示统一菜单系统的优势

// 此函数已被移除

// 此函数已被移除

// 此函数已被移除

// 此函数已被移除

// 此函数已被移除

///|
// 检查是否在战斗状态
fn is_in_battle() -> Bool {
  match battle_system.state {
    InBattle => true
    NotInBattle => false
  }
}

///|
// 获取菜单选项的显示文本
fn get_menu_option_text(option : MenuOption) -> String {
  match option {
    Fight => "Fight"
    Bag => "Bag"
    Pokemon => "Pokemon"
    Run => "Run"
  }
}

///|
// 获取下一个菜单选项
fn get_next_menu_option(current : MenuOption) -> MenuOption {
  match current {
    Fight => Bag
    Bag => Pokemon
    Pokemon => Run
    Run => Fight
  }
}

///|
// 获取上一个菜单选项
fn get_prev_menu_option(current : MenuOption) -> MenuOption {
  match current {
    Fight => Run
    Bag => Fight
    Pokemon => Bag
    Run => Pokemon
  }
}



///|
// 创建战斗界面实体
fn create_battle_entities() -> Unit {
  // 使用现有的布局系统
  let enemy_pos = get_enemy_area_position()
  let player_pos = get_player_area_position()
  let title_pos = get_title_position()
  
  // 创建战斗背景sprite - 覆盖整个屏幕
  let background_entity = @system.Entity::new()
  let background_sprite = @sprite.Sprite::new_picture(
    @sprite.Picture::new(
      @math.Vec2D(VIEWPORT_WIDTH, VIEWPORT_HEIGHT),
      "data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNTEyIiBoZWlnaHQ9IjM4NCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48cmVjdCB3aWR0aD0iNTEyIiBoZWlnaHQ9IjM4NCIgZmlsbD0iIzAwMDAwMCIvPjwvc3ZnPg=="
    ),
    150
  )
  @sprite.sprites.set(background_entity, background_sprite)
  @position.positions.set(background_entity, @math.Vec2D(0.0, 0.0))
  @ui.uis.set(background_entity, @ui.Ui::new())
  battle_system.battle_entities.push(background_entity)
  
  // 创建战斗标题sprite - 屏幕顶部中央
  let title_entity = @system.Entity::new()
  let title_sprite = @sprite.Sprite::new_text(@sprite.Text::new("BATTLE!", font="bold 32px Arial"), 250)
  @sprite.sprites.set(title_entity, title_sprite)
  @position.positions.set(title_entity, title_pos)
  @ui.uis.set(title_entity, @ui.Ui::new())
  battle_system.battle_entities.push(title_entity)
  
  // 创建战斗提示sprite - 标题下方
  let prompt_entity = @system.Entity::new()
  let prompt_sprite = @sprite.Sprite::new_text(@sprite.Text::new("Use ↑↓ to select, Z to confirm", font="18px Arial"), 250)
  @sprite.sprites.set(prompt_entity, prompt_sprite)
  @position.positions.set(prompt_entity, @math.Vec2D(title_pos.0, title_pos.1 + 40.0))
  @ui.uis.set(prompt_entity, @ui.Ui::new())
  battle_system.battle_entities.push(prompt_entity)
  
  // 创建Enemy区域 - 基于布局系统
  create_enemy_entities_simple(enemy_pos)
  
  // 创建Player区域 - 基于布局系统
  create_player_entities_simple(player_pos)
  
  // 创建战斗菜单按钮 - 使用简化的设置
  setup_battle_menu()
  
  // 创建状态信息sprite - 基于Player区域位置
  let mp_entity = @system.Entity::new()
  let mp_sprite = @sprite.Sprite::new_text(@sprite.Text::new("MP: 50/50", font="16px Arial"), 250)
  @sprite.sprites.set(mp_entity, mp_sprite)
  @position.positions.set(mp_entity, @math.Vec2D(player_pos.0, player_pos.1 + battle_layout.player_area_height + 20.0))
  @ui.uis.set(mp_entity, @ui.Ui::new())
  battle_system.battle_entities.push(mp_entity)
  
  let level_entity = @system.Entity::new()
  let level_sprite = @sprite.Sprite::new_text(@sprite.Text::new("Level: 5", font="16px Arial"), 250)
  @sprite.sprites.set(level_entity, level_sprite)
  @position.positions.set(level_entity, @math.Vec2D(player_pos.0, player_pos.1 + battle_layout.player_area_height + 40.0))
  @ui.uis.set(level_entity, @ui.Ui::new())
  battle_system.battle_entities.push(level_entity)
}

///|
// 创建Enemy实体 - 基于布局位置
fn create_enemy_entities_simple(enemy_pos : @math.Vec2D) -> Unit {
  // 创建敌人区域sprite
  let enemy_entity = @system.Entity::new()
  let enemy_sprite = @sprite.Sprite::new_picture(
    @sprite.Picture::new(
      @math.Vec2D(battle_layout.enemy_area_width, battle_layout.enemy_area_height),
      "data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTIwIiBoZWlnaHQ9IjEwMCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48cmVjdCB3aWR0aD0iMTIwIiBoZWlnaHQ9IjEwMCIgZmlsbD0iI2ZmNmI2YiIvPjwvc3ZnPg=="
    ),
    250
  )
  @sprite.sprites.set(enemy_entity, enemy_sprite)
  @position.positions.set(enemy_entity, enemy_pos)
  @ui.uis.set(enemy_entity, @ui.Ui::new())
  battle_system.battle_entities.push(enemy_entity)
  
  // 创建敌人标签sprite
  let enemy_label_entity = @system.Entity::new()
  let enemy_label_sprite = @sprite.Sprite::new_text(@sprite.Text::new("Enemy", font="16px Arial"), 250)
  @sprite.sprites.set(enemy_label_entity, enemy_label_sprite)
  @position.positions.set(enemy_label_entity, @math.Vec2D(enemy_pos.0 + battle_layout.enemy_area_width / 2.0, enemy_pos.1 + battle_layout.enemy_area_height - 30.0))
  @ui.uis.set(enemy_label_entity, @ui.Ui::new())
  battle_system.battle_entities.push(enemy_label_entity)
  
  // 创建敌人HP显示sprite
  let enemy_hp_entity = @system.Entity::new()
  let enemy_hp_text = "HP: " + battle_system.enemy_hp.to_string() + "/" + battle_system.enemy_max_hp.to_string()
  let enemy_hp_sprite = @sprite.Sprite::new_text(@sprite.Text::new(enemy_hp_text, font="16px Arial"), 250)
  @sprite.sprites.set(enemy_hp_entity, enemy_hp_sprite)
  @position.positions.set(enemy_hp_entity, @math.Vec2D(enemy_pos.0 + battle_layout.enemy_area_width / 2.0, enemy_pos.1 + battle_layout.enemy_area_height - 10.0))
  @ui.uis.set(enemy_hp_entity, @ui.Ui::new())
  battle_system.enemy_hp_entity = Some(enemy_hp_entity)
  battle_system.battle_entities.push(enemy_hp_entity)
}

///|
// 创建Player实体 - 基于布局位置
fn create_player_entities_simple(player_pos : @math.Vec2D) -> Unit {
  // 创建玩家区域sprite
  let player_entity = @system.Entity::new()
  let player_sprite = @sprite.Sprite::new_picture(
    @sprite.Picture::new(
      @math.Vec2D(battle_layout.player_area_width, battle_layout.player_area_height),
      "data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNTEyIiBoZWlnaHQ9IjEwMCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48cmVjdCB3aWR0aD0iNTEyIiBoZWlnaHQ9IjEwMCIgZmlsbD0iIzRlY2RjNCIvPjwvc3ZnPg=="
    ),
    250
  )
  @sprite.sprites.set(player_entity, player_sprite)
  @position.positions.set(player_entity, player_pos)
  @ui.uis.set(player_entity, @ui.Ui::new())
  battle_system.battle_entities.push(player_entity)
  
  // 创建玩家标签sprite
  let player_label_entity = @system.Entity::new()
  let player_label_sprite = @sprite.Sprite::new_text(@sprite.Text::new("Player", font="16px Arial"), 250)
  @sprite.sprites.set(player_label_entity, player_label_sprite)
  @position.positions.set(player_label_entity, @math.Vec2D(player_pos.0 + battle_layout.player_area_width / 2.0, player_pos.1 + battle_layout.player_area_height - 30.0))
  @ui.uis.set(player_label_entity, @ui.Ui::new())
  battle_system.battle_entities.push(player_label_entity)
  
  // 创建玩家HP显示sprite
  let player_hp_entity = @system.Entity::new()
  let player_hp_text = "HP: " + battle_system.player_hp.to_string() + "/" + battle_system.player_max_hp.to_string()
  let player_hp_sprite = @sprite.Sprite::new_text(@sprite.Text::new(player_hp_text, font="16px Arial"), 250)
  @sprite.sprites.set(player_hp_entity, player_hp_sprite)
  @position.positions.set(player_hp_entity, @math.Vec2D(player_pos.0 + battle_layout.player_area_width / 2.0, player_pos.1 + battle_layout.player_area_height - 10.0))
  @ui.uis.set(player_hp_entity, @ui.Ui::new())
  battle_system.player_hp_entity = Some(player_hp_entity)
  battle_system.battle_entities.push(player_hp_entity)
}







///|
// 更新菜单选择显示
fn update_menu_selection() -> Unit {
  // 按钮视觉效果更新已移除（不再使用按钮实体）
  // 现在只更新文本显示
}



///|
// 计算技能菜单的最佳位置
fn calculate_skill_menu_position() -> @math.Vec2D {
  // 基于屏幕尺寸和现有UI元素计算最佳位置
  let screen_width = 800.0
  // screen_height 变量已被移除，不再使用
  
  // 使用技能菜单的内置尺寸
  let menu_width = battle_system.skill_menu.width
  let menu_height = battle_system.skill_menu.height
  
  // 主菜单按钮区域（左下角）
  let main_menu_left = battle_system.main_menu.position.0
  let main_menu_right = main_menu_left + battle_system.main_menu.width
  let main_menu_top = battle_system.main_menu.position.1
  let main_menu_bottom = main_menu_top + battle_system.main_menu.height
  
  // 这些硬编码的坐标值已被移除，现在使用配置系统
  
  // 尝试多个位置，按优先级排序
  let possible_positions = [
    // 位置1：主菜单右侧，紧贴主菜单
    @math.Vec2D(main_menu_right + 10.0, main_menu_top),
    // 位置2：主菜单右侧，稍微上移
    @math.Vec2D(main_menu_right + 10.0, main_menu_top - 20.0),
    // 位置3：屏幕右侧，避免与玩家状态重叠
    @math.Vec2D(screen_width - menu_width - 20.0, main_menu_top),
    // 位置4：屏幕中央下方
    @math.Vec2D((screen_width - menu_width) / 2.0, main_menu_top - 40.0)
  ]
  
  // 检查每个位置是否有冲突
  for position in possible_positions {
    if !has_skill_menu_collision(position, @math.Vec2D(menu_width, menu_height)) {
      return position
    }
  }
  
  // 如果所有位置都有冲突，返回默认位置
  return @math.Vec2D(main_menu_right + 10.0, main_menu_top)
}

///|
// 检查技能菜单位置是否与其他UI元素冲突
fn has_skill_menu_collision(position : @math.Vec2D, size : @math.Vec2D) -> Bool {
  let menu_left = position.0
  let menu_right = position.0 + size.0
  let menu_top = position.1
  let menu_bottom = position.1 + size.1
  
  // 检查与主菜单按钮区域的冲突 - 使用battle_system中的几何属性
  let main_menu_left = battle_system.main_menu.position.0
  let main_menu_right = main_menu_left + battle_system.main_menu.width
  let main_menu_top = battle_system.main_menu.position.1
  let main_menu_bottom = main_menu_top + battle_system.main_menu.height
  
  if menu_left < main_menu_right && menu_right > main_menu_left &&
     menu_top < main_menu_bottom && menu_bottom > main_menu_top {
    return true
  }
  
  // 检查与敌人区域的冲突 - 使用配置系统
  let enemy_pos = get_enemy_area_position()
  let enemy_left = enemy_pos.0
  let enemy_right = enemy_pos.0 + 120.0  // 使用battle_layout中的尺寸
  let enemy_top = enemy_pos.1
  let enemy_bottom = enemy_pos.1 + 100.0
  
  if menu_left < enemy_right && menu_right > enemy_left &&
     menu_top < enemy_bottom && menu_bottom > enemy_top {
    return true
  }
  
  // 检查与玩家区域的冲突 - 使用配置系统
  let player_pos = get_player_area_position()
  let player_left = player_pos.0
  let player_right = player_pos.0 + 120.0  // 使用battle_layout中的尺寸
  let player_top = player_pos.1
  let player_bottom = player_pos.1 + 100.0
  
  if menu_left < player_right && menu_right > player_left &&
     menu_top < player_bottom && menu_bottom > player_top {
    return true
  }
  
  // 检查与状态信息区域的冲突 - 使用配置系统
  let status_pos = get_status_area_position()
  let status_left = status_pos.0
  let status_right = status_pos.0 + 100.0  // 使用battle_layout中的尺寸
  let status_top = status_pos.1
  let status_bottom = status_pos.1 + 80.0
  
  if menu_left < status_right && menu_right > status_left &&
     menu_top < status_bottom && menu_bottom > status_top {
    return true
  }
  
  return false
}

///|
// 创建技能菜单
fn create_skill_menu() -> Unit {
  // 清理之前的技能菜单实体
  cleanup_skill_menu()
  
  // 初始化技能数据
  init_skills()
  
  // 计算菜单位置
  let menu_position = calculate_skill_menu_position()
  println("🎯 技能菜单位置: (" + menu_position.0.to_string() + ", " + menu_position.1.to_string() + ")")
  
  // 更新技能菜单的内置位置
  battle_system.skill_menu.position = menu_position
  
  // 创建技能菜单背景 - 使用内置尺寸
  let background_entity = @system.Entity::new()
  let background_sprite = @sprite.Sprite::new_picture(
    @sprite.Picture::new(
      @math.Vec2D(battle_system.skill_menu.width, battle_system.skill_menu.height),
      "data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjIwIiBoZWlnaHQ9IjIwMCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48cmVjdCB3aWR0aD0iMjIwIiBoZWlnaHQ9IjIwMCIgZmlsbD0iIzFhMWExYSIgc3Ryb2tlPSIjNGVjZGM0IiBzdHJva2Utd2lkdGg9IjIiIHJ4PSI4Ii8+PC9zdmc+"
    ),
    200
  )
  @sprite.sprites.set(background_entity, background_sprite)
  @position.positions.set(background_entity, menu_position)
  @ui.uis.set(background_entity, @ui.Ui::new())
  
  battle_system.skill_menu.background_entity = Some(background_entity)
  battle_system.skill_menu.entities.push(background_entity)
  
  // 创建技能菜单标题
  let title_entity = @system.Entity::new()
  let title_sprite = @sprite.Sprite::new_text(
    @sprite.Text::new("SKILLS", color="#FFFFFF", font="bold 18px Arial"), 
    250
  )
  @sprite.sprites.set(title_entity, title_sprite)
  @position.positions.set(title_entity, @math.Vec2D(menu_position.0 + 20.0, menu_position.1 + 15.0))
  @ui.uis.set(title_entity, @ui.Ui::new())
  
  battle_system.skill_menu.title_entity = Some(title_entity)
  battle_system.skill_menu.entities.push(title_entity)
  
  // 创建技能选项
  let mut skill_y_offset = 50.0
  let mut i = 0
  
  while i < battle_system.skill_menu.skills.length() {
    let skill = battle_system.skill_menu.skills[i]
    let skill_entity = @system.Entity::new()
    
    // 技能文本格式：名称 (伤害) - MP消耗
    let skill_text = skill.name + " (" + skill.damage.to_string() + " DMG) - " + skill.mp_cost.to_string() + " MP"
    let skill_sprite = @sprite.Sprite::new_text(
      @sprite.Text::new(skill_text, color="#FFFFFF", font="14px Arial"), 
      250
    )
    
    @sprite.sprites.set(skill_entity, skill_sprite)
    @position.positions.set(skill_entity, @math.Vec2D(menu_position.0 + 25.0, menu_position.1 + skill_y_offset))
    @ui.uis.set(skill_entity, @ui.Ui::new())
    
    battle_system.skill_menu.skill_entities.push(skill_entity)
    battle_system.skill_menu.entities.push(skill_entity)
    
    skill_y_offset = skill_y_offset + 30.0
    i = i + 1
  }
  
  // 创建选择指示器
  let indicator_entity = @system.Entity::new()
  let indicator_sprite = @sprite.Sprite::new_text(
    @sprite.Text::new("▶", color="#4ECDC4", font="bold 16px Arial"), 
    250
  )
  @sprite.sprites.set(indicator_entity, indicator_sprite)
  @position.positions.set(indicator_entity, @math.Vec2D(menu_position.0 + 10.0, menu_position.1 + 50.0))
  @ui.uis.set(indicator_entity, @ui.Ui::new())
  
  battle_system.skill_menu.indicator_entity = Some(indicator_entity)
  battle_system.skill_menu.entities.push(indicator_entity)
  

  
  // 设置技能菜单为可见
  battle_system.skill_menu.visible = true
  battle_system.skill_menu.selected_index = 0
  
  // 更新技能菜单的内置位置和尺寸 - 使用实际创建的位置
  battle_system.skill_menu.position = menu_position
  // 注意：width和height已经在初始化时设置，这里不需要更新
  
  // 主菜单按钮状态更新已移除（不再使用按钮实体）
  
  println("✅ 技能菜单已创建，包含 " + battle_system.skill_menu.skills.length().to_string() + " 个技能")
  println("📍 菜单位置: (" + battle_system.skill_menu.position.0.to_string() + ", " + battle_system.skill_menu.position.1.to_string() + ")")
  println("📏 菜单尺寸: " + battle_system.skill_menu.width.to_string() + " x " + battle_system.skill_menu.height.to_string())
}

///|
// 清理技能菜单实体
fn cleanup_skill_menu() -> Unit {
  // 删除所有技能菜单实体
  for entity in battle_system.skill_menu.entities {
    @system.Entity::destroy(entity)
  }
  
  // 重置技能菜单状态
  battle_system.skill_menu.entities = Array::new()
  battle_system.skill_menu.skill_entities = Array::new()
  battle_system.skill_menu.background_entity = None
  battle_system.skill_menu.title_entity = None
  battle_system.skill_menu.indicator_entity = None
  battle_system.skill_menu.visible = false
  battle_system.skill_menu.selected_index = 0
}

///|
// 更新HP显示
fn update_hp_display() -> Unit {
  // 更新敌人HP显示
  match battle_system.enemy_hp_entity {
    Some(enemy_hp_entity) => {
      let enemy_hp_text = "HP: " + battle_system.enemy_hp.to_string() + "/" + battle_system.enemy_max_hp.to_string()
      let enemy_hp_sprite = @sprite.Sprite::new_text(@sprite.Text::new(enemy_hp_text, font="16px Arial"), 250)
      @sprite.sprites.set(enemy_hp_entity, enemy_hp_sprite)
    }
    None => ()
  }
  
  // 更新玩家HP显示
  match battle_system.player_hp_entity {
    Some(player_hp_entity) => {
      let player_hp_text = "HP: " + battle_system.player_hp.to_string() + "/" + battle_system.player_max_hp.to_string()
      let player_hp_sprite = @sprite.Sprite::new_text(@sprite.Text::new(player_hp_text, font="16px Arial"), 250)
      @sprite.sprites.set(player_hp_entity, player_hp_sprite)
    }
    None => ()
  }
}

///|
// 处理菜单选择确认
fn handle_menu_selection() -> Unit {
  match battle_system.main_menu.selected_option {
    Fight => {
      // 显示技能菜单
      if !battle_system.skill_menu.visible {
        create_skill_menu()
      }
    }
    Bag => {
      // 处理背包选择
      // 可以在这里添加背包逻辑
      ()
    }
    Pokemon => {
      // 处理宝可梦选择
      // 可以在这里添加宝可梦管理逻辑
      ()
    }
    Run => {
      // 处理逃跑选择 - 退出战斗
      exit_battle()
    }
  }
}

///|
// 更新技能菜单选择指示器
fn update_skill_menu_selection() -> Unit {
  match battle_system.skill_menu.indicator_entity {
    Some(indicator_entity) => {
      // 使用技能菜单的内置几何属性计算指示器位置
      let menu_x = battle_system.skill_menu.position.0
      let menu_y = battle_system.skill_menu.position.1
      
      // 计算指示器的新位置 - 基于菜单的内置位置和尺寸
      let indicator_x = menu_x + 10.0  // 距离左边界10像素
      let indicator_y = menu_y + 50.0 + (battle_system.skill_menu.selected_index.to_double() * 30.0)
      
      @position.positions.set(indicator_entity, @math.Vec2D(indicator_x, indicator_y))
      
      println("🎯 技能选择指示器更新: 技能 " + (battle_system.skill_menu.selected_index + 1).to_string())
      println("📍 指示器位置: (" + indicator_x.to_string() + ", " + indicator_y.to_string() + ")")
    }
    None => ()
  }
}

///|
// 处理技能选择
fn handle_skill_selection() -> Unit {
  if battle_system.skill_menu.visible && battle_system.skill_menu.selected_index >= 0 && battle_system.skill_menu.selected_index < battle_system.skill_menu.skills.length() {
    let selected_skill = battle_system.skill_menu.skills[battle_system.skill_menu.selected_index]
    
    println("⚔️ 使用技能: " + selected_skill.name + " (伤害: " + selected_skill.damage.to_string() + ")")
    
    // 对敌人造成伤害
    if battle_system.enemy_hp > 0 {
      battle_system.enemy_hp = battle_system.enemy_hp - selected_skill.damage
      if battle_system.enemy_hp < 0 {
        battle_system.enemy_hp = 0
      }
      
      // 更新HP显示
      update_hp_display()
      println("💥 敌人受到 " + selected_skill.damage.to_string() + " 点伤害！剩余HP: " + battle_system.enemy_hp.to_string() + "/" + battle_system.enemy_max_hp.to_string())
      
      // 检查敌人是否被击败
      if battle_system.enemy_hp <= 0 {
        println("🎉 敌人被击败了！")
        // 这里可以添加胜利逻辑
      }
    }
    
    // 隐藏技能菜单
    cleanup_skill_menu()
    
    // 主菜单状态恢复已移除（不再使用按钮实体）
  }
}

///|
// 返回主菜单
fn return_to_main_menu() -> Unit {
  if battle_system.skill_menu.visible {
    cleanup_skill_menu()
    // 主菜单状态更新已移除（不再使用按钮实体）
    println("🔙 返回主菜单")
  }
}

///|
// 清理战斗界面实体
fn cleanup_battle_entities() -> Unit {
  // 删除所有战斗实体
  for entity in battle_system.battle_entities {
    @system.Entity::destroy(entity)
  }
  // 清空实体列表
  battle_system.battle_entities = Array::new()
  
  // 清理调试实体
  for entity in battle_system.debug_entities {
    @system.Entity::destroy(entity)
  }
  // 清空调试实体列表
  battle_system.debug_entities = Array::new()
}

///|
// 战斗输入系统
fn battle_input_system(_backend : &@system.Backend) -> Unit {
  if is_in_battle() {
    if battle_system.skill_menu.visible {
      // 技能菜单激活时的输入处理
      // 上下键选择技能
      if @system.is_just_pressed(@system.ArrowUp) {
        if battle_system.skill_menu.selected_index > 0 {
          battle_system.skill_menu.selected_index = battle_system.skill_menu.selected_index - 1
        } else {
          battle_system.skill_menu.selected_index = battle_system.skill_menu.skills.length() - 1
        }
        update_skill_menu_selection()
      }
      
      if @system.is_just_pressed(@system.ArrowDown) {
        if battle_system.skill_menu.selected_index < battle_system.skill_menu.skills.length() - 1 {
          battle_system.skill_menu.selected_index = battle_system.skill_menu.selected_index + 1
        } else {
          battle_system.skill_menu.selected_index = 0
        }
        update_skill_menu_selection()
      }
      
      // Z键或Enter键确认技能选择
      if @system.is_just_pressed(@system.KeyZ) || @system.is_just_pressed(@system.Enter) {
        handle_skill_selection()
      }
      
      // 空格键也可以确认技能选择
      if @system.is_just_pressed(@system.Space) {
        handle_skill_selection()
      }
      
      // X键返回主菜单
      if @system.is_just_pressed(@system.KeyX) {
        return_to_main_menu()
      }
      
      // D键激活调试模式
      if @system.is_just_pressed(@system.KeyD) {
        println("🔧 技能菜单调试模式已激活！")
        debug_ui_layout()
        create_debug_boundaries()
      }
      
      // 左右键切换技能选择
      if @system.is_just_pressed(@system.ArrowLeft) {
        if battle_system.skill_menu.selected_index > 0 {
          battle_system.skill_menu.selected_index = battle_system.skill_menu.selected_index - 1
        } else {
          battle_system.skill_menu.selected_index = battle_system.skill_menu.skills.length() - 1
        }
        update_skill_menu_selection()
      }
      
      if @system.is_just_pressed(@system.ArrowRight) {
        if battle_system.skill_menu.selected_index < battle_system.skill_menu.skills.length() - 1 {
          battle_system.skill_menu.selected_index = battle_system.skill_menu.selected_index + 1
        } else {
          battle_system.skill_menu.selected_index = 0
        }
        update_skill_menu_selection()
      }
    } else {
      // 主菜单激活时的输入处理
      
      // 鼠标悬停检测已移除（不再使用按钮实体）
      
      // 上下键选择菜单选项
      if @system.is_just_pressed(@system.ArrowUp) {
        battle_system.main_menu.selected_option = get_prev_menu_option(battle_system.main_menu.selected_option)
        update_menu_selection()
      }
      
      if @system.is_just_pressed(@system.ArrowDown) {
        battle_system.main_menu.selected_option = get_next_menu_option(battle_system.main_menu.selected_option)
        update_menu_selection()
      }
      
      // Z键或Enter键确认选择
      if @system.is_just_pressed(@system.KeyZ) || @system.is_just_pressed(@system.Enter) {
        handle_menu_selection()
      }
      
      // 空格键也可以确认选择
      if @system.is_just_pressed(@system.Space) {
        handle_menu_selection()
      }
      
      // D键激活调试模式
      if @system.is_just_pressed(@system.KeyD) {
        println("🔧 主菜单调试模式已激活！")
        debug_ui_layout()
        create_debug_boundaries()
      }
    }
  } else {
    // 不在战斗中，按A进入战斗
    if @system.is_just_pressed(@system.KeyA) {
      enter_battle()
    }
  }
}

///|
// 检测鼠标悬停在按钮上


///|
// 战斗页面渲染系统 - 现在只是状态检查，实体在状态变化时创建/删除
fn battle_render_system(_backend : &@system.Backend) -> Unit {
  // 战斗界面现在通过实体系统自动渲染，不需要在这里做任何事情
  // 实体在进入/退出战斗时创建/删除
} 

///|
// 调试UI布局信息
fn debug_ui_layout() -> Unit {
  println("🔧 === UI布局调试信息 ===")
  println("屏幕尺寸: " + VIEWPORT_WIDTH.to_string() + " x " + VIEWPORT_HEIGHT.to_string())
  println("战斗状态: " + (if is_in_battle() { "战斗中" } else { "非战斗" }))
  
  // 显示菜单选项信息
  if is_in_battle() {
    println("当前选择: " + get_menu_option_text(battle_system.main_menu.selected_option))
    println("悬停选项: 已移除（不再使用按钮实体）")
  }
  
  // 显示技能菜单信息
  if battle_system.skill_menu.visible {
    println("技能菜单: 可见")
    println("选中技能索引: " + battle_system.skill_menu.selected_index.to_string())
    println("技能数量: " + battle_system.skill_menu.skills.length().to_string())
  } else {
    println("技能菜单: 隐藏")
  }
  
  println("🔧 === 调试信息结束 ===")
}

///|
// 创建调试边界框
fn create_debug_boundaries() -> Unit {
  println("🔧 创建调试边界框...")
  
  // 创建主菜单按钮的边界框
  let options = [Fight, Bag, Pokemon, Run]
  for option in options {
    guard battle_system.main_menu.button_entities.get(option) is Some(entity)
    
    // 创建边界框实体
    let boundary_entity = @system.Entity::new()
    let boundary_sprite = @sprite.Sprite::new_picture(
      @sprite.Picture::new(
        @math.Vec2D(82.0, 27.0), // 比按钮稍大一点
        "data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iODIiIGhlaWdodD0iMjciIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+PHJlY3Qgd2lkdGg9IjgyIiBoZWlnaHQ9IjI3IiBmaWxsPSJub25lIiBzdHJva2U9IiNmZjAwMDAiIHN0cm9rZS13aWR0aD0iMiIvPjwvc3ZnPg=="
      ),
      300 // 高优先级，确保在最上层
    )
    @sprite.sprites.set(boundary_entity, boundary_sprite)
    
    // 设置边界框位置（与按钮位置相同）
    guard @position.positions.get(entity) is Some(button_pos)
    @position.positions.set(boundary_entity, button_pos)
    
    // 添加到调试实体列表
    battle_system.debug_entities.push(boundary_entity)
    
    println("🔧 为 " + get_menu_option_text(option) + " 创建边界框")
  }
  
  println("🔧 调试边界框创建完成")
} 

///|
// 显示菜单几何信息 - 演示如何使用新的几何属性
fn show_menu_geometry_info() -> Unit {
  println("📊 菜单几何信息:")
  println("  屏幕尺寸: 800 x 600")
  println("  主战斗菜单:")
  println("    位置: (" + battle_system.main_menu.position.0.to_string() + ", " + battle_system.main_menu.position.1.to_string() + ")")
  println("    尺寸: " + battle_system.main_menu.width.to_string() + " x " + battle_system.main_menu.height.to_string())
  println("    右边界: " + (battle_system.main_menu.position.0 + battle_system.main_menu.width).to_string())
  println("    下边界: " + (battle_system.main_menu.position.1 + battle_system.main_menu.height).to_string())
  
  if battle_system.skill_menu.visible {
    println("  技能菜单:")
    println("    位置: (" + battle_system.skill_menu.position.0.to_string() + ", " + battle_system.skill_menu.position.1.to_string() + ")")
    println("    尺寸: " + battle_system.skill_menu.width.to_string() + " x " + battle_system.skill_menu.height.to_string())
    println("    右边界: " + (battle_system.skill_menu.position.0 + battle_system.skill_menu.width).to_string())
    println("    下边界: " + (battle_system.skill_menu.position.1 + battle_system.skill_menu.height).to_string())
  } else {
    println("  技能菜单: 未显示")
  }
  
  // 验证菜单边界 - 使用新的配置模块
  let _ = validate_menu_boundaries()
} 

// 此函数已移动到 battle_menu_config.mbt 中 

// 此函数已移动到 battle_menu_config.mbt 中 

// 此函数已移动到 battle_menu_config.mbt 中 

///|
// 创建菜单调试边界框 - 演示如何使用几何属性
fn create_menu_debug_boundaries() -> Unit {
  // 为主菜单创建边界框
  let main_menu_entity = @system.Entity::new()
  let main_menu_boundary = @sprite.Sprite::new_picture(
    @sprite.Picture::new(
      @math.Vec2D(battle_system.main_menu.width, battle_system.main_menu.height),
      "data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTcwIiBoZWlnaHQ9IjExNSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48cmVjdCB3aWR0aD0iMTcwIiBoZWlnaHQ9IjExNSIgZmlsbD0ibm9uZSIgc3Ryb2tlPSIjZmYwMDAwIiBzdHJva2Utd2lkdGg9IjIiIHN0cm9rZS1kYXNoYXJyYXk9IjUsNSIvPjwvc3ZnPg=="
    ),
    100
  )
  @sprite.sprites.set(main_menu_entity, main_menu_boundary)
  @position.positions.set(main_menu_entity, battle_system.main_menu.position)
  @ui.uis.set(main_menu_entity, @ui.Ui::new())
  battle_system.debug_entities.push(main_menu_entity)
  
  // 为技能菜单创建边界框（如果可见）
  if battle_system.skill_menu.visible {
    let skill_menu_entity = @system.Entity::new()
    let skill_menu_boundary = @sprite.Sprite::new_picture(
      @sprite.Picture::new(
        @math.Vec2D(battle_system.skill_menu.width, battle_system.skill_menu.height),
        "data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjIwIiBoZWlnaHQ9IjIwMCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48cmVjdCB3aWR0aD0iMjIwIiBoZWlnaHQ9IjIwMCIgZmlsbD0ibm9uZSIgc3Ryb2tlPSIjMDAwMGZmIiBzdHJva2Utd2lkdGg9IjIiIHN0cm9rZS1kYXNoYXJyYXk9IjUsNSIvPjwvc3ZnPg=="
      ),
      100
    )
    @sprite.sprites.set(skill_menu_entity, skill_menu_boundary)
    @position.positions.set(skill_menu_entity, battle_system.skill_menu.position)
    @ui.uis.set(skill_menu_entity, @ui.Ui::new())
    battle_system.debug_entities.push(skill_menu_entity)
  }
  
  println("🔧 菜单调试边界框创建完成")
} 

///|
// 简化的菜单设置 - 模仿ui.mbt的设计模式
fn setup_battle_menu() -> Unit {
  // 创建Fight按钮
  let fight_button = @system.Entity::new()
  @position.positions.set(fight_button, @math.Vec2D(60, 210))
  let fight_sprite = @sprite.Sprite::new_picture(
    @sprite.Picture::new(
      @math.Vec2D(80, 25),
      "pixel_adventure/Menu/Buttons/Play.png",
    ),
    240,
  )
  @sprite.sprites.set(fight_button, fight_sprite)
  @ui.uis.set(fight_button, @ui.Ui::new())
  
  // 为Fight按钮添加碰撞检测
  let fight_area = @collision.Area::new(
    @collision.CollisionShape::Rect(
      size=@math.Vec2D(80.0, 25.0),
      offset=@math.Vec2D::zero(),
    ),
    @collision.CollisionLayer::new(),
    @collision.CollisionMask::empty(),
    monitoring_mouse=true,
  )
  fight_area.on_just_released(fn(mouse_button) {
    if mouse_button == @system.MouseButton::Left {
      println("⚔️ Fight按钮被点击！")
      battle_system.main_menu.selected_option = Fight
      handle_menu_selection()
    }
  })
  @collision.areas.set(fight_button, fight_area)
  battle_system.battle_entities.push(fight_button)
  
  // 创建Bag按钮
  let bag_button = @system.Entity::new()
  @position.positions.set(bag_button, @math.Vec2D(60, 240))
  let bag_sprite = @sprite.Sprite::new_picture(
    @sprite.Picture::new(
      @math.Vec2D(80, 25),
      "pixel_adventure/Menu/Buttons/Play.png",
    ),
    240,
  )
  @sprite.sprites.set(bag_button, bag_sprite)
  @ui.uis.set(bag_button, @ui.Ui::new())
  
  let bag_area = @collision.Area::new(
    @collision.CollisionShape::Rect(
      size=@math.Vec2D(80.0, 25.0),
      offset=@math.Vec2D::zero(),
    ),
    @collision.CollisionLayer::new(),
    @collision.CollisionMask::empty(),
    monitoring_mouse=true,
  )
  bag_area.on_just_released(fn(mouse_button) {
    if mouse_button == @system.MouseButton::Left {
      println("🎒 Bag按钮被点击！")
      battle_system.main_menu.selected_option = Bag
      handle_menu_selection()
    }
  })
  @collision.areas.set(bag_button, bag_area)
  battle_system.battle_entities.push(bag_button)
  
  // 创建Pokemon按钮
  let pokemon_button = @system.Entity::new()
  @position.positions.set(pokemon_button, @math.Vec2D(60, 270))
  let pokemon_sprite = @sprite.Sprite::new_picture(
    @sprite.Picture::new(
      @math.Vec2D(80, 25),
      "pixel_adventure/Menu/Buttons/Play.png",
    ),
    240,
  )
  @sprite.sprites.set(pokemon_button, pokemon_sprite)
  @ui.uis.set(pokemon_button, @ui.Ui::new())
  
  let pokemon_area = @collision.Area::new(
    @collision.CollisionShape::Rect(
      size=@math.Vec2D(80.0, 25.0),
      offset=@math.Vec2D::zero(),
    ),
    @collision.CollisionLayer::new(),
    @collision.CollisionMask::empty(),
    monitoring_mouse=true,
  )
  pokemon_area.on_just_released(fn(mouse_button) {
    if mouse_button == @system.MouseButton::Left {
      println("🐱 Pokemon按钮被点击！")
      battle_system.main_menu.selected_option = Pokemon
      handle_menu_selection()
    }
  })
  @collision.areas.set(pokemon_button, pokemon_area)
  battle_system.battle_entities.push(pokemon_button)
  
  // 创建Run按钮
  let run_button = @system.Entity::new()
  @position.positions.set(run_button, @math.Vec2D(60, 300))
  let run_sprite = @sprite.Sprite::new_picture(
    @sprite.Picture::new(
      @math.Vec2D(80, 25),
      "pixel_adventure/Menu/Buttons/Play.png",
    ),
    240,
  )
  @sprite.sprites.set(run_button, run_sprite)
  @ui.uis.set(run_button, @ui.Ui::new())
  
  let run_area = @collision.Area::new(
    @collision.CollisionShape::Rect(
      size=@math.Vec2D(80.0, 25.0),
      offset=@math.Vec2D::zero(),
    ),
    @collision.CollisionLayer::new(),
    @collision.CollisionMask::empty(),
    monitoring_mouse=true,
  )
  run_area.on_just_released(fn(mouse_button) {
    if mouse_button == @system.MouseButton::Left {
      println("🏃 Run按钮被点击！")
      battle_system.main_menu.selected_option = Run
      handle_menu_selection()
    }
  })
  @collision.areas.set(run_button, run_area)
  battle_system.battle_entities.push(run_button)
  
  // 添加按钮文本
  add_button_text(fight_button, "Fight", 60, 210)
  add_button_text(bag_button, "Bag", 60, 240)
  add_button_text(pokemon_button, "Pokemon", 60, 270)
  add_button_text(run_button, "Run", 60, 300)
}

///|
// 为按钮添加文本标签
fn add_button_text(button_entity : @system.Entity, text : String, x : Double, y : Double) -> Unit {
  let text_entity = @system.Entity::new()
  let text_sprite = @sprite.Sprite::new_text(
    @sprite.Text::new(text, color="#FFFFFF", font="16px Arial"),
    250
  )
  @sprite.sprites.set(text_entity, text_sprite)
  @position.positions.set(text_entity, @math.Vec2D(x + 40, y + 5)) // 文本居中
  @ui.uis.set(text_entity, @ui.Ui::new())
  battle_system.battle_entities.push(text_entity)
} 