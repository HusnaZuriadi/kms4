package kms.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kms.dao.subjectDAO;
import kms.dao.teacherDAO;
import kms.model.fullTime;
import kms.model.partTime;
import kms.model.subject;
import kms.model.teacher;

import java.io.IOException;
import java.util.List;

/**
 * Servlet implementation class ViewTeacherController
 */
@WebServlet("/ViewTeacherController")
public class ViewTeacherController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ViewTeacherController() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		try {
			
		    int teacherId = Integer.parseInt(request.getParameter("teacherId"));
		    
		    teacher t = teacherDAO.getTeacher(teacherId);
		    
		    if (t instanceof fullTime) {
		        request.setAttribute("type", "fullTime");
		    } else if (t instanceof partTime) {
		        request.setAttribute("type", "partTime");
		    }
		    
		    List<subject> listSubject = subjectDAO.getSubjectsByTeacherId(teacherId);

		    request.setAttribute("teacher", t);
		    request.setAttribute("listSubject", listSubject);
		    request.getRequestDispatcher("viewTeacher.jsp").forward(request, response);
		}
		
		catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        } 
	}

}
