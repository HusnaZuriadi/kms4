package kms.controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Servlet implementation class ValidateOTPController
 */
@WebServlet("/ValidateOTPController")
public class ValidateOTPController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ValidateOTPController() {
        super();
        // TODO Auto-generated constructor stub
    }

    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Object otpObj = session.getAttribute("otp");

        RequestDispatcher dispatcher = null;

        if (otpObj == null) {
            request.setAttribute("message", "Session expired or OTP missing. Please request again.");
            dispatcher = request.getRequestDispatcher("forgotPassword.jsp");
            dispatcher.forward(request, response);
            return;
        }

        int otp = (int) otpObj;
        int value = Integer.parseInt(request.getParameter("otp"));

        if (value == otp) {
            String email = (String) session.getAttribute("email");
            request.setAttribute("email", email);
            request.setAttribute("status", "success");
            dispatcher = request.getRequestDispatcher("newPassword.jsp");
        } else {
            request.setAttribute("message", "Wrong OTP");
            dispatcher = request.getRequestDispatcher("EnterOTP.jsp");
        }

        dispatcher.forward(request, response);
    }

}
