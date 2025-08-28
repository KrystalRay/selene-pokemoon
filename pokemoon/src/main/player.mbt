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

// NPC系统函数
fn get_npc_dialogue(npc_id : String, npc_pos : @math.Vec2D) -> String {
  match npc_id {
    "1" => "欢迎来到宝可梦世界！"
    "2" => "这里有很多有趣的宝可梦！"
    _ => "祝你冒险愉快！"
  }
}

fn check_npc_interaction_range(player_pos : @math.Vec2D, npc_pos : @math.Vec2D, interaction_range : Double) -> Bool {
  let diff = player_pos - npc_pos
  let distance = (diff[X] * diff[X] + diff[Y] * diff[Y]).sqrt()
  distance <= interaction_range
}

///|
let player_idle_animation : @sprite.Animation = @sprite.Animation::new(
  "pixel_adventure/Main Characters/Mask Dude/Idle (32x32).png",
  loop_=true,
  max_frame=11,
  height=32.0,
  width=32.0,
)

///|
let player_walk_animation : @sprite.Animation = @sprite.Animation::new(
  "pixel_adventure/Main Characters/Mask Dude/Run (32x32).png",
  loop_=true,
  max_frame=12,
  height=32.0,
  width=32.0,
)

///|
fn add_player(pos : @math.Vec2D) -> Unit {
  let player_sprite = @sprite.Sprite::new_animation(player_idle_animation, 10)
  @sprite.sprites.set(game_state.player, player_sprite)
  @velocity.velocities.set(game_state.player, @math.Vec2D::zero())
  @position.positions.set(game_state.player, pos)
  
  // 修改碰撞形状，使其更适合俯视视角
  @collision.collides.set(game_state.player, @collision.Collide::{
    shape: Rect(size=@math.Vec2D(20.0, 20.0), offset=@math.Vec2D(6.0, 6.0)),
    layer: player_collision_layer,
    mask: player_collision_mask,
  })
  
  // 设置相机跟随玩家
  @camera.camera.attached_entity = Some(game_state.player)
  @camera.camera.offset = @math.Vec2D(16.0, 16.0)  // 玩家尺寸的一半，让玩家出现在屏幕中心
}

///|
enum PlayerState {
  Idle
  Walking
} derive(Show)

///|
const MOVE_SPEED = 2.0

///|
// 暂时注释掉未使用的常量
// const TILE_SIZE = 16.0

///|
fn player_state_system(_backend : &@system.Backend) -> Unit {
  // 如果在战斗状态，不处理移动输入
  if is_in_battle() {
    // 停止玩家移动
    @velocity.velocities[game_state.player] = @math.Vec2D::zero()
    return
  }
  
  guard @velocity.velocities.get(game_state.player) is Some(_velocity)
  guard @position.positions.get(game_state.player) is Some(_position)
  
  let mut new_velocity_x = 0.0
  let mut new_velocity_y = 0.0
  let mut is_moving = false
  
  // 四方向移动，每次移动一个瓦片大小
  if @system.is_pressed(@system.ArrowLeft) {
    new_velocity_x = -MOVE_SPEED
    is_moving = true
    game_state.direction = Direction2::Left
  }
  if @system.is_pressed(@system.ArrowRight) {
    new_velocity_x = MOVE_SPEED
    is_moving = true
    game_state.direction = Direction2::Right
  }
  if @system.is_pressed(@system.ArrowUp) {
    new_velocity_y = -MOVE_SPEED
    is_moving = true
  }
  if @system.is_pressed(@system.ArrowDown) {
    new_velocity_y = MOVE_SPEED
    is_moving = true
  }
  
  // 设置速度，让碰撞系统自动处理碰撞
  @velocity.velocities[game_state.player] = @math.Vec2D(new_velocity_x, new_velocity_y)
  
  // 根据移动状态播放动画
  let transform = match game_state.direction {
    Direction2::Left => @math.Transform::flip_x(32.0)
    Direction2::Right => @math.Transform::new()
  }
  
  if is_moving {
    @sprite.play_animation(game_state.player, player_walk_animation, transform~)
    // game_state.player_state = PlayerState::Walking
  } else {
    @sprite.play_animation(game_state.player, player_idle_animation, transform~)
    // game_state.player_state = PlayerState::Idle
  }
}

///|
fn player_interaction_system(_backend : &@system.Backend) -> Unit {
  guard @position.positions.get(game_state.player) is Some(pos)
  
  // 检测与NPC的交互
  if @system.is_just_pressed(@system.Space) {
    check_npc_interaction(pos.inner())
  }
  
  // 检测与物品的交互
  check_item_interaction(pos.inner())
}

///|
fn check_npc_interaction(player_pos : @math.Vec2D) -> Unit {
  // 检测玩家附近的NPC
  let interaction_range = 32.0 // 交互范围
  
  // 遍历所有实体，找到NPC
  let entities = @system.all_entities.to_array()
  for entity in entities {
    // 检查是否有NPC碰撞层
    if @collision.collides.get(entity) is Some(collide) {
      if collide.layer == npc_collision_layer {
        // 检查距离
        if @position.positions.get(entity) is Some(npc_pos) {
          if check_npc_interaction_range(player_pos, npc_pos.inner(), interaction_range) {
            // 在交互范围内，触发对话
            let dialogue = get_npc_dialogue("1", npc_pos.inner()) // 暂时使用默认ID
            println("NPC: " + dialogue)
            return
          }
        }
      }
    }
  }
  
  println("没有找到附近的NPC")
}

///|
fn check_item_interaction(_player_pos : @math.Vec2D) -> Unit {
  // 实现物品拾取逻辑
  // 这里可以添加背包系统
  // 暂时只是打印信息
  // println("Checking for items...")  // 注释掉频繁的日志输出
}

///|
fn camera_follow_system(_backend : &@system.Backend) -> Unit {
  guard @position.positions.get(game_state.player) is Some(pos)
  
  // 让相机平滑跟随玩家，但保持俯视角度
  let target_camera_pos = pos.inner()
  let current_camera_pos = @camera.camera.position
  let lerp_factor = 0.1 // 平滑跟随系数
  
  let diff = target_camera_pos - current_camera_pos
  let new_camera_pos = current_camera_pos + @math.Vec2D(diff[X] * lerp_factor, diff[Y] * lerp_factor)
  @camera.camera.position = new_camera_pos
}
