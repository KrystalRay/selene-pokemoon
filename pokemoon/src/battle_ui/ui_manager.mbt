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
// 简化的 UI 管理器
struct BattleUIManager {
  mut is_visible: Bool
  mut current_menu: String
  mut menu_stack: Array[String]
}

///|
// 全局 UI 管理器实例
let ui_manager: BattleUIManager = {
  is_visible: false,
  current_menu: "",
  menu_stack: Array::new(),
}

///|
// 显示菜单
fn show_menu(menu_name: String) -> Unit {
  ui_manager.is_visible = true
  ui_manager.current_menu = menu_name
  ui_manager.menu_stack.push(menu_name)
  println("🎮 显示菜单: " + menu_name)
}

///|
// 隐藏菜单
fn hide_menu() -> Unit {
  ui_manager.is_visible = false
  ui_manager.current_menu = ""
  println("🎮 隐藏菜单")
}

///|
// 返回上级菜单
fn go_back_menu() -> Unit {
  if ui_manager.menu_stack.length() > 1 {
    let _ = ui_manager.menu_stack.pop()
    let previous_menu = ui_manager.menu_stack.last()
    match previous_menu {
      Some(menu) => {
        ui_manager.current_menu = menu
        println("🎮 返回菜单: " + menu)
      }
      None => {}
    }
  }
}

///|
// 检查 UI 是否可见
fn is_ui_visible() -> Bool {
  ui_manager.is_visible
}

///|
// 获取当前菜单
fn get_current_menu() -> String {
  ui_manager.current_menu
}

///|
// 清理所有菜单
fn cleanup_ui() -> Unit {
  ui_manager.is_visible = false
  ui_manager.current_menu = ""
  ui_manager.menu_stack.clear()
  println("🎮 清理所有菜单")
} 