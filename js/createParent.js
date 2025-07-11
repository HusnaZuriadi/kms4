window.onload = function () {
  // 1. Tunjuk success modal kalau ada ?success=true
  const urlParams = new URLSearchParams(window.location.search);
  if (urlParams.get('success') === 'true') {
    const modal = document.getElementById('successModal');
    if (modal) modal.style.display = 'flex';
  }

  // 2. Setup password, confirm password, phone dan validation
  const password = document.getElementById('password');
  const confirmPassword = document.getElementById('confirmPassword');
  const phone = document.getElementById('phone');
  const passwordStrength = document.getElementById('passwordStrength');
  const form = document.querySelector('form');

  if (!password || !confirmPassword || !phone || !form) return;

  // Phone input: hanya benarkan nombor & max 11 digit
  phone.addEventListener('keydown', function (e) {
    const allowedKeys = ['Backspace', 'Tab', 'ArrowLeft', 'ArrowRight', '-', 'Delete'];
    const isNumber = /^[0-9]$/.test(e.key);
    const isEditingKey = allowedKeys.includes(e.key);
    const digitsOnly = phone.value.replace(/\D/g, '');

    if (!isNumber && !isEditingKey) e.preventDefault();
    if (digitsOnly.length >= 11 && isNumber && !isEditingKey) e.preventDefault();
  });

  // Password strength
  password.addEventListener('input', function () {
    const pwd = password.value;
    const strongPattern = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@#$%^&+=!]).{8,}$/;
    const mediumPattern = /^(?=.*[a-zA-Z])(?=.*\d).{6,}$/;

    if (pwd.length === 0) {
      passwordStrength.textContent = "";
    } else if (!mediumPattern.test(pwd)) {
      passwordStrength.textContent = "Weak password";
      passwordStrength.style.color = "red";
    } else if (!strongPattern.test(pwd)) {
      passwordStrength.textContent = "Medium strength";
      passwordStrength.style.color = "orange";
    } else {
      passwordStrength.textContent = "Strong password";
      passwordStrength.style.color = "green";
    }
  });

  // Final form validation
  form.onsubmit = function () {
    const pwd = password.value;
    const confirmPwd = confirmPassword.value;
    const phoneVal = phone.value;

    const phonePattern = /^\d{3}-\d{7}$/;
    const strongPwd = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@#$%^&+=!]).{8,}$/;

    if (pwd !== confirmPwd) {
      alert("Passwords do not match.");
      return false;
    }

    if (!strongPwd.test(pwd)) {
      alert("Password is not strong enough.");
      return false;
    }

    if (!phonePattern.test(phoneVal)) {
      alert("Phone must be in format 011-1234567.");
      return false;
    }

    return true;
  };
};

function closeModal() {
  document.getElementById('successModal').style.display = 'none';
  window.location.href = "login.jsp"; // terus redirect tanpa delay
}

