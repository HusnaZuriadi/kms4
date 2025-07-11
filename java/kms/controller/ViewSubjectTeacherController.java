package kms.controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kms.dao.subjectDAO;
import kms.model.subject;

import java.io.IOException;
import java.util.List;

/**
 * Servlet implementation class ViewSubjectTeacherController
 */
@WebServlet("/ViewSubjectTeacherController")
public class ViewSubjectTeacherController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ViewSubjectTeacherController() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		// Get all subjects
        List<subject> subjectList = subjectDAO.getAllSubjects();

        // Set it into the request scope for JSP
        request.setAttribute("subjectList", subjectList);

        // Forward to JSP
        RequestDispatcher dispatcher = request.getRequestDispatcher("viewSubjectT.jsp");
        dispatcher.forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
