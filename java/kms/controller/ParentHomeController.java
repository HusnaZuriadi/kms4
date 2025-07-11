package kms.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kms.dao.parentDAO;
import kms.dao.studentDAO;
import kms.model.parent;
import kms.model.student;
import kms.service.QuoteService;

import java.io.IOException;
import java.util.List;

/**
 * Servlet implementation class ParentHomeController
 */
@WebServlet("/ParentHomeController")
public class ParentHomeController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ParentHomeController() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		 parent parentUser = (parent) request.getSession().getAttribute("user");

	        if (parentUser == null) {
	            response.sendRedirect("login.jsp");
	            return;
	        }

	        int parentId = parentUser.getParentId();

	        // Load data
	        List<student> studentList = studentDAO.getStudentsByParentId(parentId);
	        String quote = QuoteService.getRandomQuote();

	        request.setAttribute("studentList", studentList);
	        request.setAttribute("randomQuote", quote);
	      

	        // Forward to JSP
	        request.getRequestDispatcher("parentHome.jsp").forward(request, response);
	    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
	}

}
