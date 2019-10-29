<?php

include_once 'includes/jamf.inc';
include_once 'settings.inc';

# Replace SAML_RETURN with the variable your IdP uses to return the username of the person logging in
$user = $_SERVER['SAML_RETURN'];

print(json_encode($user));

