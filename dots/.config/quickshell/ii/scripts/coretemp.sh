#!/bin/bash
TARGET_DIR="$HOME/.config/quickshell/ii"

# 确保目标目录存在
# mkdir -p "$TARGET_DIR"

# 方法1：尝试查找 coretemp/k10temp
for d in /sys/class/hwmon/hwmon*; do
    name=$(cat "$d/name" 2>/dev/null)
    echo "检查: $d -> $name"  # 调试信息
    
    if [ "$name" = "coretemp" ] || [ "$name" = "k10temp" ]; then
        if [ -f "$d/temp1_input" ]; then
            ln -sf "$d/temp1_input" "$TARGET_DIR/coretemp"
            echo "找到 $name，创建链接到 $d/temp1_input"
            exit 0
        fi
    fi
done

# 方法2：如果没找到，尝试 thermal zone
if [ ! -L "$TARGET_DIR/coretemp" ]; then
    # 查找 CPU 封装温度
    for zone in /sys/class/thermal/thermal_zone*; do
        type=$(cat "$zone/type" 2>/dev/null)
        if [ "$type" = "x86_pkg_temp" ] || [ "$type" = "TCPU" ]; then
            ln -sf "$zone/temp" "$TARGET_DIR/coretemp"
            echo "找到 thermal zone $type，创建链接"
            exit 0
        fi
    done
fi

# 方法3：尝试 coretemp 平台设备
if [ -d "/sys/devices/platform/coretemp.0" ]; then
    for hwmon in /sys/devices/platform/coretemp.0/hwmon/hwmon*; do
        if [ -f "$hwmon/temp1_input" ]; then
            ln -sf "$hwmon/temp1_input" "$TARGET_DIR/coretemp"
            echo "找到 coretemp 平台设备，创建链接"
            exit 0
        fi
    done
fi

echo "未找到 CPU 温度传感器"
exit 1