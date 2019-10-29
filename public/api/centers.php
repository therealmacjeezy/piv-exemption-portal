<?php

include_once 'includes/jamf.inc';
include_once 'settings.inc';

$centers = [];
$user = $_SERVER['SAML_RETURN'];

$filteredCenters = array_filter(CENTERS, function ($k) {
	return CENTERS[$k]['dev'] == DEV_MODE;
}, ARRAY_FILTER_USE_KEY);

foreach ($filteredCenters as $k => $v) {
	$centers[] = array(
		"value" => $k,
		"text" => $v['label']
	);
}

#print($user);
print(json_encode($centers));