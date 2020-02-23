#!/bin/sh

if [ ! -f "/Applications/Google Chrome.app/Contents/Info.plist" ]; then
		echo "<result>Chrome isn't installed</result>"
else
        INSTALLEDVERSION=$( defaults read "/Applications/Google Chrome.app/Contents/Info.plist" CFBundleShortVersionString )
        CURRENTVERSION=$( curl -s https://omahaproxy.appspot.com/history | awk -F',' '/mac,stable/{print $3; exit}' )
        if [[ "$INSTALLEDVERSION" == "$CURRENTVERSION" ]]; then
                echo "<result>Latest - $CURRENTVERSION</result>"
        else
                echo "<result>Old</result>"
        fi
fi

exit 0