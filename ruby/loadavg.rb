#!/usr/local/bin/ruby
# uptime.rb taken from http://raspen.org/dynamic-shell-prompt/

# $ cat /proc/loadavg
# 0.97 0.55 0.37 1/335 21306
# The first three columns measure CPU and IO utilization of the last one, five, and 15 minute periods. 
# The fourth column shows the number of currently running processes and the total number of processes. 
# The last column displays the last process ID used. 

load_avg = IO.read("/proc/loadavg", 4).to_f

if load_avg <= 0.05
  printf "%0.2f%s", load_avg, ""
elsif load_avg <= 0.25
  printf "\\[\033[32m\\]%0.2f%s\\[\033[00m\\]", load_avg, ""
elsif load_avg <= 0.50
  printf "\\[\033[33m\\]%0.2f%s\\[\033[00m\\]", load_avg, ""
else
  printf "\\[\033[31m\\]%0.2f%s\\[\033[00m\\]", load_avg, ""
end
