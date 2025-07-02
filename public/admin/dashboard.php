<?php

session_start();
if (!isset($_SESSION['user_id']) || ($_SESSION['role'] !== 'admin' && $_SESSION['role'] !== 'superadmin')) {
    header('Location: login.php');
    exit;
}
$users = json_decode(file_get_contents(__DIR__.'/users.json'), true);
$countUsers = count($users);
$countAdmins = count(array_filter($users, fn($u) => $u['role'] === 'admin'));
$countSellers = count(array_filter($users, fn($u) => $u['role'] === 'seller'));
?>
<h2>Добро пожаловать, <?=htmlspecialchars($_SESSION['name'])?>!</h2>
<p>Всего пользователей: <?=$countUsers?></p>
<p>Продавцов: <?=$countSellers?></p>
<p>Админов: <?=$countAdmins?></p>
<a href="users.php">Список пользователей</a> | <a href="create_user.php">➕ Новый аккаунт</a> | <a href="logout.php">Выйти</a>