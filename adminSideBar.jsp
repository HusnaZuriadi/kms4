<%@ page import="kms.model.teacher" %>
<%
    String role = (String) session.getAttribute("role");
    Object user = session.getAttribute("user");
    
    String name = "";
    int id = 0;
    String roleDisplay = "Admin";

    if ("admin".equalsIgnoreCase(role) && user instanceof teacher) {
        teacher admin = (teacher) user;
        name = admin.getTeacherName();
        id = admin.getTeacherId(); // adminId == teacherId here
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
      <h3 class="profile-name"><%=name%></h3>
      <p class="profile-role"><%= roleDisplay %></p>
    </div>
    
    <div class="nav-section">
      <div class="nav-title">Main Menu</div>
      <ul class="nav-links">
        <li><a href="AdminHomeController" class="active"><i class="fas fa-home"></i> Dashboard</a></li>
        <li><a href="ListSubjectController"><i class="fas fa-book"></i> Subjects</a></li>
        <li><a href="ListAttendanceController"><i class="fas fa-calendar-check"></i> Attendance</a></li>
        <li><a href="ListStudentController"><i class="fas fa-user-graduate"></i> Students</a></li>
      </ul>
    </div>
    
    <div class="nav-section">
      <div class="nav-title">User Management</div>
      <ul class="nav-links">
        <li><a href="ListTeacherController"><i class="fas fa-chalkboard-teacher"></i> Teacher Accounts</a></li>
        <li><a href="ListParentController"><i class="fas fa-users"></i> Parent Accounts</a></li>
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
