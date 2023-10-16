#!/bin/bash

xfreerdp -grab-keyboard /v:192.168.0.247 /size:100% /cert-ignore /u:user /p:password /d: /dynamic-resolution /gfx-h264:avc444 +gfx-progressive /audio-mode:1 &
