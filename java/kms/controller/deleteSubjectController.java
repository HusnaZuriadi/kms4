package kms.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kms.dao.subjectDAO;

import java.io.IOException;

/**
 * Servlet implementation class deleteSubjectController
 */
@WebServlet("/deleteSubjectController")
public class deleteSubjectController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public deleteSubjectController() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		 // Get subjectId from request
        int subjectId = Integer.parseInt(request.getParameter("subjectId"));

        // Delete subject using DAO
        subjectDAO.deleteSubject(subjectId);
        
     // get session and role
		HttpSession session = request.getSession(false);
		if (session == null || session.getAttribute("user") == null) {
			response.sendRedirect("login.jsp");
			return;
		}
		request.setAttribute("msg", "Subject successfully deleted.");
		// Redirect back to subject list after deletion
        response.sendRedirect("ListSubjectController");
	}

	

}
