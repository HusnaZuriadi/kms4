<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kms.model.teacher" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    Object user = session.getAttribute("user");
    String role = (String) session.getAttribute("role");
    String adminName = "";
    int id = -1;
    if ("admin".equals(role) && user instanceof teacher) {
        teacher a = (teacher) user;
        adminName = a.getTeacherName();
        id = a.getTeacherId();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Update Subject</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="stylesheet" href="updateSubject.css">
</head>
<body>

<!-- Header -->
<header>
    <button class="navSidebar" onclick="toggleSidebar()">
        <i class="fa-solid fa-bars"></i>
    </button>
    <div class="navbar">
        <img src="images/LOGO-AL-KAUTHAR-EDUQIDS.png" alt="Logo" />
    </div>
</header>

<!-- Sidebar -->
<nav class="sidebar" id="sidebar">
    <div class="profile">
        <a href="viewAccount.jsp">
            <img src="PhotoServlet?role=<%= role %>&type=photo&id=<%= id %>" />
        </a>
        <h3><%= adminName %></h3>
        <p>Administrator</p>
    </div>
    <ul class="sidebar-links top-links">
        <li><a href="AdminHomeController"><i class="fas fa-home"></i> Home</a></li>
        <li><a href="ListSubjectController"><i class="fas fa-book"></i> Subject</a></li>
        <li><a href="recordAttendance.jsp"><i class="fas fa-calendar-check"></i> Attendance</a></li>
        <li><a href="recordProgress.jsp"><i class="fas fa-chart-line"></i> Progress</a></li>
        <li><a href="ListStudentController"><i class="fas fa-user-graduate"></i> Student</a></li>
    </ul>
    <div class="_separator_1e1cy_1"></div>
    <ul class="sidebar-links bottom-links">
        <li><a href="viewAccount.jsp"><i class="fas fa-user-cog"></i> Account</a></li>
        <li><a href="LogoutController"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
    </ul>
</nav>

<!-- Form -->
<div class="form-container">
    <h2>Update Subject</h2>
    <form action="UpdateSubjectController" method="post">
        <input type="hidden" name="subjectId" value="${subject.subjectId}" />

        <div class="form-group">
            <label for="subjectName">Subject Name</label>
            <input type="text" id="subjectName" name="subjectName" value="${subject.subjectName}" required />
        </div>

        <div class="form-group">
            <label for="teacherId">Assign Teacher</label>
            <select id="teacherId" name="teacherId" required>
                <option value="">Select Teacher</option>
                <c:forEach var="teacher" items="${teacherList}">
                    <option value="${teacher.teacherId}"
                        <c:if test="${teacher.teacherId == subject.teacherId}">selected</c:if>>
                        ${teacher.teacherName}
                    </option>
                </c:forEach>
            </select>
        </div>

        <div class="form-group">
            <label for="subjectAge">Subject Age</label>
            <select id="subjectAge" name="subjectAge" required>
                <option value="">Select Age Group</option>
                <option value="4" <c:if test="${subject.ageGroup == 4}">selected</c:if>>4 Years Old</option>
                <option value="5" <c:if test="${subject.ageGroup == 5}">selected</c:if>>5 Years Old</option>
                <option value="6" <c:if test="${subject.ageGroup == 6}">selected</c:if>>6 Years Old</option>
            </select>
        </div>

        <div class="form-actions">
            <button type="submit" class="btn-submit">Update</button>
            <a href="ListSubjectController" class="btn-cancel">Cancel</a>
        </div>
    </form>
</div>

<script>
    function toggleSidebar() {
        const sidebar = document.getElementById("sidebar");
        sidebar.classList.toggle("show");
    }
</script>
</body>
</html>
