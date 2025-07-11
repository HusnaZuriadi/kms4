<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, kms.model.*, kms.helper.CalculateAge" %>
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
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Parent Accounts</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
<link rel="stylesheet" href="css/viewParent.css">
</head>
<body>

	<header>
		<button class="navSidebar" onclick="toggleSidebar()">
			<i class="fa-solid fa-bars"></i>
		</button>
		<div class="logo">
			<img src="images/LOGO-AL-KAUTHAR-EDUQIDS.png"
				alt="ALKAUTHAR EDUQIDS Logo">
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

	<h2>Parent Information</h2>

	<div class="section parent-info">
	  <div class="parent-profile">
	    <img src="PhotoServlet?role=parent&type=photo&id=${parent.parentId}" alt="Parent Photo" class="parent-photo" />
	    
	    <div class="parent-details">
	      <div class="detail-item"><strong>Name:</strong> ${parent.parentName}</div>
	      <div class="detail-item"><strong>Email:</strong> ${parent.parentEmail}</div>
	      <div class="detail-item"><strong>Phone:</strong> ${parent.parentPhone}</div>
	    </div>
	  </div>
	</div>

	<h2>Registered Children</h2>

	<div class="section">
	    <c:forEach var="s" items="${student}">
    <%
        kms.model.student stu = (kms.model.student) pageContext.getAttribute("s");
        java.sql.Date birthDate = stu.getStudBirthDate();
        int age = kms.helper.CalculateAge.calculateAgeStud(birthDate);
    %>
    <div class="child-card">
        <img src="PhotoServlet?role=student&type=photo&id=${s.studId}" alt="Photo" class="child-photo" />

        <div class="child-info">
            <h3>${s.studName}</h3>
            <p><strong>Birth Date:</strong>
                <fmt:formatDate value="${s.studBirthDate}" pattern="dd/MM/yyyy" />
            </p>
            <p><strong>Age:</strong> <%= age %> years old</p>
            <p><strong>Gender:</strong> ${s.studGender}</p>
            <p><strong>Address:</strong> ${s.studAddress}</p>
            <p><strong>Birth Certificate:</strong>
                <a class="cert-link" href="PhotoServlet?role=student&type=cert&id=${s.studId}" target="_blank">View</a>
            </p>
        </div>
    </div>
</c:forEach>


	    <c:if test="${empty student}">
	        <p class="no-children">This parent has no registered children.</p>
	    </c:if>
	</div>

	<a href="ListParentController" class="back-btn">← Back to Parent List</a>
	
	<script>
	function toggleSidebar() {
	    document.getElementById("sidebar").classList.toggle("show");
	}
	</script>

</body>
</html>
