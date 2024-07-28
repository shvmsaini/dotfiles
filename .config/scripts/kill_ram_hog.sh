#!/bin/bash

# Find the PID of the process with the highest memory usage
pid=$(ps -eo pid,rss | sort -nrk 2 | head -n 1 | awk '{print $1}')

# Get the process name for informational purposes
process_name=$(ps -p $pid -o comm=)

# Print a message about the process being killed
echo "Killing process $process_name (PID: $pid) with the highest RAM usage."

# Force kill the process
kill -SIGKILL $pid


# Optional: Add logic to only kill processes above a certain memory threshold (in KB)
# memory_limit=1024*1024  # 1 GB
# if [[ $(ps -p $pid -o rss=) -gt $memory_limit ]]; then
#   # Kill only if exceeding the memory limit
#   kill -SIGKILL $pid
# else
#   echo "Process $process_name uses less than ${memory_limit} KB. Not killing."
# fi
