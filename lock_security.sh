#!/usr/bin/bash

# Take a folder as input and put all auth fails into
# Requires inotify-tools, ffmpeg and syslog-ng (if you are on Debian like)

output_folder="/home/dummy/Images/" # Dont forget / at end
record_time="00:00:20"
webcam="/dev/"	# Use ffmpeg to find it
mkdir -p output_folder
while inotifywait -q -e modify /var/log/auth.log >/dev/null
do
        if (( $(tail -1 /var/log/auth.log | grep failure | wc -l) == 1))
        then
               today=$(date +'%Y_%m_%d_%H-%M-%S')
               # -f pulse -ac 2 -i /dev/snd/controlC1 # Add to command to record audio, don't work if micro is disabled by lockscreen (my case)
			   ffmpeg -i $webcam -video_size 1920x1080 -input_format yuyv422 -t $record_time -vcodec libx264 $output_folder+"record_"+$today.mp4
        fi
done
