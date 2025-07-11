<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ page import="kms.model.*" %>
<%@ page session="true" %>
<%
    Object user = session.getAttribute("user");
    String role = (String) session.getAttribute("role");

    int id = 0;
    String name = "", email = "", phone = "", roleDisplay = "", teacherType = "";
    double salary = 0.0;
    int contract = 0;
    double hourlyRate = 0.0;

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
                Integer c = ((partTime) t).getContract();
                Double h = ((partTime)t).getHourlyRate();// wrapper type
                if (c != null) {
                    contract = c;
                }
                if (h != null) {
                    hourlyRate = h; // 
                }
            }
        }
    }
%>


<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>View Account</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
<link rel="stylesheet" href="viewAccount.css">
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

      <!-- Inject sidebar automatically -->
<c:choose>
    <c:when test="${sessionScope.role == 'admin'}">
        <jsp:include page="adminSideBar.jsp">
            <jsp:param name="role" value="admin"/>
        </jsp:include>
    </c:when>
    <c:when test="${sessionScope.role == 'teacher'}">
        <jsp:include page="teacherSideBar.jsp">
            <jsp:param name="role" value="teacher"/>
        </jsp:include>
    </c:when>
    <c:when test="${sessionScope.role == 'parent'}">
        <jsp:include page="parentSidebar.jsp">
            <jsp:param name="role" value="parent"/>
        </jsp:include>
    </c:when>
</c:choose>


	<main class="account-container">
		<div class="account-card">
			<h1>My Account</h1>
			<a href="updateAccount.jsp">
  <button class="edit-btn">Edit Account</button>
</a>

			<div class="profile-info">
				<div class="profile-img">
 <img src="PhotoServlet?role=<%= role %>&type=photo&id=<%= id %>" style="width: 200px; height: 200px; object-fit: cover; border-radius: 10px;" /></div>
				<div class="details">
					<div class="column">
						<p>
							<strong>Name</strong><br><%=name %>
						</p>
						
						<p>
							<strong>E-mail</strong><br><%=email %>
						</p>
						<p>
							<strong>Phone Number</strong><br><%=phone %>
						</p>
						
						<p>
							<strong>Role</strong><br><%=role %>
						</p>
					</div>
					<div class="column">
						
						<% if ("FullTime".equalsIgnoreCase(teacherType)) { %>
            <p><strong>Salary</strong><br>RM <%= salary %></p>
          <% } else if ("PartTime".equalsIgnoreCase(teacherType)) { %>
            <p><strong>Contract (Months):</strong><br><%= contract %></p>
            <p><strong>Hourly Rate:</strong><br>RM <%= hourlyRate %></p>
          <% } %>
					</div>
				</div>
			</div>
		</div>
	</main>
	 <script>
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

  // Mobile sidebar toggle
  function toggleSidebar() {
    const sidebar = document.getElementById('sidebar');
    const overlay = document.getElementById('overlay');
    
    sidebar.classList.toggle('open');
    overlay.classList.toggle('active');
  }
</script>

</body>
</html>