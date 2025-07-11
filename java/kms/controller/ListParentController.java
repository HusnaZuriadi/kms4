package kms.controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kms.dao.*;
import kms.model.*;

/**
 * Servlet implementation class ListParentController
 */
@WebServlet("/ListParentController")
public class ListParentController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ListParentController() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		// Declare list to hold parents
		List<parent> parentList = parentDAO.getAllParents();
		
		// Declare map to hold number of children for each parent
        Map<Integer, Integer> childCountMap = new HashMap<>();
        
        try {
			// Get all parent data from DAO
			parentList = parentDAO.getAllParents();

			// Loop through each parent
			for (int i = 0; i < parentList.size(); i++) {
				parent p = parentList.get(i);

				// Get number of children registered under this parent
				int parentId = p.getParentId();
				int count = studentDAO.countStudentByParent(parentId);

				// Put into the map: parentId -> count
				childCountMap.put(parentId, count);
			}

			// Pass both list and count map to JSP
			request.setAttribute("parentList", parentList);
			request.setAttribute("childCountMap", childCountMap);

			// Redirect to JSP page
			RequestDispatcher rd = request.getRequestDispatcher("parentList.jsp");
			rd.forward(request, response);

		} catch (Exception e) {
			e.printStackTrace();
			// Optional: Redirect to error page
			response.sendRedirect("error.jsp");
		}
	}
	}


