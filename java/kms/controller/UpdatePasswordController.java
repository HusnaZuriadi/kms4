package kms.controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kms.dao.parentDAO;
import kms.dao.teacherDAO;

import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import org.mindrot.jbcrypt.BCrypt;

/**
 * Servlet implementation class UpdatePasswordController
 */
@WebServlet("/UpdatePasswordController")
public class UpdatePasswordController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public UpdatePasswordController() {
        super();
        // TODO Auto-generated constructor stub
    }


	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		HttpSession session = request.getSession();
		String email = request.getParameter("email");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");


        RequestDispatcher dispatcher = null;

        if (newPassword != null && confirmPassword != null && newPassword.equals(confirmPassword)) {
            if (!isStrongPassword(newPassword)) {
                request.setAttribute("message", "Password must contain at least 8 characters, uppercase, lowercase, number and symbol.");
                dispatcher = request.getRequestDispatcher("newPassword.jsp");
                dispatcher.forward(request, response);
                return;
            }

            try {
            	// Hash password
                String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());

                int rowCount = parentDAO.updateParentPassword(email, hashedPassword);
                if (rowCount == 0) {
                    rowCount = teacherDAO.updateTeacherPassword(email, hashedPassword);
                }

                if (rowCount > 0) {
                    request.setAttribute("status", "success");
                } else {
                    request.setAttribute("status", "failed");
                }

                dispatcher = request.getRequestDispatcher("newPassword.jsp");
                dispatcher.forward(request, response);

            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("status", "failed");
                dispatcher = request.getRequestDispatcher("newPassword.jsp");
                dispatcher.forward(request, response);
            }
        } else {
            request.setAttribute("message", "Passwords do not match.");
            dispatcher = request.getRequestDispatcher("newPassword.jsp");
            dispatcher.forward(request, response);
        }
    }

    private boolean isStrongPassword(String password) {
        // Minimum 8 characters, at least 1 uppercase, 1 lowercase, 1 digit, 1 special character
        String pattern = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@#$%^&+=!]).{8,}$";
        return password != null && password.matches(pattern);
    }

}
