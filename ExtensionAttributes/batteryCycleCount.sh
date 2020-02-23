#!/bin/sh

#echo "<result>$(ioreg -r -c "AppleSmartBattery" | grep -w "CycleCount" | awk '{print $3}' | sed s/\"//g)</result>"

powerReport=$("/usr/sbin/system_profiler" SPPowerDataType)

if [[ "$powerReport" = *"Battery Information"* ]]; then
	cycleCount=$("/bin/echo" "$powerReport" | "/usr/bin/awk" '/Cycle Count/ {print $3}' | "/usr/bin/bc")
else
	cycleCount=0
fi

"/bin/echo" "<result>$cycleCount</result>"

exit 0
