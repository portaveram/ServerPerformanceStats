#!/bin/bash

# ============================================
#   Server Performance Stats - Beginner Level
#   Author: Portaveram
#   Description: Analyzes basic server performance stats
# ============================================

# ---- Color Codes ----
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
BOLD='\033[1m'
RESET='\033[0m'

# ---- Header ----
echo -e "${RED}============================================${RESET}"
echo -e "${BOLD}${MAGENTA}           SERVER PERFORMANCE STATS${RESET}"
echo -e "${CYAN}============================================${RESET}"
echo -e "${YELLOW}Date & Time:${RESET} $(date)"
echo -e "${GREEN}Hostname:${RESET} $(hostname)"
echo -e "${RED}============================================${RESET}"
echo

# ---- CPU Usage ----
echo -e "${BOLD}${BLUE}CPU Usage:${RESET}"
top -bn1 | grep "Cpu(s)" | awk -v Y="$YELLOW" -v R="$RESET" '{print Y "User: " $2"% | System: " $4"% | Idle: " $8"%" R}'
echo

# ---- Memory Usage ----
echo -e "${BOLD}${RED}Memory Usage:${RESET}"
free -h | awk -v Y="$YELLOW" -v R="$RESET" '/Mem:/ {
    total=$2; used=$3; free=$4;
    used_perc=(used/total)*100;
    printf(Y "Total: %s | Used: %s | Free: %s | Used: %.2f%%%s\n", total, used, free, used_perc, R)
}'
echo

# ---- Disk Usage ----
echo -e "${BOLD}${BLUE}Disk Usage:${RESET}"
df -h --total | grep total | awk -v Y="$YELLOW" -v R="$RESET" '{print Y "Total: " $2 " | Used: " $3 " | Free: " $4 " | Used: " $5 R}'
echo

# ---- Top 5 Processes by CPU ----
echo -e "${BOLD}${WHITE}Top 5 Processes by CPU Usage:${RESET}"
ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6 | awk -v Y="$YELLOW" -v R="$RESET" 'NR==1{print Y $0 R; next}{print $0}'
echo

# ---- Top 5 Processes by Memory ----
echo -e "${BOLD}${GREEN}Top 5 Processes by Memory Usage:${RESET}"
ps -eo pid,comm,%mem --sort=-%mem | head -n 6 | awk -v Y="$YELLOW" -v R="$RESET" 'NR==1{print Y $0 R; next}{print $0}'
echo

# ---- Additional Info ----
echo -e "${BLUE}============================================${RESET}"
echo -e "${BOLD}${MAGENTA}           ADDITIONAL SERVER INFO${RESET}"
echo -e "${BLUE}============================================${RESET}"

echo -e "${BOLD}${GREEN}OS Version:${RESET}"
cat /etc/os-release | grep PRETTY_NAME | cut -d= -f2 | tr -d '"'
echo

echo -e "${BOLD}${BLUE}Uptime:${RESET}"
uptime -p
echo

echo -e "${BOLD}${RED}Load Average:${RESET}"
uptime | awk -F'load average:' '{ print $2 }'
echo

echo -e "${BOLD}${WHITE}Logged in Users:${RESET}"
who | awk '{print $1}' | sort | uniq
echo

if [ "$(id -u)" -eq 0 ]; then
  echo -e "${BOLD}${BLUE}Failed Login Attempts:${RESET}"
  lastb | head -n 10
else
  echo -e "${YELLOW}Failed Login Attempts: (Run as root to view)${RESET}"
fi

echo
echo -e "${RED}============================================${RESET}"
echo -e "${BOLD}${GREEN}Stats collection complete.${RESET}"
echo -e "${RED}============================================${RESET}"

