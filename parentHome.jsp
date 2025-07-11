<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="kms.model.*" %>
<%@ page session="true" %>
<%
    Object user = session.getAttribute("user");
    String role = (String) session.getAttribute("role");
    
    int id = 0;
    String name = "", email = "", phone = "", roleDisplay = "";

    if (user instanceof kms.model.parent) {
        kms.model.parent p = (kms.model.parent) user;
        id = p.getParentId();
        name = p.getParentName();
        email = p.getParentEmail();
        phone = p.getParentPhone();
        roleDisplay = "Parent";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Parent Dashboard - Al Kauthar EduQids</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" />
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    body {
      font-family: "Poppins", sans-serif;
      background: #efefe7;
      color: #2c3e50;
      line-height: 1.6;
      min-height: 100vh;
    }

    /* Header */
    .header {
      background: #88c34e;
      border-bottom: 3px solid #9dd45e;
      height: 80px;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 0 2rem;
      box-shadow: 0 4px 20px rgba(136, 195, 78, 0.15);
      position: fixed;
      top: 0;
      left: 0;
      right: 0;
      z-index: 100;
    }

    .menu-toggle {
      position: absolute;
      left: 2rem;
      top: 50%;
      transform: translateY(-50%);
      color: #ffffff;
      background: transparent;
      border: none;
      box-shadow: none;
      font-size: 1.8rem;
      cursor: pointer;
      transition: color 0.3s ease;
    }

    .menu-toggle:hover {
      color: #f0f0f0;
    }

    .logo-section {
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .logo-section img {
      height: 60px;
      filter: drop-shadow(0 4px 8px rgba(0,0,0,0.1));
    }

    /* Sidebar */
    .sidebar {
      width: 300px;
      background: #ffffff;
      border-right: 3px solid #9dd45e;
      padding: 2rem 1.5rem;
      overflow-y: auto;
      transition: transform 0.3s ease;
      box-shadow: 5px 0 15px rgba(136, 195, 78, 0.05);
      position: fixed;
      top: 80px;
      left: 0;
      height: calc(100vh - 80px);
      transform: translateX(-100%);
      z-index: 60;
    }

    .sidebar.open {
      transform: translateX(0);
    }

    .sidebar-profile {
      text-align: center;
      background: #fce4ec;
      padding: 2rem 1rem;
      border-radius: 20px;
      margin-bottom: 2rem;
      color: #2c3e50;
      box-shadow: 0 4px 20px rgba(244, 145, 186, 0.15);
      border: 2px solid #f491ba;
    }

    .profile-avatar {
      width: 80px;
      height: 80px;
      border-radius: 50%;
      border: 4px solid rgba(255,255,255,0.3);
      margin-bottom: 1rem;
      box-shadow: 0 4px 15px rgba(0,0,0,0.2);
    }

    .profile-name {
      font-size: 1.3rem;
      font-weight: 700;
      margin-bottom: 0.5rem;
      color: #1a252f;
    }

    .profile-role {
      font-size: 0.9rem;
      font-weight: 500;
      color: #34495e;
    }

    .nav-section {
      margin-bottom: 2rem;
    }

    .nav-title {
      font-size: 0.8rem;
      font-weight: 700;
      color: #34495e;
      text-transform: uppercase;
      letter-spacing: 1px;
      margin-bottom: 1rem;
      padding: 0 1rem;
    }

    .nav-links {
      list-style: none;
    }

    .nav-links li {
      margin-bottom: 0.5rem;
    }

    .nav-links a {
      display: flex;
      align-items: center;
      gap: 1rem;
      padding: 1rem 1.2rem;
      color: #34495e;
      text-decoration: none;
      border-radius: 16px;
      transition: all 0.3s ease;
      font-weight: 500;
      position: relative;
      overflow: hidden;
    }

    .nav-links a::before {
      content: '';
      position: absolute;
      left: 0;
      top: 0;
      width: 4px;
      height: 100%;
      background: #9dd45e;
      transform: scaleY(0);
      transition: transform 0.3s ease;
    }

    .nav-links a:hover {
      background: #f6f9f3;
      color: #2c3e50;
      transform: translateX(5px);
      box-shadow: 0 4px 20px rgba(136, 195, 78, 0.15);
    }

    .nav-links a:hover::before {
      transform: scaleY(1);
    }

    .nav-links a.active {
      background: #e8f5e8;
      color: #2c3e50;
      box-shadow: 0 8px 30px rgba(136, 195, 78, 0.2);
      border: 2px solid #88c34e;
    }

    .nav-links a.active::before {
      transform: scaleY(1);
      background: rgba(255,255,255,0.3);
    }

    .nav-links a i {
      font-size: 1.1rem;
      width: 20px;
      text-align: center;
    }

    /* Image Banner */
    .image-banner {
      height: 300px;
      display: flex;
      align-items: center;
      justify-content: center;
      position: relative;
      overflow: hidden;
      box-shadow: 0 4px 20px rgba(136, 195, 78, 0.15);
      margin: 0;
      width: 100%;
      margin-top: 80px
    }

    .banner-image {
      width: 100%;
      height: 100%;
      object-fit: cover;
      opacity: 0.8;
      display: block;
    }

    /* Welcome Banner */
    .welcome-banner {
      background: #f5f5ed;
      color: #2c3e50;
      padding: 1rem 2rem;
      text-align: center;
      font-weight: 600;
      font-size: 1.1rem;
      border-radius: 16px;
      margin: 1rem;
      box-shadow: 0 4px 20px rgba(136, 195, 78, 0.15);
      border: 2px solid #88c34e;
    }

    /* Layout */
    .layout {
      display: flex;
      min-height: calc(100vh - 280px);
    }

    /* Main Container */
    .mainContainer {
      flex: 1;
      padding: 2rem;
      max-width: 100%;
    }

    /* Parent Dashboard Cards */
    .parent-dashboard {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
      gap: 2rem;
      margin-bottom: 2rem;
    }

    .dashboard-card {
      background: #ffffff;
      padding: 2rem;
      border-radius: 20px;
      box-shadow: 0 4px 20px rgba(136, 195, 78, 0.15);
      border: 2px solid #e0e0e0;
      transition: all 0.3s ease;
      position: relative;
      overflow: hidden;
    }

    .dashboard-card::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      height: 4px;
    }

    .dashboard-card.family::before {
      background: linear-gradient(90deg, #f491ba, #fce4ec);
    }

    .dashboard-card.activities::before {
      background: linear-gradient(90deg, #88c34e, #9dd45e);
    }

    .dashboard-card.progress::before {
      background: linear-gradient(90deg, #fce4ec, #f491ba);
    }

    .dashboard-card:hover {
      transform: translateY(-5px) scale(1.02);
      box-shadow: 0 8px 30px rgba(136, 195, 78, 0.2);
      border-color: #88c34e;
    }

    .card-header {
      display: flex;
      align-items: center;
      gap: 1rem;
      margin-bottom: 1.5rem;
    }

    .card-icon {
      width: 60px;
      height: 60px;
      border-radius: 16px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 1.5rem;
      color: white;
      box-shadow: 0 8px 30px rgba(0, 0, 0, 0.15);
    }

    .dashboard-card.family .card-icon {
      background: linear-gradient(135deg, #f491ba, #fce4ec);
    }

    .dashboard-card.activities .card-icon {
      background: linear-gradient(135deg, #88c34e, #9dd45e);
    }

    .dashboard-card.progress .card-icon {
      background: linear-gradient(135deg, #fce4ec, #f491ba);
    }

    .card-title {
      font-size: 1.5rem;
      font-weight: 700;
      color: #2c3e50;
      margin-bottom: 0.5rem;
    }

    .card-subtitle {
      color: #34495e;
      font-size: 0.9rem;
      font-weight: 500;
    }

    .card-content {
      margin-bottom: 1.5rem;
    }

    .family-info {
      display: flex;
      flex-direction: column;
      gap: 1rem;
    }

    .family-item {
      display: flex;
      align-items: center;
      gap: 1rem;
      padding: 1rem;
      background: #f8f9fa;
      border-radius: 12px;
      transition: all 0.3s ease;
    }

    .family-item:hover {
      background: #fce4ec;
      transform: translateX(5px);
    }

    .family-avatar {
      width: 50px;
      height: 50px;
      border-radius: 50%;
      background: linear-gradient(135deg, #f491ba, #fce4ec);
      display: flex;
      align-items: center;
      justify-content: center;
      color: white;
      font-weight: 700;
      font-size: 1.2rem;
      flex-shrink: 0;
    }
    
    .family-avatar img
    {
    width: 50px; 
    height: 50px; 
    border-radius: 50%; 
    object-fit: cover;
    }

    .family-details h4 {
      font-weight: 600;
      color: #2c3e50;
      margin-bottom: 0.25rem;
    }

    .family-details p {
      color: #34495e;
      font-size: 0.9rem;
    }

    .activity-list {
      display: flex;
      flex-direction: column;
      gap: 0.75rem;
    }

    .activity-item {
      display: flex;
      align-items: center;
      gap: 1rem;
      padding: 0.75rem;
      background: #f8f9fa;
      border-radius: 12px;
      transition: all 0.3s ease;
    }

    .activity-item:hover {
      background: #e8f5e8;
      transform: translateX(5px);
    }

    .activity-icon {
      width: 35px;
      height: 35px;
      border-radius: 50%;
      background: #88c34e;
      color: white;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 0.9rem;
      flex-shrink: 0;
    }

    .activity-text {
      flex: 1;
    }

    .activity-text strong {
      color: #2c3e50;
      font-weight: 600;
    }

    .activity-text small {
      color: #34495e;
      font-size: 0.85rem;
    }

    .progress-items {
      display: flex;
      flex-direction: column;
      gap: 1rem;
    }

    .progress-item {
      background: #f8f9fa;
      padding: 1rem;
      border-radius: 12px;
      transition: all 0.3s ease;
    }

    .progress-item:hover {
      background: #fce4ec;
      transform: translateX(5px);
    }

    .progress-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 0.5rem;
    }

    .progress-label {
      font-weight: 600;
      color: #2c3e50;
    }

    .progress-value {
      color: #f491ba;
      font-weight: 700;
    }

    .progress-bar {
      width: 100%;
      height: 8px;
      background: #e0e0e0;
      border-radius: 4px;
      overflow: hidden;
    }

    .progress-fill {
      height: 100%;
      background: linear-gradient(90deg, #f491ba, #fce4ec);
      border-radius: 4px;
      transition: width 0.3s ease;
    }

    .card-actions {
      display: flex;
      gap: 0.75rem;
      flex-wrap: wrap;
    }

    .card-btn {
      flex: 1;
      min-width: 120px;
      padding: 0.75rem 1rem;
      border: none;
      border-radius: 12px;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.3s ease;
      text-decoration: none;
      text-align: center;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 0.5rem;
      font-size: 0.9rem;
    }

    .card-btn.primary {
      background: #88c34e;
      color: white;
    }

    .card-btn.primary:hover {
      background: #76a33e;
      transform: translateY(-2px);
    }

    .card-btn.secondary {
      background: #f491ba;
      color: white;
    }

    .card-btn.secondary:hover {
      background: #e67fa3;
      transform: translateY(-2px);
    }

    /* Content Grid */
    .content-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
      gap: 1.5rem;
      margin-bottom: 2rem;
    }

    .content-section {
      background: #ffffff;
      padding: 2rem;
      border-radius: 20px;
      box-shadow: 0 4px 20px rgba(136, 195, 78, 0.15);
      position: relative;
      border: 2px solid #e0e0e0;
      transition: all 0.3s ease;
    }

    .content-section:hover {
      border-color: #88c34e;
      box-shadow: 0 8px 30px rgba(136, 195, 78, 0.2);
    }

    .section-title {
      display: flex;
      align-items: center;
      gap: 1rem;
      font-size: 1.3rem;
      font-weight: 700;
      color: #2c3e50;
      margin-bottom: 1.5rem;
    }

    .section-icon {
      width: 40px;
      height: 40px;
      border-radius: 16px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 1.1rem;
      box-shadow: 0 4px 20px rgba(136, 195, 78, 0.15);
    }

    .quotes-section .section-icon {
      background: #fce4ec;
      color: #2c3e50;
    }

    .tips-section .section-icon {
      background: #e8f5e8;
      color: #2c3e50;
    }

    .calendar-section .section-icon {
      background: #e8f5e8;
      color: #2c3e50;
    }

    .quote-content, .tip-content {
      color: #34495e;
      font-style: italic;
      line-height: 1.8;
      font-size: 1rem;
      position: relative;
      padding: 1rem;
      background: #f5f5f5;
      border-radius: 16px;
      border-left: 4px solid #fce4ec;
    }

    .tip-content {
      border-left-color: #e8f5e8;
    }

    /* Date section */
    .calendar-display {
      text-align: center;
      padding: 1.5rem;
      background: #f5f5f5;
      border-radius: 16px;
    }

    .date-display {
      font-size: 1.3rem;
      font-weight: 700;
      color: #88c34e;
    }

    /* Mobile Overlay */
    .overlay {
      display: none;
      position: fixed;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      background: rgba(136, 195, 78, 0.3);
      backdrop-filter: blur(5px);
      z-index: 50;
    }

    .overlay.active {
      display: block;
    }

    /* Mobile Responsiveness */
    @media (max-width: 768px) {
      .menu-toggle {
        display: block;
        position: static;
        margin-right: auto;
      }

      .header {
        justify-content: space-between;
      }

      .logo-section {
        order: 2;
      }

      .sidebar {
        transform: translateX(-100%);
      }

      .sidebar.open {
        transform: translateX(0);
      }

      .mainContainer {
        padding: 1rem;
      }

      .header {
        padding: 0 1rem;
      }

      .parent-dashboard, .content-grid {
        grid-template-columns: 1fr;
      }

      .welcome-banner {
        margin: 0.5rem;
        font-size: 1rem;
      }

      .image-banner {
        height: 150px;
      }

      .card-actions {
        flex-direction: column;
      }

      .card-btn {
        min-width: auto;
      }
    }

    /* Animations */
    .dashboard-card, .content-section {
      animation: slideUp 0.6s ease forwards;
      opacity: 0;
      transform: translateY(20px);
    }

    .dashboard-card:nth-child(1) { animation-delay: 0.1s; }
    .dashboard-card:nth-child(2) { animation-delay: 0.2s; }
    .dashboard-card:nth-child(3) { animation-delay: 0.3s; }

    @keyframes slideUp {
      to {
        opacity: 1;
        transform: translateY(0);
      }
    }

    /* Print styles */
    @media print {
      .sidebar, .menu-toggle, .overlay, .image-banner { display: none !important; }
      .mainContainer { padding: 0; }
      .dashboard-card, .content-section { 
        break-inside: avoid; 
        box-shadow: none;
        border: 1px solid #ddd;
      }
    }
  </style>
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
        <li><a href="ParentHomeController" class="active"><i class="fas fa-home"></i> Dashboard</a></li>
        <li><a href="ListChooseSubjectController"><i class="fas fa-book"></i> Subjects</a></li>
        <li><a href="ListAttendanceParentController"><i class="fas fa-calendar-check"></i> Attendance</a></li>
        <li><a href="ListStudentController"><i class="fas fa-child"></i> My Children</a></li>
      </ul>
    </div>
    
    <div class="nav-section">
      <div class="nav-title">Quick Actions</div>
      <ul class="nav-links">
        <li><a href="createStudent.jsp"><i class="fas fa-user-plus"></i> Add Child</a></li>
        <li><a href="ChooseSubject.jsp"><i class="fas fa-book-open"></i> Register Subject</a></li>
      </ul>
    </div>
    
    <div class="nav-section">
      <div class="nav-title">Account</div>
      <ul class="nav-links">
        <li><a href="viewAccount.jsp"><i class="fas fa-user-cog"></i> Profile Settings</a></li>
        <li><a href="LogoutController.jsp"><i class="fas fa-sign-out-alt"></i> Sign Out</a></li>
      </ul>
    </div>
  </nav>

<!-- Image Banner -->
<div class="image-banner">
  <img src="images/kindergarten3.jpg" alt="Kindergarten Banner" class="banner-image" >
</div>

<!-- Welcome Banner -->
<div class="welcome-banner">
  Hi, <%= name %>! Your partnership in your child's education is a blessing. Together, we nurture young minds with love and faith!
</div>

<!-- Layout Container -->
<div class="layout">
  <!-- Main Content -->
  <main class="mainContainer">

    <!-- Parent Dashboard Cards -->
    <div class="parent-dashboard">
      
      <!-- Family Overview Card -->
      <div class="dashboard-card family">
        <div class="card-header">
          <div class="card-icon">
            <i class="fas fa-users"></i>
          </div>
          <div>
            <h3 class="card-title">Family Overview</h3>
            <p class="card-subtitle">Your children's information</p>
          </div>
        </div>
        <div class="card-content">
          <div class="family-info">
            <c:choose>
              <c:when test="${not empty studentList}">
                <c:forEach var="stud" items="${studentList}" varStatus="status">
                  <c:if test="${status.index < 2}">
                    <div class="family-item">
                      <div class="family-avatar">
                       <img src="PhotoServlet?role=student&type=photo&id=${stud.studId}" />
                      </div>
                      <div class="family-details">
                        <h4>${stud.studName}</h4>
                      </div>
                    </div>
                  </c:if>
                </c:forEach>
                <c:if test="${fn:length(studentList) > 2}">
                  <div class="family-item">
                    <div class="family-avatar">
                      +${fn:length(studentList) - 2}
                    </div>
                    <div class="family-details">
                      <h4>More Children</h4>
                      <p>View all your children</p>
                    </div>
                  </div>
                </c:if>
              </c:when>
              <c:otherwise>
                <div class="family-item">
                  <div class="family-avatar">
                    <i class="fas fa-plus"></i>
                  </div>
                  <div class="family-details">
                    <h4>No Children Registered</h4>
                    <p>Add your first child to get started</p>
                  </div>
                </div>
              </c:otherwise>
            </c:choose>
          </div>
        </div>
        <div class="card-actions">
          <a href="ListStudentController" class="card-btn primary">
            <i class="fas fa-eye"></i>
            View All
          </a>
          <a href="createStudent.jsp" class="card-btn secondary">
            <i class="fas fa-plus"></i>
            Add Child
          </a>
        </div>
      </div>

      <!-- Today's Activities Card -->
      <div class="dashboard-card activities">
        <div class="card-header">
          <div class="card-icon">
            <i class="fas fa-calendar-day"></i>
          </div>
          <div>
            <h3 class="card-title">Today's Activities</h3>
            <p class="card-subtitle">Daily schedule and events</p>
          </div>
        </div>
        <div class="card-content">
          <div class="activity-list">
            <div class="activity-item">
              <div class="activity-icon">
                <i class="fas fa-calendar-check"></i>
              </div>
              <div class="activity-text">
                <strong>Attendance Status</strong><br>
                <small>${attendanceStatus != null ? attendanceStatus : 'Check attendance'}</small>
              </div>
            </div>
            <div class="activity-item">
              <div class="activity-icon">
                <i class="fas fa-book"></i>
              </div>
              <div class="activity-text">
                <strong>Active Subjects</strong><br>
                <small>${totalSubjects != null ? totalSubjects : '0'} subjects enrolled</small>
              </div>
            </div>
          </div>
        </div>
        <div class="card-actions">
          <a href="ListAttendanceParentController" class="card-btn primary">
            <i class="fas fa-calendar-check"></i>
            Attendance
          </a>
          <a href="ListChooseSubjectController" class="card-btn secondary">
            <i class="fas fa-book"></i>
            Subjects
          </a>
        </div>
      </div>

      <!-- Progress Tracking Card -->
      <div class="dashboard-card progress">
        <div class="card-header">
          <div class="card-icon">
            <i class="fas fa-chart-line"></i>
          </div>
          <div>
            <h3 class="card-title">Learning Progress</h3>
            <p class="card-subtitle">Academic development overview</p>
          </div>
        </div>
        <div class="card-content">
          <div class="progress-items">
            <div class="progress-item">
              <div class="progress-header">
                <span class="progress-label">Overall Development</span>
                <span class="progress-value">85%</span>
              </div>
              <div class="progress-bar">
                <div class="progress-fill" style="width: 85%"></div>
              </div>
            </div>
            <div class="progress-item">
              <div class="progress-header">
                <span class="progress-label">Social Skills</span>
                <span class="progress-value">92%</span>
              </div>
              <div class="progress-bar">
                <div class="progress-fill" style="width: 92%"></div>
              </div>
            </div>
            <div class="progress-item">
              <div class="progress-header">
                <span class="progress-label">Creative Learning</span>
                <span class="progress-value">78%</span>
              </div>
              <div class="progress-bar">
                <div class="progress-fill" style="width: 78%"></div>
              </div>
            </div>
          </div>
        </div>
        <div class="card-actions">
          <a href="#" class="card-btn primary">
            <i class="fas fa-chart-bar"></i>
            View Reports
          </a>
          <a href="#" class="card-btn secondary">
            <i class="fas fa-download"></i>
            Download
          </a>
        </div>
      </div>
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
            Parenting Tips
          </h3>
          <div class="tip-content">Be present, listen actively, and lead by example. Create a nurturing environment where your child feels safe to learn, explore, and grow with confidence and Islamic values.</div>
        </div>
      </div>
    </div>

    <!-- Today's Date Section -->
    <div class="content-grid">
      <div>
        <div class="content-section calendar-section">
          <h3 class="section-title">
            <div class="section-icon"><i class="fas fa-calendar-alt"></i></div>
            Today's Date
          </h3>
          <div class="calendar-display">
            <div class="date-display" id="current-date"></div>
          </div>
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