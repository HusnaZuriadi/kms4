package kms.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kms.dao.studentDAO;
import kms.dao.subjectDAO;
import kms.dao.studentProgressDAO;
import kms.model.student;
import kms.model.subject;
import kms.model.StudentProgress;

import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/ProgressController")
public class ProgressController extends HttpServlet {
	
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
	        throws ServletException, IOException {
	    // Default month = current month (YYYY-MM)
	    String month = java.time.LocalDate.now().toString().substring(0, 7);

	    // Get students who haven't had progress recorded yet
	    List<student> students = studentDAO.getStudentsWithoutProgressThisMonth(month);

	    request.setAttribute("progressMonth", month);
	    request.setAttribute("students", students);

	    // Forward to JSP
	    request.getRequestDispatcher("createStudentProgress.jsp").forward(request, response);
	}


    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        switch (action) {
            case "selectStudent":
                handleStudentSelection(request, response);
                break;
            case "saveProgress":
                handleSaveProgress(request, response);
            default:
                response.sendRedirect("createStudentProgress.jsp");
        }
    }

    private void handleStudentSelection(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String studIdStr = request.getParameter("studId");

            if (studIdStr == null || studIdStr.isEmpty()) {
                request.setAttribute("error", "Please select a student.");
                request.getRequestDispatcher("createStudentProgress.jsp").forward(request, response);
                return;
            }

            int studId = Integer.parseInt(studIdStr);
            String month = request.getParameter("progressMonth");

            student selectedStudent = studentDAO.getStudent(studId);
            List<subject> enrolledSubjects = subjectDAO.getSubjectsByStudentId(studId);
            List<student> students = studentDAO.getStudentsWithoutProgressThisMonth(month);

            request.setAttribute("students", students);
            request.setAttribute("selectedStudent", selectedStudent);
            request.setAttribute("enrolledSubjects", enrolledSubjects);
            request.setAttribute("progressMonth", month);

            request.getRequestDispatcher("createStudentProgress.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            e.printStackTrace();
            request.setAttribute("error", "Invalid student ID.");
            request.getRequestDispatcher("createStudentProgress.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Something went wrong during student selection.");
            request.getRequestDispatcher("createStudentProgress.jsp").forward(request, response);
        }
    }



    private void handleSaveProgress(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int studId = Integer.parseInt(request.getParameter("studId"));
        String monthStr = request.getParameter("progressMonth");
        String notes = request.getParameter("notes");

        // Parse month into Date format (e.g. 2024-06-01)
        Date month = Date.valueOf(monthStr + "-01");

        List<subject> subjects = subjectDAO.getSubjectsByStudentId(studId);
        List<Integer> marks = new ArrayList<>();

        for (int i = 0; i < subjects.size(); i++) {
            int subjectId = subjects.get(i).getSubjectId();
            String markStr = request.getParameter("mark_" + subjectId);
            int mark = (markStr != null && !markStr.isEmpty()) ? Integer.parseInt(markStr) : 0;
            marks.add(mark);
        }


        // Save each subject's mark
        for (int i = 0; i < subjects.size(); i++) {
            StudentProgress progress = new StudentProgress();
            progress.setMonths(month);
            progress.setMarks(marks.get(i));
            progress.setTeacherComment(notes);

            studentProgressDAO.addProgressWithEnrollment(studId, subjects.get(i).getSubjectId(), progress);
        }

        response.sendRedirect("createStudentProgress.jsp?success=true");
    }
}