package kms.controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.List;

import kms.dao.AttendanceDAO;
import kms.model.Attendance;

/**
 * Servlet implementation class ListAttendanceController
 */
@WebServlet("/ListAttendanceController")
public class ListAttendanceController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public ListAttendanceController() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String filterDate = request.getParameter("filterDate");
        String studAge = request.getParameter("selectedAge"); // match JSP param name
        String searchQuery = request.getParameter("searchQuery");

        Date dateToUse;

        // Parse date (default = today)
        if (filterDate != null && !filterDate.isEmpty()) {
            try {
                dateToUse = Date.valueOf(filterDate);
            } catch (IllegalArgumentException e) {
                dateToUse = Date.valueOf(LocalDate.now());
            }
        } else {
            dateToUse = Date.valueOf(LocalDate.now());
        }

        // Parse age 
        int age = 0;
        if (studAge != null && !studAge.isEmpty()) {
            try {
                age = Integer.parseInt(studAge);
            } catch (NumberFormatException e) {
                age = 0;
            }
        }

     // Get attendance records - only if age is selected
        List<Attendance> attendances;
        if ( age> 0) {
            // Age is selected, fetch records
        	attendances = AttendanceDAO.getAttendanceByFilters(dateToUse, age, searchQuery);
        } else {
            // No age selected - return empty list
            attendances = new java.util.ArrayList<>();
        }

        // Send filters back to JSP for UI retention
        request.setAttribute("attendances", attendances);
        request.setAttribute("filterDate", dateToUse);
        request.setAttribute("selectedAge", age);
        request.setAttribute("searchQuery", searchQuery);

        RequestDispatcher req = request.getRequestDispatcher("listAttendance.jsp");
        req.forward(request, response);
    }
}
