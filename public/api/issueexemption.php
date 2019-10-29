<?php

include_once 'settings.inc';
include_once 'includes/jamf.inc';

$_POST = json_decode(file_get_contents('php://input'));

# Replace SAML_RETURN with the variable your IdP uses to return the username of the person logging in
$user = !DEV_MODE ? $_SERVER['SAML_RETURN'] : DEV_USER;
$computerID = $_POST->params->id;
$selectedCenter = $_POST->params->selectedCenter;
$reason = $_POST->params->selectedReason;

# Replace the path below with a location to save the logs
$LOG_PATH = 'e:\pivexemption\exemptions.log';

$center = getCenter($selectedCenter);
$selectedCenter = $center[domain];

error_log("---Start New Exemption---\n", 3, $LOG_PATH);
error_log("Center Selected: " . $selectedCenter . "\n", 3, $LOG_PATH);
error_log("Jamf Admin: " . $user . "\n", 3, $LOG_PATH);
error_log("Reason Selected: " . $reason . "\n", 3, $LOG_PATH);
error_log("---End New Exemption---\n", 3, $LOG_PATH);

# Replace the below variables with the ones used in your jamf pro
# EA Names
$PIV_EXEMPTION_EA = 'Smartcard-exempt';
$PIV_EXEMPTION_REASON = 'Smartcard-exempt - Justification Category';
$PIV_EXEMPTION_DOCUMENTATION = 'Smartcard-exempt - Reason';

$pivDocumentation = "Jamf Admin: ${user}";

# This is the data that gets used in the API call. It flips the EA from a 0 to a 1 which triggers the Exemption
$pivXML = "<computer><extension_attributes><extension_attribute><name>$PIV_EXEMPTION_EA</name><type>Integer</type><value>1</value></extension_attribute><extension_attribute><name>$PIV_EXEMPTION_REASON</name><type>String</type><value>$reason</value></extension_attribute><extension_attribute><name>$PIV_EXEMPTION_DOCUMENTATION</name><type>String</type><value>$pivDocumentation</value></extension_attribute></extension_attributes></computer>";

callAPI($center, 'PUT', "computers/id/${computerID}/subset/extension_attributes", $pivXML);
