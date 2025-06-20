#!/bin/bash

log_data=~/pi_diagnostics/system_log.txt

echo "Logging system metrics to $log_data..."
echo "Press ctr + C to stop the process"
echo "---------------------------------------" >> "$log_data"
echo "System Monitoring Started: $(date)" >> "$log_data"
echo "---------------------------------------" >> "$log_data"

while true
do
    echo "" >> "$log_data"

    echo "Timestamp: $(date)" >> "$log_data"
    echo "IP Address: $(hostname -I)" >> "$log_data"
    echo "CPU Temp: $(vcgencmd measure_temp)" >> "$log_data"
    echo "CPU Usage: $(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')%" >> "$log_data"
    echo "CPU Frequency: $(vcgencmd measure_clock arm | awk -F"=" '{printf "%.2f MHz\n", $2 / 1000000}')" >> "$log_data"
    echo "Throttle Status: $(vcgencmd get_throttled)" >> "$log_data"
    echo "Load Average: $(uptime | awk -F'load average:' '{ print $2 }')" >> "$log_data"
    echo "GPU Memory: $(vcgencmd get_mem gpu)" >> "$log_data"

    echo "---" >> "$log_data"
    echo "Memory Usage:" >> "$log_data"
    free -h >> "$log_data"

    echo "---" >> "$log_data"
    echo "Disk Usage:" >> "$log_data"
    df -h / >> "$log_data"

    echo "-----------------------------" >> "$log_data"
  sleep 10
done

