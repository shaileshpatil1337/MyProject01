#!/bin/bash

# Get system information
system_load=$(uptime | awk -F "load average:" '{print $2}' | cut -d, -f1 | xargs)
process_count=$(ps -e | wc -l | xargs)
disk_usage=$(df -h / | awk 'NR==2 {print $5}' | cut -d'%' -f1)
users_logged_in=$(who | wc -l | xargs)
memory_usage=$(free -m | awk 'NR==2 {print $3/$2 * 100}' | xargs printf "%.1f")
swap_usage=$(free -m | awk 'NR==4 {print $3/$2 * 100}' | xargs printf "%.1f")
ipv4_enp0s3=$(ip addr show enp0s3 | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | xargs)
ipv4_enp0s8=$(ip addr show enp0s8 | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | xargs)

# Get current date and time
current_datetime=$(date +"%Y%m%d_%H%M%S")

# Formatted output
output="System information as of $current_datetime\n\n"
output+="  System load:  $system_load               Processes:               $process_count\n"
output+="  Usage of /:   $disk_usage% of $(df -h / | awk 'NR==2 {print $2}')   Users logged in:         $users_logged_in\n"
output+="  Memory usage: $memory_usage%                 IPv4 address for enp0s3: $ipv4_enp0s3\n"
output+="  Swap usage:   $swap_usage%                 IPv4 address for enp0s8: $ipv4_enp0s8\n"

# Print formatted output
echo -e "$output"

# Save to a file with date and time
output_file="system_info_$current_datetime.txt"
echo -e "$output" > "$output_file"
echo "System information has been saved to $output_file"

