<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, kms.model.*"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ page session="true"%>

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
  <meta charset="UTF-8">
  <title>Create Subject - Admin</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">

  <!-- External CSS -->
  <link rel="stylesheet" href="css/createSubject.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
</head>
<body>

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

  <!-- Page content -->
  <div class="container">
    <form action="CreateSubjectController" method="post" class="create-subject-form">
      <div class="form-group-row">
        <div>
         <label for="ageGroup">Age Group:</label>
    <select name="ageGroup" id="ageGroup" required>
      <option value="">Select Age</option>
      <option value="4">4 years old</option>
      <option value="5">5 years old</option>
      <option value="6">6 years old</option>
    </select>
    <small style="color: #888; font-size: 0.9em;">* Choose age group for this subject</small>
          <label for="subjectName">Subject Name:</label>
          <input type="text" name="subjectName" id="subjectName" required />
        </div>
      </div>

      <div class="form-group-row">
        <div>
          <label for="teacherId">Assign Teacher:</label>
          <select name="teacherId" id="teacherId" required>
    		<option value="">Select Teacher</option>
    		<c:forEach var="teacher" items="${teacherList}">
        	<option value="${teacher.teacherId}">${teacher.teacherName}</option>
    </c:forEach>
		</select>

        </div>
      </div>

      <div class="submit-container">
        <button type="submit" class="submit-btn">Create Subject</button> 
      </div>
    </form>
  </div>
  
   <script>
   function toggleSidebar() {
	    const sidebar = document.getElementById("sidebar");
	    const dashboard = document.getElementById("dashboard");
	    sidebar.classList.toggle("show");
	    dashboard.classList.toggle("shifted");
	  }
  </script>

</body>
</html>
