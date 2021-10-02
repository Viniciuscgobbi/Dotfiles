# !/env/bash
xset -dpms s off &
setxkbmap -model abnt2 -layout br &
nitrogen --restore &
dunst &
exec i3
