<?php

include_once 'includes/jamf.inc';
include_once 'settings.inc';

$selectedCenter = $_GET['selectedCenter'];
$EA_NAME = "Smartcard-exempt";
$EAID = "10";
$computerID = $_GET['id'];

$center = getCenter($selectedCenter);

function searchForEA($name, $array) {
    foreach ($array as $key => $val) {
        if ($val['name'] === $name) {
            return $key;
        }
    }
    return null;
}


function EA_search_array($needle, $haystack) {
	
	if (in_array($needle, $haystack)) {
		return true;
	}
	
	foreach ($haystack as $item) {
		if (is_array($item) && search_array($needle, $item)) 
		return true;
	}
	
	return false;
	
}

$ea_check = callAPI($center, 'GET', "computers/id/$computerID/subset/extension_attributes", false)->computer->extension_attributes;


try {
    $ea_array = json_decode(json_encode($ea_check),true);

    $array_value = searchForEA("Smartcard-exempt", $ea_array);

    if (EA_search_array("0", $ea_array[$array_value])) {
        echo 'Not Exempt';
    } else {
        echo 'Exempted';
    }
    
    // print(json_encode($ea_array[$array_value]));
} catch (exception $e) {
	print "[]";
}