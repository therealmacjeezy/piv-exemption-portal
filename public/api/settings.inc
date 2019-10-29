<?php
// this included file is NOT put in git
include 'settings.local.inc';

// are we going to act on the dev server or production servers
define('DEV_MODE', $DEV_MODE);

define('DEV_USER', $DEV_USER);

// this is where the list of piv exemption reasons comes from. An api call reads the menu options of a jamf EA
define('PIV_EXEMPTION_ATTRIBUTE', 'Smartcard-exempt - Justification Category');

// what is the information for the various jamf servers
define('CENTERS', array(
  "JP1" => array(
    "domain" => "your.server1.com",
    "creds" => $PROD_CRED,
    "dev" => false,
    "label" => "Jamf Server 1"
  ),
  "JP2" => array(
    "domain" => "your.server2.com",
    "creds" => $PROD_CRED,
    "dev" => false,
    "label" => "Jamf Server 2"
  ),
  "JP3" => array(
    "domain" => "your.server3.com",
    "creds" => $PROD_CRED,
    "dev" => false,
    "label" => "Jamf Server 3"
  ),
  "DEV" => array(
    "domain" => "your.dev.server.com",
    "creds" => $DEV_CRED,
    "dev" => true,
    "label" => "Dev Server"
  ),
));

function getCenter(&$site) {
  if (DEV_MODE) {
    return CENTERS['DEV'];
  }

  if (strpos($site, '#') > 0) {
    $split = explode('#', $site);
    $center = CENTERS[$split[0]];
    $site = $split[1];
    return $center;
  }

  return CENTERS[explode('-', $site)[0]];
}