#!/bin/bash

# ==========================================
# DevOps System Monitor - Phase 2
# Logging & Threshold Alerts
# ==========================================

LOG_DIR="logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/system.log"

# Threshold percentage
THRESHOLD=80
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Get percentage values
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
RAM_USAGE=$(free | awk '/Mem:/ {printf("%.0f"), $3/$2 * 100}')

log_event() {
    echo "$1"
    echo "[$TIMESTAMP] $1" >> "$LOG_FILE"
}

echo "=========================================="
echo "      DevOps System Monitor Status        "
echo "=========================================="
echo "Timestamp : $TIMESTAMP"
echo "Hostname  : $(hostname)"
echo "------------------------------------------"
echo "RAM Usage  : ${RAM_USAGE}%"
echo "Disk Usage : ${DISK_USAGE}%"
echo "------------------------------------------"

# RAM Check
if [ "$RAM_USAGE" -ge "$THRESHOLD" ]; then
    log_event "[ALERT] High RAM Usage: ${RAM_USAGE}% (Exceeds ${THRESHOLD}%)"
else
    log_event "[INFO] RAM Usage is normal: ${RAM_USAGE}%"
fi

# Disk Check
if [ "$DISK_USAGE" -ge "$THRESHOLD" ]; then
    log_event "[ALERT] High Disk Usage: ${DISK_USAGE}% (Exceeds ${THRESHOLD}%)"
else
    log_event "[INFO] Disk Usage is normal: ${DISK_USAGE}%"
fi

echo "=========================================="
echo "Log written to: $LOG_FILE"
