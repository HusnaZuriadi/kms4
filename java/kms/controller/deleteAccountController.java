package kms.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kms.dao.parentDAO;
import kms.dao.teacherDAO;
import kms.model.teacher;

import java.io.IOException;

/**
 * Servlet implementation class deleteAccountController
 */
@WebServlet("/deleteAccountController")
public class deleteAccountController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public deleteAccountController() {
        super();
        // TODO Auto-generated constructor stub
    }


	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		    int id = Integer.parseInt(request.getParameter("id"));
		    String role = request.getParameter("role");
		    String inputPassword = request.getParameter("password");

		    HttpSession session = request.getSession();
		    Object user = session.getAttribute("user");

		    if (user instanceof teacher) {
		        teacher admin = (teacher) user;
		        String adminPassword = admin.getTeacherPass(); // password dari session

		        // Compare password yang user type dalam form
		        if (teacherDAO.checkPassword(inputPassword, adminPassword)) {
		            if ("parent".equalsIgnoreCase(role)) {
		                parentDAO.deleteParent(id);
		            } else if ("teacher".equalsIgnoreCase(role)) {
		                teacherDAO.deleteTeacher(id);
		            }

		            response.sendRedirect("List" + role.substring(0, 1).toUpperCase() + role.substring(1) + "Controller");
		        } else {
		            response.getWriter().println("<script>alert('Wrong admin password.'); window.history.back();</script>");
		        }
		    } else {
		        response.sendRedirect("login.jsp");
		    }
		}

	}
