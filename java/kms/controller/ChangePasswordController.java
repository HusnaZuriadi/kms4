package kms.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

import kms.dao.parentDAO;
import kms.dao.teacherDAO;
import kms.model.parent;
import kms.model.teacher;

import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/ChangePasswordController")
public class ChangePasswordController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get session and logged-in user
        HttpSession session = request.getSession(false);
        String role = (String) session.getAttribute("role");
        Object user = session.getAttribute("user");

        // Get form values
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validation
        if (!newPassword.equals(confirmPassword)) {
            session.setAttribute("msg", "New password and confirmation do not match.");
            response.sendRedirect("viewAccount.jsp");
            return;
        }

        if (user != null && role != null) {
            if (role.equals("parent") && user instanceof parent) {
                parent p = (parent) user;

                // Check current password
                if (BCrypt.checkpw(currentPassword, p.getParentPass())) {
                	String hashed = BCrypt.hashpw(newPassword, BCrypt.gensalt());
                	parentDAO.updatePassword(p.getParentId(), hashed); // ✅ saved hashed
                	p.setParentPass(hashed); // ✅ session uses the same

                    session.setAttribute("user", p);
                    session.setAttribute("msg", "Password changed successfully.");
                } else {
                    session.setAttribute("msg", "Current password is incorrect.");
                }
            } else if ((role.equals("teacher") || role.equals("admin")) && user instanceof teacher) {
                teacher t = (teacher) user;

                if (BCrypt.checkpw(currentPassword, t.getTeacherPass())) {
                	String hashed = BCrypt.hashpw(newPassword, BCrypt.gensalt());
                	teacherDAO.updatePassword(t.getTeacherId(), hashed); // ✅ saved hashed
                	t.setTeacherPass(hashed); // ✅ session uses the same

                    session.setAttribute("user", t);
                    session.setAttribute("msg", "Password changed successfully.");
                } else {
                    session.setAttribute("msg", "Current password is incorrect.");
                }
            }
        } else {
            session.setAttribute("msg", "Please log in first.");
        }

        response.sendRedirect("viewAccount.jsp");
    }
}
