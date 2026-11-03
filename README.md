# Server Performance Stats

A Bash script that analyses basic performance stats on any Linux server.

Project from roadmap.sh: https://roadmap.sh/projects/server-stats

## Stats shown

**Required**
- Total CPU usage
- Total memory usage (Free vs Used, with percentages)
- Total disk usage (Free vs Used, with percentages)
- Top 5 processes by CPU usage
- Top 5 processes by memory usage

**Extra**
- OS version
- Uptime
- Load average (1, 5 and 15 minutes)
- Number of logged-in users
- Failed login attempts

## How to run

1. Clone the repository:
   ```bash
   git clone https://github.com/NyxtheGlitch/server-stats.git
   cd server-stats
   ```

2. Make the script executable:
   ```bash
   chmod +x server-stats.sh
   ```

3. Run it:
   ```bash
   sudo ./server-stats.sh
   ```

   `sudo` is needed to read `/var/log/auth.log` for failed login attempts.
   Without `sudo`, every other stat still works.

## Sample output

```
====== Server Performance ====
---System Info---

os-release: Ubuntu 26.04.1 LTS
Uptime: up 13 hours, 25 minutes
Load average: 0.00, 0.00, 0.00
logged-in: 1
Failed logins: 0

---CPU Usage---

0%

---Total memory usage---

Used: 560 MB / 7407 MB (7.6%)
Free: 6660 MB / 7407 MB (89.9%)

---Total disk usage---

Used: 4 G / 1007 G (0.4%)
Free: 953 G / 1007 G (94.6%)

---Top 5 processes by CPU usage---

    PID COMMAND         %CPU
   2980 nano             0.0
      1 systemd          0.0
     91 systemd-udevd    0.0
   1824 polkitd          0.0
    325 Relay(329)       0.0

---Top 5 processes by memory usage---

    PID COMMAND         %MEM
    263 unattended-upgr  0.4
    158 networkd-dispat  0.3
     51 systemd-journal  0.3
      1 systemd          0.2
     86 systemd-resolve  0.1
```

## How it works

| Stat | Command used |
|---|---|
| CPU usage | `vmstat` (100 minus the idle %) |
| Memory | `free -m` |
| Disk | `df -BG /` |
| Top processes | `ps -eo ... --sort` |
| OS version | `/etc/os-release` |
| Uptime | `uptime -p` |
| Load average | `/proc/loadavg` |
| Logged-in users | `who` |
| Failed logins | `grep` on `/var/log/auth.log` |

## Notes

- Used % + Free % for disk may not add up to 100%. Linux reserves about 5% of
  the disk for the root user, and `df` doesn't count that space as used or free.
- The script was written and tested on Ubuntu running in WSL.
