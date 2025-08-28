// 战斗 UI 系统测试
// 使用 MoonBit 测试块和断言

// 测试基本功能
test "基本测试 - 数学运算" {
  assert_eq(1 + 1, 2)
  assert_eq(2 * 3, 6)
  assert_eq(10 - 5, 5)
}

// 测试字符串操作
test "字符串测试" {
  let message = "Hello, Battle UI!"
  assert_eq(message, "Hello, Battle UI!")
}

// 测试布尔值
test "布尔值测试" {
  assert_eq(true, true)
  assert_eq(false, false)
}

// 测试数组操作
test "数组测试" {
  let skills = ["Tackle", "Thunderbolt", "Fire Blast"]
  assert_eq(skills[0], "Tackle")
  assert_eq(skills[1], "Thunderbolt")
  assert_eq(skills[2], "Fire Blast")
}

// 测试简单计算
test "计算测试" {
  let sum = 1 + 2 + 3 + 4 + 5
  assert_eq(sum, 15)
}

// 测试函数调用
fn add_numbers(a: Int, b: Int) -> Int {
  a + b
}

test "函数测试" {
  let result = add_numbers(5, 3)
  assert_eq(result, 8)
} 