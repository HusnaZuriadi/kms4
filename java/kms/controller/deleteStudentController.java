package kms.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kms.dao.studentDAO;
import kms.model.parent;

import java.io.IOException;

@WebServlet("/deleteStudentController")
public class deleteStudentController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public deleteStudentController() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// Get studId
		String studIdParam = request.getParameter("studId");
		if (studIdParam == null || studIdParam.isEmpty()) {
			response.sendRedirect("ListStudentController?msg=missingId");
			return;
		}

		int studId = Integer.parseInt(studIdParam);
		studentDAO.deleteStudent(studId); // Delete student

		// Get session and role
		HttpSession session = request.getSession(false);
		if (session == null || session.getAttribute("user") == null) {
			response.sendRedirect("login.jsp");
			return;
		}

		String role = (String) session.getAttribute("role");

		// Redirect ke page ikut role
		if ("parent".equalsIgnoreCase(role)) {
			response.sendRedirect("ListStudentController");
		} else if ("admin".equalsIgnoreCase(role)) {
			String ageParam = request.getParameter("age");
			if (ageParam != null && !ageParam.isEmpty()) {
				response.sendRedirect("ListStudentController?age=" + ageParam);
			} else {
				response.sendRedirect("ListStudentController");
			}
		}
		
		System.out.println("Received studId: " + studId);

	}
}
