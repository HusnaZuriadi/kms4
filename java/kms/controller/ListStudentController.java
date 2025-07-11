package kms.controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kms.dao.studentDAO;
import kms.model.parent;
import kms.model.student;

import java.io.IOException;
import java.util.List;

@WebServlet("/ListStudentController")
public class ListStudentController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public ListStudentController() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);
		
		
		// Check if user is logged in
		if (session == null || session.getAttribute("user") == null) {
			response.sendRedirect("login.jsp?msg=sessionExpired");
			return;
		}

		String role = (String) session.getAttribute("role");
		request.setAttribute("role", role); // ➕ Tambah ni untuk digunakan di JSP

		if (!"parent".equalsIgnoreCase(role) && !"admin".equalsIgnoreCase(role)) {
			response.sendRedirect("login.jsp?msg=unauthorized");
			return;
		}

		 RequestDispatcher rd;

	        if ("parent".equalsIgnoreCase(role)) {
	            // Parent view: show children only
	            parent p = (parent) session.getAttribute("user");
	            int parentId = p.getParentId();
	            List<student> studentList = studentDAO.getStudentsByParentId(parentId);
	            request.setAttribute("students", studentList);
	            rd = request.getRequestDispatcher("listStudent.jsp");

	        } else {
	            // Admin view: filter by age
	            String ageParam = request.getParameter("age");

	            if (ageParam != null && !ageParam.isEmpty()) {
	                try {
	                    int age = Integer.parseInt(ageParam.trim());
	                    List<student> studentList = studentDAO.getStudentsByAge(age);
	                    request.setAttribute("students", studentList);
	                } catch (NumberFormatException e) {
	                    // age parameter invalid
	                    request.setAttribute("students", null);
	                }
	            }

	            rd = request.getRequestDispatcher("ListStudentAdmin.jsp");
	        }

	        rd.forward(request, response);
	    }
	
}