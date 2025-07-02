<?php
session_start();
if (!isset($_SESSION['user_id']) || $_SESSION['role'] !== 'superadmin') {
    header('Location: login.php');
    exit;
}
$users = json_decode(file_get_contents(__DIR__.'/users.json'), true);

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $new = [
        "id" => end($users)['id'] + 1,
        "name" => $_POST['name'],
        "email" => $_POST['email'],
        "password" => password_hash($_POST['password'], PASSWORD_DEFAULT),
        "role" => $_POST['role'],
        "created_at" => date('Y-m-d H:i:s')
    ];
    foreach ($users as $u) {
        if ($u['email'] === $new['email']) {
            $error = "Email уже существует!";
            break;
        }
    }
    if (empty($error)) {
        $users[] = $new;
        file_put_contents(__DIR__.'/users.json', json_encode($users, JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT));
        header('Location: users.php');
        exit;
    }
}
?>
<form method="post">
    <input name="name" placeholder="Имя" required>
    <input name="email" type="email" placeholder="Email" required>
    <input name="password" type="password" placeholder="Пароль" required>
    <select name="role">
        <option value="seller">Продавец</option>
        <option value="admin">Админ</option>
        <option value="superadmin">Главный админ</option>
    </select>
    <button type="submit">Создать</button>
    <?php if (!empty($error)) echo "<div style='color:red;'>$error</div>"; ?>
</form>