package kms.dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import kms.connection.ConnectionManager;
import kms.helper.CalculateAge;
import kms.model.Attendance;


public class AttendanceDAO {

    private static Connection con = null;
    private static PreparedStatement ps = null;
    private static ResultSet rs = null;
    private static String sql;

    // Insert attendance record into the database
    public static void addAttendance(Attendance attendance) {
        try {
            con = ConnectionManager.getConnection();
            sql = "INSERT INTO attendance(attendanceId, attendanceDate, studId, checkinTime, checkoutTime, attendanceStatus, checkinTemp) VALUES (attendance_seq.NEXTVAL, ?, ?, ?, ?, ?, ?)";
            ps = con.prepareStatement(sql);
            ps.setDate(1, attendance.getAttendanceDate());
            ps.setInt(2, attendance.getStudId());
            ps.setTimestamp(3, attendance.getCheckinTime());
            ps.setTimestamp(4, attendance.getCheckoutTime());
            ps.setString(5, attendance.getAttendanceStatus());
            ps.setDouble(6, attendance.getCheckinTemp());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }

    // Update existing attendance record
    public static void updateAttendance(Attendance attendance) {
        try {
            con = ConnectionManager.getConnection();
            sql = "UPDATE attendance SET attendanceDate=?, studId=?, checkinTime=?, checkoutTime=?, attendanceStatus=?, checkinTemp=? WHERE attendanceId=?";
            ps = con.prepareStatement(sql);
            ps.setDate(1, attendance.getAttendanceDate());
            ps.setInt(2, attendance.getStudId());
            ps.setTimestamp(3, attendance.getCheckinTime());
            ps.setTimestamp(4, attendance.getCheckoutTime());
            ps.setString(5, attendance.getAttendanceStatus());
            ps.setDouble(6, attendance.getCheckinTemp());
            ps.setInt(7, attendance.getAttendanceId());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }

    // Delete attendance record by ID
    public static void deleteAttendance(int attendanceId) {
        try {
            con = ConnectionManager.getConnection();
            sql = "DELETE FROM attendance WHERE attendanceId=?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, attendanceId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }

    // Get attendance by attendance ID
    public static Attendance getAttendance(int attendanceId) {
        Attendance attendance = new Attendance();
        try {
            con = ConnectionManager.getConnection();
            sql = "SELECT a.*, s.studName FROM attendance a JOIN student s ON a.studId = s.studId WHERE a.attendanceId = ?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, attendanceId);
            rs = ps.executeQuery();
            if (rs.next()) {
                attendance.setAttendanceId(rs.getInt("attendanceId"));
                attendance.setAttendanceDate(rs.getDate("attendanceDate"));
                attendance.setStudId(rs.getInt("studId"));
                attendance.setCheckinTime(rs.getTimestamp("checkinTime"));
                attendance.setCheckoutTime(rs.getTimestamp("checkoutTime"));
                attendance.setAttendanceStatus(rs.getString("attendanceStatus"));
                attendance.setCheckinTemp(rs.getDouble("checkinTemp"));
                attendance.setStudName(rs.getString("studName"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
        return attendance;
    }

    // Get all attendance records
    public static List<Attendance> getAllAttendances() {
        List<Attendance> attendances = new ArrayList<>();
        try {
            con = ConnectionManager.getConnection();
            sql = "SELECT A.*, S.studName FROM attendance A JOIN student S ON A.studId = S.studId ORDER BY A.attendanceId ASC";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Attendance attendance = new Attendance();
                attendance.setAttendanceId(rs.getInt("attendanceId"));
                attendance.setAttendanceDate(rs.getDate("attendanceDate"));
                attendance.setStudId(rs.getInt("studId"));
                attendance.setCheckinTime(rs.getTimestamp("checkinTime"));
                attendance.setCheckoutTime(rs.getTimestamp("checkoutTime"));
                attendance.setAttendanceStatus(rs.getString("attendanceStatus"));
                attendance.setCheckinTemp(rs.getDouble("checkinTemp"));
                attendance.setStudName(rs.getString("studName"));
                attendances.add(attendance);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
        return attendances;
    }

    // Get attendance by date
    public static List<Attendance> getAttendanceByDate(Date attendanceDate) {
        List<Attendance> attendances = new ArrayList<>();
        try {
            con = ConnectionManager.getConnection();
            sql = "SELECT A.*, S.studName FROM attendance A JOIN student S ON A.studId = S.studId WHERE A.attendanceDate = ? ORDER BY S.studName ASC";
            ps = con.prepareStatement(sql);
            ps.setDate(1, attendanceDate);
            rs = ps.executeQuery();
            while (rs.next()) {
                Attendance attendance = new Attendance();
                attendance.setAttendanceId(rs.getInt("attendanceId"));
                attendance.setAttendanceDate(rs.getDate("attendanceDate"));
                attendance.setStudId(rs.getInt("studId"));
                attendance.setCheckinTime(rs.getTimestamp("checkinTime"));
                attendance.setCheckoutTime(rs.getTimestamp("checkoutTime"));
                attendance.setAttendanceStatus(rs.getString("attendanceStatus"));
                attendance.setCheckinTemp(rs.getDouble("checkinTemp"));
                attendance.setStudName(rs.getString("studName"));
                attendances.add(attendance);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
        return attendances;
    }

    // Get all attendance records for a specific student
    public static List<Attendance> getAttendanceByStudent(int studentId) {
        List<Attendance> attendances = new ArrayList<>();
        try {
            con = ConnectionManager.getConnection();
            sql = "SELECT a.*, s.studName FROM attendance a JOIN student s ON a.studId = s.studId WHERE a.studId = ? ORDER BY a.attendanceDate DESC";
            ps = con.prepareStatement(sql);
            ps.setInt(1, studentId);
            rs = ps.executeQuery();
            while (rs.next()) {
                Attendance attendance = new Attendance();
                attendance.setAttendanceId(rs.getInt("attendanceId"));
                attendance.setAttendanceDate(rs.getDate("attendanceDate"));
                attendance.setStudId(rs.getInt("studId"));
                attendance.setCheckinTime(rs.getTimestamp("checkinTime"));
                attendance.setCheckoutTime(rs.getTimestamp("checkoutTime"));
                attendance.setAttendanceStatus(rs.getString("attendanceStatus"));
                attendance.setCheckinTemp(rs.getDouble("checkinTemp"));
                attendance.setStudName(rs.getString("studName"));
                attendances.add(attendance);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
        return attendances;
    }

    // Get attendance records for a specific student on a specific date
    public static List<Attendance> getAttendanceByStudentAndDate(int studentId, String dateStr) {
        List<Attendance> attendances = new ArrayList<>();
        try {
        	 con = ConnectionManager.getConnection();
            sql = "SELECT a.*, s.studName FROM attendance a JOIN student s ON a.studId = s.studId WHERE a.studId = ? AND TO_CHAR(a.attendanceDate, 'YYYY-MM-DD') = ?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, studentId);
            ps.setString(2, dateStr);
            rs = ps.executeQuery();
            while (rs.next()) {
                Attendance attendance = new Attendance();
                attendance.setAttendanceId(rs.getInt("attendanceId"));
                attendance.setAttendanceDate(rs.getDate("attendanceDate"));
                attendance.setStudId(rs.getInt("studId"));
                attendance.setCheckinTime(rs.getTimestamp("checkinTime"));
                attendance.setCheckoutTime(rs.getTimestamp("checkoutTime"));
                attendance.setAttendanceStatus(rs.getString("attendanceStatus"));
                attendance.setCheckinTemp(rs.getDouble("checkinTemp"));
                attendance.setStudName(rs.getString("studName"));
                attendances.add(attendance);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
        return attendances;
    }
    
    public static List<Attendance> getAttendanceByStudentAndMonth(int studentId, String yyyyMM) {
        List<Attendance> attendances = new ArrayList<>();
        try {
            con = ConnectionManager.getConnection();
            sql = "SELECT a.*, s.studName FROM attendance a " +
                  "JOIN student s ON a.studId = s.studId " +
                  "WHERE a.studId = ? AND TO_CHAR(a.attendanceDate, 'YYYY-MM') = ? " +
                  "ORDER BY a.attendanceDate ASC";
            ps = con.prepareStatement(sql);
            ps.setInt(1, studentId);
            ps.setString(2, yyyyMM);
            rs = ps.executeQuery();
            while (rs.next()) {
                Attendance attendance = new Attendance();
                attendance.setAttendanceId(rs.getInt("attendanceId"));
                attendance.setAttendanceDate(rs.getDate("attendanceDate"));
                attendance.setStudId(rs.getInt("studId"));
                attendance.setCheckinTime(rs.getTimestamp("checkinTime"));
                attendance.setCheckoutTime(rs.getTimestamp("checkoutTime"));
                attendance.setAttendanceStatus(rs.getString("attendanceStatus"));
                attendance.setCheckinTemp(rs.getDouble("checkinTemp"));
                attendance.setStudName(rs.getString("studName"));
                attendances.add(attendance);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
        return attendances;
    }
    
 // Get attendance by date and student name
    public static List<Attendance> getAttendanceByFilters(Date date, int age, String query) {
        List<Attendance> attendances = new ArrayList<>();

        try {
            con = ConnectionManager.getConnection();
            sql = "SELECT a.*, s.studName, s.studBirthDate FROM attendance a " +
                  "JOIN student s ON a.studId = s.studId " +
                  "WHERE a.attendanceDate = ?";
            
            if (query != null && !query.trim().isEmpty()) {
                sql += " AND LOWER(s.studName) LIKE ?";
            }

            ps = con.prepareStatement(sql);
            ps.setDate(1, date);

            if (query != null && !query.trim().isEmpty()) {
                ps.setString(2, "%" + query.toLowerCase() + "%");
            }

            rs = ps.executeQuery();

            while (rs.next()) {
                Attendance attendance = new Attendance();
                attendance.setAttendanceId(rs.getInt("attendanceId"));
                attendance.setAttendanceDate(rs.getDate("attendanceDate"));
                attendance.setStudId(rs.getInt("studId"));
                attendance.setStudName(rs.getString("studName"));
                attendance.setAttendanceStatus(rs.getString("attendanceStatus"));
                attendance.setCheckinTime(rs.getTimestamp("checkinTime"));
                attendance.setCheckoutTime(rs.getTimestamp("checkoutTime"));
                attendance.setCheckinTemp(rs.getDouble("checkinTemp"));
              

                // 💡 Filter umur guna CalculateAge
                int calculatedAge = CalculateAge.calculateAgeStud(rs.getDate("studBirthDate"));
                if (age == 0 || calculatedAge == age) {
                    attendances.add(attendance);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }

        return attendances;
    }
    
 // count attendance for today using SYSDATE
    public static int countTodayAttendance() {
        int count = 0;
        try {
            con = ConnectionManager.getConnection();
            
            // Guna TRUNC(sysdate) untuk padankan tarikh tanpa masa
            sql = "SELECT COUNT(*) FROM Attendance WHERE TRUNC(attendanceDate) = TRUNC(SYSDATE) AND status = 'Present'";
            
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next()) count = rs.getInt(1);

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
        return count;
    }



}