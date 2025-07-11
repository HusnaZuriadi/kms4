package kms.controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kms.dao.AttendanceDAO;
import kms.model.Attendance;

import java.io.IOException;

/**
 * Servlet implementation class UpdateAttendanceController
 */
@WebServlet("/UpdateAttendanceController")
public class UpdateAttendanceController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public UpdateAttendanceController() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String idStr = request.getParameter("attendanceId");
	    if (idStr != null && !idStr.isEmpty()) {
	        try {
	            int attendanceId = Integer.parseInt(idStr);
	            Attendance attendance = AttendanceDAO.getAttendance(attendanceId);
	            request.setAttribute("attendance", attendance);
	            RequestDispatcher req = request.getRequestDispatcher("updateAttendance.jsp");
	            req.forward(request, response);
	        } catch (NumberFormatException e) {
	            System.out.println("Invalid attendanceId: " + idStr);
	            response.sendRedirect("ListAttendanceController");
	        }
	    } else {
	        System.out.println("Missing attendanceId parameter");
	        response.sendRedirect("ListAttendanceController");
	    }
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	    Attendance attendance = new Attendance();

	    try {
	        // Parse & validate attendanceId
	        String idStr = request.getParameter("attendanceId");
	        if (idStr == null || idStr.trim().isEmpty()) throw new NumberFormatException("Missing attendanceId");
	        attendance.setAttendanceId(Integer.parseInt(idStr));

	        // Parse & validate attendanceDate
	        String dateStr = request.getParameter("attendanceDate");
	        if (dateStr == null || dateStr.trim().isEmpty()) throw new IllegalArgumentException("Missing attendanceDate");
	        attendance.setAttendanceDate(java.sql.Date.valueOf(dateStr));

	        // Parse & validate student ID
	        String studIdStr = request.getParameter("studId");
	        if (studIdStr == null || studIdStr.trim().isEmpty()) throw new NumberFormatException("Missing studId");
	        attendance.setStudId(Integer.parseInt(studIdStr));

	     // Attendance status
	        String status = request.getParameter("attendanceStatus");
	        attendance.setAttendanceStatus(status);

	        // Check-in & checkout
	        String checkinStr = request.getParameter("checkinTime");
	        String checkoutStr = request.getParameter("checkoutTime");

	        if ("Present".equalsIgnoreCase(status)) {
	            if (checkinStr != null && !checkinStr.trim().isEmpty()) {
	                checkinStr = checkinStr.replace("T", " ") + ":00";
	                attendance.setCheckinTime(java.sql.Timestamp.valueOf(checkinStr));
	            }

	            if (checkoutStr != null && !checkoutStr.trim().isEmpty()) {
	                checkoutStr = checkoutStr.replace("T", " ") + ":00";
	                attendance.setCheckoutTime(java.sql.Timestamp.valueOf(checkoutStr));
	            }
	        } else {
	            attendance.setCheckinTime(null);
	            attendance.setCheckoutTime(null);
	        }


	        // Parse & validate temperature
	        String tempStr = request.getParameter("checkinTemp");
	        if (tempStr != null && !tempStr.trim().isEmpty() && !tempStr.equals("-")) {
	            attendance.setCheckinTemp(Double.parseDouble(tempStr));
	        } else {
	            attendance.setCheckinTemp(0.0); // or set to null if DB allows
	        }


	        // Update and forward
	        AttendanceDAO.updateAttendance(attendance);
	     // Redirect back to the attendance list with the same filter date
	        String filterDate = request.getParameter("filterDate"); // get from hidden input
	        if (filterDate == null || filterDate.trim().isEmpty()) {
	            filterDate = dateStr; // fallback to attendanceDate
	        }
	        String age = request.getParameter("age");
	        if (age != null && !age.trim().isEmpty()) {
	            response.sendRedirect("ListAttendanceController?filterDate=" + filterDate + "&age=" + age);
	        } else {
	            response.sendRedirect("ListAttendanceController?filterDate=" + filterDate);
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	        response.sendRedirect("errorPage.jsp?msg=" + e.getMessage());
	    }
	}


}
