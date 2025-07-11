package kms.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Date;
import java.util.Arrays;
import java.util.Calendar;
import java.util.List;
import jakarta.servlet.http.Part;
import jakarta.servlet.annotation.MultipartConfig;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;

import kms.dao.*;
import kms.model.*;
import kms.helper.CalculateAge;


@WebServlet("/createStudentController")
@MultipartConfig(maxFileSize = 16177215) // optional: limit file size
public class createStudentController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public createStudentController() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("parentId") == null) {
            response.sendRedirect("login.jsp?msg=sessionExpired");
            return;
        }

        String name = request.getParameter("name");
        String gender = request.getParameter("gender");
        String dobStr = request.getParameter("dob");
        String address = request.getParameter("address");

        // Validation
        if (name == null || name.trim().length() < 2 || !name.matches("[a-zA-Z\\s]+")) {
            response.sendRedirect("createStudent.jsp?error=InvalidName");
            return;
        }

        

        Date dob = null;
        if (dobStr != null && !dobStr.isEmpty()) {
            try {
                dob = Date.valueOf(dobStr);
                Date today = new Date(System.currentTimeMillis());
                Calendar cal = Calendar.getInstance();
                cal.setTime(today);
                cal.add(Calendar.YEAR, -7);
                Date limit = new Date(cal.getTimeInMillis());
                if (dob.after(today) || dob.before(limit)) {
                    response.sendRedirect("createStudent.jsp?error=InvalidDOB");
                    return;
                }
            } catch (IllegalArgumentException e) {
                response.sendRedirect("createStudent.jsp?error=InvalidDOBFormat");
                return;
            }
            
            int age = CalculateAge.calculateAgeStud(dob);
            if (age < 3 || age > 7) {
                response.sendRedirect("createStudent.jsp?error=InvalidAge");
                return;
            }

        }

        if (address == null || address.trim().length() < 10) {
            response.sendRedirect("createStudent.jsp?error=InvalidAddress");
            return;
        }

        // File Uploads
        Part photoPart = request.getPart("photo");
        if (photoPart == null || photoPart.getSize() == 0 || !photoPart.getContentType().startsWith("image/") || photoPart.getSize() > 5 * 1024 * 1024) {
            response.sendRedirect("createStudent.jsp?error=InvalidPhoto");
            return;
        }

        Part certPart = request.getPart("birthCert");
        List<String> validTypes = Arrays.asList("application/pdf", "image/jpeg", "image/png", "image/jpg");
        if (certPart == null || certPart.getSize() == 0 || !validTypes.contains(certPart.getContentType()) || certPart.getSize() > 10 * 1024 * 1024) {
            response.sendRedirect("createStudent.jsp?error=InvalidCert");
            return;
        }

        // Build student object
        student stud = new student();
        stud.setStudName(name);
        stud.setStudGender(gender);
        stud.setStudAddress(address);
        stud.setStudBirthDate(dob);
        stud.setStudPhoto(readPartAsBytes(photoPart));
        stud.setStudBirthCert(readPartAsBytes(certPart));
        stud.setParentId((Integer) session.getAttribute("parentId"));

        // Save
        studentDAO.addStudent(stud);

        String role = (String) session.getAttribute("role");
        if ("admin".equals(role)) {
            request.setAttribute("students", studentDAO.getAllStudents());
        } else if ("parent".equals(role)) {
            request.setAttribute("students", studentDAO.getStudentsByParentId(stud.getParentId()));
        } else {
            response.sendRedirect("login.jsp?msg=sessionExpired");
            return;
        }

        response.sendRedirect("ListStudentController?success=true");
    }

    private byte[] readPartAsBytes(Part part) throws IOException {
        InputStream is = part.getInputStream();
        ByteArrayOutputStream buffer = new ByteArrayOutputStream();
        int nRead;
        byte[] data = new byte[16384];
        while ((nRead = is.read(data, 0, data.length)) != -1) {
            buffer.write(data, 0, nRead);
        }
        buffer.flush();
        return buffer.toByteArray();
    }
}
