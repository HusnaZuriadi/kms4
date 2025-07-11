package kms.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import kms.connection.ConnectionManager;
import kms.model.enrollment;


public class enrollmentsDAO {

    private static Connection con;
    private static PreparedStatement ps;
    private static ResultSet rs;
    private static String sql;

    // Add new enrollment
    public static void addEnrollment(int studId, int subjectId) {
        try {
            con = ConnectionManager.getConnection();
            sql = "INSERT INTO Enrollments (studId, subjectId, progressId) VALUES (?, ?, NULL)";
            ps = con.prepareStatement(sql);
            ps.setInt(1, studId);
            ps.setInt(2, subjectId);
            ps.executeUpdate();
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception ex) {}
            try { if (con != null) con.close(); } catch (Exception ex) {}
        }
    }


    public static List<Integer> getRegisteredSubjectIds(int studId) {
        List<Integer> ids = new ArrayList<>();
        try {
            con = ConnectionManager.getConnection();
            sql = "SELECT subjectId FROM Enrollments WHERE studId = ?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, studId);
            rs = ps.executeQuery();
            while (rs.next()) {
                ids.add(rs.getInt("subjectId"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
        return ids;
    }



    // Optional: check if a student is registered to a subject
    public static boolean isStudentRegistered(int studId, int subjectId) {
        boolean registered = false;
        try {
            con = ConnectionManager.getConnection();
            sql = "SELECT COUNT(*) FROM Enrollments WHERE studId = ? AND subjectId = ?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, studId);
            ps.setInt(2, subjectId);
            rs = ps.executeQuery();

            if (rs.next() && rs.getInt(1) > 0) {
                registered = true;
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }

        return registered;
    }
    
    public static void deleteEnrollment(int studId, int subjectId) {
        try {
            con = ConnectionManager.getConnection();
            sql = "DELETE FROM Enrollments WHERE studId = ? AND subjectId = ?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, studId);
            ps.setInt(2, subjectId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }

 // Get enrollId based on studId and subjectId
    public static int getEnrollId(int studId, int subjectId) {
        int enrollId = -1;
        try {
            con = ConnectionManager.getConnection();
            sql = "SELECT enrollId FROM Enrollments WHERE studId = ? AND subjectId = ?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, studId);
            ps.setInt(2, subjectId);
            rs = ps.executeQuery();
            if (rs.next()) {
                enrollId = rs.getInt("enrollId");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
        return enrollId;
    }



}
