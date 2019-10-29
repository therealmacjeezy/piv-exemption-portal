<?php

include_once 'settings.inc';

function callAPI($center, $method, $path, $data=NULL, $json_encode=true){
  if (!is_array($center)) {
    $fixedCenter = getCenter($center);
    $center = CENTERS[$fixedCenter];
  }

  $url = "https://{$center['domain']}/JSSResource/{$path}";
  $curl = curl_init();

  switch ($method){
    case "POST":
      curl_setopt($curl, CURLOPT_POST, 1);
      if ($data)
        curl_setopt($curl, CURLOPT_POSTFIELDS, $data);
      break;
    case "PUT":
      curl_setopt($curl, CURLOPT_CUSTOMREQUEST, "PUT");
      if ($data)
        curl_setopt($curl, CURLOPT_POSTFIELDS, $data);			 					
      break;
    default:
      if ($data)
        $url = sprintf("%s?%s", $url, http_build_query($data));
  }

  // OPTIONS:
  curl_setopt($curl, CURLOPT_URL, $url);
  curl_setopt($curl, CURLOPT_HTTPHEADER, array(
    'APIKEY: 111111111111111111111',
    'Accept: application/json',
    'Content-Type: application/xml',
  ));
  curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
  curl_setopt($curl, CURLOPT_HTTPAUTH, CURLAUTH_BASIC);
  // Change service account before production
  curl_setopt($curl, CURLOPT_USERPWD, $center['creds']);
  curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false);

  // EXECUTE:
  $result = curl_exec($curl);
  $httpcode = curl_getinfo($curl, CURLINFO_HTTP_CODE);
  if ($httpcode != 200) {
    $result = "";
  }
  if ($json_encode) {
    $result = json_decode($result);
  }
  curl_close($curl);
  return $result;
}
