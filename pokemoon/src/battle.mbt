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
// 战斗系统组件
struct BattleSystem {
  mut state : BattleState
  mut battle_entities : Array[@system.Entity]
}

///|
// 全局战斗系统实例
let battle_system : BattleSystem = {
  state: NotInBattle,
  battle_entities: Array::new()
}

///|
// 进入战斗状态
fn enter_battle() -> Unit {
  battle_system.state = InBattle
  // 创建战斗界面实体
  create_battle_entities()
}

///|
// 退出战斗状态
fn exit_battle() -> Unit {
  battle_system.state = NotInBattle
  // 清理战斗界面实体
  cleanup_battle_entities()
}

///|
// 检查是否在战斗状态
fn is_in_battle() -> Bool {
  match battle_system.state {
    InBattle => true
    NotInBattle => false
  }
}

///|
// 创建战斗界面实体
fn create_battle_entities() -> Unit {
  // 计算屏幕中心位置
  let screen_center_x = VIEWPORT_WIDTH / 2.0
  let screen_center_y = VIEWPORT_HEIGHT / 2.0
  
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
  // 背景位置设置为(0,0)，这样背景的左上角从屏幕左上角开始，完全覆盖整个屏幕
  @position.positions.set(background_entity, @math.Vec2D(0.0, 0.0))
  // 添加UI组件，使背景固定在屏幕上
  @ui.uis.set(background_entity, @ui.Ui::new())
  battle_system.battle_entities.push(background_entity)
  
  // 创建战斗标题sprite - 屏幕顶部中央
  let title_entity = @system.Entity::new()
  let title_sprite = @sprite.Sprite::new_text(@sprite.Text::new("BATTLE!", font="bold 32px Arial"), 250)
  @sprite.sprites.set(title_entity, title_sprite)
  @position.positions.set(title_entity, @math.Vec2D(screen_center_x, 80.0))
  // 添加UI组件，使标题固定在屏幕上
  @ui.uis.set(title_entity, @ui.Ui::new())
  battle_system.battle_entities.push(title_entity)
  
  // 创建战斗提示sprite - 标题下方
  let prompt_entity = @system.Entity::new()
  let prompt_sprite = @sprite.Sprite::new_text(@sprite.Text::new("Press A to exit battle", font="18px Arial"), 250)
  @sprite.sprites.set(prompt_entity, prompt_sprite)
  @position.positions.set(prompt_entity, @math.Vec2D(screen_center_x, 120.0))
  // 添加UI组件，使提示固定在屏幕上
  @ui.uis.set(prompt_entity, @ui.Ui::new())
  battle_system.battle_entities.push(prompt_entity)
  
  // 创建敌人区域sprite - 屏幕左侧
  let enemy_entity = @system.Entity::new()
  let enemy_sprite = @sprite.Sprite::new_picture(
    @sprite.Picture::new(
      @math.Vec2D(120.0, 100.0),
      "data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTIwIiBoZWlnaHQ9IjEwMCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48cmVjdCB3aWR0aD0iMTIwIiBoZWlnaHQ9IjEwMCIgZmlsbD0iI2ZmNmI2YiIvPjwvc3ZnPg=="
    ),
    250
  )
  @sprite.sprites.set(enemy_entity, enemy_sprite)
  @position.positions.set(enemy_entity, @math.Vec2D(80.0, 150.0))
  // 添加UI组件，使敌人区域固定在屏幕上
  @ui.uis.set(enemy_entity, @ui.Ui::new())
  battle_system.battle_entities.push(enemy_entity)
  
  // 创建敌人标签sprite
  let enemy_label_entity = @system.Entity::new()
  let enemy_label_sprite = @sprite.Sprite::new_text(@sprite.Text::new("Enemy", font="16px Arial"), 250)
  @sprite.sprites.set(enemy_label_entity, enemy_label_sprite)
  @position.positions.set(enemy_label_entity, @math.Vec2D(140.0, 200.0))
  // 添加UI组件，使敌人标签固定在屏幕上
  @ui.uis.set(enemy_label_entity, @ui.Ui::new())
  battle_system.battle_entities.push(enemy_label_entity)
  
  // 创建玩家区域sprite - 屏幕右侧
  let player_entity = @system.Entity::new()
  let player_sprite = @sprite.Sprite::new_picture(
    @sprite.Picture::new(
      @math.Vec2D(120.0, 100.0),
      "data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNTEyIiBoZWlnaHQ9IjEwMCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48cmVjdCB3aWR0aD0iNTEyIiBoZWlnaHQ9IjEwMCIgZmlsbD0iIzRlY2RjNCIvPjwvc3ZnPg=="
    ),
    250
  )
  @sprite.sprites.set(player_entity, player_sprite)
  @position.positions.set(player_entity, @math.Vec2D(312.0, 150.0))
  // 添加UI组件，使玩家区域固定在屏幕上
  @ui.uis.set(player_entity, @ui.Ui::new())
  battle_system.battle_entities.push(player_entity)
  
  // 创建玩家标签sprite
  let player_label_entity = @system.Entity::new()
  let player_label_sprite = @sprite.Sprite::new_text(@sprite.Text::new("Player", font="16px Arial"), 250)
  @sprite.sprites.set(player_label_entity, player_label_sprite)
  @position.positions.set(player_label_entity, @math.Vec2D(372.0, 200.0))
  // 添加UI组件，使玩家标签固定在屏幕上
  @ui.uis.set(player_label_entity, @ui.Ui::new())
  battle_system.battle_entities.push(player_label_entity)
  
  // 创建战斗菜单sprite - 屏幕左侧
  let fight_entity = @system.Entity::new()
  let fight_sprite = @sprite.Sprite::new_text(@sprite.Text::new("Fight", font="20px Arial"), 250)
  @sprite.sprites.set(fight_entity, fight_sprite)
  @position.positions.set(fight_entity, @math.Vec2D(80.0, 280.0))
  // 添加UI组件，使战斗菜单固定在屏幕上
  @ui.uis.set(fight_entity, @ui.Ui::new())
  battle_system.battle_entities.push(fight_entity)
  
  let bag_entity = @system.Entity::new()
  let bag_sprite = @sprite.Sprite::new_text(@sprite.Text::new("Bag", font="20px Arial"), 250)
  @sprite.sprites.set(bag_entity, bag_sprite)
  @position.positions.set(bag_entity, @math.Vec2D(80.0, 310.0))
  // 添加UI组件，使背包菜单固定在屏幕上
  @ui.uis.set(bag_entity, @ui.Ui::new())
  battle_system.battle_entities.push(bag_entity)
  
  let pokemon_entity = @system.Entity::new()
  let pokemon_sprite = @sprite.Sprite::new_text(@sprite.Text::new("Pokemon", font="20px Arial"), 250)
  @sprite.sprites.set(pokemon_entity, pokemon_sprite)
  @position.positions.set(pokemon_entity, @math.Vec2D(80.0, 340.0))
  // 添加UI组件，使宝可梦菜单固定在屏幕上
  @ui.uis.set(pokemon_entity, @ui.Ui::new())
  battle_system.battle_entities.push(pokemon_entity)
  
  let run_entity = @system.Entity::new()
  let run_sprite = @sprite.Sprite::new_text(@sprite.Text::new("Run", font="20px Arial"), 250)
  @sprite.sprites.set(run_entity, run_sprite)
  @position.positions.set(run_entity, @math.Vec2D(80.0, 370.0))
  // 添加UI组件，使逃跑菜单固定在屏幕上
  @ui.uis.set(run_entity, @ui.Ui::new())
  battle_system.battle_entities.push(run_entity)
  
  // 创建状态信息sprite - 屏幕右侧
  let hp_entity = @system.Entity::new()
  let hp_sprite = @sprite.Sprite::new_text(@sprite.Text::new("HP: 100/100", font="16px Arial"), 250)
  @sprite.sprites.set(hp_entity, hp_sprite)
  @position.positions.set(hp_entity, @math.Vec2D(350.0, 280.0))
  // 添加UI组件，使HP信息固定在屏幕上
  @ui.uis.set(hp_entity, @ui.Ui::new())
  battle_system.battle_entities.push(hp_entity)
  
  let mp_entity = @system.Entity::new()
  let mp_sprite = @sprite.Sprite::new_text(@sprite.Text::new("MP: 50/50", font="16px Arial"), 250)
  @sprite.sprites.set(mp_entity, mp_sprite)
  @position.positions.set(mp_entity, @math.Vec2D(350.0, 300.0))
  // 添加UI组件，使MP信息固定在屏幕上
  @ui.uis.set(mp_entity, @ui.Ui::new())
  battle_system.battle_entities.push(mp_entity)
  
  let level_entity = @system.Entity::new()
  let level_sprite = @sprite.Sprite::new_text(@sprite.Text::new("Level: 5", font="16px Arial"), 250)
  @sprite.sprites.set(level_entity, level_sprite)
  @position.positions.set(level_entity, @math.Vec2D(350.0, 320.0))
  // 添加UI组件，使等级信息固定在屏幕上
  @ui.uis.set(level_entity, @ui.Ui::new())
  battle_system.battle_entities.push(level_entity)
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
}

///|
// 战斗输入系统
fn battle_input_system(backend : &@system.Backend) -> Unit {
  // 检查是否按下 A 键 - 使用 is_just_pressed 避免重复触发
  if @system.is_just_pressed(@system.KeyA) {
    if is_in_battle() {
      // 如果在战斗中，按 A 退出战斗
      exit_battle()
    } else {
      // 如果不在战斗中，按 A 进入战斗
      enter_battle()
    }
  }
}

///|
// 战斗页面渲染系统 - 现在只是状态检查，实体在状态变化时创建/删除
fn battle_render_system(backend : &@system.Backend) -> Unit {
  // 战斗界面现在通过实体系统自动渲染，不需要在这里做任何事情
  // 实体在进入/退出战斗时创建/删除
} 