#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Video Speed Down
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🤖
# @raycast.packageName Video Speed

# Documentation:
# @raycast.description Decrease video playback speed by 0.25x
# @raycast.author FerranMartin
# @raycast.authorURL https://raycast.com/FerranMartin

osascript <<'EOF'
tell application "System Events"
	set frontApp to name of first application process whose frontmost is true
end tell

set jsCode to "var v = document.querySelector('video'); if(v){ var prev = v.playbackRate; v.playbackRate = Math.max(v.playbackRate - 0.25, 0.25); 'Changed from ' + prev + ' to ' + v.playbackRate; } else { 'No video element found'; }"

if frontApp contains "Arc" then
	tell application "Arc"
		tell active tab of window 1 to execute javascript jsCode
	end tell
else if frontApp contains "Chrome" then
	tell application "Google Chrome"
		tell active tab of window 1 to execute javascript jsCode
	end tell
else if frontApp contains "Brave" then
	tell application "Brave Browser"
		tell active tab of window 1 to execute javascript jsCode
	end tell
else if frontApp contains "Edge" then
	tell application "Microsoft Edge"
		tell active tab of window 1 to execute javascript jsCode
	end tell
else if frontApp contains "Safari" then
	tell application "Safari"
		set jsResult to do JavaScript jsCode in front document
	end tell
else
	log "Unsupported app: " & frontApp
end if
EOF