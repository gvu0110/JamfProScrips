#!/bin/sh

loggedInUser=$(dscl /Local/Default -list /Users uid | awk '$2 >= 100 && $0 !~ /^_|jamf|guest|Guest|jenkins/ { print $1 }')
fullName=$(dscl . -read /Users/$loggedInUser RealName | sed  -e 's/^ *//g' -e '2q;d')
firstName=$(echo $fullName | awk '{ print $1 }')

# Process with 3 words in full name:
numberOfWords=$(echo $fullName | wc -w)

if [ $numberOfWords == "3" ]; then
lastName=$(echo $fullName | awk '{ print $3 }')
else
lastName=$(echo $fullName | awk '{ print $2 }')
fi

initialLastName="$(echo $lastName | tr '[:upper:]' '[:lower:]' | head -c 1)"

serialNumber=$(system_profiler SPHardwareDataType | awk '/Serial/ {print $4}')

origComputerName=$(scutil --get ComputerName)
origLocalHostName=$(scutil --get LocalHostName)
origHostName=$(scutil --get HostName)

if [ "${firstName}${initialLastName}-${serialNumber}" != "$origComputerName" ] || [ "${firstName}${initialLastName}-${serialNumber}" != "$origLocalHostName" ] || [ "${firstName}${initialLastName}-${serialNumber}" != "$origHostName" ]; then
	echo "<result>Name is wrong</result>"
else
	echo "<result>Name is good</result>"
fi

exit 0