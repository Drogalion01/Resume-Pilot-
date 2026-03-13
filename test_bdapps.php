<?php
$requestData = [
    'applicationId' => 'APP_135994',
    'password' => '3b02c1ca07828624a7e14e969abca9a9',
    'subscriberId' => 'tel:8801845348911',
    'applicationHash' => 'App Name',
    'applicationMetaData' => [
        'client' => 'WEBAPP',
        'appCode' => 'https://flicksize.com'
    ]
];
$ch = curl_init('https://developer.bdapps.com/subscription/otp/request');
curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($requestData));
curl_setopt($ch, CURLOPT_HTTPHEADER, ['Content-Type: application/json']);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
echo curl_exec($ch);
?>





