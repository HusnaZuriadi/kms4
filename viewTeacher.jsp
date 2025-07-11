<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, kms.model.*"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ page session="true"%>

<%
  Object user = session.getAttribute("user");
  String role = (String) session.getAttribute("role");
  String name = "";

  if ("admin".equalsIgnoreCase(role) && user instanceof teacher) {
      teacher a = (teacher) user;
      name = a.getTeacherName();
  }
%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Teacher Profile</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
  <link rel="stylesheet" href="css/viewTeacher.css"> <%-- Guna css yang sama --%>
</head>
<body>

<header>
  <button class="navSidebar" onclick="toggleSidebar()"><i class="fa-solid fa-bars"></i></button>
  <div class="logo">
    <img src="images/LOGO-AL-KAUTHAR-EDUQIDS.png" alt="Logo">
  </div>
</header>

<nav class="sidebar" id="sidebar">
  <div class="profile">
    <img src="images/admin.jpg" alt="Admin Profile Photo">
    <h3><%= name %></h3>
    <p><%= role %></p>
  </div>
  <a href="#">Dashboard</a>
  <a href="ListStudentController">Student Registration</a>
  <a href="#">Teachers</a>
  <a href="#">Parents</a>
  <a href="#">Logout</a>
</nav>

<h2>Teacher Profile</h2>

<!-- Profile Section -->
<div class="section teacher-info">
  <div class="teacher-profile">
    <img src="PhotoServlet?role=teacher&type=photo&id=${teacher.teacherId}" alt="Teacher Photo" class="parent-photo" />
    <div class="teacher-details">
      <div class="detail-item"><strong>Name:</strong> ${teacher.teacherName}</div>
      <div class="detail-item"><strong>Email:</strong> ${teacher.teacherEmail}</div>
      <div class="detail-item"><strong>Phone:</strong> ${teacher.teacherPhone}</div>
      <div class="detail-item"><strong>Role:</strong> 
        <c:choose>
          <c:when test="${teacher.teacherRole eq 'Admin'}">Admin</c:when>
          <c:otherwise>Teacher</c:otherwise>
        </c:choose>
      </div>
      <div class="detail-item"><strong>Type:</strong> 
        <c:choose>
          <c:when test="${type eq 'fullTime'}">Full Time</c:when>
          <c:otherwise>Part Time</c:otherwise>
        </c:choose>
      </div>

      <c:if test="${type eq 'fullTime'}">
        <div class="detail-item"><strong>Salary:</strong> RM ${teacher.salary}</div>
      </c:if>
      <c:if test="${type eq 'partTime'}">
        <div class="detail-item"><strong>Contract:</strong> ${teacher.contract} months</div>
      </c:if>
    </div>
  </div>
</div>

<!-- Subject Section -->
<h2 class ="subject">Subjects Taught</h2>

<div class="children-container">
  <c:if test="${empty listSubject}">
    <p class="no-children">This teacher has no subjects assigned.</p>
  </c:if>

  <div class="subject-grid">
    <c:forEach var="s" items="${listSubject}">
      <div class="subject-card">
        <h3>${s.subjectName}</h3>
        <p><strong>Age Group:</strong> ${s.ageGroup}</p>
      </div>
    </c:forEach>
  </div>
</div>




<a href="ListTeacherController" class="back-btn">← Back to Teacher List</a>

<script>
  function toggleSidebar() {
    document.getElementById("sidebar").classList.toggle("show");
  }
</script>

</body>
</html>
