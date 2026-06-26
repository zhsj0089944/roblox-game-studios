#!/bin/bash
# 验证 GDD 文档完整性
# 用法: ./validate-gdd.sh <path-to-gdd>

GDD_FILE="$1"

if [ -z "$GDD_FILE" ]; then
    echo "用法: $0 <path-to-gdd>"
    exit 1
fi

if [ ! -f "$GDD_FILE" ]; then
    echo "错误: 文件不存在: $GDD_FILE"
    exit 1
fi

echo "验证 GDD: $GDD_FILE"
echo "========================="

# 检查必需部分
SECTIONS=(
    "## 摘要"
    "## 概述"
    "## 玩家幻想"
    "## 详细设计"
    "## 公式"
    "## 边界情况"
    "## 依赖"
    "## 调参旋钮"
    "## 验收标准"
)

MISSING=0
for section in "${SECTIONS[@]}"; do
    if ! grep -q "$section" "$GDD_FILE"; then
        echo "❌ 缺少部分: $section"
        MISSING=$((MISSING + 1))
    else
        echo "✓ 找到: $section"
    fi
done

echo ""
echo "========================="
if [ $MISSING -eq 0 ]; then
    echo "✓ GDD 完整性检查通过"
    exit 0
else
    echo "❌ GDD 缺少 $MISSING 个必需部分"
    exit 1
fi
