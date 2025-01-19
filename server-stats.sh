#!/bin/bash

# Function to print a decorative header
print_header() {
  echo "========================================"
  echo "          $1"
  echo "========================================"
}

# Function to print a decorative sub-header
print_subheader() {
  echo "----------------------------------------"
  echo "          $1"
  echo "----------------------------------------"
}

# Function to print a graphical separator
print_separator() {
  echo "****************************************"
}

# Prompt the user for their preferences
echo "Which stats would you like to see? (Enter the numbers separated by spaces)"
echo "1. Total CPU usage"
echo "2. Total memory usage (Free vs Used including percentage)"
echo "3. Total disk usage (Free vs Used including percentage)"
echo "4. Top 5 processes by CPU usage"
echo "5. Top 5 processes by memory usage"
echo "6. OS version"
echo "7. Uptime"
echo "8. Load average"
echo "9. Logged in users"
echo "10. Failed login attempts"
read -p "Enter your choices: " choices

# Function to check if a choice is selected
is_selected() {
  for choice in $choices; do
    if [ "$choice" == "$1" ]; then
      return 0
    fi
  done
  return 1
}

# Total CPU usage
if is_selected 1; then
  print_header "Total CPU Usage"
  top -bn1 | grep "Cpu(s)" | \
  sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | \
  awk '{print "CPU Usage: " 100 - $1"%"}'
  print_separator
fi

# Total memory usage
if is_selected 2; then
  print_header "Total Memory Usage (Free vs Used including percentage)"
  free -m | awk 'NR==2{printf "Used: %sMB (%.2f%%), Free: %sMB (%.2f%%)\n", $3, $3*100/$2, $4, $4*100/$2 }'
  print_separator
fi

# Total disk usage
if is_selected 3; then
  print_header "Total Disk Usage (Free vs Used including percentage)"
  df -h | awk '$NF=="/"{printf "Used: %dGB (%s), Free: %dGB (%s)\n", $3, $5, $4, $5}'
  print_separator
fi

# Top 5 processes by CPU usage
if is_selected 4; then
  print_header "Top 5 Processes by CPU Usage"
  ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 6 | while read line; do
    print_subheader "$line"
  done
  print_separator
fi

# Top 5 processes by memory usage
if is_selected 5; then
  print_header "Top 5 Processes by Memory Usage"
  ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 6 | while read line; do
    print_subheader "$line"
  done
  print_separator
fi

# OS version
if is_selected 6; then
  print_header "OS Version"
  lsb_release -a
  print_separator
fi

# Uptime
if is_selected 7; then
  print_header "Uptime"
  uptime -p
  print_separator
fi

# Load average
if is_selected 8; then
  print_header "Load Average"
  uptime | awk -F'load average:' '{ print $2 }'
  print_separator
fi

# Logged in users
if is_selected 9; then
  print_header "Logged In Users"
  who
  print_separator
fi

# Failed login attempts
if is_selected 10; then
  print_header "Failed Login Attempts"
  grep "Failed password" /var/log/auth.log | wc -l
  print_separator
fi
