package kms.controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kms.dao.teacherDAO;
import kms.model.teacher;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Servlet implementation class ListTeacherController
 */
@WebServlet("/ListTeacherController")
public class ListTeacherController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ListTeacherController() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		 HttpSession session = request.getSession();
	        teacher currentAdmin = (teacher) session.getAttribute("user"); // current logged-in admin

	        // Get all teachers (including admins)
	        List<teacher> allTeachers = teacherDAO.getAllTeacher();

	        // Filter out the current admin by comparing teacherId
	        List<teacher> filteredList = allTeachers.stream()
	                .filter(t -> t.getTeacherId() != currentAdmin.getTeacherId())
	                .collect(Collectors.toList());

	        request.setAttribute("teacherList", filteredList);

	        RequestDispatcher dispatcher = request.getRequestDispatcher("teacherList.jsp");
	        dispatcher.forward(request, response);
	    }
	}


