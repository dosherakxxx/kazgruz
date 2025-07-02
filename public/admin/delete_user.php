<?php

session_start();
if (!isset($_SESSION['user_id']) || ($_SESSION['role'] !== 'admin' && $_SESSION['role'] !== 'superadmin')) {
    header('Location: login.php');
    exit;
}
$users = json_decode(file_get_contents(__DIR__.'/users.json'), true);
$id = isset($_GET['id']) ? (int)$_GET['id'] : 0;
$user = null;
foreach ($users as $u) {
    if ($u['id'] == $id) $user = $u;
}
if (!$user) {
    echo "Пользователь не найден";
    exit;
}
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    foreach ($users as &$u) {
        if ($u['id'] == $id) {
            $u['name'] = $_POST['name'];
            $u['email'] = $_POST['email'];
            if (!empty($_POST['password'])) {
                $u['password'] = password_hash($_POST['password'], PASSWORD_DEFAULT);
            }
            if ($_SESSION['role'] === 'superadmin' && isset($_POST['role'])) {
                $u['role'] = $_POST['role'];
            }
        }
    }
    file_put_contents(__DIR__.'/users.json', json_encode($users, JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT));
    header('Location: users.php');
    exit;
}
?>
<form method="post">
    <input name="name" value="<?=htmlspecialchars($user['name'])?>" required>
    <input name="email" type="email" value="<?=htmlspecialchars($user['email'])?>" required>
    <input name="password" type="password" placeholder="Новый пароль (не менять — оставить пустым)">
    <?php if ($_SESSION['role'] === 'superadmin'): ?>
        <select name="role">
            <option value="seller" <?=$user['role']=='seller'?'selected':''?>>Продавец</option>
            <option value="admin" <?=$user['role']=='admin'?'selected':''?>>Админ</option>
            <option value="superadmin" <?=$user['role']=='superadmin'?'selected':''?>>Главный админ</option>
        </select>
    <?php else: ?>
        <input type="hidden" name="role" value="<?=$user['role']?>">
    <?php endif; ?>
    <button type="submit">Сохранить</button>
</form>
<a href="users.php">Назад к списку</a>