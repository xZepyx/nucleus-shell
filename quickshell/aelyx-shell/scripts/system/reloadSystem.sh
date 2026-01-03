#!/bin/sh

killall qs
qs -c aelyx-shell
hyprctl reload
