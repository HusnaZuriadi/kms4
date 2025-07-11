<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Enter OTP</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
<link rel="stylesheet" href="css/EnterOTP.css" />
</head>
<body>

<header>
		<div class="logo">
			<img src="images/LOGO-AL-KAUTHAR-EDUQIDS.png"
				alt="ALKAUTHAR EDUQIDS Logo">
		</div>
	</header>
<div class="container">
     <div class="otp-container">
       
        <img src="images/logo.png" alt="OTP image" class="otp">

        <h2>Enter OTP</h2>

        <% if(request.getAttribute("message") != null) { %>
            <div class="message"><%= request.getAttribute("message") %></div>
        <% } %>

        <form action="OTPValidateController" method="post">
            <div class="form-group">
                <input type="text" name="otp" placeholder="Enter OTP" required />
            </div>
            <input type="submit" value="Reset Password" />
        </form>

       <div class="resend-section">
      Didn’t receive the code?
      <form action="ForgotPasswordController" method="post" style="display:inline;">
        <input type="hidden" name="resend" value="true" />
        <button type="submit" class="link-button resend-disabled" id="resendBtn" disabled>Resend OTP in <span id="timer">30</span>s</button>
      </form>
    </div>

        <div class="info-text">
            * OTP is valid for 5 minutes only.
        </div>
    </div>
    </div>
    
    <!-- JavaScript for timer -->
<script>
  let countdown = 30;
  const timerSpan = document.getElementById("timer");
  const resendBtn = document.getElementById("resendBtn");

  const interval = setInterval(() => {
    countdown--;
    timerSpan.textContent = countdown;

    if (countdown <= 0) {
      clearInterval(interval);
      resendBtn.innerText = "Resend OTP";
      resendBtn.disabled = false;
      resendBtn.classList.remove("resend-disabled");
    }
  }, 1000);
</script>
</body>
</html>