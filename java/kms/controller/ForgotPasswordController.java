package kms.controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import javax.mail.*;
import javax.mail.internet.*;
import java.io.IOException;
import java.util.Properties;
import java.util.Random;

@WebServlet("/ForgotPasswordController")
public class ForgotPasswordController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public ForgotPasswordController() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    	

        String email = request.getParameter("email");
        String resend = request.getParameter("resend");
        HttpSession mySession = request.getSession();
        RequestDispatcher dispatcher = null;

     // Handle Resend OTP
        if ("true".equals(resend)) {
            email = (String) mySession.getAttribute("email");
        }


        if (email != null && !email.trim().isEmpty()) {

            int otpvalue = new Random().nextInt(999999);

            // Email settings
            Properties props = new Properties();
            props.put("mail.smtp.host", "smtp.gmail.com");
            props.put("mail.smtp.port", "587");
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");

            Session session = Session.getInstance(props, new Authenticator() {
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication("alkautharkms@gmail.com", "ghii pqez njvn pyyb");
                }
            });

            try {
                MimeMessage message = new MimeMessage(session);
                message.setFrom(new InternetAddress("alkautharkms@gmail.com"));
                message.addRecipient(Message.RecipientType.TO, new InternetAddress(email));
                message.setSubject("OTP for Password Reset - Kindergarten Management System");
                message.setText("Dear user,\n\nYour OTP for password reset is: " + otpvalue
                        + "\n\nPlease use this OTP to proceed.\n\nRegards,\nAlkauthareduqids Team");

                Transport.send(message);
                System.out.println("OTP email sent successfully.");

                // Store OTP and email in session
                mySession.setAttribute("otp", otpvalue);
                mySession.setAttribute("email", email);
                request.setAttribute("message", "OTP is sent to your email.");

                dispatcher = request.getRequestDispatcher("EnterOTP.jsp");

            } catch (MessagingException e) {
                e.printStackTrace();
                request.setAttribute("error", "Failed to send OTP. Please try again.");
                dispatcher = request.getRequestDispatcher("forgotPassword.jsp");
            }

        } else {
            request.setAttribute("error", "Please enter a valid email address.");
            dispatcher = request.getRequestDispatcher("forgotPassword.jsp");
        }

        // Forward after all logic is complete
        if (dispatcher != null) {
            dispatcher.forward(request, response);
        }
    }
}
