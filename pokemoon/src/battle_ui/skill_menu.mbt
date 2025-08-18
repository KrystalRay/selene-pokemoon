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
// 技能结构
struct Skill {
  id: String
  name: String
  power: Int
  accuracy: Int
  pp: Int
  max_pp: Int
  type: String
  category: String
}

///|
// 技能菜单结构
struct SkillMenu {
  mut visible: Bool
  mut selected_index: Int
  mut skills: Array[Skill]
  mut entities: Array[@system.Entity]
  mut background_entity: Option[@system.Entity]
  mut title_entity: Option[@system.Entity]
  
  // 几何属性
  position: @math.Vec2D
  width: Double
  height: Double
  
  // 技能实体
  mut skill_entities: Array[@system.Entity]
  mut skill_text_entities: Array[@system.Entity]
}

///|
// 全局技能菜单实例
let skill_menu: SkillMenu = {
  visible: false,
  selected_index: 0,
  skills: Array::new(),
  entities: Array::new(),
  background_entity: None,
  title_entity: None,
  position: @math.Vec2D(300, 200),
  width: 200.0,
  height: 150.0,
  skill_entities: Array::new(),
  skill_text_entities: Array::new(),
}

///|
// 显示技能菜单
fn show_skill_menu() -> Unit {
  if skill_menu.visible {
    return
  }
  
  skill_menu.visible = true
  
  // 创建背景
  create_skill_menu_background()
  
  // 创建标题
  create_skill_menu_title()
  
  // 创建技能列表
  create_skill_list()
  
  println("⚔️ 技能菜单已显示")
}

///|
// 隐藏技能菜单
fn hide_skill_menu() -> Unit {
  if !skill_menu.visible {
    return
  }
  
  skill_menu.visible = false
  
  // 清理所有实体
  for entity in skill_menu.entities {
    @system.Entity::destroy(entity)
  }
  skill_menu.entities.clear()
  
  // 清理技能实体
  skill_menu.skill_entities.clear()
  skill_menu.skill_text_entities.clear()
  
  // 重置选择
  skill_menu.selected_index = 0
  
  println("⚔️ 技能菜单已隐藏")
}

///|
// 创建技能菜单背景
fn create_skill_menu_background() -> Unit {
  let background = @system.Entity::new()
  @position.positions.set(background, skill_menu.position)
  
  let background_sprite = @sprite.Sprite::new_picture(
    @sprite.Picture::new(
      @math.Vec2D(skill_menu.width, skill_menu.height),
      "pixel_adventure/Menu/Buttons/Play.png",
    ),
    200,
  )
  @sprite.sprites.set(background, background_sprite)
  @ui.uis.set(background, @ui.Ui::new())
  
  skill_menu.background_entity = Some(background)
  skill_menu.entities.push(background)
}

///|
// 创建技能菜单标题
fn create_skill_menu_title() -> Unit {
  let title = @system.Entity::new()
  let title_pos = @math.Vec2D(
    skill_menu.position.x,
    skill_menu.position.y - 30
  )
  @position.positions.set(title, title_pos)
  
  let title_text = @sprite.Sprite::new_text(
    @sprite.Text::new("Choose Move", color="#FFFFFF", font="18px Arial"),
    250
  )
  @sprite.sprites.set(title, title_text)
  @ui.uis.set(title, title_text)
  
  skill_menu.title_entity = Some(title)
  skill_menu.entities.push(title)
}

///|
// 创建技能列表
fn create_skill_list() -> Unit {
  for (index, skill) in skill_menu.skills.enumerate() {
    create_skill_item(skill, index)
  }
}

///|
// 创建技能项
fn create_skill_item(skill: Skill, index: Int) -> Unit {
  let skill_entity = @system.Entity::new()
  let skill_pos = @math.Vec2D(
    skill_menu.position.x + 10,
    skill_menu.position.y + 10 + (index as Double * 30)
  )
  @position.positions.set(skill_entity, skill_pos)
  
  let skill_sprite = @sprite.Sprite::new_picture(
    @sprite.Picture::new(
      @math.Vec2D(80, 25),
      "pixel_adventure/Menu/Buttons/Play.png",
    ),
    240,
  )
  @sprite.sprites.set(skill_entity, skill_sprite)
  @ui.uis.set(skill_entity, @ui.Ui::new())
  
  // 添加碰撞检测
  let skill_area = @collision.Area::new(
    @collision.CollisionShape::Rect(
      size=@math.Vec2D(80.0, 25.0),
      offset=@math.Vec2D::zero(),
    ),
    @collision.CollisionLayer::new(),
    @collision.CollisionMask::empty(),
    monitoring_mouse=true,
  )
  
  skill_area.on_just_released(fn(mouse_button) {
    if mouse_button == @system.MouseButton::Left {
      handle_skill_selection(index)
    }
  })
  
  @collision.areas.set(skill_entity, skill_area)
  skill_menu.skill_entities.push(skill_entity)
  skill_menu.entities.push(skill_entity)
  
  // 创建技能文本
  create_skill_text(skill, index)
}

///|
// 创建技能文本
fn create_skill_text(skill: Skill, index: Int) -> Unit {
  let text_entity = @system.Entity::new()
  let text_pos = @math.Vec2D(
    skill_menu.position.x + 15,
    skill_menu.position.y + 15 + (index as Double * 30)
  )
  @position.positions.set(text_entity, text_pos)
  
  let skill_text = @sprite.Sprite::new_text(
    @sprite.Text::new(skill.name, color="#FFFFFF", font="14px Arial"),
    250
  )
  @sprite.sprites.set(text_entity, skill_text)
  @ui.uis.set(text_entity, @ui.Ui::new())
  
  skill_menu.skill_text_entities.push(text_entity)
  skill_menu.entities.push(text_entity)
}

///|
// 处理技能选择
fn handle_skill_selection(index: Int) -> Unit {
  if index >= 0 && index < skill_menu.skills.length() {
    skill_menu.selected_index = index
    let skill = skill_menu.skills[index]
    println("⚔️ 选择了技能: \(skill.name)")
    
    // 隐藏技能菜单
    hide_skill_menu()
    
    // 这里可以触发技能使用逻辑
    use_skill(skill)
  }
}

///|
// 使用技能
fn use_skill(skill: Skill) -> Unit {
  println("🔥 使用技能: \(skill.name)")
  // 这里可以添加技能使用的具体逻辑
}

///|
// 设置技能列表
fn set_skills(skills: Array[Skill]) -> Unit {
  skill_menu.skills = skills
  skill_menu.selected_index = 0
}

///|
// 添加技能
fn add_skill(skill: Skill) -> Unit {
  skill_menu.skills.push(skill)
}

///|
// 处理技能菜单输入
fn handle_skill_menu_input(key: String) -> Unit {
  if !skill_menu.visible {
    return
  }
  
  match key {
    "ArrowUp" => {
      if skill_menu.selected_index > 0 {
        skill_menu.selected_index = skill_menu.selected_index - 1
        update_skill_selection()
      }
    }
    "ArrowDown" => {
      if skill_menu.selected_index < skill_menu.skills.length() - 1 {
        skill_menu.selected_index = skill_menu.selected_index + 1
        update_skill_selection()
      }
    }
    "Enter" | "Space" => {
      confirm_skill_selection()
    }
    "Escape" => {
      hide_skill_menu()
    }
    _ => {}
  }
}

///|
// 更新技能选择
fn update_skill_selection() -> Unit {
  // 这里可以添加选择指示器的更新逻辑
  println("📝 选择了技能: \(skill_menu.skills[skill_menu.selected_index].name)")
}

///|
// 确认技能选择
fn confirm_skill_selection() -> Unit {
  handle_skill_selection(skill_menu.selected_index)
}

///|
// 检查技能菜单是否可见
fn is_skill_menu_visible() -> Bool {
  skill_menu.visible
}

///|
// 获取选中的技能
fn get_selected_skill() -> Option[Skill] {
  if skill_menu.selected_index >= 0 && skill_menu.selected_index < skill_menu.skills.length() {
    Some(skill_menu.skills[skill_menu.selected_index])
  } else {
    None
  }
}

///|
// 获取技能数量
fn get_skill_count() -> Int {
  skill_menu.skills.length()
} 