package kms.controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kms.dao.enrollmentsDAO;
import kms.dao.subjectDAO;
import kms.model.subject;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/AddChooseSubjectController")
public class AddChooseSubjectController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public AddChooseSubjectController() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String studIdParam = request.getParameter("studId");
        int studId = 0;

        if (studIdParam != null && !studIdParam.isEmpty()) {
            studId = Integer.parseInt(studIdParam);
            request.setAttribute("selectedStudId", studId);
        }

        // Get all subjects
        List<subject> allSubjects = subjectDAO.getAllSubjects();

        // Get registered subject IDs for this student
        List<Integer> registeredIds = enrollmentsDAO.getRegisteredSubjectIds(studId);

        // Filter subjects: only show those not registered
        List<subject> unregisteredSubjects = new ArrayList<>();
        for (subject sub : allSubjects) {
            if (!registeredIds.contains(sub.getSubjectId())) {
                unregisteredSubjects.add(sub);
            }
        }

        request.setAttribute("subjectList", unregisteredSubjects);
        RequestDispatcher dispatcher = request.getRequestDispatcher("addChooseSubject.jsp");
        dispatcher.forward(request, response);
    }
}
