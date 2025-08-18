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
// 主战斗菜单选项
enum MainMenuOption {
  Fight
  Bag
  Pokemon
  Run
}

///|
// 主战斗菜单状态
struct MainBattleMenu {
  mut is_visible: Bool
  mut selected_option: MainMenuOption
  mut entities: Array[@system.Entity]
  mut background_entity: Option[@system.Entity]
  mut title_entity: Option[@system.Entity]
  
  // 菜单位置和尺寸
  position: @math.Vec2D
  size: @math.Vec2D
  
  // 按钮相关
  mut button_entities: Map[MainMenuOption, @system.Entity]
  mut button_text_entities: Map[MainMenuOption, @system.Entity]
}

///|
// 全局主战斗菜单实例
let main_battle_menu: MainBattleMenu = {
  is_visible: false,
  selected_option: MainMenuOption::Fight,
  entities: Array::new(),
  background_entity: None,
  title_entity: None,
  position: @math.Vec2D(400.0, 300.0),
  size: @math.Vec2D(400.0, 300.0),
  button_entities: Map::new(),
  button_text_entities: Map::new(),
}

///|
// 清理菜单实体
fn cleanup_menu_entities() -> Unit {
  for entity in main_battle_menu.entities {
    @system.Entity::destroy(entity)
  }
  main_battle_menu.entities.clear()
  main_battle_menu.button_entities.clear()
  main_battle_menu.button_text_entities.clear()
  main_battle_menu.background_entity = None
  main_battle_menu.title_entity = None
}

///|
// 显示主战斗菜单
fn show_main_battle_menu() -> Unit {
  if main_battle_menu.is_visible {
    return
  }
  
  main_battle_menu.is_visible = true
  
  // 创建背景
  let background = @system.Entity::new()
  @position.positions.set(background, main_battle_menu.position)
  
  let background_sprite = @sprite.Sprite::new_picture(
    @sprite.Picture::new(
      "assets/ui/battle_menu_bg.png",
      size=main_battle_menu.size
    )
  )
  
  @sprite.sprites.set(background, background_sprite)
  @ui.uis.set(background, @ui.Ui::new())
  
  main_battle_menu.background_entity = Some(background)
  main_battle_menu.entities.push(background)
  
  // 创建标题
  let title = @system.Entity::new()
  let title_pos = @math.Vec2D(
    main_battle_menu.position.x,
    main_battle_menu.position.y - 120.0
  )
  @position.positions.set(title, title_pos)
  
  let title_text = @sprite.Sprite::new_text(
    @sprite.Text::new("Battle Menu", color="#FFFFFF", font="18px Arial"),
    size=@math.Vec2D(200.0, 30.0)
  )
  
  @sprite.sprites.set(title, title_text)
  @ui.uis.set(title, @ui.Ui::new())
  
  main_battle_menu.title_entity = Some(title)
  main_battle_menu.entities.push(title)
  
  // 创建战斗按钮
  let fight_button = @system.Entity::new()
  let button_pos = @math.Vec2D(
    main_battle_menu.position.x - 150.0,
    main_battle_menu.position.y - 50.0
  )
  @position.positions.set(fight_button, button_pos)
  
  let fight_sprite = @sprite.Sprite::new_picture(
    @sprite.Picture::new(
      "assets/ui/button_bg.png",
      size=@math.Vec2D(80.0, 25.0)
    )
  )
  
  @sprite.sprites.set(fight_button, fight_sprite)
  @ui.uis.set(fight_button, @ui.Ui::new())
  
  // 添加碰撞检测
  let fight_area = @collision.Area::new(
    @collision.CollisionShape::Rect(
      size=@math.Vec2D(80.0, 25.0),
      offset=@math.Vec2D::zero(),
    ),
    @collision.CollisionLayer::new(),
    @collision.CollisionMask::empty(),
  )
  
  fight_area.on_just_released(fn(mouse_button) {
    if mouse_button == @system.MouseButton::Left {
      main_battle_menu.selected_option = MainMenuOption::Fight
      println("⚔️ 选择战斗")
    }
  })
  
  @collision.areas.set(fight_button, fight_area)
  main_battle_menu.button_entities.set(MainMenuOption::Fight, fight_button)
  main_battle_menu.entities.push(fight_button)
  
  // 创建背包按钮
  let bag_button = @system.Entity::new()
  let button_pos = @math.Vec2D(
    main_battle_menu.position.x - 50.0,
    main_battle_menu.position.y - 50.0
  )
  @position.positions.set(bag_button, button_pos)
  
  let bag_sprite = @sprite.Sprite::new_picture(
    @sprite.Picture::new(
      "assets/ui/button_bg.png",
      size=@math.Vec2D(80.0, 25.0)
    )
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
  )
  
  bag_area.on_just_released(fn(mouse_button) {
    if mouse_button == @system.MouseButton::Left {
      main_battle_menu.selected_option = MainMenuOption::Bag
      println("🎒 选择背包")
    }
  })
  
  @collision.areas.set(bag_button, bag_area)
  main_battle_menu.button_entities.set(MainMenuOption::Bag, bag_button)
  main_battle_menu.entities.push(bag_button)
  
  // 创建宝可梦按钮
  let pokemon_button = @system.Entity::new()
  let button_pos = @math.Vec2D(
    main_battle_menu.position.x + 50.0,
    main_battle_menu.position.y - 50.0
  )
  @position.positions.set(pokemon_button, button_pos)
  
  let pokemon_sprite = @sprite.Sprite::new_picture(
    @sprite.Picture::new(
      "assets/ui/button_bg.png",
      size=@math.Vec2D(80.0, 25.0)
    )
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
  )
  
  pokemon_area.on_just_released(fn(mouse_button) {
    if mouse_button == @system.MouseButton::Left {
      main_battle_menu.selected_option = MainMenuOption::Pokemon
      println("🔮 选择宝可梦")
    }
  })
  
  @collision.areas.set(pokemon_button, pokemon_area)
  main_battle_menu.button_entities.set(MainMenuOption::Pokemon, pokemon_button)
  main_battle_menu.entities.push(pokemon_button)
  
  // 创建逃跑按钮
  let run_button = @system.Entity::new()
  let button_pos = @math.Vec2D(
    main_battle_menu.position.x + 150.0,
    main_battle_menu.position.y - 50.0
  )
  @position.positions.set(run_button, button_pos)
  
  let run_sprite = @sprite.Sprite::new_picture(
    @sprite.Picture::new(
      "assets/ui/button_bg.png",
      size=@math.Vec2D(80.0, 25.0)
    )
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
  )
  
  run_area.on_just_released(fn(mouse_button) {
    if mouse_button == @system.MouseButton::Left {
      main_battle_menu.selected_option = MainMenuOption::Run
      println("🏃 选择逃跑")
    }
  })
  
  @collision.areas.set(run_button, run_area)
  main_battle_menu.button_entities.set(MainMenuOption::Run, run_button)
  main_battle_menu.entities.push(run_button)
  
  // 添加按钮文本
  add_button_text(MainMenuOption::Fight, "Fight", button_pos.x, button_pos.y)
  add_button_text(MainMenuOption::Bag, "Bag", button_pos.x, button_pos.y)
  add_button_text(MainMenuOption::Pokemon, "Pokemon", button_pos.x, button_pos.y)
  add_button_text(MainMenuOption::Run, "Run", button_pos.x, button_pos.y)
  
  println("🎮 主战斗菜单已显示")
}

///|
// 添加按钮文本
fn add_button_text(option: MainMenuOption, text: String, x: Float, y: Float) -> Unit {
  let text_entity = @system.Entity::new()
  let text_sprite = @sprite.Sprite::new_text(
    @sprite.Text::new(text, color="#FFFFFF", font="16px Arial"),
    size=@math.Vec2D(80.0, 25.0)
  )
  
  @sprite.sprites.set(text_entity, text_sprite)
  @position.positions.set(text_entity, @math.Vec2D(x + 40, y + 5)) // 文本居中
  @ui.uis.set(text_entity, @ui.Ui::new())
  
  main_battle_menu.button_text_entities.set(option, text_entity)
  main_battle_menu.entities.push(text_entity)
}

///|
// 隐藏主战斗菜单
fn hide_main_battle_menu() -> Unit {
  if !main_battle_menu.is_visible {
    return
  }
  
  main_battle_menu.is_visible = false
  cleanup_menu_entities()
  println("🎮 主战斗菜单已隐藏")
}

///|
// 切换主战斗菜单显示状态
fn toggle_main_battle_menu() -> Unit {
  if main_battle_menu.is_visible {
    hide_main_battle_menu()
  } else {
    show_main_battle_menu()
  }
}

///|
// 检查主战斗菜单是否可见
fn is_main_battle_menu_visible() -> Bool {
  main_battle_menu.is_visible
}

///|
// 获取选中的主菜单选项
fn get_selected_main_menu_option() -> MainMenuOption {
  main_battle_menu.selected_option
} 