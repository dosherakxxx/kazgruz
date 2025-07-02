<?php

session_start();
$users = json_decode(file_get_contents(__DIR__.'/users.json'), true);

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $email = trim($_POST['email']);
    $password = $_POST['password'];
    foreach ($users as $user) {
        if ($user['email'] === $email && password_verify($password, $user['password'])) {
            $_SESSION['user_id'] = $user['id'];
            $_SESSION['role'] = $user['role'];
            $_SESSION['name'] = $user['name'];
            header('Location: dashboard.php');
            exit;
        }
    }
    $error = "Неверный логин или пароль";
}
?>
<form method="post">
    <input type="email" name="email" placeholder="Email" required>
    <input type="password" name="password" placeholder="Пароль" required>
    <button type="submit">Войти</button>
    <?php if (!empty($error)) echo "<div style='color:red;'>$error</div>"; ?>
</form>