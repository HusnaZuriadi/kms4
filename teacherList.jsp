<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="java.util.*, kms.model.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="true" %>

<%
  Object user = session.getAttribute("user");
  String role = (String) session.getAttribute("role");
  String name = "";
  int currentAdminId = -1;

  if ("admin".equalsIgnoreCase(role) && user instanceof teacher) {
      teacher admin = (teacher) user;
      name = admin.getTeacherName();
      currentAdminId = admin.getTeacherId();
  }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Parent Accounts</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
<link rel="stylesheet" href="css/listParent.css">
<title>List of Parents</title>
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

	<nav class="sidebar" id="sidebar">
		<div class="profile">
			<img src="images/admin.jpg" alt="Admin Profile Photo">
			<h3><%= name %></h3>

			<p><%= role %></p>
		</div>
		<a href="#">Dashboard</a> 
		<a href="ListStudentController">Student Registration</a> 
		<a href="#">Teachers</a> 
		<a href="#">Accounts</a> 
		<a href="LogoutController">Logout</a>
	</nav>
	
	<div>
	<h2>List of Teachers</h2>

	<table border="1" class="table table-striped">
		<thead class="table-dark">
			<tr>
				<th>ID</th>
				<th>Name</th>
				<th>Email</th>
				<th>Phone</th>
				<th>Role</th>
				<th colspan="2">Action</th>
			</tr>
		</thead>

		<c:if test="${empty teacherList}">
			<tr>
				<td colspan="8">No teachers found.</td>
			</tr>
		</c:if>

		<tbody>
			<c:forEach var="t" items="${teacherList}">
				<c:if test="${t.teacherId != currentAdminId}">
					<tr>
						<td>${t.teacherId}</td>
						<td>${t.teacherName}</td>
						<td>${t.teacherEmail}</td>
						<td>${t.teacherPhone}</td>
						<td>${t.teacherRole}</td>
						<td>
							<a class="btn btn-info" href="ViewTeacherController?teacherId=${t.teacherId}">View</a>
						</td>
						<td>
							<a class="btn btn-danger" href="javascript:void(0);" onclick="openDeleteModal(${t.teacherId}, 'teacher')">Delete</a>
						</td>
					</tr>
				</c:if>
			</c:forEach>
		</tbody>
	</table>
</div>

<script>
  function toggleSidebar() {
    document.getElementById("sidebar").classList.toggle("show");
  }

  function openDeleteModal(id, role) {
    document.getElementById("deleteId").value = id;
    document.getElementById("deleteRole").value = role;
    document.getElementById("deleteModal").style.display = "block";
  }

  function closeDeleteModal() {
    document.getElementById("deleteModal").style.display = "none";
  }

  window.addEventListener('keydown', function(e) {
    if (e.key === "Escape") {
      closeDeleteModal();
    }
  });
</script>

<!-- Delete Modal -->
<div id="deleteModal" class="modal">
  <div class="modal-content">
    <span class="close" onclick="closeDeleteModal()">&times;</span>
    <h3>Are you sure you want to delete this teacher account?</h3>
    <form id="deleteForm" method="post" action="deleteAccountController">
      <input type="hidden" name="id" id="deleteId">
      <input type="hidden" name="role" id="deleteRole">
      
      <p>Please enter your admin password to confirm this action.</p>
      <input type="password" name="password" required><br><br>

      <button type="submit">Confirm Delete</button>
      <button type="button" onclick="closeDeleteModal()">Cancel</button>
    </form>
  </div>
</div>

</body>
</html>