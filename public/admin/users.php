<?php
session_start();
if (!isset($_SESSION['user_id']) || ($_SESSION['role'] !== 'admin' && $_SESSION['role'] !== 'superadmin')) {
    header('Location: login.php');
    exit;
}
$users = json_decode(file_get_contents(__DIR__.'/users.json'), true);
?>
<table border="1">
<tr><th>ID</th><th>Имя</th><th>Email</th><th>Роль</th><th>Действия</th></tr>
<?php foreach ($users as $u): ?>
<tr>
    <td><?=$u['id']?></td>
    <td><?=htmlspecialchars($u['name'])?></td>
    <td><?=htmlspecialchars($u['email'])?></td>
    <td><?=$u['role']?></td>
    <td>
        <a href="edit_user.php?id=<?=$u['id']?>">✏️</a>
        <a href="delete_user.php?id=<?=$u['id']?>">🗑️</a>
    </td>
</tr>
<?php endforeach; ?>
</table>
<a href="create_user.php">➕ Новый аккаунт</a>