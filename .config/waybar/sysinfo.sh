#!/bin/bash

# 1. Uso de CPU 
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'.' -f1)

# 2. Temperatura CPU 
CPU_TEMP=$(sensors | grep -E 'Tctl|Package id 0' | awk '{print $2}' | head -n 1 | tr -d '+')

# 3. RAM (Usada / Total)
MEM_USAGE=$(free -h | awk '/^Mem:/ {print $3 "/" $2}')

# 4. Gráfica Integrada Ryzen (Temperatura)
GPU_TEMP=$(sensors | grep -E 'edge|junction' | awk '{print $2}' | head -n 1 | tr -d '+')
[ -z "$GPU_TEMP" ] && GPU_TEMP="N/A"


# CONSTRUCCIÓN DEL JSON
TEXT=""
TOOLTIP="- CPU: $CPU_USAGE% ($CPU_TEMP)\\n- RAM: $MEM_USAGE\\n- GPU: $GPU_TEMP"

echo "{\"text\":\"$TEXT\", \"tooltip\":\"$TOOLTIP\"}"
