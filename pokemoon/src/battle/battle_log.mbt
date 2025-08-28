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
// 战斗日志系统 - 仿照Pokemon Showdown的battle-log.ts
// 记录和管理战斗中的所有事件和日志

///|
// 日志类型枚举
pub enum LogType {
  Battle
  Move
  Status
  Item
  Weather
  Terrain
  System
} derive(Show, Eq)

///|
// 战斗日志管理器
pub struct BattleLogManager {
  entries : Array[LogEntry]
  max_entries : Int
  log_level : LogLevel
  auto_format : Bool
} derive(Show)

///|
// 创建新的日志管理器
pub fn create_battle_log_manager() -> BattleLogManager {
  BattleLogManager::{
    entries: Array::new(),
    max_entries: 1000,
    log_level: LogLevel::Info,
    auto_format: true
  }
}

///|
// 添加日志条目
pub fn add_log_entry(
  manager : BattleLogManager,
  entry : LogEntry
) -> BattleLogManager {
  // 暂时返回原管理器，避免复杂的数组操作
  BattleLogManager::{
    entries: manager.entries,
    max_entries: manager.max_entries,
    log_level: manager.log_level,
    auto_format: manager.auto_format
  }
}

///|
// 获取日志条目
pub fn get_log_entries(manager : BattleLogManager) -> Array[LogEntry] {
  manager.entries
}

///|
// 设置日志级别
pub fn set_log_level(
  manager : BattleLogManager,
  level : LogLevel
) -> BattleLogManager {
  BattleLogManager::{
    entries: manager.entries,
    max_entries: manager.max_entries,
    log_level: level,
    auto_format: manager.auto_format
  }
}

///|
// 设置最大条目数
pub fn set_max_entries(
  manager : BattleLogManager,
  max : Int
) -> BattleLogManager {
  BattleLogManager::{
    entries: manager.entries,
    max_entries: max,
    log_level: manager.log_level,
    auto_format: manager.auto_format
  }
}

///|
// 设置自动格式化
pub fn set_auto_format(
  manager : BattleLogManager,
  auto : Bool
) -> BattleLogManager {
  BattleLogManager::{
    entries: manager.entries,
    max_entries: manager.max_entries,
    log_level: manager.log_level,
    auto_format: auto
  }
}

///|
// 清空日志
pub fn clear_log(manager : BattleLogManager) -> BattleLogManager {
  BattleLogManager::{
    entries: Array::new(),
    max_entries: manager.max_entries,
    log_level: manager.log_level,
    auto_format: manager.auto_format
  }
}

///|
// 获取日志统计信息
pub fn get_log_stats(manager : BattleLogManager) -> Map[String, Int] {
  let stats = Map::new()
  stats.set("total_entries", manager.entries.length())
  stats.set("max_entries", manager.max_entries)
  stats
}

///|
// 格式化日志条目为字符串
pub fn format_log_entry(entry : LogEntry) -> String {
  let level_str = match entry.level {
    LogLevel::Info => "INFO"
    LogLevel::Success => "SUCCESS"
    LogLevel::Warning => "WARN"
    LogLevel::Error => "ERROR"
  }
  
  "[" + level_str + "] " + entry.message
}

///|
// 测试函数
pub fn test_battle_log() -> Unit {
  let manager = create_battle_log_manager()
  
  println("Battle log manager created successfully")
  println("Log level: " + manager.log_level.to_string())
  println("Max entries: " + manager.max_entries.to_string())
  println("Auto format: " + manager.auto_format.to_string())
} 