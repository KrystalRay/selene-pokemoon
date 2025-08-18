# Battle Menu Configuration

这个文档说明了battle系统中所有menu参数的配置和使用方法。

## 文件结构

- `battle_menu_config.mbt` - MoonBit源代码配置文件
- `battle_menu_config.json` - JSON格式配置文件（便于查看和修改）
- `README_BATTLE_MENU_CONFIG.md` - 本说明文档

## 主要配置项

### 1. 主战斗菜单 (Main Battle Menu)

**位置和尺寸：**
- 位置：`(50, 400)` - 屏幕左侧
- 宽度：`170px` - 屏幕宽度的约1/3
- 高度：`115px` - 屏幕高度的约30%

**样式配置：**
- 背景色：`#1a1a1a` (深灰色)
- 边框色：`#4ECDC4` (青色)
- 文字色：`#FFFFFF` (白色)
- 指示器色：`#4ECDC4` (青色)

**按钮配置：**
- 按钮间距：`25px`
- 按钮高度：`20px`
- 按钮内边距：`10px`

**菜单选项：**
- Fight - 进入战斗模式
- Bag - 打开背包
- Pokemon - 查看宝可梦状态
- Run - 尝试逃跑

### 2. 技能菜单 (Skill Menu)

**位置和尺寸：**
- 位置：`(250, 400)` - 主菜单右侧
- 宽度：`220px` - 屏幕宽度的约35%
- 高度：`200px` - 屏幕高度的约25%

**样式配置：**
- 背景色：`#1a1a1a` (深灰色)
- 边框色：`#4ECDC4` (青色)
- 文字色：`#FFFFFF` (白色)
- 标题色：`#FFFFFF` (白色)

**技能项配置：**
- 技能间距：`30px`
- 技能高度：`25px`
- 技能内边距：`25px`
- 标题高度：`20px`

**可用技能：**
1. **Tackle** - 15 DMG, 0 MP (物理攻击)
2. **Ember** - 25 DMG, 5 MP (火系攻击)
3. **Thunder** - 35 DMG, 10 MP (电系攻击)
4. **Hyper Beam** - 50 DMG, 20 MP (普通系攻击)

### 3. 屏幕配置 (Screen Config)

**尺寸：**
- 宽度：`800px`
- 高度：`600px`
- 标题高度：`32px`
- 提示文字高度：`18px`

### 4. 布局配置 (Layout Config)

**边距和间距：**
- 外边距：`20px`
- 内边距：`15px`

**区域尺寸：**
- 敌人区域：`120x100px`
- 玩家区域：`120x100px`
- 菜单区域：`200x120px`
- 状态区域：`100x80px`

**位置偏移：**
- 标题Y偏移：`20px`
- 敌人区域Y偏移：`50px`
- 玩家区域Y偏移：`50px`
- 菜单区域Y偏移：`170px`
- 状态区域Y偏移：`170px`

## 使用方法

### 在代码中使用配置

```moonbit
// 导入配置文件
import battle_menu_config

// 获取主菜单位置
let main_menu_pos = battle_menu_config.get_main_menu_position()

// 获取技能菜单位置
let skill_menu_pos = battle_menu_config.get_skill_menu_position()

// 动态调整菜单尺寸
battle_menu_config.adjust_menu_sizes()

// 重新定位菜单
battle_menu_config.reposition_menus()

// 验证菜单边界
let is_valid = battle_menu_config.validate_menu_boundaries()
```

### 修改配置参数

1. **修改MoonBit代码：** 直接编辑 `battle_menu_config.mbt` 文件
2. **查看JSON配置：** 使用 `battle_menu_config.json` 文件查看所有参数
3. **重新编译：** 修改后需要重新编译项目

## 动态调整

系统支持根据屏幕尺寸动态调整菜单：

- 主菜单宽度 = 屏幕宽度 × 0.33
- 主菜单高度 = 屏幕高度 × 0.3
- 技能菜单宽度 = 屏幕宽度 × 0.35
- 技能菜单高度 = 屏幕高度 × 0.25

## 颜色主题

**主要颜色：**
- 敌人区域：`#ff6b6b` (红色)
- 玩家区域：`#4ECDC4` (青色)
- 背景：`#000000` (黑色)
- 主要文字：`#FFFFFF` (白色)
- 次要文字：`#CCCCCC` (浅灰色)
- 强调色：`#4ECDC4` (青色)

## 字体配置

- 标题：`bold 32px Arial`
- 副标题：`bold 18px Arial`
- 正文：`16px Arial`
- 菜单：`14px Arial`
- 小字：`12px Arial`

## 层级管理

- 背景：150
- UI元素：200
- 菜单：250
- 指示器：300
- 调试：100

## 注意事项

1. 所有位置坐标都是相对于屏幕左上角的
2. 菜单尺寸会根据屏幕尺寸自动调整
3. 修改配置后需要重新编译项目
4. 确保菜单不会超出屏幕边界
5. 颜色值使用十六进制格式

## 故障排除

如果遇到菜单显示问题：

1. 检查屏幕尺寸配置是否正确
2. 验证菜单位置是否在屏幕边界内
3. 确认所有必需的字段都已设置
4. 查看控制台输出的调试信息 