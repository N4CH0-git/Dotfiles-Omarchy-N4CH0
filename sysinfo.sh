#!/bin/bash

# 1. Uso de CPU (Limpio, sin decimales)
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'.' -f1)

# 2. Temperatura CPU (Limpia, sin el signo +)
CPU_TEMP=$(sensors | grep -E 'Tctl|Package id 0' | awk '{print $2}' | head -n 1 | tr -d '+')

# 3. RAM (Usada / Total)
MEM_USAGE=$(free -h | awk '/^Mem:/ {print $3 "/" $2}')

# 4. Gráfica Integrada Ryzen (Temperatura)
GPU_TEMP=$(sensors | grep -E 'edge|junction' | awk '{print $2}' | head -n 1 | tr -d '+')
[ -z "$GPU_TEMP" ] && GPU_TEMP="N/A"

# 5. Red (Velocidad en KB/s)
INTERFACE=$(ip route get 8.8.8.8 2>/dev/null | awk '{print $5; exit}')
if [ -z "$INTERFACE" ]; then
    NET_SPEED="0"
else
    R1=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes)
    sleep 0.5
    R2=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes)
    NET_SPEED=$(( ($R2 - $R1) / 512 ))
fi

# CONSTRUCCIÓN DEL JSON
# Usamos guiones en lugar de emoticonos y \\n para el salto de línea
TEXT=""
TOOLTIP="- Ryzen 7 250: $CPU_USAGE% ($CPU_TEMP)\\n- RAM: $MEM_USAGE\\n- Radeon 780M: $GPU_TEMP"

echo "{\"text\":\"$TEXT\", \"tooltip\":\"$TOOLTIP\"}"
