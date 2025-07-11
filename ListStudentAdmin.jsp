<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, kms.model.*, kms.helper.CalculateAge" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%
  Object user = session.getAttribute("user");
  String role = (String) session.getAttribute("role");
  String adminName = "";
  int id = 0;

  if ("admin".equals(role) && user instanceof teacher) {
      teacher a = (teacher) user;
      adminName = a.getTeacherName();
      id = a.getTeacherId();
  }
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>List of Students - Al Kauthar EduQids</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="listStudent.css">
   
</head>
<body>

<!-- Header -->
<header class="headerContainer">
  <button class="navSidebarButton" onclick="toggleSidebarFunction()">
    <i class="fa-solid fa-bars"></i>
  </button>
  <div class="logoSection">
    <img src="images/LOGO-AL-KAUTHAR-EDUQIDS.png" alt="Al Kauthar EduQids Logo" />
  </div>
</header>

<!-- Image Banner -->
<div class="imageBannerSection">
  <img src="images/kindergarten3.jpg" alt="Kindergarten Banner" class="bannerImageDisplay">
  <div class="bannerOverlayContent">
    <div class="bannerTextDisplay">Our Amazing Students</div>
  </div>
</div>

<!-- Welcome Banner -->
<div class="welcomeBannerContainer">
  View and manage all student records in one place!
</div>

<!-- Layout Container -->
<div class="layoutContainer">
  <!-- Sidebar -->
  <nav class="sidebarNavigation" id="sidebarElement">
    <div class="profileSection">
      <a href="viewAccount.jsp">
        <img src="PhotoServlet?role=<%= role %>&type=photo&id=<%= id %>" alt="Profile Photo">
      </a>
      <h3><%= adminName %></h3>
      <p>Administrator</p>
    </div>
    <ul class="sidebarLinksContainer top-links">
      <li><a href="AdminHomeController"><i class="fas fa-home"></i> Home</a></li>
      <li><a href="ListSubjectController"><i class="fas fa-book"></i> Subject</a></li>
      <li><a href="ListAttendanceController"><i class="fas fa-calendar-check"></i> Attendance</a></li>
      <li><a href="recordProgress.jsp"><i class="fas fa-chart-line"></i> Progress</a></li>
      <li><a href="ListStudentController" class="active"><i class="fas fa-user-graduate"></i> Student</a></li>
    </ul>
    <div class="separatorLine"></div>
    <ul class="sidebarLinksContainer bottom-links">
      <li><a href="viewAccount.jsp"><i class="fas fa-user-cog"></i> Account</a></li>
      <li><a href="LogoutController"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
    </ul>
  </nav>

  <!-- Main Content -->
  <main class="mainContentContainer">
    <!-- Page Header -->
    <div class="pageHeaderContent">
      <h1>
        <i class="fas fa-users"></i>
        List of Students
      </h1>
      <p>View and manage all student records</p>
    </div>

    <!-- Filter Section -->
    <c:if test="${role == 'admin'}">
      <div class="filterSectionContainer">
        <div class="filterTitleHeader">
          <i class="fas fa-filter"></i>
          Filter Students by Age
        </div>
        <form method="get" action="ListStudentController">
          <div class="formGroupContainer">
            <label class="formLabelText" for="ageSelect">Select Age Group:</label>
            <select name="age" id="ageSelect" class="selectFieldStyle" onchange="this.form.submit()">
              <option value="">-- Select Age --</option>
              <c:forEach var="i" begin="4" end="6">
                <option value="${i}" <c:if test="${param.age == i}">selected</c:if>>${i} Years Old</option>
              </c:forEach>
            </select>
          </div>
        </form>
      </div>
    </c:if>

    <!-- Age Selection Notice -->
    <c:if test="${empty param.age}">
      <div class="ageNoticeContainer">
        <i class="fas fa-info-circle"></i>
        Please select an age group to view students
      </div>
    </c:if>

    <!-- Students Table -->
    <c:choose>
      <c:when test="${not empty students}">
        <div class="tableContainerWrapper fadeInAnimation">
          <div class="tableHeaderTitle">
            <i class="fas fa-list"></i> Students List - Age ${param.age}
          </div>
          <table class="studentsTableMain">
            <thead>
              <tr>
                <th>Student ID</th>
                <th>Name</th>
                <th>Gender</th>
                <th>Age</th>
                <th>Birth Date</th>
                <th>Address</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="stud" items="${students}">
                <tr>
                  <td><strong>${stud.studId}</strong></td>
                  <td>${stud.studName}</td>
                  <td>${stud.studGender}</td>
                  <td>
                    <%
                    kms.model.student currentStudent = (kms.model.student) pageContext.getAttribute("stud");
                    int calculatedAge = 0;
                    if (currentStudent != null && currentStudent.getStudBirthDate() != null) {
                        calculatedAge = CalculateAge.calculateAgeStud(currentStudent.getStudBirthDate());
                    }
                    %>
                    <%= calculatedAge %>
                  </td>
                  <td><fmt:formatDate value="${stud.studBirthDate}" pattern="MMM dd, yyyy" /></td>
                  <td>${stud.studAddress}</td>
                  <td>
                    <a class="buttonNav viewButtonNav" href="viewStudentController?studId=${stud.studId}&age=${param.age}">
                      <i class="fas fa-eye"></i> View
                    </a>
<button class="buttonNav deleteButtonNav"
        data-studid="${stud.studId}"
        data-age="${param.age}"
        onclick="confirmDeleteFunction(this)">
  <i class="fas fa-trash"></i> Delete
</button>


                  </td>
                </tr>
              </c:forEach>
            </tbody>
          </table>
        </div>
      </c:when>
      <c:otherwise>
        <c:if test="${not empty param.age}">
          <div class="emptyStateContainer">
            <i class="fas fa-user-friends"></i>
            <h3>No Students Found</h3>
            <p>No students found for age ${param.age}. Students may not be enrolled yet for this age group.</p>
          </div>
        </c:if>
      </c:otherwise>
    </c:choose>
  </main>
</div>

<c:if test="${param.msg == 'missingId'}">
  <div class="errorMessageBox">
    <i class="fas fa-exclamation-circle"></i>
    Error: Student ID is missing. Please try again.
  </div>
</c:if>


<!-- Mobile Overlay -->
<div class="overlayBackground" id="overlayElement" onclick="toggleSidebarFunction()"></div>

<script>
  function toggleSidebarFunction() {
    const sidebar = document.getElementById("sidebarElement");
    const overlay = document.getElementById("overlayElement");
    
    sidebar.classList.toggle("show");
    overlay.classList.toggle("active");
  }
  function confirmDeleteFunction(buttonElement) {
	  // Ambil studId dan age dari button
	  const studId = buttonElement.getAttribute("data-studid");
	  const age = buttonElement.getAttribute("data-age");

	  // Check ada ke studId
	  if (!studId) {
	    alert("Student ID is missing. Cannot delete.");
	    return;
	  }

	  // Confirm delete
	  if (confirm("Are you sure you want to delete this student?")) {
	    // Buat URL
	    let url = "deleteStudentController?studId=" + studId;
	    if (age) {
	      url = url + "&age=" + age;
	    }
	    
	    // Redirect
	    window.location.href = url;
	  }
	}

  // Close sidebar when clicking on main content
  document.addEventListener('DOMContentLoaded', function() {
    document.addEventListener('click', function(e) {
      const sidebar = document.getElementById('sidebarElement');
      const navButton = document.querySelector('.navSidebarButton');
      
      if (!sidebar.contains(e.target) && 
          !navButton.contains(e.target) && 
          sidebar.classList.contains('show')) {
        toggleSidebarFunction();
      }
    });
  });
</script>

</body>
</html>