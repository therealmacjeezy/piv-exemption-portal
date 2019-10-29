<?php
# This file goes on the server itself. Don't forget to add this file to the .gitignore if using git

$DEV_MODE = false;
# Jamf Pro API account used in your prod environment
$PROD_CRED = "api_user:api_pass";
# Jamf Pro Dev API account used in your dev environment
$DEV_CRED = "devapi_user:devapi_pass";
# Static username to mimic the uid of the logged in user
$DEV_USER = "test_user";