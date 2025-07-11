package kms.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import kms.connection.ConnectionManager;
import kms.model.StudentProgress;

public class studentProgressDAO {

    private static Connection con = null;
    private static PreparedStatement ps = null;
    private static ResultSet rs = null;
    private static String sql;

    // Insert new progress and link to enrollment
    public static void addStudentProgress(StudentProgress progress, int enrollId) {
        int progressId = -1;

        try {
            con = ConnectionManager.getConnection();

            // Step 1: Insert into studentprogress
            sql = "INSERT INTO progress ( months, marks, teacherComment) VALUES ( ?, ?, ?)";
            ps = con.prepareStatement(sql, new String[]{"progressId"});
            ps.setDate(1, progress.getMonths());
            ps.setInt(2, progress.getMarks());
            ps.setString(3, progress.getTeacherComment());
            ps.executeUpdate();

            rs = ps.getGeneratedKeys();
            if (rs.next()) {
                progressId = rs.getInt(1);
            }
            rs.close();
            ps.close();

            // Step 2: Update enrollment with progressId
            if (progressId != -1) {
                sql = "UPDATE enrollment SET progressId = ? WHERE enrollId = ?";
                ps = con.prepareStatement(sql);
                ps.setInt(1, progressId);
                ps.setInt(2, enrollId);
                ps.executeUpdate();
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }

    public static void updateStudentProgress(StudentProgress progress) {
        try {
            con = ConnectionManager.getConnection();
            sql = "UPDATE progress SET months=?, marks=?, teacherComment=? WHERE progressId=?";
            ps = con.prepareStatement(sql);
            ps.setDate(1, progress.getMonths());
            ps.setInt(2, progress.getMarks());
            ps.setString(3, progress.getTeacherComment());
            ps.setInt(4, progress.getProgressId());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }

    public static void deleteStudentProgress(int progressId) {
        try {
            con = ConnectionManager.getConnection();
            sql = "DELETE FROM progress WHERE progressId = ?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, progressId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }

    public static StudentProgress getStudentProgressById(int progressId) {
        StudentProgress progress = new StudentProgress();
        try {
            con = ConnectionManager.getConnection();
            sql = "SELECT * FROM progress WHERE progressId = ?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, progressId);
            rs = ps.executeQuery();
            if (rs.next()) {
                progress.setProgressId(rs.getInt("progressId"));
                progress.setMonths(rs.getDate("months"));
                progress.setMarks(rs.getInt("marks"));
                progress.setTeacherComment(rs.getString("teacherComment"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
        return progress;
    }

    public static List<StudentProgress> getAllStudentProgress() {
        List<StudentProgress> list = new ArrayList<>();
        try {
            con = ConnectionManager.getConnection();
            sql = "SELECT * FROM progress ORDER BY months DESC";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                StudentProgress progress = new StudentProgress();
                progress.setProgressId(rs.getInt("progressId"));
                progress.setMonths(rs.getDate("months"));
                progress.setMarks(rs.getInt("marks"));
                progress.setTeacherComment(rs.getString("teacherComment"));
                list.add(progress);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
        return list;
    }
    
    public static void addProgressWithEnrollment(int studId, int subjectId, StudentProgress progress) {
        int enrollId = enrollmentsDAO.getEnrollId(studId, subjectId);
        if (enrollId != -1) {
            addStudentProgress(progress, enrollId);
        } else {
            System.out.println("Enrollment not found for studId: " + studId + ", subjectId: " + subjectId);
        }
    }
}
