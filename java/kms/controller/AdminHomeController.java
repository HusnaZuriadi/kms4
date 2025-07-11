package kms.controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import kms.service.QuoteService;
import kms.service.TipService;
import kms.dao.parentDAO;
import kms.dao.studentDAO;
import kms.dao.teacherDAO;

import java.io.IOException;

@WebServlet("/AdminHomeController")
public class AdminHomeController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    	 HttpSession session = request.getSession();
         Integer adminId = (Integer) session.getAttribute("adminId");

         if (adminId == null) {
             response.sendRedirect("login.jsp");
             return;
         }

         // Set random quote and tip
         String quote = QuoteService.getRandomQuote();
         request.setAttribute("randomQuote", quote);

         String tip = TipService.getRandomTip();
         request.setAttribute("randomTip", tip);

         // Set birthdays and stats
         request.setAttribute("birthdaysToday", studentDAO.getTodaysBirthdays());
         request.setAttribute("totalStudents", studentDAO.countAll());
         request.setAttribute("totalParents", parentDAO.countAll());
         request.setAttribute("totalTeachers", teacherDAO.countExcludingAdmin(adminId));

         RequestDispatcher rd = request.getRequestDispatcher("adminHome.jsp");
         rd.forward(request, response);
    }
}
