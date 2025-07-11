package kms.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kms.dao.AttendanceDAO;
import kms.dao.studentDAO;
import kms.dao.subjectDAO;
import kms.model.student;
import kms.model.teacher;
import kms.model.subject;

import kms.service.QuoteService;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Base64;
import java.util.List;

@WebServlet("/TeacherHomeController")
public class TeacherHomeController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public TeacherHomeController() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        teacher currentTeacher = (teacher) session.getAttribute("user");

        // Handle null session
        if (currentTeacher == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
        	// Get subject(s) for this teacher
        	List<subject> subjectList = subjectDAO.getSubjectsByTeacherId(currentTeacher.getTeacherId());
        	String subjectName = "-";
        	if (!subjectList.isEmpty()) {
        	    subjectName = subjectList.get(0).getSubjectName(); // ambil yang pertama sahaja
        	}

            // ✅ Get the total number of students under this teacher
            int studentCount = studentDAO.countStudentsByTeacherId(currentTeacher.getTeacherId());
            //get attendance count sysdate
          
            int attendanceCount = AttendanceDAO.countTodayAttendance();
            // Get random quote
            String randomQuote = QuoteService.getRandomQuote();

            // Get today’s birthday student (show the first if more than one)
            List<student> birthdayStudents = studentDAO.getBirthdaysToday();
            String studName = "-";
            String studBirthDate = "-";
            String studPhoto = "";

            if (!birthdayStudents.isEmpty()) {
                student birthdayStudent = birthdayStudents.get(0);
                studName = birthdayStudent.getStudName();
                studBirthDate = birthdayStudent.getStudBirthDate().toString();
                if (birthdayStudent.getStudPhoto() != null) {
                    studPhoto = Base64.getEncoder().encodeToString(birthdayStudent.getStudPhoto());
                }
            }

            // Set attributes to pass to JSP
            request.setAttribute("subjectName", subjectName);
            request.setAttribute("studentCount", studentCount); // ✅ Set the count here
            request.setAttribute("attendanceCount", attendanceCount);
            request.setAttribute("randomQuote", randomQuote);
            request.setAttribute("studName", studName);
            request.setAttribute("studBirthDate", studBirthDate);
            request.setAttribute("studPhoto", studPhoto);

            // Forward to the JSP page
            request.getRequestDispatcher("teacherHome.jsp").forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Database error in TeacherHomeController", e);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
