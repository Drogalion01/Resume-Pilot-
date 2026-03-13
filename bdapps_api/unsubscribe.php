<?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');
header('Content-Type: application/json; charset=utf-8');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode([
        'success' => false,
        'message' => 'Method not allowed. Use POST.',
    ]);
    exit;
}

$rawBody = file_get_contents('php://input');
$data = json_decode($rawBody, true);

if (!is_array($data)) {
    http_response_code(400);
    echo json_encode([
        'success' => false,
        'message' => 'Invalid JSON payload',
    ]);
    exit;
}

$applicationId = trim((string)($data['applicationId'] ?? ''));
$password = trim((string)($data['password'] ?? ''));
$version = trim((string)($data['version'] ?? '1.0'));
$action = trim((string)($data['action'] ?? '0'));
$subscriberId = trim((string)($data['subscriberId'] ?? ''));

if ($action !== '0' && $action !== '1') {
    http_response_code(400);
    echo json_encode([
        'success' => false,
        'message' => 'Invalid action. Allowed values: 0 (unsubscribe), 1 (subscribe).',
    ]);
    exit;
}

if ($subscriberId === '' || !preg_match('/^tel:88(01[3-9][0-9]{8})$/', $subscriberId)) {
    http_response_code(400);
    echo json_encode([
        'success' => false,
        'message' => 'Invalid subscriberId. Expected tel:8801XXXXXXXXX',
    ]);
    exit;
}

// Keep server-side credentials as fallback for safer deployment.
if ($applicationId === '') {
    $applicationId = 'APP_135994';
}
if ($password === '') {
    $password = '3b02c1ca07828624a7e14e969abca9a9';
}

$requestData = [
    'applicationId' => $applicationId,
    'password' => $password,
    'version' => $version,
    'action' => $action,
    'subscriberId' => $subscriberId,
];
$requestJson = json_encode($requestData);

$bdappsUrl = 'https://developer.bdapps.com/subscription/send';
$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, $bdappsUrl);
curl_setopt($ch, CURLOPT_POST, true);
curl_setopt($ch, CURLOPT_POSTFIELDS, $requestJson);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_TIMEOUT, 20);
curl_setopt($ch, CURLOPT_HTTPHEADER, [
    'Content-Type: application/json',
    'Content-Length: ' . strlen($requestJson),
]);

$responseJson = curl_exec($ch);
$curlError = curl_error($ch);
$httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
curl_close($ch);

file_put_contents(
    'unsubscribe.log',
    date('Y-m-d H:i:s') . ' | HTTP ' . $httpCode . ' | Req: ' . $requestJson . ' | Res: ' . (string)$responseJson . PHP_EOL,
    FILE_APPEND
);

if ($responseJson === false) {
    http_response_code(502);
    echo json_encode([
        'success' => false,
        'message' => 'Failed to call BDApps unsubscribe API',
        'details' => $curlError,
    ]);
    exit;
}

$response = json_decode($responseJson, true);
if (!is_array($response)) {
    http_response_code(502);
    echo json_encode([
        'success' => false,
        'message' => 'Invalid JSON from BDApps',
        'httpCode' => $httpCode,
        'raw' => substr($responseJson, 0, 600),
    ]);
    exit;
}

$statusCode = strtoupper(trim((string)($response['statusCode'] ?? '')));
$subscriptionStatus = strtoupper(trim((string)($response['subscriptionStatus'] ?? '')));
$subscriptionStatusNormalized = rtrim($subscriptionStatus, '.');
$statusDetail = (string)($response['statusDetail'] ?? '');
$statusDetailLower = strtolower(trim($statusDetail));
$alreadyUnregistered =
    (strpos($statusDetailLower, 'already unregistered') !== false) ||
    (strpos($statusDetailLower, 'not registered') !== false) ||
    (strpos($statusDetailLower, 'already unregister') !== false);

$success =
    ($statusCode === 'S1000') ||
    ($subscriptionStatusNormalized === 'UNREGISTERED') ||
    $alreadyUnregistered;

$responseVersion = (string)($response['version'] ?? $version);
$responseStatusCode = (string)($response['statusCode'] ?? ($success ? 'S1000' : 'E0000'));
$responseStatusDetail = $statusDetail !== ''
    ? $statusDetail
    : ($success ? 'Unsubscribed successfully' : 'Unsubscribe failed');
$responseSubscriptionStatus = (string)($response['subscriptionStatus'] ?? ($success ? 'UNREGISTERED' : 'UNKNOWN'));

if ($httpCode >= 400) {
    http_response_code($httpCode);
}

echo json_encode([
    'version' => $responseVersion,
    'statusCode' => $responseStatusCode,
    'statusDetail' => $responseStatusDetail,
    'subscriptionStatus' => $responseSubscriptionStatus,
    'success' => $success,
    'message' => $responseStatusDetail,
    'subscriberId' => $subscriberId,
]);
