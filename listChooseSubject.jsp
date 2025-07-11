<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%
    kms.model.parent parentUser = (kms.model.parent) session.getAttribute("user");
	String role = (String) session.getAttribute("role");
    String parentName = "";
    int id = 0;

    if (parentUser != null) {
        parentName = parentUser.getParentName();
        id = parentUser.getParentId();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Choose Subject</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    
    <!-- External CSS -->
    <link rel="stylesheet" href="listChooseSubject.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
</head>

<body>


<!-- Header -->
<header>
		<button class="navSidebar" onclick="toggleSidebar()">
			<i class="fa-solid fa-bars"></i>
		</button>
		<div class="logo">
			<img src="images/LOGO-AL-KAUTHAR-EDUQIDS.png"
				alt="ALKAUTHAR EDUQIDS Logo">
		</div>
	</header>

<!-- Sidebar -->
<nav class="sidebar" id="sidebar">
  <div class="profile">
    <a href="viewAccount.jsp">
      <img src="PhotoServlet?role=<%= role %>&type=photo&id=<%= id %>" >
    </a>
    <h3><%= role %></h3>
    <p>===</p>
  </div>
  <ul class="sidebar-links top-links">
    <li><a href="parentHome.jsp" class="active"><i class="fas fa-home"></i> Home</a></li>
    <li><a href="ListChooseSubjectController"><i class="fas fa-book"></i> Subject</a></li>
    <li><a href="#"><i class="fas fa-calendar-check"></i> Attendance</a></li>
    <li><a href="#"><i class="fas fa-chart-line"></i> Progress</a></li>
    <li><a href="ListStudentController"><i class="fas fa-child"></i> Student</a></li>
  </ul>
  <div class="_separator_1e1cy_1"></div>
  <ul class="sidebar-links bottom-links">
    <li><a href="#"><i class="fas fa-user-cog"></i> Account</a></li>
    <li><a href="LogoutController"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
  </ul>
</nav>

<!-- Main Content -->
<div class="container">
    <!-- Header Row -->
    <div class="header-row">
        <h2>Subject</h2>
        <form action="AddChooseSubjectController" method="get">
            <input type="hidden" name="studId" value="${selectedStudId}" />
            <button type="submit" class="btn-add">+ Register New Subject</button>
        </form>
    </div>

    <!-- Student Dropdown -->
    <form action="ListChooseSubjectController" method="get">
        <div class="form-row">
            <label>Student</label>
            <select name="studId" onchange="this.form.submit()" required>
                <option value="">Select student</option>
                <c:forEach var="student" items="${students}">
                    <option value="${student.studId}" 
                        <c:if test="${student.studId == selectedStudId}">selected</c:if>>
                        ${student.studName}
                    </option>
                </c:forEach>
            </select>
        </div>
    </form>

    <!-- Subject Grid -->
    <div class="subject-grid">
        <c:choose>
            <c:when test="${empty subjectList}">
                <div class="placeholder">
                    No subjects registered or available for this student.
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="subject" items="${subjectList}">
                    <div class="subject-card">
                        <p><i class="fa-solid fa-book"></i> ${subject.subjectName}</p>
                        <p><small>Teacher ID: ${subject.teacherId}</small></p>

                        <c:choose>
                            <c:when test="${registeredSubjectIds.contains(subject.subjectId)}">
                                <span class="status registered">Registered</span>
                                <form action="DeleteChooseSubjectController" method="post">
                                    <input type="hidden" name="studId" value="${selectedStudId}" />
                                    <input type="hidden" name="subjectId" value="${subject.subjectId}" />
                                    <button type="submit" class="btn-delete">Delete</button>
                                </form>
                            </c:when>
                            <c:otherwise>
                                <form action="RegisterSubjectController" method="post">
                                    <input type="hidden" name="studId" value="${selectedStudId}" />
                                    <input type="hidden" name="subjectId" value="${subject.subjectId}" />
                                    <button type="submit" class="btn-register">Register</button>
                                </form>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
</div>

 <script>
 function toggleSidebar() {
	    document.getElementById("sidebar").classList.toggle("show");
	    document.getElementById("dashboard").classList.toggle("shifted");
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

</body>
</html>
