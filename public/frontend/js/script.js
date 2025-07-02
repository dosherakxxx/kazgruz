document.addEventListener('DOMContentLoaded', function() {
    // --- Динамический Header ---
    const userEmail = localStorage.getItem('userEmail');
    const nav = document.querySelector('.nav');
    if (nav) {
        if (userEmail) {
            // Удаляем "Вход / Регистрация"
            const loginLink = nav.querySelector('.nav__login-btn');
            if (loginLink) loginLink.remove();
            // Добавляем "Личный кабинет"
            const profileLink = document.createElement('a');
            profileLink.href = 'frontend/html/profile.html';
            profileLink.className = 'nav__link nav__profile-btn';
            profileLink.textContent = 'Личный кабинет';
            nav.appendChild(profileLink);

            // Добавляем "Выйти"
            const logoutLink = document.createElement('a');
            logoutLink.href = '#';
            logoutLink.className = 'nav__link nav__logout-btn';
            logoutLink.textContent = 'Выйти';
            logoutLink.onclick = function() {
                localStorage.removeItem('userEmail');
                window.location.reload();
                return false;
            };
            nav.appendChild(logoutLink);
        }
    }
    // --- конец блока Header ---

    // Переключение табов (если есть)
    const tabs = document.querySelectorAll('.auth-tab');
    const forms = document.querySelectorAll('.auth-form');
    if (tabs.length) {
        tabs.forEach(tab => {
            tab.addEventListener('click', function() {
                tabs.forEach(t => t.classList.remove('active'));
                forms.forEach(f => f.classList.remove('active'));
                this.classList.add('active');
                document.getElementById(this.dataset.tab + '-form').classList.add('active');
            });
        });
    }

    // Вход
    const loginForm = document.getElementById('login-form');
    if (loginForm) {
        loginForm.addEventListener('submit', async function(e) {
            e.preventDefault();
            const email = this.querySelector('input[type="email"]').value;
            const password = this.querySelector('input[type="password"]').value;

            const res = await fetch('../../backend/login.php', {
                method: 'POST',
                headers: {'Content-Type': 'application/json'},
                body: JSON.stringify({email, password})
            });
            const data = await res.json();
            alert(data.message);
            if (data.success) {
                localStorage.setItem('userEmail', email);
                window.location.href = 'profile.html';
            }
        });
    }

    // Регистрация
    const registerForm = document.getElementById('register-form');
    if (registerForm) {
        registerForm.addEventListener('submit', async function(e) {
            e.preventDefault();
            const name = this.querySelector('input[type="text"]').value;
            const email = this.querySelectorAll('input[type="email"]')[0].value;
            const password = this.querySelectorAll('input[type="password"]')[0].value;

            const res = await fetch('../../backend/registr.php', {
                method: 'POST',
                headers: {'Content-Type': 'application/json'},
                body: JSON.stringify({email, password, name})
            });
            const data = await res.json();
            alert(data.message);
            if (data.success) {
                // Сразу авторизуем пользователя после регистрации
                localStorage.setItem('userEmail', email);
                window.location.href = 'profile.html';
            }
        });
    }
});