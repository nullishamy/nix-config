#!/usr/bin/env bash
id=$(xdotool search --classname scratch-term)

if [ "$id" != "" ]
 then
  bspc node "$id" --flag hidden -f
fi
