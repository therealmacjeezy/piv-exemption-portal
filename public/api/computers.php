<?php

include_once 'includes/jamf.inc';
include_once 'settings.inc';

$user = $_GET['user'];
$selectedCenter = $_GET['selectedCenter'];

$center = getCenter($selectedCenter);



try {
	$comps = callAPI($center, 'GET', "users/name/$user", false);
	if (is_null($comps)) {
		$error="";
		print(json_encode($error)); 
	} else 
	{
		$userComputers = $comps->user->links->computers;
		print(json_encode($userComputers));
	}
} catch (Exception $e) {
	print[];
}
