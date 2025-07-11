<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Subject List - Teacher View</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <!-- External CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/listSubject.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />

    <script>
        function toggleSidebar() {
            document.getElementById("sidebar").classList.toggle("active");
        }

        function toggleDropdown(id) {
            document.getElementById(id).classList.toggle("show");
        }

        window.addEventListener('click', function(e) {
            document.querySelectorAll(".dropdown-content").forEach(dc => {
                if (!dc.contains(e.target) && !dc.previousElementSibling.contains(e.target)) {
                    dc.classList.remove("show");
                }
            });
        });
    </script>
</head>
<body>

<!-- Header -->
<header>
    <button class="toggle-btn" onclick="toggleSidebar()">
        <i class="fa-solid fa-bars"></i>
    </button>
    <div class="logo">
        <img src="${pageContext.request.contextPath}/image/logo.png" alt="ALKAUTHAR EDUQIDS">
    </div>
</header>

<!-- Sidebar -->
<div class="sidebar" id="sidebar">
    <div class="profile">
        <img src="${pageContext.request.contextPath}/image/teacher.jpg" alt="Teacher Profile">
        <h3>John Doe</h3>
        <p>Teacher</p>
    </div>

    <a href="#">Dashboard</a>
    <a href="#">My Schedule</a>
    
    <a href="#">Logout</a>
</div>

<!-- Page Content -->
<div class="container">
    <h2>Available Subjects</h2>

    <div class="subject-grid">
        <c:choose>
            <c:when test="${empty subjectList}">
                <div class="placeholder">
                    No subjects available yet.
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="subject" items="${subjectList}">
                    <div class="subject-card">
                        <i class="fa-solid fa-book"></i>
                        <p>${subject.subjectName}</p>
                        <p><small>Teacher ID: ${subject.teacherId}</small></p>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
</div>

</body>
</html>
