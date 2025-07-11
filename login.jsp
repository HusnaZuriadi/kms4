<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Login - Kindergarten System</title>
  <link rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
  <link rel="stylesheet" href="css/login.css" />
</head>
<body>

<div class="container">
  <div class="left-panel">
    <img src="images/sign up.png" alt="Login Kids" />
  </div>

  <div class="right-panel">
    <h2>Login Account</h2>

    <!-- Show message if login failed -->
    <%
      String msg = request.getParameter("msg");
      if ("fail".equals(msg)) {
    %>
      <div class="error-message">
        <i class="fas fa-exclamation-triangle"></i>
        <div>
          <strong>Login Failed!</strong><br>
          The email or password you entered is incorrect.
        </div>
      </div>
    <% } else if ("success".equals(msg)) { %>
      <div class="success-message">
        <i class="fas fa-check-circle"></i>
        <div>
          <strong>Account Created Successfully!</strong><br>
          You can now login with your credentials.
        </div>
      </div>
    <% } %>

    <% if ("resetSuccess".equals(request.getAttribute("status"))) { %>
      <div class="success-message">
        <i class="fas fa-check-circle"></i>
        <div>
          <strong>Password Updated Successfully!</strong><br>
          Please login with your new password.
        </div>
      </div>
    <% } %>

    <form action="loginController" method="post" id="loginForm">
      <div class="roles">
        <input type="radio" name="role" value="Admin" required>Admin 
        <input type="radio" name="role" value="Parent">Parents 
        <input type="radio" name="role" value="Teacher">Teacher
      </div>

      <label>Email</label> 
      <input type="email" id="email" name="email" placeholder="Enter your email" required> 

      <label>Password</label>
      <input type="password" id="password" name="password" placeholder="Enter your password" required>
      
      <div style="margin-bottom: 10px; text-align: right;">
        <a href="forgotPassword.jsp" style="font-size: 0.9em;text-decoration: none;">Forgot password?</a>
      </div>

      <button type="submit">Log In</button>

      <div class="register-link">
        Don't have an account? <a href="index.html">Sign Up</a> now!
      </div>
    </form>
  </div>
</div>

<!-- Teacher/Admin Success Modal -->
<c:if test="${param.success == 'teacher' || param.success == 'admin'}">
  <div id="successModal" class="modal" style="display: flex;">
    <div class="modal-content">
      <div class="emoji">🎉🧒🏻👧🏼✨</div>
      <h2>Account Created!</h2>
      <p>Welcome to Al-Kauthar EduQids 🎈<br>This is where your teaching journey starts!</p>
      <button onclick="closeModal()">Let's Go!</button>
    </div>
  </div>
</c:if>

<script>
  window.onload = function () {
    const params = new URLSearchParams(window.location.search);
    const msg = params.get("msg");

    // Auto focus on email if login failed
    if (msg === "fail") {
      const emailField = document.getElementById("email");
      if (emailField) {
        emailField.focus();
        emailField.select();
      }
    }
  };

  function closeModal() {
    document.getElementById('successModal').style.display = 'none';
    window.location.href = "login.jsp";
  }

  // Form validation
  document.getElementById('loginForm').addEventListener('submit', function(e) {
    const email = document.getElementById('email').value.trim();
    const password = document.getElementById('password').value.trim();

    if (!email || !password) {
      e.preventDefault();
      alert('Please fill in all required fields.');
      return false;
    }

    const submitButton = this.querySelector('button[type="submit"]');
    submitButton.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Logging in...';
    submitButton.disabled = true;
  });
</script>

</body>
</html>
