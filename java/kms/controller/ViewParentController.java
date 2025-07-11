package kms.controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kms.dao.parentDAO;
import kms.dao.studentDAO;
import kms.model.parent;
import kms.model.student;

import java.io.IOException;
import java.util.List;

/**
 * Servlet implementation class ViewParentController
 */
@WebServlet("/ViewParentController")
public class ViewParentController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ViewParentController() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		try {
            int parentId = Integer.parseInt(request.getParameter("parentId"));

            // Get parent info
            parent p = parentDAO.getParent(parentId);

            // Get list of children
            List<student> student = studentDAO.getStudentsByParentId(parentId);

            // Set attributes for view
            request.setAttribute("parent", p);
            request.setAttribute("student", student);

            // Redirect to view page
            RequestDispatcher dispatcher = request.getRequestDispatcher("viewParent.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
	}


}
