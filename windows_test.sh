#!/bin/bash

# 运行Godot的启动脚本
# 通过设置HOME目录到当前目录，解决日志文件权限问题
# 自动运行所有模式，有错误时提前退出

# 设置HOME环境变量
export HOME="$(pwd)"
echo "Setting HOME to: $HOME"

# 创建必要的目录
mkdir -p user_data/logs

echo "=================================="
echo "Godot 自动测试脚本"
echo "=================================="
echo "开始运行所有测试模式..."
echo "=================================="

# 函数：运行命令并检查错误
run_command() {
    local description=$1
    local command=$2
    
    echo "\n${description}..."
    echo "命令: ${command}"
    
    # 运行命令并捕获退出码
    eval "${command}"
    local exit_code=$?
    
    if [ $exit_code -ne 0 ]; then
        echo "\n错误: ${description} 失败，退出码: ${exit_code}"
        echo "=================================="
        echo "测试失败，提前退出！"
        echo "=================================="
        exit $exit_code
    else
        echo "\n成功: ${description} 完成"
    fi
}

# 1. 运行 Check-only 模式（检查项目是否有错误）
run_command "Check-only 模式" "../../Godot_v4.6-stable_linux.x86_64 --path \"$(pwd)\" --headless --check-only --quit-after 100"

# 2. 运行所有测试
run_command "运行所有测试" "../../Godot_v4.6-stable_linux.x86_64 --path \"$(pwd)\" --headless --scene \"res://tests/TestRunner.tscn\""

# 3. 运行 Headless 模式（确保能正常运行）
run_command "Headless 模式" "../../Godot_v4.6-stable_linux.x86_64 --path \"$(pwd)\" --headless --quit-after 100"

echo "\n=================================="
echo "所有测试模式运行完成！"
echo "=================================="