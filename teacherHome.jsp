<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ page import="kms.model.teacher" %>
<%
    Object user = session.getAttribute("user");
    String role = (String) session.getAttribute("role");
    
    int id = 0;
    String name = "", email = "", phone = "", roleDisplay = "", teacherType = "";

    if (user instanceof teacher) {
        teacher t = (teacher) user;
        id = t.getTeacherId();
        name = t.getTeacherName();
        email = t.getTeacherEmail();
        phone = t.getTeacherPhone();
        roleDisplay = "Teacher";
        teacherType = t.getTeacherType();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Teacher Dashboard - Al Kauthar EduQids</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" />
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="teacherHome.css">
</head>
<body>

<!-- Header -->
<header class="header">
  <button class="menu-toggle" onclick="toggleSidebar()">
    <i class="fas fa-bars"></i>
  </button>
  <div class="logo-section">
    <img src="images/LOGO-AL-KAUTHAR-EDUQIDS.png" alt="Al Kauthar EduQids Logo" />
  </div>
</header>

<nav class="sidebar" id="sidebar">
    <!-- Profile Section -->
    <div class="sidebar-profile">
      <a href="viewAccount.jsp">
        <img src="PhotoServlet?role=<%= role %>&type=photo&id=<%= id %>" 
             alt="Profile Photo" 
             class="profile-avatar"
             onerror="this.src='images/default-avatar.png'" />
      </a>
      <h3 class="profile-name"><%=name%></h3>
      <p class="profile-role"><%= roleDisplay %></p>
    </div>
    
    <div class="nav-section">
      <div class="nav-title">Main Menu</div>
      <ul class="nav-links">
        <li><a href="TeacherHomeController" class="active"><i class="fas fa-home"></i> Dashboard</a></li>
        <li><a href="ListSubjectController"><i class="fas fa-book"></i> Subjects</a></li>
        <li><a href="ListAttendanceController"><i class="fas fa-calendar-check"></i> Attendance</a></li>
        <li><a href="ListStudentController"><i class="fas fa-user-graduate"></i> Students</a></li>
      </ul>
    </div>
    
    <div class="nav-section">
      <div class="nav-title">Quick Actions</div>
      <ul class="nav-links">
        <li><a href="recordAttendance.jsp"><i class="fas fa-clipboard-check"></i> Record Attendance</a></li>
        <li><a href="recordProgress.jsp"><i class="fas fa-chart-line"></i> Record Progress</a></li>
      </ul>
    </div>
    
    <div class="nav-section">
      <div class="nav-title">Account</div>
      <ul class="nav-links">
        <li><a href="viewAccount.jsp"><i class="fas fa-user-cog"></i> Profile Settings</a></li>
        <li><a href="LogoutController"><i class="fas fa-sign-out-alt"></i> Sign Out</a></li>
      </ul>
    </div>
  </nav>

<!-- Image Banner -->
<div class="image-banner">
  <img src="images/kindergarten3.jpg" alt="Kindergarten Banner" class="banner-image" >
</div>

<!-- Welcome Banner -->
<div class="welcome-banner">
  Hi, <%= name %>! Every child entrusted to your care is a trust from Allah. Shape the future with love and barakah!
</div>

<!-- Layout Container -->
<div class="layout">
  <!-- Main Content -->
  <main class="main-content">

    <!-- Stats Grid -->
    <div class="stats-grid">
      <a href="ListStudentController" class="stat-card students">
        <div class="stat-header">
          <div>
            <div class="stat-number">${studentCount}</div>
            <div class="stat-label">Total Students</div>
          </div>
          <div class="stat-icon">
            <i class="fas fa-user-graduate"></i>
          </div>
        </div>
      </a>

      <a href="ListSubjectController" class="stat-card teachers">
        <div class="stat-header">
          <div>
            <div class="stat-number">${subjectName}</div>
            <div class="stat-label">Subject Assigned</div>
          </div>
          <div class="stat-icon">
            <i class="fas fa-book"></i>
          </div>
        </div>
      </a>

      <a href="recordAttendance.jsp" class="stat-card parents">
        <div class="stat-header">
          <div>
            <div class="stat-number">${attendanceCount}</div>
            <div class="stat-label">Attendance</div>
          </div>
          <div class="stat-icon">
            <i class="fas fa-clipboard-check"></i>
          </div>
        </div>
      </a>
    </div>

    <!-- Content Grid -->
    <div class="content-grid">
      <!-- Left Column -->
      <div>
        <div class="content-section quotes-section">
          <h3 class="section-title">
            <div class="section-icon"><i class="fas fa-quote-left"></i></div>
            Daily Inspiration
          </h3>
          <div class="quote-content">${randomQuote}</div>
        </div>
      </div>

      <!-- Right Column -->
      <div>
        <div class="content-section tips-section">
          <h3 class="section-title">
            <div class="section-icon"><i class="fas fa-lightbulb"></i></div>
            Teaching Tips
          </h3>
          <div class="tip-content">Use positive reinforcement and make learning fun through interactive activities. Remember that every child learns at their own pace and deserves patience and encouragement.</div>
        </div>
      </div>
    </div>

    <!-- Date and Birthday Row -->
    <div class="date-birthday-row">
      <div class="content-section calendar-section">
        <h3 class="section-title">
          <div class="section-icon"><i class="fas fa-calendar-alt"></i></div>
          Today's Date
        </h3>
        <div class="calendar-display">
          <div class="date-display" id="current-date"></div>
        </div>
      </div>

     <div class="content-section birthday-section">
        <h3 class="section-title">
          <div class="section-icon"><i class="fas fa-birthday-cake"></i></div>
          Birthday Celebrations
        </h3>
        <div class="birthday-list">
          <c:if test="${empty birthdaysToday}">
            <div class="no-birthday">
              <i class="fas fa-cake" style="font-size: 1.5rem; opacity: 0.3; margin-bottom: 0.5rem; display: block;"></i>
              No birthdays today
            </div>
          </c:if>
          <c:forEach var="stud" items="${birthdaysToday}">
            <div class="birthday-item">
              <strong>${stud.studName}</strong><br>
              <small><fmt:formatDate value="${stud.studBirthDate}" pattern="dd MMM yyyy"/></small>
            </div>
          </c:forEach>
        </div>
      </div>
    </div>
  </main>
</div>

<!-- Mobile Overlay -->
<div class="overlay" id="overlay" onclick="toggleSidebar()"></div>

<script>
  // Mobile sidebar toggle
  function toggleSidebar() {
    const sidebar = document.getElementById('sidebar');
    const overlay = document.getElementById('overlay');
    
    sidebar.classList.toggle('open');
    overlay.classList.toggle('active');
  }

  // Display current date
  function displayCurrentDate() {
    const now = new Date();
    const options = { 
      weekday: 'long', 
      year: 'numeric', 
      month: 'long', 
      day: 'numeric' 
    };
    document.getElementById('current-date').textContent = now.toLocaleDateString('en-US', options);
  }

  // Initialize
  document.addEventListener('DOMContentLoaded', function() {
    displayCurrentDate();
  });

  // Close sidebar when clicking on main content
  document.addEventListener('click', function(e) {
    const sidebar = document.getElementById('sidebar');
    const menuToggle = document.querySelector('.menu-toggle');
    
    if (!sidebar.contains(e.target) && 
        !menuToggle.contains(e.target) && 
        sidebar.classList.contains('open')) {
      toggleSidebar();
    }
  });
</script>

</body>
</html>