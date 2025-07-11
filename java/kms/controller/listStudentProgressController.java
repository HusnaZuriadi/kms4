package kms.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kms.dao.studentDAO;
import kms.model.student;

import java.io.IOException;
import java.util.List;

/**
 * Servlet implementation class listStudentProgressController
 */
@WebServlet("/listStudentProgressController")
public class listStudentProgressController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public listStudentProgressController() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		  String month = request.getParameter("month");
	        String ageGroupParam = request.getParameter("ageGroup");

	        List<student> studentList = null;
	        int selectedClass = 0;

	        if (month != null && ageGroupParam != null && !ageGroupParam.isEmpty()) {
	            try {
	                selectedClass = Integer.parseInt(ageGroupParam);
	                studentList = studentDAO.getStudentsByAgeAndMonth(selectedClass, month.substring(0, 7));
	            } catch (Exception e) {
	                e.printStackTrace();
	            }
	        }

	        request.setAttribute("studentList", studentList);
	        request.setAttribute("selectedMonth", month);
	        request.setAttribute("selectedClass", selectedClass);

	        request.getRequestDispatcher("istStudentProgress.jsp").forward(request, response);
	    }
}
