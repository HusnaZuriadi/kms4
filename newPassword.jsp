<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%
    String email = (String) session.getAttribute("email");

    if (email == null) {
        response.sendRedirect("forgotPassword.jsp"); // Session expired or invalid
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>New Password</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
  <link rel="stylesheet" href="css/newPassword.css" />
</head>
<body>

<header>
		<div class="logo">
			<img src="images/LOGO-AL-KAUTHAR-EDUQIDS.png"
				alt="ALKAUTHAR EDUQIDS Logo">
		</div>
	</header>

<div class="container">
  <h2>Create New Password</h2>

  <% if ("success".equals(request.getAttribute("status"))) { %>
    <div class="success-message">
      Password updated successfully! Redirecting to login...
    </div>
  <% } else { %>
    <form action="UpdatePasswordController" method="post" id="passwordForm">
      <input type="hidden" name="email" value="<%= email %>" />

      <label for="newPassword">New Password:</label>
      <input type="password" id="newPassword" name="newPassword" required>

      <label for="confirmPassword">Confirm Password:</label>
      <input type="password" id="confirmPassword" name="confirmPassword" required>

      <input type="submit" value="Update Password">
    </form>
  <% } %>
</div>

<!-- Clean JS Section -->
<script>
  document.addEventListener("DOMContentLoaded", function () {
    const form = document.getElementById("passwordForm");

    if (form) {
      form.addEventListener("submit", function (e) {
        const newPass = document.getElementById("newPassword").value;
        const confirmPass = document.getElementById("confirmPassword").value;

        if (newPass !== confirmPass) {
          alert("Passwords do not match!");
          e.preventDefault(); // stop form submission
        }
      });
    }

    const status = "<%= request.getAttribute("status") %>";
    if (status === "success") {
      setTimeout(function () {
        window.location.href = "login.jsp";
      }, 3000);
    }
  });
</script>

</body>
</html>
