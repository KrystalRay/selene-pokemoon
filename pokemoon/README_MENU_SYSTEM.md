# 统一菜单系统架构

## 概述

本项目实现了一个统一的菜单管理系统，通过建立基础的 `Menu` 结构体，然后派生出 `MainBattleMenu` 和 `SkillMenu` 来实现菜单的统一管理和定义。

## 架构设计

### 1. 基础菜单结构体 (Menu)

```moonbit
struct Menu {
  mut visible : Bool                    // 菜单可见性
  mut selected_index : Int             // 当前选中项索引
  mut entities : Array[@system.Entity] // 菜单实体列表
  mut background_entity : Option[@system.Entity] // 背景实体
  mut title_entity : Option[@system.Entity]      // 标题实体
  mut indicator_entity : Option[@system.Entity]  // 选择指示器实体
}
```

### 2. 主战斗菜单 (MainBattleMenu)

继承自基础菜单，添加了主战斗菜单特有的功能：

```moonbit
struct MainBattleMenu {
  // 继承基础菜单字段
  mut visible : Bool
  mut selected_index : Int
  mut entities : Array[@system.Entity]
  mut background_entity : Option[@system.Entity]
  mut title_entity : Option[@system.Entity]
  mut indicator_entity : Option[@system.Entity]
  
  // 主战斗菜单特有字段
  mut selected_option : MenuOption      // 当前选中的菜单选项
  mut hovered_option : Option[MenuOption] // 鼠标悬停的选项
  button_entities : Map[MenuOption, @system.Entity] // 按钮实体映射
  button_text_entities : Map[MenuOption, @system.Entity] // 按钮文本实体映射
}
```

### 3. 技能菜单 (SkillMenu)

继承自基础菜单，添加了技能菜单特有的功能：

```moonbit
struct SkillMenu {
  // 继承基础菜单字段
  mut visible : Bool
  mut selected_index : Int
  mut entities : Array[@system.Entity]
  mut background_entity : Option[@system.Entity]
  mut title_entity : Option[@system.Entity]
  mut indicator_entity : Option[@system.Entity]
  
  // 技能菜单特有字段
  mut skills : Array[Skill]            // 技能列表
  mut skill_entities : Array[@system.Entity] // 技能实体列表
  mut back_button_entity : Option[@system.Entity] // 返回按钮实体
}
```

## 系统优势

### 1. 代码复用
- 所有菜单共享相同的基础字段和功能
- 减少重复代码，提高维护性

### 2. 统一管理
- 通过 `BattleSystem` 统一管理所有菜单
- 菜单状态集中管理，便于调试和维护

### 3. 类型安全
- 强类型系统确保菜单操作的安全性
- 编译时检查减少运行时错误

### 4. 扩展性
- 可以轻松添加新的菜单类型
- 新菜单自动继承基础功能

## 使用示例

### 显示/隐藏菜单
```moonbit
// 显示主战斗菜单
show_main_battle_menu()

// 隐藏技能菜单
hide_skill_menu()
```

### 菜单状态检查
```moonbit
// 检查技能菜单是否可见
if battle_system.skill_menu.visible {
  // 处理技能菜单逻辑
}
```

### 菜单实体管理
```moonbit
// 清理菜单实体
cleanup_battle_entities() // 自动清理所有菜单实体
```

## 未来扩展

### 1. 添加新菜单类型
可以轻松添加新的菜单类型，如：
- `InventoryMenu` (背包菜单)
- `PokemonMenu` (宝可梦菜单)
- `SettingsMenu` (设置菜单)

### 2. 菜单动画系统
基于统一的实体管理，可以实现：
- 菜单切换动画
- 选择项高亮动画
- 菜单弹出/收起动画

### 3. 菜单配置系统
可以添加配置文件支持：
- 菜单布局配置
- 菜单样式配置
- 菜单快捷键配置

## 总结

这个统一菜单系统通过面向对象的设计原则，实现了代码的复用、维护性和扩展性。通过建立清晰的继承关系，使得菜单管理变得更加规范和高效。 