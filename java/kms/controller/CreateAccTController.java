package kms.controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import kms.dao.teacherDAO;
import kms.model.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/CreateAccTController")
public class CreateAccTController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public CreateAccTController() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("=== doGet() called ===");
        
        // Check if this is a success redirect
        String success = request.getParameter("success");
        if ("true".equals(success)) {
            System.out.println("Success parameter detected, showing success page");
            
            // Forward to success page or JSP with success flag
            request.setAttribute("showSuccessModal", true);
            
            // Get admin list for form
            try {
                List<teacher> adminList = teacherDAO.getAllAdmins();
                request.setAttribute("adminList", adminList);
            } catch (Exception e) {
                System.err.println("Error loading admin list: " + e.getMessage());
            }
            
            RequestDispatcher rd = request.getRequestDispatcher("createTeacher.jsp");
            rd.forward(request, response);
            return;
        }
        
        try {
            List<teacher> adminList = teacherDAO.getAllAdmins();
            System.out.println("Admin list size: " + (adminList != null ? adminList.size() : "null"));
            request.setAttribute("adminList", adminList);

            RequestDispatcher rd = request.getRequestDispatcher("createTeacher.jsp");
            rd.forward(request, response);
        } catch (Exception e) {
            System.err.println("Error in doGet(): " + e.getMessage());
            e.printStackTrace();
            throw new ServletException("Error loading admin list", e);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("=== doPost() called ===");
        
        try {
            // Get parameters
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String pass = request.getParameter("password");
            String role = request.getParameter("role");
            String phone = request.getParameter("phone");
            String type = request.getParameter("teacherType");
            String adminIdParam = request.getParameter("adminId");

            // Debug: Print all received parameters
            System.out.println("Received parameters:");
            System.out.println("- name: " + name);
            System.out.println("- email: " + email);
            System.out.println("- password: " + (pass != null ? "[HIDDEN]" : "null"));
            System.out.println("- role: " + role);
            System.out.println("- phone: " + phone);
            System.out.println("- teacherType: " + type);
            System.out.println("- adminId: " + adminIdParam);

            // ========== Server-side validation ==========
            System.out.println("=== Starting validation ===");

            // Check for null/empty required fields
            if (name == null || name.trim().isEmpty()) {
                System.out.println("Validation failed: Name is empty");
                request.setAttribute("error", "Name is required");
                doGet(request, response);
                return;
            }

            if (email == null || email.trim().isEmpty()) {
                System.out.println("Validation failed: Email is empty");
                request.setAttribute("error", "Email is required");
                doGet(request, response);
                return;
            }

            if (pass == null || pass.trim().isEmpty()) {
                System.out.println("Validation failed: Password is empty");
                request.setAttribute("error", "Password is required");
                doGet(request, response);
                return;
            }

            if (role == null || role.trim().isEmpty()) {
                System.out.println("Validation failed: Role is empty");
                request.setAttribute("error", "Role is required");
                doGet(request, response);
                return;
            }

            if (phone == null || phone.trim().isEmpty()) {
                System.out.println("Validation failed: Phone is empty");
                request.setAttribute("error", "Phone is required");
                doGet(request, response);
                return;
            }

            // Validate email format
            if (!email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {
                System.out.println("Validation failed: Invalid email format");
                request.setAttribute("error", "Invalid email format");
                doGet(request, response);
                return;
            }

            // Validate phone format (more flexible)
            if (!phone.matches("^01[0-9]-?[0-9]{7,8}$")) {
                System.out.println("Validation failed: Invalid phone format: " + phone);
                request.setAttribute("error", "Invalid phone number format");
                doGet(request, response);
                return;
            }

            // Validate role-specific requirements
            if ("Teacher".equalsIgnoreCase(role)) {
                if (type == null || type.trim().isEmpty()) {
                    System.out.println("Validation failed: Teacher type is required for Teacher role");
                    request.setAttribute("error", "Teacher type is required");
                    doGet(request, response);
                    return;
                }
            }

            System.out.println("=== Validation passed ===");

            // ========== Create teacher object ==========
            System.out.println("=== Creating teacher object ===");
            
            teacher teach;

            if ("Admin".equalsIgnoreCase(role)) {
                System.out.println("Creating Admin (fullTime)");
                teach = new fullTime();
                type = "FullTime"; // Override type for admin
            } else if ("FullTime".equalsIgnoreCase(type)) {
                System.out.println("Creating FullTime teacher");
                teach = new fullTime();
            } else if ("PartTime".equalsIgnoreCase(type)) {
                System.out.println("Creating PartTime teacher");
                teach = new partTime();
            } else {
                System.out.println("Creating generic teacher (fallback)");
                teach = new teacher();
            }

            // Set basic properties
            teach.setTeacherName(name.trim());
            teach.setTeacherEmail(email.trim());
            teach.setTeacherPass(pass);
            teach.setTeacherPhone(phone.trim());
            teach.setTeacherRole(role);
            teach.setTeacherType(type);

            // Set adminId if present
            if (adminIdParam != null && !adminIdParam.trim().isEmpty()) {
                try {
                    int adminId = Integer.parseInt(adminIdParam);
                    teach.setAdminId(adminId);
                    System.out.println("Set adminId: " + adminId);
                } catch (NumberFormatException e) {
                    System.out.println("Invalid adminId format, setting to null: " + adminIdParam);
                    teach.setAdminId(null);
                }
            } else {
                teach.setAdminId(null);
                System.out.println("No adminId provided, setting to null");
            }

            // ========== Handle FullTime & PartTime specific fields ==========
            System.out.println("=== Processing type-specific fields ===");
            
            try {
                if (teach instanceof fullTime) {
                    System.out.println("Processing fullTime specific fields");
                    String salaryStr = request.getParameter("salary");
                    if (salaryStr != null && !salaryStr.trim().isEmpty()) {
                        double salary = Double.parseDouble(salaryStr);
                        ((fullTime) teach).setSalary(salary);
                        System.out.println("Set salary: " + salary);
                    } else {
                        System.out.println("No salary provided for fullTime");
                    }
                } else if (teach instanceof partTime) {
                    System.out.println("Processing partTime specific fields");
                    String contractStr = request.getParameter("contract");
                    String hourlyStr = request.getParameter("hourlyRate");

                    if (contractStr != null && !contractStr.trim().isEmpty()) {
                        int contract = Integer.parseInt(contractStr);
                        ((partTime) teach).setContract(contract);
                        System.out.println("Set contract: " + contract);
                    }

                    if (hourlyStr != null && !hourlyStr.trim().isEmpty()) {
                        double hourly = Double.parseDouble(hourlyStr);
                        ((partTime) teach).setHourlyRate(hourly);
                        System.out.println("Set hourlyRate: " + hourly);
                    }
                }
            } catch (NumberFormatException e) {
                System.err.println("Number format error: " + e.getMessage());
                request.setAttribute("error", "Invalid number format in salary/contract fields");
                doGet(request, response);
                return;
            }

            // ========== Save teacher ==========
            System.out.println("=== Calling teacherDAO.addTeacher() ===");
            
            teacherDAO.addTeacher(teach, type);
            
            System.out.println("=== teacherDAO.addTeacher() completed successfully ===");

            // ========== SUCCESS - Redirect with success parameter ==========
            System.out.println("=== Redirecting to success page ===");
            response.sendRedirect("CreateAccTController?success=true");
            
        } catch (Exception e) {
            System.err.println("=== Exception in doPost(): " + e.getMessage());
            e.printStackTrace();
            
            // Set error message and forward back to form
            request.setAttribute("error", "An error occurred while creating the account: " + e.getMessage());
            doGet(request, response);
        }
    }
}