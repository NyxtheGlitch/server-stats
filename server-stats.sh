#!/bin/bash
# server-stats.sh - show basic performance stats

echo "====== Server Performance ===="

cpu_usage () {
	echo "---CPU Usage---"
	echo ""
	vmstat 1 2 | tail -1 | awk '{print 100 - $15 "%"}'
	echo ""
}

memory_usage () { 
	echo "---Total memory usage---"
	echo ""
	free -m | awk '/^Mem:/ {
		 printf "Used: %d MB / %d MB (%.1f%%)\n", $3, $2, $3/$2*100
		 printf "Free: %d MB / %d MB (%.1f%%)\n", $4, $2, $4/$2*100
	}'
	echo ""
}

disk_usage () {
	echo "---Total disk usage---"
	echo ""
	df -BG / | awk 'NR==2 {
	  printf "Used: %d G / %d G (%.1f%%)\n", $3, $2, $3/$2*100
	  printf "Free: %d G / %d G (%.1f%%)\n", $4, $2, $4/$2*100
	}'
	echo ""
}

cpu_processes () {
	echo "---Top 5 processes by CPU usage---"
	echo ""
	ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6
	echo ""
}



memory_processes () {
	echo "---Top 5 processes by memory usage---"
	echo "" 
	ps -eo pid,comm,%mem --sort=-%mem | head -n 6
	echo ""
}

os_info () {
        echo "---System Info---"
        echo ""
	# OS version line here
        echo "os-release: $(grep PRETTY_NAME  /etc/os-release| cut -d '"' -f 2)"
        # uptime line here
	echo "Uptime: $(uptime -p)"
        # load average line here
	awk '{printf "Load average: %0.2f, %0.2f, %0.2f \n", $1, $2, $3}' /proc/loadavg 
        # logged-in users line here
	echo "logged-in: $(who | wc -l)"
        echo ""
	# failed login attempts here
	if [ -f /var/log/auth.log ]; then
		echo "Failed logins: $(grep -c "Failed password" /var/log/auth.log)"
	else
		echo "Failed logins: log not available"
	fi
}

os_info
cpu_usage
memory_usage
disk_usage
cpu_processes
memory_processes
