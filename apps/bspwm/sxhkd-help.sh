#!/usr/bin/env bash

awk '/^[a-z]/ && last {print "<small>",$0,"\t",last,"</small>"} {last=""} /^#/{last=$0}'  \
~/.config/sxhkd/sxhkdrc{,.common} |

column -t -s $'\t' |

rofi -dmenu -i -markup-rows -no-show-icons -lines 15 -yoffset 40 
