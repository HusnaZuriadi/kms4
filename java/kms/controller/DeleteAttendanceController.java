package kms.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kms.dao.AttendanceDAO;
import kms.model.Attendance;

import java.io.IOException;
import java.sql.Date;

@WebServlet("/DeleteAttendanceController")
public class DeleteAttendanceController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public DeleteAttendanceController() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	    try {
	        String idParam = request.getParameter("attendanceId");
	        if (idParam == null || idParam.trim().isEmpty()) {
	            throw new IllegalArgumentException("Attendance ID is missing.");
	        }

	        int attendanceId = Integer.parseInt(idParam);

	        // Delete logic
	        Attendance attendance = AttendanceDAO.getAttendance(attendanceId);
	        AttendanceDAO.deleteAttendance(attendanceId);

	        String filterDate = request.getParameter("filterDate");
	        String filterAge = request.getParameter("filterAge");

	        String redirectUrl = "ListAttendanceController";
	        if (filterDate != null && filterAge != null) {
	            redirectUrl += "?filterDate=" + filterDate + "&filterAge=" + filterAge;
	        }

	        response.sendRedirect(redirectUrl);
	    } catch (Exception e) {
	        e.printStackTrace();
	        response.sendRedirect("errorPage.jsp?msg=Failed to delete: " + e.getMessage());
	    }
	}


}
