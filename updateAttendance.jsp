<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kms.model.student, kms.dao.studentDAO, java.util.List, kms.model.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page session="true" %>

<%
    Object user = session.getAttribute("user");
    String role = (String) session.getAttribute("role");

    int id = 0;
    String name = "", email = "", phone = "", roleDisplay = "", teacherType = "";
    double salary = 0.0;
    int contract = 0;

    if (role != null && user != null) {
       if ((role.equalsIgnoreCase("teacher") || role.equalsIgnoreCase("admin")) && user instanceof teacher) {
            teacher t = (teacher) user;
            id = t.getTeacherId();
            name = t.getTeacherName();
            email = t.getTeacherEmail();
            phone = t.getTeacherPhone();
            roleDisplay = role.equals("admin") ? "Administrator" : "Teacher";
            teacherType = t.getTeacherType();

        }
    }

    studentDAO dao = new studentDAO();
    List<student> students = dao.getAllStudents();
    request.setAttribute("students", students);
%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8" />
  <title>Update Attendance - Alkauthar Eduqids</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
  <link rel="stylesheet" href="css/updateAttendance.css"/>
</head>
<body>

<!-- Header -->
<header class="headerContainer">
  <button class="navSidebarButton" onclick="toggleSidebarFunction()">
    <i class="fa-solid fa-bars"></i>
  </button>
  <div class="logoContainer">
    <img src="images/LOGO-AL-KAUTHAR-EDUQIDS.png" alt="Al Kauthar EduQids Logo" />
  </div>
</header>



<!-- Layout Container -->
<div class="layoutContainer">
  <!-- Sidebar -->
  <nav class="sidebarNavigation" id="sidebarElement">
    <div class="profileSection">
      <a href="viewAccount.jsp">
        <img src="PhotoServlet?role=<%= role %>&type=photo&id=<%= id %>" alt="Profile Photo">
      </a>
      <h3><%= name %></h3>
      <p><%= roleDisplay %></p>
    </div>
    <ul class="sidebarLinksContainer top-links">
      <li><a href="AdminHomeController"><i class="fas fa-home"></i> Home</a></li>
      <li><a href="ListSubjectController"><i class="fas fa-book"></i> Subject</a></li>
      <li><a href="ListAttendanceController"><i class="fas fa-calendar-check"></i> Attendance</a></li>
      <li><a href="recordProgress.jsp"><i class="fas fa-chart-line"></i> Progress</a></li>
      <li><a href="createStudent.jsp"><i class="fas fa-user-graduate"></i> Student</a></li>
    </ul>
    <div class="separatorLine"></div>
    <ul class="sidebarLinksContainer bottom-links">
      <li><a href="viewAccount.jsp"><i class="fas fa-user-cog"></i> Account</a></li>
      <li><a href="logout.jsp"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
    </ul>
  </nav>

  <!-- Main Content -->
  <main class="mainContentContainer">
    <!-- Breadcrumb -->
    <div class="nav2">
      <a href="ListAttendanceController">
        <i class="fas fa-arrow-left"></i>
        Back to Attendance List
      </a>
    </div>

    <!-- Page Header -->
    <div class="pageHeaderContent">
      <h1>
        <i class="fas fa-edit"></i>
        Update Attendance
      </h1>
      <p>Modify attendance record details</p>
    </div>

    <!-- Attendance Form -->
    <div class="formSectionContainer fadeInAnimation">
      <div class="sectionHeaderTitle">
        <h3>
          <i class="fas fa-clipboard-check"></i>
          Attendance Record Details
        </h3>
      </div>
      <div class="sectionContentArea">
        <form action="UpdateAttendanceController" method="post">
          <input type="hidden" name="attendanceId" value="${attendance.attendanceId}" />
          <input type="hidden" name="filterDate" value="${attendance.attendanceDate}" />
          

         <div class="formGroupContainer">
  <strong><i class="fas fa-calendar"></i> Date :</strong>
  <input type="hidden" name="attendanceDate" value="${attendance.attendanceDate}" />
  <input type="date" class="inputFieldStyle" value="${attendance.attendanceDate}" disabled />
</div>

<div class="formGroupContainer">
  <strong><i class="fas fa-user"></i> Student Name :</strong>
  <input type="hidden" name="studId" value="${attendance.studId}" />
  <input type="text" class="selectFieldStyle" value="${attendance.studName}" disabled />
</div>


          <div class="formRowLayout">
            <div class="formGroupContainer">
              <strong><i class="fas fa-sign-in-alt"></i> Check-in Time :</strong>
              <input type="datetime-local" id="checkinTimeInput" name="checkinTime" class="inputFieldStyle"
                value="<fmt:formatDate value='${attendance.checkinTime}' pattern='yyyy-MM-dd\'T\'HH:mm' />" required />
            </div>

            <div class="formGroupContainer">
              <strong><i class="fas fa-sign-out-alt"></i> Checkout Time :</strong>
              <input type="datetime-local" id="checkoutTimeInput" name="checkoutTime" class="inputFieldStyle"
                value="<fmt:formatDate value='${attendance.checkoutTime}' pattern='yyyy-MM-dd\'T\'HH:mm' />" required />
            </div>
          </div>

          <div class="formRowLayout">
            <div class="formGroupContainer">
              <strong><i class="fas fa-check-circle"></i> Attendance Status :</strong>
              <select name="attendanceStatus" id="attendanceStatusSelect" class="selectFieldStatus" required>
                <option value="Present" ${attendance.attendanceStatus == 'Present' ? 'selected' : ''}>Present</option>
                <option value="Absent" ${attendance.attendanceStatus == 'Absent' ? 'selected' : ''}>Absent</option>
              </select>
            </div>

            <div class="formGroupContainer">
              <strong><i class="fas fa-thermometer-half"></i> Check-in Temperature :</strong>
              <input type="text" id="checkinTempInput" name="checkinTemp" value="${attendance.checkinTemp}" class="inputFieldStyle" required />
            </div>
          </div>

          <div class="formButtonContainer">
            <button type="reset" class="buttonNav cancelButtonNav">
              <i class="fas fa-undo"></i>
              Reset
            </button>
            <button type="submit" class="buttonNav saveButtonNav">
              <i class="fas fa-save"></i>
              Update
            </button>
          </div>
        </form>
      </div>
    </div>
  </main>
</div>

<!-- Mobile Overlay -->
<div class="overlayBackground" id="overlayElement" onclick="toggleSidebarFunction()"></div>

<script>
  function toggleSidebarFunction() {
    const sidebar = document.getElementById("sidebarElement");
    const overlay = document.getElementById("overlayElement");
    
    sidebar.classList.toggle("show");
    overlay.classList.toggle("active");
  }
  
  document.addEventListener('DOMContentLoaded', function () {
      const statusSelect = document.getElementById("attendanceStatusSelect");
      const checkinInput = document.getElementById("checkinTimeInput");
      const checkoutInput = document.getElementById("checkoutTimeInput");
      const checkinTempInput = document.getElementById("checkinTempInput");

      function updateCheckFieldsFunction() {
        if (statusSelect.value === "Absent") {
            checkinInput.value = "";
            checkoutInput.value = "";
            checkinTempInput.value = "-";

            checkinInput.readOnly = true;
            checkoutInput.readOnly = true;
            checkinTempInput.readOnly = true;

            checkinInput.required = false;
            checkoutInput.required = false;
            checkinTempInput.required = false;
        } else {
            checkinInput.readOnly = false;
            checkoutInput.readOnly = false;
            checkinTempInput.readOnly = false;

            checkinInput.required = true;
            checkoutInput.required = true;
            checkinTempInput.required = true;

            // If previously marked Absent, clear dash for fresh input
            if (checkinTempInput.value === "-") {
                checkinTempInput.value = "";
            }
        }
      }

      // run on load
      updateCheckFieldsFunction();

      // run when status changes
      statusSelect.addEventListener("change", updateCheckFieldsFunction);

      // Close sidebar when clicking on main content
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
