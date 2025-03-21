#!/bin/bash

WEBHOOK_URL="PUT_YOUR_WEBHOOK_HERE"

REQUIRED_COMMANDS=("curl" "jq" "uptime" "free" "top" "df" "awk" "grep" "ping" "uname" "lsb_release" "lscpu" "bc")
for cmd in "${REQUIRED_COMMANDS[@]}"; do
    if ! command -v "$cmd" &>/dev/null; then
        echo "Error: Required command '$cmd' not found. Please install it." >&2
        exit 1
    fi
done

UPTIME=$(uptime -p || echo "N/A")

LOAD=$(cat /proc/loadavg 2>/dev/null | awk '{print $1", "$2", "$3}' || echo "N/A")

RAM_TOTAL=$(free -m | awk '/Mem:/ {print $2}' || echo "0")
RAM_USED=$(free -m | awk '/Mem:/ {print $3}' || echo "0")
RAM_PERCENT=$(awk "BEGIN {if ($RAM_TOTAL > 0) printf \"%.2f\", ($RAM_USED/$RAM_TOTAL)*100; else print \"N/A\"}")

CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}' || echo "N/A")

DISK_USAGE_RAW=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%') # Removing % symbol for comparison
DISK_USAGE="${DISK_USAGE_RAW}%" # Re-adding % for display

NET_INTERFACE=$(ip route | awk '/default/ {print $5; exit}')
if [ -n "$NET_INTERFACE" ]; then
    NET_IN=$(cat /proc/net/dev | awk -v iface="$NET_INTERFACE" '$1 ~ iface {print $2}')
    NET_OUT=$(cat /proc/net/dev | awk -v iface="$NET_INTERFACE" '$1 ~ iface {print $10}')
else
    NET_IN=0
    NET_OUT=0
fi
NET_IN_MB=$(echo "scale=2; $NET_IN / 1024 / 1024" | bc 2>/dev/null || echo "N/A")
NET_OUT_MB=$(echo "scale=2; $NET_OUT / 1024 / 1024" | bc 2>/dev/null || echo "N/A")

DATE=$(date "+%Y-%m-%d %H:%M:%S")
SERVER_TIME=$(date "+%T")

OS_NAME=$(lsb_release -d 2>/dev/null | awk -F"\t" '{print $2}' || echo "Unknown OS")
KERNEL=$(uname -r || echo "N/A")
ARCHITECTURE=$(uname -m || echo "N/A")
HOSTNAME=$(hostname || echo "N/A")

CPU_NAME=$(lscpu | grep "Model name" | awk -F": " '{print $2}' || echo "N/A")
CPU_CORES=$(lscpu | grep "^CPU(s):" | awk -F": " '{print $2}' || echo "N/A")
CPU_THREADS=$(lscpu | grep "Thread(s) per core" | awk -F": " '{print $2}' || echo "N/A")

TOTAL_MEMORY=$(free -h | awk '/Mem:/ {print $2}' || echo "N/A")

PING=$(ping -c 1 8.8.8.8 | grep 'time=' | awk -F'=' '{print $4}' | awk '{print $1}')
if [ -z "$PING" ]; then
    PING="Request timed out"
fi

COLOR=3447003  # Default (Blue)
if (( $(echo "$CPU_USAGE > 80" | bc -l) )) || (( $(echo "$RAM_PERCENT > 80" | bc -l) )) || (( "$DISK_USAGE_RAW" -gt 80 )); then
    COLOR=16711680  # Red (Critical)
elif (( $(echo "$CPU_USAGE > 50" | bc -l) )) || (( $(echo "$RAM_PERCENT > 50" | bc -l) )) || (( "$DISK_USAGE_RAW" -gt 50 )); then
    COLOR=16776960  # Yellow (Warning)
else
    COLOR=65280  # Green (Good)
fi

if [ -z "$WEBHOOK_URL" ]; then
    echo "Error: WEBHOOK_URL is empty. Please set it before running the script." >&2
    exit 1
fi

JSON_PAYLOAD=$(jq -n --arg date "$DATE" \
  --arg server_time "$SERVER_TIME" \
  --arg uptime "$UPTIME" \
  --arg load "$LOAD" \
  --arg ram_used "$RAM_USED" \
  --arg ram_total "$RAM_TOTAL" \
  --arg ram_percent "$RAM_PERCENT" \
  --arg cpu "$CPU_USAGE%" \
  --arg disk "$DISK_USAGE" \
  --arg net_in "$NET_IN_MB MB" \
  --arg net_out "$NET_OUT_MB MB" \
  --arg os_name "$OS_NAME" \
  --arg kernel "$KERNEL" \
  --arg architecture "$ARCHITECTURE" \
  --arg hostname "$HOSTNAME" \
  --arg ping "$PING" \
  --arg cpu_name "$CPU_NAME" \
  --arg cpu_cores "$CPU_CORES" \
  --arg cpu_threads "$CPU_THREADS" \
  --arg total_memory "$TOTAL_MEMORY" \
  --argjson color "$COLOR" \
  '{
    "embeds": [{
      "title": "Server Status",
      "color": $color,
      "fields": [
        {"name": "📅 Date", "value": $date, "inline": true},
        {"name": "🕒 Server Time", "value": $server_time, "inline": true},
        {"name": "⏳ Uptime", "value": $uptime, "inline": true},
        {"name": "🏷️ OS", "value": $os_name, "inline": true},
        {"name": "🔧 Kernel", "value": $kernel, "inline": true},
        {"name": "🖥️ Architecture", "value": $architecture, "inline": true},
        {"name": "⚙️ CPU Usage", "value": $cpu, "inline": true},
        {"name": "🖥️ CPU", "value": $cpu_name, "inline": true},
        {"name": "🔢 CPU Cores", "value": $cpu_cores, "inline": true},
        {"name": "💻 CPU Threads", "value": $cpu_threads, "inline": true},
        {"name": "📊 Load Average", "value": $load, "inline": true},
        {"name": "💾 RAM Usage", "value": ($ram_used + "MB / " + $ram_total + "MB (" + $ram_percent + "%)"), "inline": true},
        {"name": "💾 Total Memory", "value": $total_memory, "inline": true},
        {"name": "🖴 Disk Usage", "value": $disk, "inline": true},
        {"name": "💻 Hostname", "value": $hostname, "inline": true},
        {"name": "📡 Network In", "value": $net_in, "inline": true},
        {"name": "📤 Network Out", "value": $net_out, "inline": true},
        {"name": "🏓 Ping", "value": $ping, "inline": true}
      ]
    }]
  }')

curl -H "Content-Type: application/json" -d "$JSON_PAYLOAD" "$WEBHOOK_URL"

echo "Server status sent successfully."
