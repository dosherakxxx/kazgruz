<?php
header('Content-Type: application/json');
$data = json_decode(file_get_contents('php://input'), true);

if (!isset($data['email']) || !isset($data['password'])) {
    echo json_encode(['success' => false, 'message' => 'Заполните все поля']);
    exit;
}

$email = strtolower(trim($data['email']));
$password = $data['password'];

$usersFile = __DIR__ . '/users.json';
$users = file_exists($usersFile) ? json_decode(file_get_contents($usersFile), true) : [];

foreach ($users as $user) {
    if ($user['email'] === $email && password_verify($password, $user['password'])) {
        echo json_encode(['success' => true, 'message' => 'Вход выполнен']);
        exit;
    }
}

echo json_encode(['success' => false, 'message' => 'Неверный email или пароль']);


