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
const VIEWPORT_WIDTH : Double = 512.0

///|
const VIEWPORT_HEIGHT : Double = 384.0

///|
fn main {
  @system.App::new(@canvas.CanvasBackend::new())
  .with_canvas_width(VIEWPORT_WIDTH)
  .with_canvas_height(VIEWPORT_HEIGHT)
  .with_fps(60)
  .add_plugin(@plugins.default_plugin)
  // .add_plugin(@plugins.debug_plugin)
  .add_system(game_start, schedule=Startup)
  .add_system(battle_input_system)       // 添加战斗输入系统
  .add_system(player_state_system)       // 玩家状态系统（仅在非战斗状态运行）
  .add_system(player_interaction_system) // 添加交互系统
  .add_system(camera_follow_system)     // 添加相机跟随系统
  .add_system(@collision.move_system)   // 添加碰撞移动系统
  .add_system(battle_render_system)     // 添加战斗渲染系统
  .run()
}

///|
fn game_start(backend : &@system.Backend) -> Unit {
  generate_map(backend)
  add_result_box()
  add_score_box()
  add_volume_button()
}
