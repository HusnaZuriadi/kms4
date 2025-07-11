package kms.controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kms.dao.enrollmentsDAO;
import kms.dao.studentDAO;
import kms.dao.subjectDAO;
import kms.model.student;
import kms.model.subject;

import java.io.IOException;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * Servlet implementation class ListChooseSubjectController
 */
@WebServlet("/ListChooseSubjectController")
public class ListChooseSubjectController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ListChooseSubjectController() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		 HttpSession session = request.getSession();
		    Integer parentId = (Integer) session.getAttribute("parentId");

		    if (parentId == null) {
		        response.sendRedirect("login.jsp");
		        return;
		    }

		    int selectedStudId = 0;
		    String studIdParam = request.getParameter("studId");
		    if (studIdParam != null && !studIdParam.isEmpty()) {
		        try {
		            selectedStudId = Integer.parseInt(studIdParam);
		        } catch (NumberFormatException e) {
		            selectedStudId = 0;
		        }
		    }

		    List<student> studentList = studentDAO.getStudentsByParentId(parentId);
		    List<subject> subjectList = subjectDAO.getSubjectsByStudentId(selectedStudId);

		    // ✅ Get subjectIds that student is already enrolled in
		    Set<Integer> registeredSubjectIds = new HashSet<>(enrollmentsDAO.getRegisteredSubjectIds(selectedStudId));

		    request.setAttribute("students", studentList);
		    request.setAttribute("subjectList", subjectList);
		    request.setAttribute("selectedStudId", selectedStudId);
		    request.setAttribute("registeredSubjectIds", registeredSubjectIds); // ✅

		    RequestDispatcher dispatcher = request.getRequestDispatcher("listChooseSubject.jsp");
		    dispatcher.forward(request, response);
	}

	    
	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		  int subjectId = Integer.parseInt(request.getParameter("subjectId"));
		    int studentId = Integer.parseInt(request.getParameter("studentId"));

		    // Assign subject to student
		    subjectDAO.assignSubjectToStudent(subjectId, studentId);

		    // Redirect to ListChooseSubjectController to show updated subject list
		    response.sendRedirect("ListChooseSubjectController?studentId=" + studentId);
	}

}
