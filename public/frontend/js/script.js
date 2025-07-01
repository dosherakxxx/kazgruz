// Переключение табов на странице входа/регистрации
document.addEventListener('DOMContentLoaded', function() {
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
});