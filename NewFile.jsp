<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kms.model.student" %>
<%@ page import="kms.dao.studentDAO" %>
<%@ page import="java.util.List" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="kms.model.*" %>
<%@ page session="true" %>
<%
    Object user = session.getAttribute("user");
    String role = (String) session.getAttribute("role");
    

    int id = 0;
    String name = "", email = "", phone = "", roleDisplay = "", teacherType = "";
    double salary = 0.0;
    int contract = 0;

    if (role != null && user != null) {
        if (role.equals("parent") && user instanceof parent) {
            parent p = (parent) user;
            id = p.getParentId();
            name = p.getParentName();
            email = p.getParentEmail();
            phone = p.getParentPhone();
            roleDisplay = "Parent";
        } else if ((role.equalsIgnoreCase("teacher") || role.equalsIgnoreCase("admin")) && user instanceof teacher) {
            teacher t = (teacher) user;
            id = t.getTeacherId();
            name = t.getTeacherName();
            email = t.getTeacherEmail();
            phone = t.getTeacherPhone();
            roleDisplay = role.equals("admin") ? "Administrator" : "Teacher";
            teacherType = t.getTeacherType();

            if (t instanceof fullTime) {
                salary = ((fullTime) t).getSalary();
            } else if (t instanceof partTime) {
                contract = ((partTime) t).getContract();
            }
        }
    }
    
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Attendance Info</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="container mt-5">

   <nav class="sidebar" id="sidebar">
    <div class="profile">
      <a href="viewAccount.jsp">  <img src="PhotoServlet?role=<%= role %>&type=photo&id=<%= id %>" ></a>
      <h3><%=name%></h3>

      <p><%= roleDisplay %></p>
    </div>
    <ul class="sidebar-links top-links">
    <li><a href="AdminHomeController"><i class="fas fa-home"></i> Home</a></li>
    <li><a href="ListSubjectController"><i class="fas fa-book"></i> Subject</a></li>
    <li><a href="ListAttendanceController"><i class="fas fa-calendar-check"></i> Attendance</a></li>
    <li><a href="recordProgress.jsp"><i class="fas fa-chart-line"></i> Progress</a></li>
    <li><a href="createStudent.jsp"><i class="fas fa-user-graduate"></i> Student</a></li>
  </ul>
  <div class="_separator_1e1cy_1"></div>
  <ul class="sidebar-links bottom-links">
    <li><a href="viewAccount.jsp"><i class="fas fa-user-cog"></i> Account</a></li>
    <li><a href="logout.jsp"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
  </ul>
	</nav>

    <div class="card p-4 shadow-sm">
        <h1 class="mb-4">Attendance Info</h1>

        <p><strong>Attendance ID:</strong> <c:out value="${attendance.attendanceId}"/></p>
        <p><strong>Date:</strong> <fmt:formatDate value="${attendance.attendanceDate}" pattern="yyyy-MM-dd"/></p>
        <p><strong>Student Name:</strong> <c:out value="${attendance.studName}"/></p>
        <p><strong>Check-in Time:</strong> <fmt:formatDate value="${attendance.checkinTime}" type="both" pattern="yyyy-MM-dd HH:mm:ss"/></p>
        <p><strong>Checkout Time:</strong> <fmt:formatDate value="${attendance.checkoutTime}" type="both" pattern="yyyy-MM-dd HH:mm:ss"/></p>
        <p><strong>Status:</strong> <c:out value="${attendance.attendanceStatus}"/></p>
        <p><strong>Check-in Temperature:</strong> <c:out value="${attendance.checkinTemp}"/> °C</p>

        <a href="ListAttendanceController" class="btn btn-outline-primary mt-3">Back to Attendance List</a>
    </div>

</body>
</html>
