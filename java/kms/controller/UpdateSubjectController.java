package kms.controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kms.dao.subjectDAO;
import kms.dao.teacherDAO;
import kms.model.subject;
import kms.model.teacher;

import java.io.IOException;
import java.util.List;

/**
 * Servlet implementation class UpdateSubjectController
 */
@WebServlet("/UpdateSubjectController")
public class UpdateSubjectController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public UpdateSubjectController() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		 int subjectId = Integer.parseInt(request.getParameter("subjectId"));
		 
		// Get subject data
		subject existingSubject = subjectDAO.getSubjectById(subjectId);

        // Get teacher list for dropdown
        List<teacher> teacherList = teacherDAO.getAllTeacher();

        request.setAttribute("subject", existingSubject);
        request.setAttribute("teacherList", teacherList);
        
        // Forward to update form
        RequestDispatcher rd = request.getRequestDispatcher("updateSubject.jsp");
        rd.forward(request, response);

	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		 subject sub = new subject();

			// Get updated form data
			    sub.setSubjectId(Integer.parseInt(request.getParameter("subjectId")));
			    sub.setSubjectName(request.getParameter("subjectName"));
			    sub.setTeacherId(Integer.parseInt(request.getParameter("teacherId")));
			    
			    // Call update method instead of insert
			    subjectDAO.updateSubject(sub);

			    // Redirect to the updated subject list
			    response.sendRedirect("ListSubjectController");

	}

}
