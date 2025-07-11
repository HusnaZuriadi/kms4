<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page session="true" %>
<%@ page import="java.time.LocalDate" %>
<%
    kms.model.parent parentUser = (kms.model.parent) session.getAttribute("user");
    String role = (String) session.getAttribute("role");
    String name = "";
    int id = 0;

    if (parentUser != null) {
        name = parentUser.getParentName();
        id = parentUser.getParentId();
    }
%>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Child Attendance - Al Kauthar EduQids</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
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
        header {
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

        .navSidebar {
            position: absolute;
            left: 2rem;
            top: 50%;
            transform: translateY(-50%);
            color: #ffffff;
            background: transparent;
            border: none;
            font-size: 1.8rem;
            cursor: pointer;
            transition: color 0.3s ease;
        }

        .navSidebar:hover {
            color: #f0f0f0;
        }

        .logo {
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .logo img {
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

        .sidebar.show {
            transform: translateX(0);
        }

        .profile {
            text-align: center;
            background: #fce4ec;
            padding: 2rem 1rem;
            border-radius: 20px;
            margin-bottom: 2rem;
            color: #2c3e50;
            box-shadow: 0 4px 20px rgba(244, 145, 186, 0.15);
            border: 2px solid #f491ba;
        }

        .profile img {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            border: 4px solid rgba(255,255,255,0.3);
            margin-bottom: 1rem;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
            object-fit: cover;
        }

        .profile h3 {
            font-size: 1.3rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            color: #1a252f;
        }

        .profile p {
            font-size: 0.9rem;
            font-weight: 500;
            color: #34495e;
            text-transform: capitalize;
        }

        .sidebar-links {
            list-style: none;
            margin-bottom: 2rem;
        }

        .sidebar-links li {
            margin-bottom: 0.5rem;
        }

        .sidebar-links a {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 1rem 1.2rem;
            color: #34495e;
            text-decoration: none;
            border-radius: 16px;
            transition: all 0.3s ease;
            font-weight: 500;
        }

        .sidebar-links a:hover {
            background: #f6f9f3;
            color: #2c3e50;
            transform: translateX(5px);
            box-shadow: 0 4px 20px rgba(136, 195, 78, 0.15);
        }

        .sidebar-links a.active {
            background: #e8f5e8;
            color: #2c3e50;
            box-shadow: 0 8px 30px rgba(136, 195, 78, 0.2);
            border: 2px solid #88c34e;
        }

        .sidebar-links a i {
            font-size: 1.1rem;
            width: 20px;
            text-align: center;
        }

        ._separator_1e1cy_1 {
            height: 2px;
            background: linear-gradient(90deg, transparent, #e0e0e0, transparent);
            margin: 1.5rem 0;
            border-radius: 2px;
        }

        /* Main Content */
        .content-wrapper {
            margin-left: 0;
            margin-top: 80px;
            padding: 2rem;
            min-height: calc(100vh - 80px);
            transition: margin-left 0.3s ease;
        }

        .content-wrapper.shifted {
            margin-left: 300px;
        }

        /* Page Header */
        .page-header {
            background: #ffffff;
            padding: 2rem;
            border-radius: 20px;
            margin-bottom: 2rem;
            box-shadow: 0 4px 20px rgba(136, 195, 78, 0.15);
            border: 2px solid #fce4ec;
            text-align: center;
        }

        .page-title {
            font-size: 2.5rem;
            font-weight: 700;
            color: #88c34e;
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 1rem;
        }

        .page-subtitle {
            color: #34495e;
            font-size: 1.1rem;
            font-weight: 500;
        }

        /* Filter Section */
        .filter-section {
            background: #ffffff;
            padding: 2rem;
            border-radius: 20px;
            margin-bottom: 2rem;
            box-shadow: 0 4px 20px rgba(136, 195, 78, 0.15);
            border: 2px solid #e0e0e0;
        }

        .filter-title {
            font-size: 1.3rem;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .filter-icon {
            width: 40px;
            height: 40px;
            border-radius: 16px;
            background: #e8f5e8;
            color: #2c3e50;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.1rem;
            box-shadow: 0 4px 20px rgba(136, 195, 78, 0.15);
        }

        .filter-form {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 2rem;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        .form-label {
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 0.75rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .form-label i {
            color: #88c34e;
        }

        .form-select, .form-input {
            padding: 1rem 1.25rem;
            border: 2px solid #e0e0e0;
            border-radius: 16px;
            font-size: 1rem;
            font-family: inherit;
            transition: all 0.3s ease;
            background: #ffffff;
        }

        .form-select:focus, .form-input:focus {
            outline: none;
            border-color: #88c34e;
            box-shadow: 0 0 0 3px rgba(136, 195, 78, 0.1);
        }

        /* Alert Messages */
        .alert {
            padding: 1rem 1.5rem;
            border-radius: 16px;
            margin-bottom: 2rem;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .alert-warning {
            background: #fef3cd;
            color: #856404;
            border: 2px solid #ffeaa7;
        }

        .alert-info {
            background: #d4edda;
            color: #155724;
            border: 2px solid #c3e6cb;
        }

        .alert i {
            font-size: 1.2rem;
        }

        /* Attendance Table */
        .attendance-section {
            background: #ffffff;
            border-radius: 20px;
            box-shadow: 0 4px 20px rgba(136, 195, 78, 0.15);
            border: 2px solid #e0e0e0;
            overflow: hidden;
        }

        .attendance-header {
            background: linear-gradient(135deg, #88c34e 0%, #9dd45e 100%);
            color: white;
            padding: 1.5rem 2rem;
            font-weight: 700;
            font-size: 1.2rem;
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .attendance-table {
            width: 100%;
            border-collapse: collapse;
        }

        .attendance-table th {
            background: #f8f9fa;
            padding: 1rem;
            text-align: left;
            font-weight: 600;
            color: #2c3e50;
            border-bottom: 2px solid #e0e0e0;
        }

        .attendance-table td {
            padding: 1rem;
            border-bottom: 1px solid #e0e0e0;
            transition: background-color 0.3s ease;
        }

        .attendance-table tr:hover {
            background: #f8f9fa;
        }

        .attendance-table tr:last-child td {
            border-bottom: none;
        }

        .status-present {
            color: #28a745;
            font-weight: 600;
        }

        .status-absent {
            color: #dc3545;
            font-weight: 600;
        }

        .status-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 12px;
            font-size: 0.875rem;
            font-weight: 600;
            text-transform: uppercase;
        }

        .status-badge.present {
            background: #d4edda;
            color: #155724;
        }

        .status-badge.absent {
            background: #f8d7da;
            color: #721c24;
        }

        .time-display {
            font-family: monospace;
            background: #f8f9fa;
            padding: 0.25rem 0.5rem;
            border-radius: 8px;
            font-weight: 600;
        }

        .temp-display {
            font-weight: 600;
            color: #88c34e;
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            background: #ffffff;
            border-radius: 20px;
            box-shadow: 0 4px 20px rgba(136, 195, 78, 0.15);
            border: 2px solid #e0e0e0;
        }

        .empty-icon {
            width: 100px;
            height: 100px;
            margin: 0 auto 2rem;
            border-radius: 50%;
            background: #fce4ec;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 3rem;
            color: #f491ba;
        }

        .empty-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 1rem;
        }

        .empty-text {
            color: #34495e;
            font-size: 1rem;
        }

        /* Mobile Responsiveness */
        @media (max-width: 768px) {
            .content-wrapper {
                padding: 1rem;
            }

            .content-wrapper.shifted {
                margin-left: 0;
            }

            .page-title {
                font-size: 2rem;
                flex-direction: column;
                gap: 0.5rem;
            }

            .filter-form {
                grid-template-columns: 1fr;
                gap: 1rem;
            }

            .attendance-table {
                font-size: 0.875rem;
            }

            .attendance-table th,
            .attendance-table td {
                padding: 0.75rem 0.5rem;
            }

            .sidebar {
                transform: translateX(-100%);
            }

            .sidebar.show {
                transform: translateX(0);
            }
        }

        /* Animations */
        .filter-section, .attendance-section, .empty-state {
            animation: slideUp 0.6s ease forwards;
            opacity: 0;
            transform: translateY(20px);
        }

        .filter-section { animation-delay: 0.1s; }
        .attendance-section { animation-delay: 0.2s; }
        .empty-state { animation-delay: 0.2s; }

        @keyframes slideUp {
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    </style>
</head>
<body>

<!-- Header -->
<header>
    <button class="navSidebar" onclick="toggleSidebar()">
        <i class="fa-solid fa-bars"></i>
    </button>
    <div class="logo">
        <img src="images/LOGO-AL-KAUTHAR-EDUQIDS.png" alt="ALKAUTHAR EDUQIDS Logo">
    </div>
</header>

<!-- Sidebar -->
<nav class="sidebar" id="sidebar">
    <div class="profile">
        <a href="viewAccount.jsp">
            <img src="PhotoServlet?role=<%= role %>&type=photo&id=<%= id %>" alt="Profile Photo" onerror="this.src='images/default-avatar.png'">
        </a>
        <h3><%= name %></h3>
        <p><%= role%></p>
    </div>
    <ul class="sidebar-links top-links">
        <c:choose>
            <c:when test="${role == 'admin'}">
                <li><a href="AdminHomeController"><i class="fas fa-home"></i> Home</a></li>
            </c:when>
            <c:when test="${role == 'teacher'}">
                <li><a href="TeacherHomeController"><i class="fas fa-home"></i> Home</a></li>
            </c:when>
            <c:when test="${role == 'parent'}">
                <li><a href="ParentHomeController"><i class="fas fa-home"></i> Home</a></li>
            </c:when>
        </c:choose>
        <li><a href="ListSubjectController"><i class="fas fa-book"></i> Subject</a></li>
        <li><a href="ListAttendanceParentController" class="active"><i class="fas fa-calendar-check"></i> Attendance</a></li>
        <li><a href="recordProgress.jsp"><i class="fas fa-chart-line"></i> Progress</a></li>
        <li><a href="ListStudentController"><i class="fas fa-user-graduate"></i> Student</a></li>
    </ul>
    <div class="_separator_1e1cy_1"></div>
    <ul class="sidebar-links bottom-links">
        <li><a href="viewAccount.jsp"><i class="fas fa-user-cog"></i> Account</a></li>
        <li><a href="LogoutController"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
    </ul>
</nav>

<!-- Main Content -->
<div class="content-wrapper" id="content-wrapper">
    
    <!-- Page Header -->
    <div class="page-header">
        <h1 class="page-title">
            <i class="fas fa-calendar-check"></i>
            Child Attendance Records
        </h1>
        <p class="page-subtitle">Track your child's daily attendance and check-in details</p>
    </div>

    <!-- Filter Section -->
    <div class="filter-section">
        <h3 class="filter-title">
            <div class="filter-icon">
                <i class="fas fa-filter"></i>
            </div>
            Filter Attendance Records
        </h3>
        
        <form method="get" action="ListAttendanceParentController" id="attendanceForm" class="filter-form">
            <div class="form-group">
                <label for="studId" class="form-label">
                    <i class="fas fa-child"></i>
                    Select Child
                </label>
                <select name="studId" id="studId" class="form-select" onchange="document.getElementById('attendanceForm').submit()">
                    <option value="">-- Choose Your Child --</option>
                    <c:forEach var="child" items="${children}">
                        <option value="${child.studId}" ${child.studId == selectedStudId ? 'selected' : ''}>${child.studName}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group">
                <label for="month" class="form-label">
                    <i class="fas fa-calendar-alt"></i>
                    Select Month
                </label>
                <input type="month" name="month" id="month" class="form-input" value="${selectedMonth}" onchange="document.getElementById('attendanceForm').submit()" />
            </div>
        </form>
    </div>

    <!-- Alert Messages -->
    <c:if test="${empty selectedStudId}">
        <div class="alert alert-warning">
            <i class="fas fa-exclamation-triangle"></i>
            Please select a child from the dropdown above to view attendance records.
        </div>
    </c:if>

    <!-- Attendance Results -->
    <c:choose>
        <c:when test="${not empty attendanceList}">
            <div class="attendance-section">
                <div class="attendance-header">
                    <i class="fas fa-calendar-check"></i>
                    Attendance for <strong><c:out value="${attendanceList[0].studName}" /></strong> - ${selectedMonth}
                </div>
                
                <table class="attendance-table">
                    <thead>
                        <tr>
                            <th><i class="fas fa-calendar-day"></i> Date</th>
                            <th><i class="fas fa-user-check"></i> Status</th>
                            <th><i class="fas fa-sign-in-alt"></i> Check-in Time</th>
                            <th><i class="fas fa-sign-out-alt"></i> Check-out Time</th>
                            <th><i class="fas fa-thermometer-half"></i> Temperature</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="att" items="${attendanceList}">
                            <tr>
                                <td>
                                    <strong><fmt:formatDate value="${att.attendanceDate}" pattern="dd MMM yyyy" /></strong><br>
                                    <small style="color: #6c757d;"><fmt:formatDate value="${att.attendanceDate}" pattern="EEEE" /></small>
                                </td>
                                <td>
                                    <span class="status-badge ${att.attendanceStatus == 'Present' ? 'present' : 'absent'}">
                                        <c:out value="${att.attendanceStatus}" />
                                    </span>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${att.checkinTime != null}">
                                            <span class="time-display">
                                                <fmt:formatDate value="${att.checkinTime}" pattern="HH:mm:ss" />
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: #6c757d;">Not recorded</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${att.checkoutTime != null}">
                                            <span class="time-display">
                                                <fmt:formatDate value="${att.checkoutTime}" pattern="HH:mm:ss" />
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: #6c757d;">Not recorded</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty att.checkinTemp}">
                                            <span class="temp-display"><c:out value="${att.checkinTemp}" />°C</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: #6c757d;">-</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:when>
        <c:when test="${not empty selectedStudId and empty attendanceList}">
            <div class="empty-state">
                <div class="empty-icon">
                    <i class="fas fa-calendar-times"></i>
                </div>
                <h2 class="empty-title">No Attendance Records Found</h2>
                <p class="empty-text">
                    No attendance records were found for the selected child and month. 
                    Please try selecting a different month or check back later.
                </p>
            </div>
        </c:when>
    </c:choose>
</div>

<!-- JavaScript -->
<script>
    function toggleSidebar() {
        const sidebar = document.getElementById("sidebar");
        const contentWrapper = document.getElementById("content-wrapper");
        
        sidebar.classList.toggle("show");
        contentWrapper.classList.toggle("shifted");
    }

    // Close sidebar when clicking outside
    document.addEventListener('click', function(e) {
        const sidebar = document.getElementById('sidebar');
        const navButton = document.querySelector('.navSidebar');
        const contentWrapper = document.getElementById('content-wrapper');
        
        if (!sidebar.contains(e.target) && !navButton.contains(e.target) && sidebar.classList.contains('show')) {
            sidebar.classList.remove('show');
            contentWrapper.classList.remove('shifted');
        }
    });

    // Auto-submit form when selections change
    document.addEventListener('DOMContentLoaded', function() {
        const studSelect = document.getElementById('studId');
        const monthInput = document.getElementById('month');
        
        // Set current month as default if no month selected
        if (!monthInput.value) {
            const now = new Date();
            const currentMonth = now.getFullYear() + '-' + String(now.getMonth() + 1).padStart(2, '0');
            monthInput.value = currentMonth;
        }
    });
</script>

</body>
</html>