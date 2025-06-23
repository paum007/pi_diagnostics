#!/bin/bash

log_data=~/pi_diagnostics/system_log.txt

echo "Select output mode: "
echo "[1] Write the data to file only"
echo "[2] Display the data to the terminal only"
echo "[3] Do both of the above options"

read -p "Enter choise [1-3]: " output_mode

log() {
  case $output_mode in
    1) echo "$1" >> "$log_data" ;;
    2) echo "$1" ;;
    3) echo "$1" | tee -a "$log_data" ;;
    *) echo "$1" ;;
  esac
}

echo "Logging system metrics to $log_data..."
echo "Press ctr + C to stop the process"

log "---------------------------------------"
log "System Monitoring Started: $(date)"
log "---------------------------------------"

while true
do
    log ""

    log "Timestamp: $(date)"
    log "IP Address: $(hostname -I)"
    log "CPU Temp: $(vcgencmd measure_temp)"
    log "CPU Usage: $(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')%"
    log "CPU Frequency: $(vcgencmd measure_clock arm | awk -F"=" '{printf "%.2f MHz\n", $2 / 1000000}')"
    log "Throttle Status: $(vcgencmd get_throttled)"
    log "Load Average: $(uptime | awk -F'load average:' '{ print $2 }')"
    log "GPU Memory: $(vcgencmd get_mem gpu)"

    log "---"
    log "Memory Usage:"
    free -h

    log "---"
    log "Disk Usage:"
    df -h /

    log "-----------------------------"
  sleep 10
done

