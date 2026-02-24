# 测试模块说明

## 目录结构

```
tests/
├── test_helper.gd              # 测试辅助基类（统一断言和结果统计）
├── run_all_tests.gd            # 统一测试运行器（一键运行所有测试）
├── README.md                    # 本说明文件
├── unit/                        # 单元测试目录
│   ├── test_item_data.gd       # ItemData 模块测试
│   ├── test_inventory.gd       # Inventory 模块测试
│   ├── test_player_data.gd     # PlayerData 模块测试
│   ├── test_realm_system.gd    # RealmSystem 模块测试
│   ├── test_cultivation_system.gd  # CultivationSystem 模块测试
│   ├── test_battle_system.gd   # BattleSystem 模块测试
│   ├── test_offline_reward.gd  # OfflineReward 模块测试
│   └── test_save_manager.gd    # SaveManager 模块测试
└── integration/                 # 集成测试目录
    └── test_all_systems.gd     # GameManager 集成环境下的全系统测试
```

## 使用方法

### 运行所有测试

运行 `run_all_tests.gd` 场景，会依次执行：
1. 所有单元测试
2. 所有集成测试
3. 输出最终测试总结

### 运行单元测试

直接运行 `tests/unit/` 目录下的任意测试文件，只测试特定模块。

### 运行集成测试

直接运行 `tests/integration/test_all_systems.gd`，在 GameManager 环境下测试系统集成。

## 测试分类

### 单元测试
- 独立测试每个核心模块
- 不依赖 GameManager
- 快速验证模块功能

### 集成测试
- 在完整游戏环境中测试
- 测试模块间的交互
- 验证完整游戏流程

## 添加新测试

### 添加新的单元测试

1. 在 `tests/unit/` 目录下创建新文件 `test_xxx.gd`
2. 继承自 Node，使用 `test_helper.gd` 进行断言
3. 实现 `func run_tests()` 方法
4. 在 `run_all_tests.gd` 的 `unit_tests` 数组中添加文件名

### 添加新的集成测试

1. 在 `tests/integration/` 目录下创建新文件
2. 或者直接在 `test_all_systems.gd` 中添加新的测试函数
