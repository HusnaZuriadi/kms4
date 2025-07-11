<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="java.util.*, kms.model.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="true" %>
<%
  Object user = session.getAttribute("user");
  String role = (String) session.getAttribute("role");
  String adminName = "";
  int id = -1;

  if ("admin".equals(role) && user instanceof teacher) {
      teacher a = (teacher) user;
      adminName = a.getTeacherName();
      id = a.getTeacherId(); // ✅ ambil ID untuk gambar
  }
%>
<!DOCTYPE html>
<html lang="en">
<head>
     <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Subject List - Al Kauthar EduQids</title>
<link rel="stylesheet" href="css/listSubject.css" />
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" />

</head>
<body>

<!-- Header -->
<header>
  <button class="navSidebar" onclick="toggleSidebar()">
    <i class="fa-solid fa-bars"></i>
  </button>
  <div class="navbar">
    <img src="images/LOGO-AL-KAUTHAR-EDUQIDS.png" alt="ALKAUTHAR EDUQIDS Logo" />
  </div>
</header>

<nav class="sidebar" id="sidebar">
  <div class="profile">
    <a href="viewAccount.jsp">
       <img src="PhotoServlet?role=<%= role %>&type=photo&id=<%= id %>" >
    </a>
    <h3><%= adminName %></h3>
    <p>Administrator</p>
  </div>
  <ul class="sidebar-links top-links">
    <li><a href="AdminHomeController"><i class="fas fa-home"></i> Home</a></li>
    <li><a href="ListSubjectController"><i class="fas fa-book"></i> Subject</a></li>
    <li><a href="listAttendance.jsp"><i class="fas fa-calendar-check"></i> Attendance</a></li>
    <li><a href="recordProgress.jsp"><i class="fas fa-chart-line"></i> Progress</a></li>
    <li><a href="ListStudentController"><i class="fas fa-user-graduate"></i> Student</a></li>

  </ul>
  <div class="_separator_1e1cy_1"></div>
  <ul class="sidebar-links bottom-links">
    <li><a href="viewAccount.jsp"><i class="fas fa-user-cog"></i> Account</a></li>
    <li><a href="LogoutController"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
  </ul>
</nav>
<!-- Page Content -->
<div class="container">
    <div class="header-row">
        <h2>Subject</h2>
        <button class="btn-add" onclick="location.href='CreateSubjectController'">+ Create</button>
    </div>

    <div class="subject-grid">
        <c:choose>
            <c:when test="${empty listSubject}">
                <div class="placeholder">
                    No subjects available yet. Please add subjects using the "+ Create" button.
                </div>
            </c:when>
            <c:otherwise>
               <c:forEach var="subject" items="${listSubject}">
  <div class="subject-card">
    <i class="fa-solid fa-book"></i>
    <p><strong>${subject.subjectName}</strong></p>
    <p>For Age: ${subject.ageGroup}</p>
    <p>
      Teacher: 
      <c:choose>
        <c:when test="${teacherNames[subject.teacherId] != null}">
          ${teacherNames[subject.teacherId]}
        </c:when>
        <c:otherwise>
          Not Assigned
        </c:otherwise>
      </c:choose>
    </p>
    <div class="card-actions">
      <a href="UpdateSubjectController?subjectId=${subject.subjectId}" class="btn-edit">
        <i class="fa-solid fa-pen-to-square"></i> Edit
      </a>
      <a href="deleteSubjectController?subjectId=${subject.subjectId}" 
         class="btn-delete" 
         onclick="return confirm('Are you sure you want to delete this subject?');">
         <i class="fa-solid fa-trash"></i> Delete
      </a>
    </div>
  </div>
</c:forEach>

            </c:otherwise>
        </c:choose>
    </div>
</div>

  <script>
  function toggleSidebar() {
	    const sidebar = document.getElementById("sidebar");
	    const dashboard = document.getElementById("dashboard");
	    sidebar.classList.toggle("show");
	    dashboard.classList.toggle("shifted");
	  }

        window.addEventListener('click', function(e) {
            document.querySelectorAll(".dropdown-content").forEach(dc => {
                if (!dc.contains(e.target) && !dc.previousElementSibling.contains(e.target)) {
                    dc.classList.remove("show");
                }
            });
        });
        </script>
</body>
</html>
