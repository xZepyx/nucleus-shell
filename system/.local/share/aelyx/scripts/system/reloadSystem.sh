#!/bin/sh

killall quickshell
quickshell -c ae-qs
hyprctl reload
