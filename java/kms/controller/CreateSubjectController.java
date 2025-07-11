package kms.controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kms.dao.subjectDAO;
import kms.dao.teacherDAO;
import kms.model.subject;
import kms.model.teacher;

import java.io.IOException;
import java.util.List;

@WebServlet("/CreateSubjectController")
public class CreateSubjectController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public CreateSubjectController() {
        super();
    }

    // Show form with teacher list
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Fetch teacher list from DB
    	 List<teacher> teacherList = teacherDAO.getAllTeacher();
    	 
        // Set to request scope
    	 request.setAttribute("teacherList", teacherList);

        // Forward to form JSP
    	 RequestDispatcher rd = request.getRequestDispatcher("createSubject.jsp");
         rd.forward(request, response);
    }

    // Handle form submission
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Create a new Subject object
    	 subject sub = new subject();

        // Get and set subject name
        sub.setSubjectName(request.getParameter("subjectName"));
        sub.setTeacherId(Integer.parseInt(request.getParameter("teacherId")));
        sub.setAgeGroup(Integer.parseInt(request.getParameter("ageGroup")));
     

        // Add subject to DB
        subjectDAO.addSubject(sub);
        
        response.sendRedirect("ListSubjectController");

        // Load updated subject list
        //request.setAttribute("subjects", subjectDAO.getAllSubjects());

        // Forward to subject list page
       //RequestDispatcher rd = request.getRequestDispatcher("listSubject.jsp");
        //rd.forward(request, response);
    }
}