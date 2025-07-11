<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="kms.model.*" %>
<%
    Object user = session.getAttribute("user");
    String role = (String) session.getAttribute("role");

    int id = 0;
    String name = "", email = "", phone = "", roleDisplay = "", teacherType = "";
    double salary = 0.0;
    int contract = 0;

    if (role != null && user != null) {
        if (role.equals("parent") && user instanceof parent) {
            parent p = (parent) user;
            id = p.getParentId();
            name = p.getParentName();
            email = p.getParentEmail();
            phone = p.getParentPhone();
            roleDisplay = "Parent";
        } else if ((role.equalsIgnoreCase("teacher") || role.equalsIgnoreCase("admin")) && user instanceof teacher) {
            teacher t = (teacher) user;
            id = t.getTeacherId();
            name = t.getTeacherName();
            email = t.getTeacherEmail();
            phone = t.getTeacherPhone();
            roleDisplay = role.equals("admin") ? "Admin" : "Teacher";
            teacherType = t.getTeacherType();

            if (t instanceof fullTime) {
                Double s = ((fullTime) t).getSalary(); // wrapper type
                if (s != null) {
                    salary = s;
                }
            } else if (t instanceof partTime) {
                Integer c = ((partTime) t).getContract(); // wrapper type
                if (c != null) {
                    contract = c;
                }
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Details - Al Kauthar EduQids</title>
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
            box-shadow: none;
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
            object-fit: cover;
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

        .nav-links a i {
            font-size: 1.1rem;
            width: 20px;
            text-align: center;
        }

        /* Main Container */
        .container {
            margin-left: 0;
            margin-top: 80px;
            padding: 2rem;
            min-height: calc(100vh - 80px);
            transition: margin-left 0.3s ease;
            max-width: 1200px;
            margin-left: auto;
            margin-right: auto;
        }

        .container.shifted {
            margin-left: 300px;
        }

        .page-header {
            background: #ffffff;
            padding: 2rem;
            border-radius: 20px;
            margin-bottom: 2rem;
            box-shadow: 0 4px 20px rgba(136, 195, 78, 0.15);
            border: 2px solid #fce4ec;
            text-align: center;
        }

        .page-header h1 {
            font-size: 2.5rem;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 1rem;
        }

        .page-header p {
            color: #34495e;
            font-size: 1.1rem;
            font-weight: 500;
        }

        .student-grid {
            display: grid;
            grid-template-columns: 1fr 2fr;
            gap: 2rem;
            margin-bottom: 2rem;
        }

        .student-photo-card {
            background: #ffffff;
            border-radius: 20px;
            box-shadow: 0 4px 20px rgba(136, 195, 78, 0.15);
            border: 2px solid #e0e0e0;
            padding: 2rem;
            text-align: center;
            height: fit-content;
            position: relative;
            overflow: hidden;
        }

        .student-photo-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #f491ba, #fce4ec);
        }

        .student-photo-container {
            position: relative;
            margin-bottom: 1rem;
        }

        .student-photo {
            width: 200px;
            height: 200px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid #f491ba;
            box-shadow: 0 8px 30px rgba(244, 145, 186, 0.3);
            margin: 0 auto;
            display: block;
        }

        .photo-placeholder {
            width: 200px;
            height: 200px;
            border-radius: 50%;
            background: #fce4ec;
            border: 4px solid #f491ba;
            box-shadow: 0 8px 30px rgba(244, 145, 186, 0.3);
            margin: 0 auto;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #f491ba;
            font-size: 3rem;
        }

        .student-name {
            font-size: 1.5rem;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 0.5rem;
        }

        .student-id {
            color: #34495e;
            font-size: 0.875rem;
            background: #e8f5e8;
            color: #2c3e50;
            padding: 0.25rem 0.75rem;
            border-radius: 12px;
            display: inline-block;
            font-weight: 600;
        }

        .student-details-card {
            background: #ffffff;
            border-radius: 20px;
            box-shadow: 0 4px 20px rgba(136, 195, 78, 0.15);
            border: 2px solid #e0e0e0;
            overflow: hidden;
        }

        .card-header {
            background: linear-gradient(135deg, #88c34e 0%, #9dd45e 100%);
            color: white;
            padding: 1.5rem 2rem;
            border-bottom: none;
        }

        .card-header h3 {
            font-size: 1.25rem;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .card-content {
            padding: 2rem;
        }

        .details-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1.5rem;
        }

        .detail-item {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }

        .detail-item.full-width {
            grid-column: 1 / -1;
        }

        .detail-label {
            font-weight: 600;
            color: #2c3e50;
            font-size: 0.875rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .detail-label i {
            color: #2c3e50;
        }

        .detail-value {
            color: #2c3e50;
            font-size: 1rem;
            padding: 0.75rem 1rem;
            background: #f8f9fa;
            border-radius: 12px;
            border: 2px solid #e0e0e0;
            min-height: 3rem;
            display: flex;
            align-items: center;
        }

        .detail-value.empty {
            color: #6c757d;
            font-style: italic;
        }

        .documents-card {
            background: #ffffff;
            border-radius: 20px;
            box-shadow: 0 4px 20px rgba(136, 195, 78, 0.15);
            border: 2px solid #e0e0e0;
            margin-bottom: 2rem;
        }

        .document-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 1.5rem;
            border-bottom: 1px solid #e0e0e0;
        }

        .document-item:last-child {
            border-bottom: none;
        }

        .document-info {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .document-icon {
            width: 48px;
            height: 48px;
            background: #2c3e50;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.25rem;
        }

        .document-details h4 {
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 0.25rem;
        }

        .document-status {
            font-size: 0.875rem;
            color: #34495e;
        }

        .document-status.available {
            color: #28a745;
        }

        .document-status.missing {
            color: #dc3545;
        }

        .document-actions a {
            background: #2c3e50;
            color: white;
            padding: 0.75rem 1.5rem;
            border-radius: 12px;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .document-actions a:hover {
            background: #1a252f;
            transform: translateY(-1px);
            box-shadow: 0 4px 20px rgba(44, 62, 80, 0.3);
        }

        .document-actions.disabled {
            opacity: 0.5;
            pointer-events: none;
        }

        /* Action Buttons */
        .action-buttons {
            background: #ffffff;
            border-radius: 20px;
            box-shadow: 0 4px 20px rgba(136, 195, 78, 0.15);
            border: 2px solid #e0e0e0;
            padding: 2rem;
            display: flex;
            gap: 1rem;
            justify-content: center;
            flex-wrap: wrap;
        }

        .btn {
            padding: 1rem 2rem;
            border: none;
            border-radius: 16px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.75rem;
            min-width: 160px;
            justify-content: center;
        }

        .btn-primary {
            background: linear-gradient(135deg, #88c34e 0%, #9dd45e 100%);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 30px rgba(136, 195, 78, 0.3);
        }

        .btn-secondary {
            background: #6c757d;
            color: white;
        }

        .btn-secondary:hover {
            background: #5a6268;
            transform: translateY(-2px);
            box-shadow: 0 8px 30px rgba(108, 117, 125, 0.3);
        }

        .btn-danger {
            background: #dc3545;
            color: white;
        }

        .btn-danger:hover {
            background: #c82333;
            transform: translateY(-2px);
            box-shadow: 0 8px 30px rgba(220, 53, 69, 0.3);
        }

        /* Show edit and delete buttons for parent */
        .role-parent .btn-primary {
            display: inline-flex;
        }

        .role-parent .btn-danger {
            display: inline-flex;
        }

        /* Hide edit button for admin, show only delete */
        .role-admin .btn-primary {
            display: none;
        }

        .role-admin .btn-danger {
            display: inline-flex;
        }

        /* Status badges */
        .status-badge {
            padding: 0.5rem 1rem;
            border-radius: 12px;
            font-size: 0.875rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            margin-top: 1rem;
            display: inline-block;
        }

        .status-active {
            background: #d4edda;
            color: #2c3e50;
        }

        /* Mobile Responsiveness */
        @media (max-width: 768px) {
            .container {
                margin: 1rem auto;
                padding: 0 0.5rem;
            }

            .container.shifted {
                margin-left: 0;
            }

            .page-header {
                padding: 1.5rem;
            }

            .page-header h1 {
                font-size: 2rem;
                flex-direction: column;
                gap: 0.5rem;
            }

            .student-grid {
                grid-template-columns: 1fr;
                gap: 1rem;
            }

            .details-grid {
                grid-template-columns: 1fr;
                gap: 1rem;
            }

            .action-buttons {
                flex-direction: column;
                align-items: stretch;
            }

            .btn {
                min-width: auto;
            }

            .document-item {
                flex-direction: column;
                gap: 1rem;
                text-align: center;
            }

            .sidebar {
                width: 280px;
                transform: translateX(-100%);
            }

            .sidebar.show {
                transform: translateX(0);
            }

            header {
                padding: 1rem;
            }
        }

        /* Animations */
        .student-photo-card, .student-details-card, .documents-card, .action-buttons {
            animation: slideUp 0.6s ease forwards;
            opacity: 0;
            transform: translateY(20px);
        }

        .student-photo-card { animation-delay: 0.1s; }
        .student-details-card { animation-delay: 0.2s; }
        .documents-card { animation-delay: 0.3s; }
        .action-buttons { animation-delay: 0.4s; }

        @keyframes slideUp {
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    </style>
</head>
    <body class="role-<%= role != null ? role.toLowerCase() : "guest" %>">
    <header>
        <button class="navSidebar" onclick="toggleSidebar()" aria-label="Toggle navigation menu">
            <i class="fa-solid fa-bars"></i>
        </button>
        <div class="logo">
            <img src="images/LOGO-AL-KAUTHAR-EDUQIDS.png" alt="Al Kauthar EduQids Logo">
        </div>
    </header>

    <nav class="sidebar" id="sidebar" role="navigation" aria-label="Main navigation">
        <div class="sidebar-profile">
            <img src="PhotoServlet?role=<%= role %>&type=photo&id=<%= id %>" 
                 alt="Profile Photo" 
                 class="profile-avatar"
                 onerror="this.src='images/default-avatar.png'">
            <h3 class="profile-name"><%= name %></h3>
            <p class="profile-role"><%= roleDisplay %></p>
        </div>
        
        <% if ("parent".equals(role)) { %>
            <div class="nav-section">
                <div class="nav-title">Main Menu</div>
                <ul class="nav-links">
                    <li><a href="ParentHomeController"><i class="fas fa-home"></i> Dashboard</a></li>
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
        <% } else if ("admin".equals(role)) { %>
            <div class="nav-section">
                <div class="nav-title">Main Menu</div>
                <ul class="nav-links">
                    <li><a href="AdminHomeController"><i class="fas fa-home"></i> Dashboard</a></li>
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
        <% } %>
        
        <div class="nav-section">
            <div class="nav-title">Account</div>
            <ul class="nav-links">
                <li><a href="viewAccount.jsp"><i class="fas fa-user-cog"></i> Profile Settings</a></li>
                <li><a href="LogoutController"><i class="fas fa-sign-out-alt"></i> Sign Out</a></li>
            </ul>
        </div>
    </nav>

    <main class="container" id="container">
        <!-- Page Header -->
        <div class="page-header">
            <h1>
                <i class="fas fa-user-graduate"></i>
                Student Profile
            </h1>
            <p>Comprehensive student information and documents</p>
        </div>

        <!-- Student Photo and Basic Info -->
        <div class="student-grid">
            <div class="student-photo-card">
                <div class="student-photo-container">
                    <c:choose>
                        <c:when test="${not empty student.studPhoto}">
                            <img src="PhotoServlet?role=student&type=photo&id=${student.studId}" 
                                 class="student-photo" alt="Student Photo" 
                                 onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                            <div class="photo-placeholder" style="display: none;">
                                <i class="fas fa-user"></i>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="photo-placeholder">
                                <i class="fas fa-user"></i>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="student-name">
                    <c:out value="${student.studName}" />
                </div>
                <div class="student-id">
                    Student ID: ${student.studId}
                </div>
                <div>
                    <span class="status-badge status-active">
                        <i class="fas fa-check-circle"></i> Enrolled
                    </span>
                </div>
            </div>

            <!-- Student Details -->
            <div class="student-details-card">
                <div class="card-header">
                    <h3>
                        <i class="fas fa-info-circle"></i>
                        Personal Information
                    </h3>
                </div>
                <div class="card-content">
                    <div class="details-grid">
                        <div class="detail-item">
                            <div class="detail-label">
                                <i class="fas fa-user"></i> Full Name
                            </div>
                            <div class="detail-value">
                                <c:out value="${student.studName}" />
                            </div>
                        </div>

                        <div class="detail-item">
                            <div class="detail-label">
                                <i class="fas fa-venus-mars"></i> Gender
                            </div>
                            <div class="detail-value">
                                <c:out value="${student.studGender}" />
                            </div>
                        </div>

                        <div class="detail-item">
                            <div class="detail-label">
                                <i class="fas fa-birthday-cake"></i> Age
                            </div>
                            <div class="detail-value">
                                <c:out value="${student.age}" /> years old
                            </div>
                        </div>

                        <div class="detail-item">
                            <div class="detail-label">
                                <i class="fas fa-calendar-alt"></i> Date of Birth
                            </div>
                            <div class="detail-value">
                                <fmt:formatDate value="${student.studBirthDate}" pattern="dd MMMM yyyy"/>
                            </div>
                        </div>

                        <div class="detail-item full-width">
                            <div class="detail-label">
                                <i class="fas fa-map-marker-alt"></i> Home Address
                            </div>
                            <div class="detail-value">
                                <c:choose>
                                    <c:when test="${not empty student.studAddress}">
                                        <c:out value="${student.studAddress}" />
                                    </c:when>
                                    <c:otherwise>
                                        <span class="empty">No address provided</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Documents -->
        <div class="documents-card">
            <div class="card-header">
                <h3>
                    <i class="fas fa-folder-open"></i>
                    Documents & Certificates
                </h3>
            </div>
            
            <div class="document-item">
                <div class="document-info">
                    <div class="document-icon">
                        <i class="fas fa-file-alt"></i>
                    </div>
                    <div class="document-details">
                        <h4>Birth Certificate</h4>
                        <div class="document-status ${not empty student.studBirthCert ? 'available' : 'missing'}">
                            <i class="fas ${not empty student.studBirthCert ? 'fa-check-circle' : 'fa-times-circle'}"></i>
                            ${not empty student.studBirthCert ? 'Document available' : 'Document not uploaded'}
                        </div>
                    </div>
                </div>
                <div class="document-actions ${empty student.studBirthCert ? 'disabled' : ''}">
                    <c:if test="${not empty student.studBirthCert}">
                        <a href="PhotoServlet?id=${student.studId}&type=cert&role=student" target="_blank">
                            <i class="fas fa-external-link-alt"></i>
                            View Document
                        </a>
                    </c:if>
                </div>
            </div>
        </div>

        <!-- Action Buttons -->
        <div class="action-buttons">
            <% if ("parent".equals(role)) { %>
                <a href="updateStudentController?studId=${student.studId}" class="btn btn-primary">
                    <i class="fas fa-edit"></i>
                    Edit Student Information
                </a>
                <button onclick="confirmDelete()" class="btn btn-danger">
                    <i class="fas fa-trash-alt"></i>
                    Delete Student
                </button>
            <% } %>
            
            <% if ("admin".equals(role)) { %>
                <button onclick="confirmDelete()" class="btn btn-danger">
                    <i class="fas fa-trash-alt"></i>
                    Delete Student
                </button>
            <% } %>
            
            <a href="ListStudentController" class="btn btn-secondary">
                <i class="fas fa-arrow-left"></i>
                Back to List
            </a>
        </div>
    </main>

    <script>
        function toggleSidebar() {
            const sidebar = document.getElementById("sidebar");
            const container = document.getElementById("container");
            
            sidebar.classList.toggle("show");
            container.classList.toggle("shifted");
        }

        function confirmDelete() {
            if (confirm('Are you sure you want to delete this student? This action cannot be undone.')) {
                // Redirect to delete controller
                window.location.href = 'deleteStudentController?studId=${student.studId}';
            }
        }

        // Add loading animation for document links
        document.querySelectorAll('.document-actions a').forEach(link => {
            link.addEventListener('click', function() {
                const icon = this.querySelector('i');
                const originalClass = icon.className;
                icon.className = 'fas fa-spinner fa-spin';
                
                setTimeout(() => {
                    icon.className = originalClass;
                }, 2000);
            });
        });

        // Close sidebar when clicking outside
        document.addEventListener('click', function(e) {
            const sidebar = document.getElementById('sidebar');
            const navButton = document.querySelector('.navSidebar');
            const container = document.getElementById('container');
            
            if (!sidebar.contains(e.target) && !navButton.contains(e.target) && sidebar.classList.contains('show')) {
                sidebar.classList.remove('show');
                container.classList.remove('shifted');
            }
        });

        // Add accessibility enhancements
        document.addEventListener('DOMContentLoaded', function() {
            // Add keyboard navigation for action buttons
            document.querySelectorAll('.btn').forEach(button => {
                button.addEventListener('keydown', function(e) {
                    if (e.key === 'Enter' || e.key === ' ') {
                        e.preventDefault();
                        this.click();
                    }
                });
            });

            // Announce page load to screen readers
            const announcement = document.createElement('div');
            announcement.setAttribute('aria-live', 'polite');
            announcement.setAttribute('aria-atomic', 'true');
            announcement.className = 'sr-only';
            announcement.textContent = 'Student profile page loaded';
            document.body.appendChild(announcement);
        });
    </script>
</body>
</html>