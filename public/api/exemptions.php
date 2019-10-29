<?php

include_once 'settings.inc';
include_once 'includes/jamf.inc';

$selectedCenter = $_GET['selectedCenter'];

$center = getCenter($selectedCenter);

$attributeName = urlencode(PIV_EXEMPTION_ATTRIBUTE);
$attribute = callAPI($center, 'GET', "computerextensionattributes/name/${attributeName}", false);

$values = $attribute->computer_extension_attribute->input_type->popup_choices;
print(json_encode(array_values(array_filter($values, function($v) {
	return (
		strtoupper(substr($v, 0, 8)) != "TEMP SYS" && 
		strtoupper(substr($v, 0, 3)) != "RBD"
	);
}))));
