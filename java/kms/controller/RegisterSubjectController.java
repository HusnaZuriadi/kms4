package kms.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kms.dao.enrollmentsDAO;
import java.io.IOException;

@WebServlet("/RegisterSubjectController")
public class RegisterSubjectController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public RegisterSubjectController() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String studIdParam = request.getParameter("studId");
            String subjectIdParam = request.getParameter("subjectId");

            if (studIdParam == null || studIdParam.isEmpty() || subjectIdParam == null || subjectIdParam.isEmpty()) {
                response.getWriter().println("Missing student or subject ID");
                return;
            }

            int studId = Integer.parseInt(studIdParam);
            int subjectId = Integer.parseInt(subjectIdParam);

            // ✅ Call DAO to insert into Enrollments table
            enrollmentsDAO.addEnrollment(studId, subjectId);

            // ✅ Redirect back to subject list
            response.sendRedirect("ListChooseSubjectController?studId=" + studId);

        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.getWriter().println("Invalid input: " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error occurred: " + e.getMessage());
        }
    }
}
