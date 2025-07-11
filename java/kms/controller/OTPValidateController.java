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
 * Servlet implementation class OTPValidateController
 */
@WebServlet("/OTPValidateController")
public class OTPValidateController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public OTPValidateController() {
        super();
        // TODO Auto-generated constructor stub
    }

    protected void service(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        RequestDispatcher dispatcher = null;

        try {
            int enteredOtp = Integer.parseInt(request.getParameter("otp"));
            int sessionOtp = (int) session.getAttribute("otp");
            String email = (String) session.getAttribute("email");

            if (enteredOtp == sessionOtp) {
                request.setAttribute("email", email); // Pass email to new password page
                dispatcher = request.getRequestDispatcher("newPassword.jsp");
            } else {
                request.setAttribute("message", "Wrong OTP. Please try again.");
                dispatcher = request.getRequestDispatcher("EnterOTP.jsp");
            }

        } catch (Exception e) {
            request.setAttribute("message", "An error occurred. Please try again.");
            dispatcher = request.getRequestDispatcher("EnterOTP.jsp");
        }

        dispatcher.forward(request, response);
    }

}
