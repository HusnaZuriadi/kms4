<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, kms.dao.studentDAO, kms.model.student, kms.model.teacher, kms.helper.CalculateAge" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.sql.Date, java.time.LocalDate" %>

<%@ page session="true" %>

<%
    // Get user session and role
    Object user = session.getAttribute("user");
    String role = (String) session.getAttribute("role");

    int id = 0;
    String name = "", email = "", phone = "", roleDisplay = "", teacherType = "";

    if (role != null && (role.equalsIgnoreCase("teacher") || role.equalsIgnoreCase("admin")) && user instanceof teacher) {
        teacher t = (teacher) user;
        id = t.getTeacherId();
        name = t.getTeacherName();
        email = t.getTeacherEmail();
        phone = t.getTeacherPhone();
        roleDisplay = role.equals("admin") ? "Administrator" : "Teacher";
        teacherType = t.getTeacherType();
    }

    // Get request parameters
    String ageStr = request.getParameter("age");
    String studIdStr = request.getParameter("studId");
    String filterDateStr = request.getParameter("filterDate");

    int selectedAge = 0;
    student selectedStudent = null;
    Date selectedDate = null;

    // Parse selected age
    if (ageStr != null && !ageStr.isEmpty()) {
        try {
            selectedAge = Integer.parseInt(ageStr);
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }
    }

    // Parse selected student
    if (studIdStr != null && !studIdStr.isEmpty()) {
        try {
            int studId = Integer.parseInt(studIdStr);
            selectedStudent = studentDAO.getStudent(studId);
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }
    }

 // Parse date - if coming from list page, use that date, otherwise default to today
    if (filterDateStr != null && !filterDateStr.isEmpty()) {
        selectedDate = Date.valueOf(filterDateStr);
    } else {
        selectedDate = Date.valueOf(LocalDate.now());
    }

    // Filter students - automatically if age is provided
    List<student> filteredStudents = new ArrayList<>();
    if (selectedAge > 0) {
        filteredStudents = studentDAO.getStudentsByAgeWithoutAttendance(selectedAge, selectedDate);
    }
    request.setAttribute("filteredStudents", filteredStudents);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Attendance Form - Al-Kauthar EduQids</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" />
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="attendanceForm.css" />
</head>
<body>
    <!-- Header -->
    <header class="header">
        <button class="navSidebar" onclick="toggleSidebar()" aria-label="Toggle navigation menu">
            <i class="fa-solid fa-bars"></i>
        </button>
        <div class="logo">
            <img src="images/LOGO-AL-KAUTHAR-EDUQIDS.png" alt="Al Kauthar EduQids Logo">
        </div>
    </header>

    <!-- Image Banner -->
    <div class="image-banner">
      <img src="images/kindergarten3.jpg" alt="Kindergarten Banner" class="banner-image">
    </div>

    <!-- Welcome Banner -->
    <div class="welcome-banner">
      Record student attendance quickly and efficiently!
    </div>

    <!-- Layout Container -->
    <div class="layout">
        <!-- Sidebar -->
        <nav class="sidebar" id="sidebar" role="navigation" aria-label="Main navigation">
            <div class="profile">
                <a href="viewAccount.jsp">
                    <img src="PhotoServlet?role=<%= role %>&type=photo&id=<%= id %>" alt="<%= roleDisplay %> Profile Photo">
                </a>
                <h3><%= name %></h3>
                <p><%= roleDisplay %></p>
            </div>
            <ul class="sidebar-links top-links">
                <li><a href="AdminHomeController"><i class="fas fa-home"></i> Home</a></li>
                <li><a href="ListSubjectController"><i class="fas fa-book"></i> Subject</a></li>
                <li><a href="ListAttendanceController"><i class="fas fa-calendar-check"></i> Attendance</a></li>
                <li><a href="recordProgress.jsp"><i class="fas fa-chart-line"></i> Progress</a></li>
                <li><a href="createStudent.jsp"><i class="fas fa-user-graduate"></i> Student</a></li>
            </ul>
            <div class="_separator_1e1cy_1"></div>
            <ul class="sidebar-links bottom-links">
                <li><a href="viewAccount.jsp"><i class="fas fa-user-cog"></i> Account</a></li>
                <li><a href="logout.jsp"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
            </ul>
        </nav>

        <!-- Main Content -->
        <main class="container">
            <!-- Breadcrumb -->
            <div class="breadcrumb">
                <a href="ListAttendanceController">
                    <i class="fas fa-arrow-left"></i>
                    Back to Attendance List
                </a>
            </div>

            <!-- Page Header -->
            <div class="page-header">
                <h1>
                    <i class="fas fa-calendar-check"></i>
                    Record Attendance
                </h1>
                <p>Select student and record their daily attendance</p>
            </div>

            <!-- Step Progress -->
            <div class="step-progress">
                <div class="progress-steps">
                    <div class="step <%= selectedAge > 0 ? "completed" : "active" %>" id="step1">
                        <div class="step-number">
                            <%= selectedAge > 0 ? "<i class='fas fa-check'></i>" : "1" %>
                        </div>
                        <div class="step-label">Select Age</div>
                    </div>
                    <div class="step <%= selectedStudent != null ? "completed" : (selectedAge > 0 ? "active" : "") %>" id="step2">
                        <div class="step-number">
                            <%= selectedStudent != null ? "<i class='fas fa-check'></i>" : "2" %>
                        </div>
                        <div class="step-label">Select Student</div>
                    </div>
                    <div class="step <%= selectedStudent != null ? "active" : "" %>" id="step3">
                        <div class="step-number">3</div>
                        <div class="step-label">Record Attendance</div>
                    </div>
                </div>
            </div>

          <!-- Step 1: Age Selection -->
        <% if (selectedAge == 0) { %>
        <div class="form-section" id="ageSelection">
            <div class="section-header">
                <h3>
                    <i class="fas fa-calendar-alt"></i>
                    Step 1: Select Age Group
                </h3>
            </div>
            <div class="section-content">
               <form action="attendanceForm.jsp" method="get">
               <input type="hidden" name="filterDate" value="<%= selectedDate %>" />
              <label for="age">Filter by Age:</label>
              <select name="age" id="age" onchange="this.form.submit()">
                <option value="">-- Select Age --</option>
                <c:forEach var="i" begin="4" end="6">
                  <option value="${i}">${i} Years Old</option>
                </c:forEach>
              </select>
            </form>
            </div>
        </div>
        <% } else { %>
        <!-- Show selected age info instead -->
        <div class="form-section" id="ageSelected">
            <div class="section-header">
                <h3>
                    <i class="fas fa-check-circle" style="color: #88c34e;"></i>
                    Step 1: Age Group Selected
                </h3>
            </div>
            <div class="section-content">
                <div class="info-box">
                    <i class="fas fa-users"></i>
                    <div>
                        <strong>Selected Age Group:</strong> <%= selectedAge %> Years Old<br>
                        <strong>Date:</strong> <%= selectedDate %>
                    </div>
                    <a href="attendanceForm.jsp">
                        <i class="fas fa-edit"></i> Change
                    </a>
                </div>
            </div>
        </div>
        <% } %>

            <!-- Step 2: Student Selection -->
            <% if (selectedAge > 0) { %>
            <div class="form-section fade-in" id="studentSelection">
                <div class="section-header">
                    <h3>
                        <i class="fas fa-users"></i>
                        Step 2: Select Student (Age <%= selectedAge %>)
                    </h3>
                </div>
                <div class="section-content">
                  <form method="get" action="attendanceForm.jsp" id="studentForm">
          <input type="hidden" name="filterDate" value="<%= selectedDate %>" />
        <input type="hidden" name="age" value="<%= selectedAge %>" />

          <div class="form-group">
            <label for="studId">Select Student:</label>
            <select name="studId" id="studId" required onchange="this.form.submit()">
                <option value="">-- Select Student --</option>
                <c:forEach var="s" items="${filteredStudents}">
                    <c:set var="selectedId" value="${param.studId}" />
                    <option value="${s.studId}" <c:if test="${selectedId != null && selectedId == (s.studId)}">
                    selected</c:if>>
                        ${s.studName}
                    </option>
                </c:forEach>
            </select>
        </div>

          <% if (filteredStudents.isEmpty()) { %>
            <div class="empty-state">
              <i class="fas fa-info-circle"></i>
              <p>No students found for age <%= selectedAge %> who haven't recorded attendance today.</p>
            </div>
          <% } %>
        </form>

                </div>
            </div>
            <% } %>
            
            <!-- Selected Student Display -->
        <% if (selectedStudent != null) { 
            // Calculate age using your existing class
            int calculatedAge = 0;
            if (selectedStudent.getStudBirthDate() != null) {
                calculatedAge = CalculateAge.calculateAgeStud(selectedStudent.getStudBirthDate());
            }
        %>
        <div class="selected-student-card fade-in">
            <img src="PhotoServlet?role=student&type=photo&id=<%= selectedStudent.getStudId() %>" 
                 class="student-photo" alt="Student Photo" 
                 onerror="this.style.display='none'; this.nextElementSibling.style.display='block';">
            <div class="student-name"><%= selectedStudent.getStudName() %></div>
            <div class="student-info">
                Student ID: <%= selectedStudent.getStudId() %> | 
                Age: <%= calculatedAge %> years | 
                Gender: <%= selectedStudent.getStudGender() %>
            </div>
        </div>
        <% } %>

            <!-- Step 3: Attendance Form -->
            <% if (selectedStudent != null) { %>
            <div class="form-section fade-in" id="attendanceForm">
                <div class="section-header">
                    <h3>
                        <i class="fas fa-clipboard-check"></i>
                        Step 3: Record Attendance for <%= selectedStudent.getStudName() %>
                    </h3>
                </div>
                <div class="section-content">
                    <form action="AddAttendanceController" method="post">
                    <input type="hidden" name="filterDate" value="<%= selectedDate %>" />
                    
                        <input type="hidden" name="studId" value="<%= selectedStudent.getStudId() %>" />
                        <input type="hidden" name="age" value="<%= selectedAge %>" />
                    
                        <div class="form-group">
                            <label for="attendanceDate">
                                <i class="fas fa-calendar"></i>
                                Date
                            </label>
                            <input type="date" id="attendanceDate" name="attendanceDate" 
                                   class="form-input" value="<%= selectedDate %>" readonly />
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="checkinTime">
                                    <i class="fas fa-clock"></i>
                                    Check-in Time
                                </label>
                                <input type="time" id="checkinTime" name="checkinTime" class="form-input" required/>
                            </div>

                            <div class="form-group">
                                <label for="checkoutTime">
                                    <i class="fas fa-clock"></i>
                                    Check-out Time
                                </label>
                                <input type="time" id="checkoutTime" name="checkoutTime" class="form-input" />
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="attendanceStatus">
                                    <i class="fas fa-user-check"></i>
                                    Attendance Status
                                </label>
                                <select id="attendanceStatus" name="attendanceStatus" class="form-select" required>
                                    <option value="">Select Status</option>
                                    <option value="Present">Present</option>
                                    <option value="Absent">Absent</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="checkinTemp">
                                    <i class="fas fa-thermometer-half"></i>
                                    Check-in Temperature
                                </label>
                                <input type="text" id="checkinTemp" name="checkinTemp" 
                                       class="form-input" placeholder="36.5°C"  required />
                            </div>
                        </div>

                        <div class="form-buttons">
                            <button type="reset" class="btn cancel-btn">
                                <i class="fas fa-undo"></i>
                                Reset Form
                            </button>
                            <button type="submit" class="btn save-btn">
                                <i class="fas fa-save"></i>
                                Submit Attendance
                            </button>
                        </div>
                    </form>
                </div>
            </div>
            <% } %>
        </main>
    </div>

    <!-- Mobile Overlay -->
    <div class="overlay" id="overlay" onclick="toggleSidebar()"></div>

    <script>
    function toggleSidebar() {
        const sidebar = document.getElementById('sidebar');
        const overlay = document.getElementById('overlay');
        
        sidebar.classList.toggle('show');
        overlay.classList.toggle('active');
    }

    document.addEventListener("DOMContentLoaded", function () {
        // Attendance status logic
        const statusSelect = document.getElementById("attendanceStatus");
        if (statusSelect) {
            statusSelect.addEventListener("change", function () {
                const checkin = document.getElementById("checkinTime");
                const checkout = document.getElementById("checkoutTime");
                const temp = document.getElementById("checkinTemp");

                console.log("Attendance status selected:", this.value);

                if (this.value === "Absent") {
                    if (checkin) { checkin.value = ""; checkin.disabled = true; }
                    if (checkout) { checkout.value = ""; checkout.disabled = true; }
                    if (temp) { temp.value = ""; temp.disabled = true; }
                } else {
                    if (checkin) checkin.disabled = false;
                    if (checkout) checkout.disabled = false;
                    if (temp) temp.disabled = false;
                }
            });

            // Trigger once on load
            statusSelect.dispatchEvent(new Event("change"));
        }

        // Form validation
        const attendanceForm = document.querySelector('form[action="AddAttendanceController"]');
        if (attendanceForm) {
            attendanceForm.addEventListener("submit", function (e) {
                const status = document.getElementById("attendanceStatus").value;
                const checkin = document.getElementById("checkinTime");

                if (status === "Present" && checkin && checkin.value === "") {
                    e.preventDefault();
                    alert("Please provide check-in time for present students.");
                    checkin.focus();
                    return false;
                }

                const submitBtn = attendanceForm.querySelector(".save-btn");
                if (submitBtn) {
                    submitBtn.classList.add("loading");
                    submitBtn.disabled = true;
                }
            });
        }

        // Close sidebar when clicking on main content
        document.addEventListener('click', function(e) {
          const sidebar = document.getElementById('sidebar');
          const navSidebar = document.querySelector('.navSidebar');
          
          if (!sidebar.contains(e.target) && 
              !navSidebar.contains(e.target) && 
              sidebar.classList.contains('show')) {
            toggleSidebar();
          }
        });
    });
</script>

</body>
</html>