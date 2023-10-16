#!/bin/bash

xfreerdp -grab-keyboard /v:192.168.0.62 /size:100% /cert-ignore /u:user /p:$PW /d: /dynamic-resolution /gfx-h264:avc444 +gfx-progressive &

