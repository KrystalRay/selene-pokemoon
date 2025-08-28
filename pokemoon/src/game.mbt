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
pub struct GameData {
  player : @system.Entity
  player_state : PlayerState
  direction : Direction2
  score : Int
  result_box : @sprite.Text
  score_box : @sprite.Text
  volume_on : Bool
}

///|
pub enum Direction2 {
  Left
  Right
} derive(Show, Eq)

///|
pub enum GameResult {
  Win
} derive(Show, Eq)

///|
// 创建新的游戏数据
pub fn create_game_data() -> GameData {
  GameData::{
    player: @system.Entity::new(),
    player_state: PlayerState::Idle,
    score: 0,
    result_box: @sprite.Text::new("", font="24px ThaleahFat"),
    score_box: @sprite.Text::new(
      "Score: 0",
      font="20px ThaleahFat",
      color="white"
    ),
    direction: Direction2::Right,
    volume_on: true
  }
}

///|
// 设置游戏结果
pub fn set_game_result(game_data : GameData, result : GameResult) -> GameData {
  match result {
    GameResult::Win => {
      let updated_result_box = @sprite.Text::new("You Win!", font="24px ThaleahFat", color="green")
      GameData::{
        player: game_data.player,
        player_state: game_data.player_state,
        direction: game_data.direction,
        score: game_data.score,
        result_box: updated_result_box,
        score_box: game_data.score_box,
        volume_on: game_data.volume_on
      }
    }
  }
}

///|
// 设置分数
pub fn set_score(game_data : GameData, score : Int) -> GameData {
  let updated_score_box = @sprite.Text::new(
    "Score: " + score.to_string(),
    font="20px ThaleahFat",
    color="white"
  )
  
  GameData::{
    player: game_data.player,
    player_state: game_data.player_state,
    direction: game_data.direction,
    score: score,
    result_box: game_data.result_box,
    score_box: updated_score_box,
    volume_on: game_data.volume_on
  }
}
