package kms.controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

import kms.dao.AttendanceDAO;

/**
 * Servlet implementation class ViewAttendanceController
 */
@WebServlet("/ViewAttendanceController")
public class ViewAttendanceController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ViewAttendanceController() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		// Get attendanceId from request
        int attendanceId = Integer.parseInt(request.getParameter("attendanceId"));

        // Load attendance record
        request.setAttribute("attendance", AttendanceDAO.getAttendance(attendanceId));

        // Forward to view page
        RequestDispatcher req = request.getRequestDispatcher("viewAttendanceAdmin.jsp");
        req.forward(request, response);
	}

}
