#!/bin/bash

# iOS 导出脚本

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
IOS_BUILD_DIR="$PROJECT_DIR/build/ios"
GODOT_PATH="/Applications/Godot.app/Contents/MacOS/Godot"

# 颜色定义
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}       iOS 导出工具${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# 创建导出目录
mkdir -p "$IOS_BUILD_DIR"

# 检查 Godot 是否存在
if [ ! -f "$GODOT_PATH" ]; then
    echo -e "${RED}错误：未找到 Godot，请确认已安装到 /Applications/Godot.app${NC}"
    exit 1
fi

echo -e "${GREEN}项目目录:${NC} $PROJECT_DIR"
echo -e "${GREEN}导出目录:${NC} $IOS_BUILD_DIR"
echo ""

# 导出 Xcode 项目
EXPORT_NAME="修仙模拟器"
EXPORT_PATH="$IOS_BUILD_DIR/$EXPORT_NAME"

echo -e "${YELLOW}正在导出 Xcode 项目...${NC}"
echo ""

"$GODOT_PATH" --headless --export-debug "iOS" "$EXPORT_PATH" --path "$PROJECT_DIR" 2>&1

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${BLUE}========================================${NC}"
    echo -e "${GREEN}导出成功！${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo ""
    echo -e "${GREEN}Xcode 项目路径:${NC}"
    echo -e "${YELLOW}$EXPORT_PATH.xcodeproj${NC}"
    echo ""
    echo "下一步操作:"
    echo "1. 打开 Xcode 项目:"
    echo -e "   ${YELLOW}open $EXPORT_PATH.xcodeproj${NC}"
    echo ""
    echo "2. 在 Xcode 中:"
    echo "   - 选择你的 Team（需要登录 Apple ID）"
    echo "   - 选择目标设备（iPhone/iPad）"
    echo "   - 点击运行按钮（▶️）进行安装"
    echo ""
    echo -e "${YELLOW}提示：如果是第一次使用，需要在 Xcode 中登录 Apple ID${NC}"
    echo -e "${YELLOW}      偏好设置 → Accounts → 添加 Apple ID${NC}"
    echo ""
else
    echo ""
    echo -e "${RED}导出失败，请检查错误信息${NC}"
    exit 1
fi
