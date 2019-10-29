#!/bin/bash

#################################################
# Enforce Timed PIV Exemption
# Create Exemption Check Files
# Joshua Harvey | Oct 2019
# josh@macjeezy.com
#################################################

# Create receipt for when the exemption expires
EXEMPTION_END=$(date -v +2d +"%m-%d")

echo "$EXEMPTION_END" > /Users/Shared/time.log 
chflags hidden /Users/Shared/time.log

echo "PIV Exemption End Date: $EXEMPTION_END"

# Create Date Check Script
echo "Creating Exemption Check Script"
/bin/cat > "/Library/Scripts/checkDate.sh" << 'Check_Date'
#!/bin/bash

#################################################
# Enforce Timed PIV Exemption - Check
# Name: checkDate.sh
# Joshua Harvey | Oct 2019
# josh@macjeezy.com
#################################################

GET_TIME=$(cat /Users/Shared/time.log)
currTime=$(date +"%m-%d")

removeExemption() {
	echo "Starting Exemption Removal via Jamf Policy"
	sudo /usr/local/bin/jamf policy -trigger removeExemption
}

if [[ "$currTime" = "$GET_TIME" ]]; then
	echo "Exemption ($GET_TIME) expires today. Time to remove"
	removeExemption
elif [[ "$currTime" > "$GET_TIME" ]]; then
	echo "Exemption ($GET_TIME) has expired. Time to remove"
	removeExemption
else
	echo "Exemption is still valid until $GET_TIME"
fi
Check_Date

/bin/chmod a+x /Library/Scripts/checkDate.sh
/usr/bin/chflags hidden /Library/Scripts/checkDate.sh
echo "Exemption Check Script Created"

# Create launchd item to run each day to trigger the script. This is kicked off at 10am
echo "Creating Launchd item"
/bin/cat > "/Library/LaunchDaemons/com.jamf.exemptioncheck.plist" << 'Exemption_Check'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.jamf.exemptioncheck.plist</string>
    <key>ProgramArguments</key>
    <array>
        <string>sh</string>
        <string>/Library/Scripts/checkDate.sh</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>StartCalendarInterval</key>
    <dict>
        <key>Hour</key>
        <integer>10</integer>
    </dict>
    <key>StandardErrorPath</key>
    <string>/Library/Scripts/error.log</string>
</dict>
</plist>
Exemption_Check

sudo /bin/chmod 0644 "/Library/LaunchDaemons/com.jamf.exemptioncheck.plist"
sudo /bin/launchctl load "/Library/LaunchDaemons/com.jamf.exemptioncheck.plist"
sudo /bin/launchctl start "/Library/LaunchDaemons/com.jamf.exemptioncheck.plist"
echo "Launchd item created and loaded"
