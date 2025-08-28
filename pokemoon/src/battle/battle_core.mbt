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
// 战斗系统核心 - 仿照Pokemon Showdown的battle.ts
// 这个模块提供了完整的战斗逻辑和状态管理

///|
// 战斗状态枚举
pub enum BattleState {
  NotStarted
  TeamPreview
  Move
  Switch
  Ended
} derive(Show, Eq)

///|
// 游戏类型枚举
pub enum GameType {
  Singles
  Doubles
  Triples
  FreeForAll
} derive(Show, Eq)

///|
// 请求状态枚举
pub enum RequestState {
  TeamPreview
  Move
  Switch
  None
} derive(Show, Eq)

///|
// 战斗结果枚举
pub enum BattleResult {
  Win(String)  // 获胜方名称
  Tie
  Ongoing
} derive(Show, Eq)

///|
// 技能信息
pub struct Move {
  id : String
  name : String
  power : Int
  accuracy : Int
  pp : Int
  max_pp : Int
  move_type : String
  category : String
  target : String
  priority : Int
  description : String
} derive(Show)

///|
// 队伍信息
pub struct Team {
  id : String
  name : String
  pokemon : Array[Pokemon]
  active_pokemon : Array[Option[Pokemon]]
  pokemon_left : Int
} derive(Show)

///|
// 场地信息
pub struct Field {
  weather : Option[String]
  terrain : Option[String]
  pseudo_weather : Map[String, Bool]
} derive(Show)

///|
// 战斗事件类型（简化版本，避免与 battle_events.mbt 冲突）
pub enum BattleEventCore {
  TurnStart(Int)
  TurnEnd(Int)
  MoveUsed(Int, String, Int)  // pokemon_id, move_id, target_id
  Switch(Int, Int)  // pokemon_id, new_position
  StatusChange(Int, String)  // pokemon_id, new_status
  WeatherChange(String)  // new_weather
  TerrainChange(String)  // new_terrain
  ItemUse(Int, String)  // pokemon_id, item_id
  AbilityActivation(Int, String)  // pokemon_id, ability_id
  MegaEvolution(Int)  // pokemon_id
  Dynamax(Int)  // pokemon_id
  Terastallize(Int)  // pokemon_id
  CriticalHit(Int)  // pokemon_id
  Miss(Int)  // pokemon_id
  NoEffect(Int)  // pokemon_id
  SuperEffective(Int)  // pokemon_id
  NotVeryEffective(Int)  // pokemon_id
  Immune(Int)  // pokemon_id
  Faint(Int)  // pokemon_id
  Win(String)  // winner_id
  Draw
} derive(Show, Eq)

///|
// 战斗系统核心结构
pub struct Battle {
  id : String
  format : String
  game_type : GameType
  state : BattleState
  request_state : RequestState
  turn : Int
  started : Bool
  ended : Bool
  result : BattleResult
  
  // 队伍信息
  teams : Array[Team]
  
  // 场地信息
  field : Field
  
  // 战斗日志
  log : Array[String]
  event_log : Array[BattleEventCore]
  
  // 系统相关
  prng_seed : String
  debug_mode : Bool
} derive(Show)

///|
// 全局战斗实例
pub let current_battle : Option[Battle] = None

///|
// 创建新的战斗
pub fn create_battle(
  format : String,
  game_type : GameType,
  teams : Array[Team]
) -> Battle {
  Battle::{
    id: generate_battle_id(),
    format: format,
    game_type: game_type,
    state: NotStarted,
    request_state: None,
    turn: 0,
    started: false,
    ended: false,
    result: Ongoing,
    teams: teams,
    field: Field::{
      weather: None,
      terrain: None,
      pseudo_weather: Map::new()
    },
    log: Array::new(),
    event_log: Array::new(),
    prng_seed: generate_seed(),
    debug_mode: false
  }
}

///|
// 生成战斗ID
pub fn generate_battle_id() -> String {
  "battle_" + "id"
}

///|
// 生成随机种子
pub fn generate_seed() -> String {
  "seed"
}

///|
// 开始战斗
pub fn start_battle(battle : Battle) -> Battle {
  if battle.started {
    return battle
  }
  
  let new_battle = Battle::{
    id: battle.id,
    format: battle.format,
    game_type: battle.game_type,
    state: TeamPreview,
    request_state: TeamPreview,
    turn: battle.turn,
    started: true,
    ended: battle.ended,
    result: battle.result,
    teams: battle.teams,
    field: battle.field,
    log: battle.log,
    event_log: battle.event_log,
    prng_seed: battle.prng_seed,
    debug_mode: battle.debug_mode
  }
  
  // 添加战斗开始事件
  new_battle.event_log.push(TurnStart(0))
  
  Battle::{
    id: new_battle.id,
    format: new_battle.format,
    game_type: new_battle.game_type,
    state: new_battle.state,
    request_state: new_battle.request_state,
    turn: new_battle.turn,
    started: new_battle.started,
    ended: new_battle.ended,
    result: new_battle.result,
    teams: new_battle.teams,
    field: new_battle.field,
    log: new_battle.log,
    event_log: new_battle.event_log,
    prng_seed: new_battle.prng_seed,
    debug_mode: new_battle.debug_mode
  }
}

///|
// 添加战斗事件
pub fn add_battle_event(battle : Battle, event : BattleEventCore) -> Battle {
  battle.event_log.push(event)
  
  Battle::{
    id: battle.id,
    format: battle.format,
    game_type: battle.game_type,
    state: battle.state,
    request_state: battle.request_state,
    turn: battle.turn,
    started: battle.started,
    ended: battle.ended,
    result: battle.result,
    teams: battle.teams,
    field: battle.field,
    log: battle.log,
    event_log: battle.event_log,
    prng_seed: battle.prng_seed,
    debug_mode: battle.debug_mode
  }
}

///|
// 添加日志条目
pub fn add_battle_log_entry(battle : Battle, message : String) -> Battle {
  battle.log.push(message)
  
  Battle::{
    id: battle.id,
    format: battle.format,
    game_type: battle.game_type,
    state: battle.state,
    request_state: battle.request_state,
    turn: battle.turn,
    started: battle.started,
    ended: battle.ended,
    result: battle.result,
    teams: battle.teams,
    field: battle.field,
    log: battle.log,
    event_log: battle.event_log,
    prng_seed: battle.prng_seed,
    debug_mode: battle.debug_mode
  }
}

///|
// 进入队伍预览阶段
pub fn enter_team_preview(battle : Battle) -> Battle {
  let new_battle = Battle::{
    id: battle.id,
    format: battle.format,
    game_type: battle.game_type,
    state: TeamPreview,
    request_state: TeamPreview,
    turn: battle.turn,
    started: battle.started,
    ended: battle.ended,
    result: battle.result,
    teams: battle.teams,
    field: battle.field,
    log: battle.log,
    event_log: battle.event_log,
    prng_seed: battle.prng_seed,
    debug_mode: battle.debug_mode
  }
  
  add_battle_log_entry(new_battle, "Team Preview phase")
}

///|
// 进入移动选择阶段
pub fn enter_move_selection(battle : Battle) -> Battle {
  let new_battle = Battle::{
    id: battle.id,
    format: battle.format,
    game_type: battle.game_type,
    state: Move,
    request_state: Move,
    turn: battle.turn + 1,
    started: battle.started,
    ended: battle.ended,
    result: battle.result,
    teams: battle.teams,
    field: battle.field,
    log: battle.log,
    event_log: battle.event_log,
    prng_seed: battle.prng_seed,
    debug_mode: battle.debug_mode
  }
  
  let updated_battle = add_battle_log_entry(new_battle, "Turn " + new_battle.turn.to_string() + " - Select moves")
  add_battle_event(updated_battle, TurnStart(updated_battle.turn))
}

///|
// 进入宝可梦交换阶段
pub fn enter_switch_selection(battle : Battle) -> Battle {
  let new_battle = Battle::{
    id: battle.id,
    format: battle.format,
    game_type: battle.game_type,
    state: Switch,
    request_state: Switch,
    turn: battle.turn,
    started: battle.started,
    ended: battle.ended,
    result: battle.result,
    teams: battle.teams,
    field: battle.field,
    log: battle.log,
    event_log: battle.event_log,
    prng_seed: battle.prng_seed,
    debug_mode: battle.debug_mode
  }
  
  add_battle_log_entry(new_battle, "Switch Pokemon phase")
}

///|
// 使用技能
pub fn use_move(
  battle : Battle,
  pokemon_id : Int,
  move_id : String,
  target_id : Int
) -> Battle {
  // 查找宝可梦和技能
  let pokemon = find_pokemon_by_id(battle, pokemon_id)
  let move_data = match pokemon {
    Some(p) => find_move_by_id(p, move_id)
    None => None
  }
  
  match (pokemon, move_data) {
    (Some(p), Some(m)) => {
      // 检查PP - 这里需要从moves数组中查找对应的Move对象
      // 由于moves现在是Array[String]，我们需要其他方式来检查PP
      // 暂时跳过PP检查
      let updated_battle = add_battle_event(battle, MoveUsed(pokemon_id, move_id, target_id))
      updated_battle
    }
    _ => battle
  }
}

///|
// 交换宝可梦
pub fn switch_pokemon(
  battle : Battle,
  pokemon_id : Int,
  new_position : Int
) -> Battle {
  // 查找宝可梦
  let pokemon = find_pokemon_by_id(battle, pokemon_id)
  
  match pokemon {
    Some(p) => {
      // 添加交换事件
      add_battle_event(battle, Switch(pokemon_id, new_position))
    }
    None => battle
  }
}

///|
// 结束回合
pub fn end_turn(battle : Battle) -> Battle {
  let updated_battle = add_battle_event(battle, TurnEnd(battle.turn))
  let updated_battle2 = add_battle_log_entry(updated_battle, "Turn " + battle.turn.to_string() + " ended")
  
  // 检查战斗是否结束
  if check_battle_end(updated_battle2) {
    let new_battle = Battle::{
      id: updated_battle2.id,
      format: updated_battle2.format,
      game_type: updated_battle2.game_type,
      state: Ended,
      request_state: updated_battle2.request_state,
      turn: updated_battle2.turn,
      started: updated_battle2.started,
      ended: true,
      result: updated_battle2.result,
      teams: updated_battle2.teams,
      field: updated_battle2.field,
      log: updated_battle2.log,
      event_log: updated_battle2.event_log,
      prng_seed: updated_battle2.prng_seed,
      debug_mode: updated_battle2.debug_mode
    }
    
    add_battle_log_entry(new_battle, "Battle ended!")
  } else {
    // 进入下一回合
    enter_move_selection(updated_battle2)
  }
}

///|
// 检查战斗是否结束
pub fn check_battle_end(battle : Battle) -> Bool {
  let mut teams_with_pokemon = 0
  
  for team in battle.teams.iter() {
    if team.pokemon_left > 0 {
      teams_with_pokemon = teams_with_pokemon + 1
    }
  }
  
  let _ = teams_with_pokemon  // 使用变量
  
  // 如果只有一个或没有队伍还有宝可梦，战斗结束
  teams_with_pokemon <= 1
}

///|
// 查找宝可梦
pub fn find_pokemon_by_id(battle : Battle, pokemon_id : Int) -> Option[Pokemon] {
  for team in battle.teams.iter() {
    for pokemon in team.pokemon.iter() {
      if pokemon.id == pokemon_id {
        return Some(pokemon)
      }
    }
  }
  None
}

///|
// 查找队伍
pub fn find_team_by_id(battle : Battle, team_id : String) -> Option[Team] {
  for team in battle.teams.iter() {
    if team.id == team_id {
      return Some(team)
    }
  }
  None
}

///|
// 查找技能 - 由于moves现在是Array[String]，这个函数需要重新设计
pub fn find_move_by_id(pokemon : Pokemon, move_id : String) -> Option[String] {
  for move_name in pokemon.moves.iter() {
    if move_name == move_id {
      return Some(move_name)
    }
  }
  None
}

///|
// 减少技能PP - 由于moves现在是Array[String]，这个函数需要重新设计
pub fn decrease_move_pp(battle : Battle, pokemon_id : Int, move_id : String) -> Battle {
  let updated_teams = Array::new()
  
  for team in battle.teams.iter() {
    let updated_pokemon = Array::new()
    
    for pokemon in team.pokemon.iter() {
      if pokemon.id == pokemon_id {
        // 由于moves现在是Array[String]，我们无法直接修改PP
        // 这里暂时跳过PP减少逻辑
        updated_pokemon.push(pokemon)
      } else {
        updated_pokemon.push(pokemon)
      }
    }
    
    let updated_team = Team::{
      id: team.id,
      name: team.name,
      pokemon: updated_pokemon,
      active_pokemon: team.active_pokemon,
      pokemon_left: team.pokemon_left
    }
    updated_teams.push(updated_team)
  }
  
  Battle::{
    id: battle.id,
    format: battle.format,
    game_type: battle.game_type,
    state: battle.state,
    request_state: battle.request_state,
    turn: battle.turn,
    started: battle.started,
    ended: battle.ended,
    result: battle.result,
    teams: updated_teams,
    field: battle.field,
    log: battle.log,
    event_log: battle.event_log,
    prng_seed: battle.prng_seed,
    debug_mode: battle.debug_mode
  }
}

///|
// 获取战斗状态
pub fn get_battle_state(battle : Battle) -> BattleState {
  battle.state
}

///|
// 获取当前回合
pub fn get_current_turn(battle : Battle) -> Int {
  battle.turn
}

///|
// 检查是否在战斗中
pub fn is_in_battle(battle : Battle) -> Bool {
  battle.started && !battle.ended
}

///|
// 获取战斗日志
pub fn get_battle_log(battle : Battle) -> Array[String] {
  battle.log
}

///|
// 获取战斗事件
pub fn get_battle_events(battle : Battle) -> Array[BattleEventCore] {
  battle.event_log
} 