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

echo "Press ctr + C to stop the process"

log "---------------------------------------"
log "System Monitoring Started: $(date)"
log "---------------------------------------"

while true
do
    log ""

    log "Timestamp: $(date)"
    log "IP Address: $(hostname -I)"

    temp = $(vcgencmd measure_temp)
    log "CPU Temp: ${temp}ºC"

    if (( $(echo "$temp > 70.0" | bc -1))); then 
      log "[WARNING] CPU temperature is too high!"
    fi

    cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
    log "CPU Usage: ${cpu_usage}%"

    if (( $(echo "$cpu_usage > 80.0" | bc -1) )); then
      log "[WARNING] CPU usage is above 80%!"
    fi

    log "CPU Frequency: $(vcgencmd measure_clock arm | awk -F"=" '{printf "%.2f MHz\n", $2 / 1000000}')"

    throttle_status=$(vcgencmd get_throttled)
    log "Throttle Status: $throttle_status"
    
    if [[ "$throttle_status" != "throttled=0x0" ]]; then
        log "[WARNING] Throttling detected (under-voltage or overheating)!"
    fi

    log "Load Average: $(uptime | awk -F'load average:' '{ print $2 }')"
    log "GPU Memory: $(vcgencmd get_mem gpu)"

    log "---"
    log "Memory Usage:"
    free -h

    log "---"

    disk_usage=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')
    log "Disk Usage: ${disk_usage}%"

    if [ "$disk_usage" -gt 90 ]; then
        log "[WARNING] Disk usage above 90%!"
    fi

    log "-----------------------------"
  sleep 10
done

