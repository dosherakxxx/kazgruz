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
    if ($user['email'] === $email) {
        echo json_encode(['success' => false, 'message' => 'Пользователь уже существует']);
        exit;
    }
}

$users[] = [
    'email' => $email,
    'password' => password_hash($password, PASSWORD_DEFAULT)
];

file_put_contents($usersFile, json_encode($users, JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT));
echo json_encode(['success' => true, 'message' => 'Регистрация успешна']);