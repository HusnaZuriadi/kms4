<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String role = (String) session.getAttribute("role");
    String name = (String) session.getAttribute("name");
    String roleDisplay = "Teacher";
    int id = 0;

    if ("teacher".equalsIgnoreCase(role)) {
        id = (session.getAttribute("teacherId") != null) ? (int) session.getAttribute("teacherId") : 0;
    }
%>

<nav class="sidebar" id="sidebar">
    <!-- Profile Section -->
    <div class="sidebar-profile">
        <a href="viewAccount.jsp">
            <img src="PhotoServlet?role=<%= role %>&type=photo&id=<%= id %>" 
                alt="Profile Photo" 
                class="profile-avatar"
                onerror="this.src='images/default-avatar.png'" />
        </a>
        <h3 class="profile-name"><%= name %></h3>
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
