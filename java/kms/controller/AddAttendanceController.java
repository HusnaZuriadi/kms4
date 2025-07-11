package kms.controller;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kms.dao.AttendanceDAO;
import kms.model.Attendance;
import java.io.IOException;
import java.sql.Timestamp;

@WebServlet("/AddAttendanceController")
public class AddAttendanceController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    public AddAttendanceController() {
        super();
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            Attendance attendance = new Attendance();
            String date = request.getParameter("attendanceDate"); // yyyy-MM-dd
            String status = request.getParameter("attendanceStatus");
            String studIdStr = request.getParameter("studId");
            
            attendance.setAttendanceDate(java.sql.Date.valueOf(date));
            attendance.setStudId(Integer.parseInt(studIdStr));
            attendance.setAttendanceStatus(status);
            
            if ("Present".equalsIgnoreCase(status)) {
                String checkin = request.getParameter("checkinTime");
                String checkout = request.getParameter("checkoutTime");
                String temp = request.getParameter("checkinTemp");
                
                attendance.setCheckinTime(Timestamp.valueOf(date + " " + checkin + ":00"));
                
                if (checkout != null && !checkout.isEmpty()) {
                    attendance.setCheckoutTime(Timestamp.valueOf(date + " " + checkout + ":00"));
                } else {
                    attendance.setCheckoutTime(null);
                }
                
                if (temp != null && !temp.isEmpty()) {
                    // Remove any non-numeric characters like °C
                    temp = temp.replaceAll("[^0-9.]", "");
                    attendance.setCheckinTemp(Double.parseDouble(temp));
                } else {
                    attendance.setCheckinTemp(0.0);
                }
            } else {
                attendance.setCheckinTime(null);
                attendance.setCheckoutTime(null);
                attendance.setCheckinTemp(0.0);
            }
            
            // Save attendance
            AttendanceDAO.addAttendance(attendance);
            
            // Get age parameter (your form sends "age", not "selectedAge")
            String age = request.getParameter("age");
            
            // Build redirect URL to return to same filtered view
            String redirectURL = "ListAttendanceController?success=true&filterDate=" + date;
            if (age != null && !age.isEmpty()) {
                redirectURL += "&selectedAge=" + age;
            }
            
            response.sendRedirect(redirectURL);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("attendanceForm.jsp?error=true");
        }
    }
}