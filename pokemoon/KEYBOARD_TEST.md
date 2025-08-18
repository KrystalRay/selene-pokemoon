# 键盘输入测试说明

## 问题诊断

**问题**: Z键没有反应，但Enter和Space键正常工作

**原因**: 在 `selene-core/src/system/keycode.mbt` 文件中，`Code::from_string` 函数缺少了 `"KeyZ" => Some(KeyZ)` 的映射。

**修复**: 已添加缺失的 `"KeyZ" => Some(KeyZ)` 映射。

## 测试步骤

### 1. 重新编译
由于修改了核心系统文件，需要重新编译整个项目：

```bash
cd selene-pokemoon
moon build
```

### 2. 测试键盘输入
进入游戏后：

1. **进入战斗**: 按 `A` 键
2. **测试Z键**: 按 `Z` 键应该能确认选择
3. **测试其他键**: 
   - `Enter` 键应该能确认选择
   - `Space` 键应该能确认选择
   - 上下箭头键应该能选择菜单选项

### 3. 预期结果
- Z键现在应该能正常响应
- 所有确认键（Z、Enter、Space）都应该工作
- 上下箭头键应该能正常选择菜单选项

## 技术细节

### 键盘事件流程
1. 浏览器发送 `keydown` 事件，包含 `event.code`（如 "KeyZ"）
2. `selene-canvas` 调用 `@system.Code::from_string("KeyZ")`
3. `from_string` 函数返回 `Some(KeyZ)`
4. 按键被添加到 `pressed_keys` 集合
5. 游戏系统检测到 `@system.is_just_pressed(@system.KeyZ)` 为 `true`

### 修复前的问题
```moonbit
// 修复前：缺少KeyZ映射
pub fn Code::from_string(code : String) -> Code? {
  match code {
    "KeyA" => Some(KeyA)
    // ... 其他键 ...
    "KeyY" => Some(KeyY)
    // KeyZ 缺失！
    "ArrowUp" => Some(ArrowUp)
    // ...
  }
}
```

### 修复后的代码
```moonbit
// 修复后：添加了KeyZ映射
pub fn Code::from_string(code : String) -> Code? {
  match code {
    "KeyA" => Some(KeyA)
    // ... 其他键 ...
    "KeyY" => Some(KeyY)
    "KeyZ" => Some(KeyZ)  // 已添加
    "ArrowUp" => Some(ArrowUp)
    // ...
  }
}
```

## 注意事项

1. **重新编译**: 修改核心系统文件后必须重新编译
2. **浏览器缓存**: 如果问题仍然存在，尝试刷新浏览器页面
3. **控制台检查**: 查看浏览器控制台是否有错误信息
4. **按键映射**: 确保浏览器发送的是标准的 "KeyZ" 代码

## 其他可能的问题

如果Z键仍然不工作，可能的原因：

1. **浏览器兼容性**: 某些浏览器可能使用不同的键码
2. **键盘布局**: 不同键盘布局可能影响键码识别
3. **系统设置**: 操作系统级别的键盘设置可能影响键码
4. **游戏状态**: 确保游戏处于正确的状态（战斗中）

## 调试建议

1. 在浏览器控制台添加日志：
   ```javascript
   // 在keydown事件中添加
   console.log("Key pressed:", event.code);
   ```

2. 检查 `pressed_keys` 集合：
   ```moonbit
   // 在游戏代码中添加调试信息
   println("Pressed keys: " + @system.pressed_keys)
   ``` 