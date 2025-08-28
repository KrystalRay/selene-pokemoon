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
// 事件总线 - 实现模块间通信，保持高内聚低耦合
// 基于发布-订阅模式设计

///|
// 事件类型
pub enum EventType {
  UIInteraction
  GameStateChange
  BattleAction
  SystemMessage
  DebugInfo
} derive(Show, Eq)

///|
// 事件数据
pub struct Event {
  event_type: EventType
  event_name: String
  data: String
  timestamp: String
  source: String
} derive(Show)

///|
// 事件处理器
pub struct EventHandler {
  id: String
  event_type: EventType
  handler_name: String
  callback: String
} derive(Show)

///|
// 事件总线管理器
pub struct EventBus {
  handlers: Array[EventHandler]
  event_queue: Array[Event]
  max_queue_size: Int
} derive(Show)

///|
// 创建新的事件总线
pub fn create_event_bus() -> EventBus {
  EventBus::{
    handlers: [],
    event_queue: [],
    max_queue_size: 100
  }
}

///|
// 注册事件处理器
pub fn register_handler(
  bus: EventBus,
  handler: EventHandler
) -> EventBus {
  let new_handlers = bus.handlers + [handler]
  EventBus::{
    handlers: new_handlers,
    event_queue: bus.event_queue,
    max_queue_size: bus.max_queue_size
  }
}

///|
// 发布事件
pub fn publish_event(
  bus: EventBus,
  event: Event
) -> EventBus {
  // 简化的队列管理，总是添加新事件
  let updated_queue = bus.event_queue + [event]
  
  EventBus::{
    handlers: bus.handlers,
    event_queue: updated_queue,
    max_queue_size: bus.max_queue_size
  }
}

///|
// 创建事件
pub fn create_event(
  event_type: EventType,
  event_name: String,
  data: String,
  source: String
) -> Event {
  Event::{
    event_type: event_type,
    event_name: event_name,
    data: data,
    timestamp: "now", // 实际应该使用时间函数
    source: source
  }
}

///|
// 获取事件类型字符串
pub fn event_type_to_string(event_type: EventType) -> String {
  match event_type {
    UIInteraction => "UI交互"
    GameStateChange => "游戏状态变化"
    BattleAction => "战斗动作"
    SystemMessage => "系统消息"
    DebugInfo => "调试信息"
  }
}

///|
// 查找事件处理器
pub fn find_handlers(
  bus: EventBus,
  event_type: EventType
) -> Array[EventHandler] {
  let filtered = bus.handlers.filter(fn(handler: EventHandler) -> Bool {
    handler.event_type == event_type
  })
  filtered
}

///|
// 获取队列中的事件数量
pub fn get_queue_size(bus: EventBus) -> Int {
  bus.event_queue.length()
}

///|
// 清空事件队列
pub fn clear_event_queue(bus: EventBus) -> EventBus {
  EventBus::{
    handlers: bus.handlers,
    event_queue: [],
    max_queue_size: bus.max_queue_size
  }
}

///|
// 测试事件总线功能
pub fn test_event_bus() -> Unit {
  println("🧪 测试事件总线功能...");
  
  // 创建事件总线
  let bus = create_event_bus();
  println("✅ 事件总线创建成功");
  
  // 创建事件处理器
  let handler = EventHandler::{
    id: "test-handler-1",
    event_type: EventType::UIInteraction,
    handler_name: "测试处理器",
    callback: "handle_ui_interaction"
  };
  
  // 注册处理器
  let bus_with_handler = register_handler(bus, handler);
  println("✅ 事件处理器注册成功");
  
  // 创建并发布事件
  let event = create_event(
    EventType::UIInteraction,
    "按钮点击",
    "用户点击了测试按钮",
    "UI系统"
  );
  
  let bus_with_event = publish_event(bus_with_handler, event);
  println("✅ 事件发布成功");
  
  // 查找处理器
  let found_handlers = find_handlers(bus_with_event, EventType::UIInteraction);
  println("✅ 找到 " + found_handlers.length().to_string() + " 个处理器");
  
  // 获取队列信息
  let queue_size = get_queue_size(bus_with_event);
  println("✅ 事件队列大小: " + queue_size.to_string());
  
  // 清空队列
  let cleared_bus = clear_event_queue(bus_with_event);
  let new_queue_size = get_queue_size(cleared_bus);
  println("✅ 队列清空后大小: " + new_queue_size.to_string());
  
  println("🎉 事件总线测试完成！");
} 