#!/bin/bash

#################################################
# Enforce Timed PIV Exemption - Remove
# Name: checkDate.sh
# Joshua Harvey | Oct 2019
# josh@macjeezy.com
#################################################

if [[ -z $4 ]]; then
    echo "Missing Server Info"
    exit 1
else
    jssURL="$4"
fi

udid=$(system_profiler SPHardwareDataType | grep UUID | awk '{print $3}')
PIV_EXEMPTION_EA="Smartcard-exempt"
PIV_EXEMPTION_REASON="Smartcard-exempt - Justification Category"
PIV_EXEMPTION_DOCUMENTATION="Smartcard-exempt - Reason"


function DecryptString() {
    # Usage: ~$ DecryptString "Encrypted String" "Salt" "Passphrase"
    echo "${1}" | /usr/bin/openssl enc -aes256 -d -a -A -S "${2}" -k "${3}"
}

apiUser=$(DecryptString "$5" '<SALT>' '<HASH>') 
apiPass=$(DecryptString "$6" '<SALT>' '<HASH>')


echo "Starting EA Section"

# curl command to update ea 
setEAStatus() {
  echo "Resetting Extension Attributes"
  curl -sk -u $apiUser:"$apiPass" -X "PUT" "https://$jssURL/JSSResource/computers/udid/$udid/subset/extension_attributes" \
      -H "Content-Type: application/xml" \
      -H "Accept: application/xml" \
      -d "<computer><extension_attributes><extension_attribute><name>$PIV_EXEMPTION_EA</name><type>Integer</type><value>0</value></extension_attribute><extension_attribute><name>$PIV_EXEMPTION_REASON</name><type>String</type><value>""</value></extension_attribute><extension_attribute><name>$PIV_EXEMPTION_DOCUMENTATION</name><type>String</type><value>""</value></extension_attribute></extension_attributes></computer>"
}
# Set Status
setEAStatus

if [[ -e "/Library/Scripts/checkDate.sh" ]]; then
    echo "Removing Date Check Script"
    rm -f "/Library/Scripts/checkDate.sh"
fi

if [[ -e "/Users/Shared/time.log" ]]; then
    echo "Removing Exemption Receipt"
    rm -f "/Users/Shared/time.log"
fi

if [[ -e "/Library/LaunchDaemons/com.jamf.exemptioncheck.plist" ]]; then
	echo "Stopping Launchd item"
    sudo launchctl stop /Library/LaunchDaemons/com.jamf.exemptioncheck.plist
    echo "Unloading Launchd item"
    sudo launchctl unload /Library/LaunchDaemons/com.jamf.exemptioncheck.plist
    echo "Removing Launchd item"
    sudo rm -f "/Library/LaunchDaemons/com.jamf.exemptioncheck.plist"
fi

echo "Exemption files have been unloaded and removed. The computer should now be PIV Enforced."

exit 0