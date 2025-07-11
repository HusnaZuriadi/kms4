package kms.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kms.dao.enrollmentsDAO;

import java.io.IOException;

@WebServlet("/DeleteChooseSubjectController")
public class DeleteChooseSubjectController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int studId = Integer.parseInt(request.getParameter("studId"));
            int subjectId = Integer.parseInt(request.getParameter("subjectId"));

            // Call DAO to delete subject for the student
            enrollmentsDAO.deleteEnrollment(studId, subjectId);

            // Redirect back to list with updated data
            response.sendRedirect("ListChooseSubjectController?studId=" + studId);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}

