#!/bin/bash

log_data=~/pi_diagnostics/system_log.txt # Telling where to write the data to

while true; do

  # This is to select the output mode
  echo "Select output mode: " 
  echo "[1] Write the data to file only"
  echo "[2] Display the data to the terminal only"
  echo "[3] Do both of the above options"

  read -p "Enter choice [1-3]: " output_mode

  # Checking if the input from the user is valid
  if [[ "$output_mode" == "1" || "$output_mode" == "2" || "$output_mode" == "3" ]]; then 
    break # Valid input

  else
    echo "Invalid input. Please enter 1, 2 or 3."

  fi

done

# Based on teh answer, the commands will be executed as follows in teh switch case
log() {
  case $output_mode in
    1) echo "$1" >> "$log_data" ;; # Write the data to the file
    2) echo "$1" ;; # Display the data in the terminal
    3) echo "$1" | tee -a "$log_data" ;; # Do both
    *) echo "$1" ;; # Default, if nothing is inputted
  esac
}

echo "Press ctr + C to stop the process"

log "---------------------------------------"
log "System Monitoring Started: $(date)"
log "---------------------------------------"

while true
do
    log ""

    log "Timestamp: $(date)" # Date
    log "IP Address: $(hostname -I)" # IP address

    temp = $(vcgencmd measure_temp) # Variable that stores temperature
    log "CPU Temp: ${temp}ºC" # Showing stored temperature

    # An if statment that displays a warning if the temperature goes above 70ºC
    if (( $(echo "$temp > 70.0" | bc -1))); then 
      log "[WARNING] CPU temperature is too high!"
    fi

    cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}') # Variable that storees the CPU usage
    log "CPU Usage: ${cpu_usage}%" # Showing stored CPU usage

    # An if statment that displays a warning if the CPU usage is above 80%
    if (( $(echo "$cpu_usage > 80.0" | bc -1) )); then
      log "[WARNING] CPU usage is above 80%!"
    fi

    log "CPU Frequency: $(vcgencmd measure_clock arm | awk -F"=" '{printf "%.2f MHz\n", $2 / 1000000}')" # CPU frequency

    throttle_status=$(vcgencmd get_throttled) # Variable that stores the throttle status
    log "Throttle Status: $throttle_status" # Showing stored throttling status

    # An if statment that displays a warning if there is any throttling
    if [[ "$throttle_status" != "throttled=0x0" ]]; then
        log "[WARNING] Throttling detected (under-voltage or overheating)!"
    fi

    log "Load Average: $(uptime | awk -F'load average:' '{ print $2 }')" # Load average
    log "GPU Memory: $(vcgencmd get_mem gpu)" # GPU memory

    log "---"
    log "Memory Usage:"
    free -h

    log "---"

    disk_usage=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%') # Variable that stores the disk usage 
    log "Disk Usage: ${disk_usage}%" # Showing stored disk usage

    # An if statment that displays a warning if the disk usage is above 90%
    if [ "$disk_usage" -gt 90 ]; then
        log "[WARNING] Disk usage above 90%!"
    fi

    log "-----------------------------"
  sleep 10 # Telling it to do all of the code in the while loop every ten seconds
done

