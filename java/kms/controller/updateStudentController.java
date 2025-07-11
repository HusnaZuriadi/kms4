package kms.controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import kms.dao.studentDAO;
import kms.helper.CalculateAge;
import kms.model.student;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Date;

@MultipartConfig
@WebServlet("/updateStudentController")
public class updateStudentController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public updateStudentController() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int studId = Integer.parseInt(request.getParameter("studId"));
        student stud = studentDAO.getStudent(studId);

        int age = CalculateAge.calculateAgeStud(stud.getStudBirthDate());

        request.setAttribute("student", stud);
        request.setAttribute("studAge", age); // 🟢 Hantar umur ke JSP

        RequestDispatcher req = request.getRequestDispatcher("updateStudent.jsp");
        req.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        student stud = new student();

        // Parse student ID
        String studIdStr = request.getParameter("studId");
        int studId = 0;
        if (studIdStr != null && !studIdStr.isEmpty()) {
            studId = Integer.parseInt(studIdStr);
        }
        stud.setStudId(studId);

        stud.setStudName(request.getParameter("name"));
        stud.setStudGender(request.getParameter("gender"));
        stud.setStudAddress(request.getParameter("address"));

        // Parse Date of Birth
        String dobStr = request.getParameter("dob");
        if (dobStr != null && !dobStr.isEmpty()) {
            stud.setStudBirthDate(Date.valueOf(dobStr));
        }

        // 🟢 Get role & parentId from session safely
        HttpSession session = request.getSession(false);
        String role = null;
        int parentId = 0;

        if (session != null) {
            role = (String) session.getAttribute("role");

            Object parentIdObj = session.getAttribute("parentId");
            if (parentIdObj instanceof Integer) {
                parentId = (Integer) parentIdObj;
            } else if (parentIdObj instanceof String) {
                try {
                    parentId = Integer.parseInt((String) parentIdObj);
                } catch (NumberFormatException e) {
                    parentId = 0;
                }
            }

            if ("parent".equals(role)) {
                stud.setParentId(parentId);
            }
        }

        // Upload photo
        Part photoPart = request.getPart("photo");
        if (photoPart != null && photoPart.getSize() > 0) {
            InputStream photoStream = photoPart.getInputStream();
            byte[] photoBytes = photoStream.readAllBytes();
            stud.setStudPhoto(photoBytes);
        } else {
            byte[] existing = studentDAO.getStudent(studId).getStudPhoto();
            stud.setStudPhoto(existing);
        }

        // Upload birth certificate
        Part certPart = request.getPart("birthCert");
        if (certPart != null && certPart.getSize() > 0) {
            InputStream certStream = certPart.getInputStream();
            byte[] certBytes = certStream.readAllBytes();
            stud.setStudBirthCert(certBytes);
        } else {
            byte[] existing = studentDAO.getStudent(studId).getStudBirthCert();
            stud.setStudBirthCert(existing);
        }

        // 🟢 Update to DB
        studentDAO.updateStudent(stud);

        // 🟢 Fetch updated student list
        if ("admin".equals(role)) {
            request.setAttribute("students", studentDAO.getAllStudents());
        } else if ("parent".equals(role)) {
            request.setAttribute("students", studentDAO.getStudentsByParentId(parentId));
        }

        // 🟢 Forward ke listStudent.jsp
        RequestDispatcher req = request.getRequestDispatcher("listStudent.jsp");
        req.forward(request, response);
    }
}
