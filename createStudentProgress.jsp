<%@ page contentType="text/html; charset=UTF-8" %><%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page import="kms.model.teacher" %>
<%
    Object user = session.getAttribute("user");
String role = (String) session.getAttribute("role");
    String teacherName = "";
    int id = 0;

    if (user instanceof teacher) {
        teacher t = (teacher) user;
        teacherName = t.getTeacherName();
        id = t.getTeacherId();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Student Progress</title>
 	<link rel="stylesheet" href="studentProgress.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" />
    
</head>
<body>

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
      <img src="PhotoServlet?role=<%= role %>&type=photo&id=<%= id %>" alt="Profile Photo">
    </a>
    <h3><%= teacherName %></h3>
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
    <li><a href="recordAttendance.jsp"><i class="fas fa-calendar-check"></i> Attendance</a></li>
    <li><a href="recordProgress.jsp"><i class="fas fa-chart-line"></i> Progress</a></li>
    <li><a href="ListStudentController"><i class="fas fa-user-graduate"></i> Student</a></li>
  </ul>
  <div class="_separator_1e1cy_1"></div>
  <ul class="sidebar-links bottom-links">
    <li><a href="viewAccount.jsp"><i class="fas fa-user-cog"></i> Account</a></li>
    <li><a href="LogoutController"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
  </ul>
</nav>


<div class="container">
    <h3 style="text-align: center;">STUDENT PROGRESS</h3>

    <!-- Student Photo -->
    <div style="text-align:center;">
        <label>Student Photo</label><br/>
        <c:choose>
            <c:when test="${not empty selectedStudent.studPhoto}">
                <img src="PhotoServlet?role=student&type=photo&id=${selectedStudent.studId}" width="300" height="300" />
            </c:when>
            <c:otherwise>
                <div class="value">No photo uploaded</div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Form Start -->
    <form action="ProgressController" method="post">
        <input type="hidden" name="action" value="saveProgress" />

        <!-- Month input -->
        <label for="progressMonth">Progress Month</label>
        <input type="month" name="progressMonth" id="progressMonth" required value="${progressMonth}" />

        <!-- Student selector -->
        <div class="row">
            <div class="col">
                <label for="studId">Full Name</label>
                <select name="studId" id="studId" onchange="submitSelectStudent()">
                    <option value="">Select student</option>
                    <c:forEach var="student" items="${students}">
                        <option value="${student.studId}" 
                            <c:if test="${student.studId == selectedStudent.studId}">selected</c:if>>
                            ${student.studName}
                        </option>
                    </c:forEach>
                </select>
            </div>
            <div class="col">
                <label for="age">Age</label>
                <input type="number" name="age" id="age" value="${selectedStudent.studAge}" readonly>
            </div>
        </div>

        <!-- Subject and Marks -->
        <label>Progress Level</label>
        <table>
            <thead>
                <tr>
                    <th>No</th>
                    <th>Subject</th>
                    <th>Mark</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="subject" items="${enrolledSubjects}" varStatus="loop">
                    <tr>
                        <td>${loop.index + 1}</td>
                        <td>${subject.subjectName}</td>
                        <td>
                            <input type="number" name="mark_${subject.subjectId}" placeholder="Enter mark" min="0" max="100" required />
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <!-- Teacher Notes -->
        <label for="notes">Teacher Notes</label>
        <textarea name="notes" id="notes" rows="5" placeholder="Add progress notes here..."></textarea>

        <!-- Submit -->
        <div class="buttons">
            <button type="reset" class="btn btn-cancel">Cancel</button>
            <button type="submit" class="btn btn-save">Save</button>
        </div>
    </form>

    <!-- Form for student selection -->
    <form id="studentSelectForm" action="ProgressController" method="post" style="display:none;">
        <input type="hidden" name="action" value="selectStudent" />
        <input type="hidden" name="progressMonth" id="hiddenMonth" />
        <input type="hidden" name="studId" id="hiddenStudId" />
    </form>

</div>

<script>
function submitSelectStudent() {
    const form = document.getElementById("studentSelectForm");
    const selectedMonth = document.getElementById("progressMonth").value;
    const selectedStudent = document.getElementById("studId").value;

    document.getElementById("hiddenMonth").value = selectedMonth;
    document.getElementById("hiddenStudId").value = selectedStudent;

    form.submit();
}
</script>
</body>
</html>
