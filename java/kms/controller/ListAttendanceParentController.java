package kms.controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kms.dao.AttendanceDAO;
import kms.dao.studentDAO;
import kms.model.Attendance;
import kms.model.parent;
import kms.model.student;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

/**
 * Servlet implementation class ListAttendanceParentController
 */
@WebServlet("/ListAttendanceParentController")
public class ListAttendanceParentController extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    	 HttpSession session = request.getSession();
         parent p = (parent) session.getAttribute("user");

         int parentId = p.getParentId();
         String selectedStudIdStr = request.getParameter("studId");
         String selectedMonth = request.getParameter("month");

         // Get children of the parent
         List<student> children = studentDAO.getStudentsByParentId(parentId);
         request.setAttribute("children", children);

         // Default: auto select current month
         if (selectedMonth == null || selectedMonth.isEmpty()) {
             LocalDate today = LocalDate.now();
             selectedMonth = today.toString().substring(0, 7); // e.g., "2025-07"
         }
         request.setAttribute("selectedMonth", selectedMonth);

         if (selectedStudIdStr != null && !selectedStudIdStr.isEmpty()) {
             int studId = Integer.parseInt(selectedStudIdStr);

             // Get all attendance for this student in the selected month
             List<Attendance> attendanceList = AttendanceDAO.getAttendanceByStudentAndMonth(studId, selectedMonth);
             request.setAttribute("attendanceList", attendanceList);
             request.setAttribute("selectedStudId", studId);
         }

         RequestDispatcher rd = request.getRequestDispatcher("AttendanceListParent.jsp");
         rd.forward(request, response);
     }

     protected void doPost(HttpServletRequest request, HttpServletResponse response)
             throws ServletException, IOException {
         doGet(request, response);
     }
}

