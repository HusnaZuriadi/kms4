<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page language="java" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Forgot Password?</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
<link rel="stylesheet" href="css/forgotPassword.css" />
</head>
<body>

<header>
		<div class="logo">
			<img src="images/LOGO-AL-KAUTHAR-EDUQIDS.png"
				alt="ALKAUTHAR EDUQIDS Logo">
		</div>
	</header>
	
	<div class="container">
        <img src="images/forgotPassword.png" alt="Forgot illustration" />
        <h2>Forget Password?</h2>
        <p>No worries, we’re always ready to assist!</p>

        <form action="ForgotPasswordController" method="post">
            <label for="email">Enter your email address</label><br><br>
            <input type="email" id="email" name="email" placeholder="abc@example.com" required><br>
            <input type="submit" value="Send Reset Link">

			<div class = "backButton">
				<a href="login.jsp" >Back to login</a>
			</div>

		</form>
    </div>

</body>
</html>