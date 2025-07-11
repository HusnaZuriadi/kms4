<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ page import="kms.model.teacher" %>
<%
  Object user = session.getAttribute("user");
  String role = (String) session.getAttribute("role");
  String adminName = "";
  int id = -1;

  if ("admin".equalsIgnoreCase(role) && user instanceof teacher) {
      teacher a = (teacher) user;
      adminName = a.getTeacherName();
      id = a.getTeacherId(); // ✅ ambil ID untuk gambar
  }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Parent Accounts</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
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

.navbar {
  display: flex;
  align-items: center;
  justify-content: center;
}

.navbar img {
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

.sidebar-links a:hover, .sidebar-links a.active {
  background: #f6f9f3;
  color: #2c3e50;
  transform: translateX(5px);
  box-shadow: 0 4px 20px rgba(136, 195, 78, 0.15);
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
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.page-title {
  font-size: 2.5rem;
  font-weight: 700;
  color: #88c34e;
  margin-bottom: 0.5rem;
  display: flex;
  align-items: center;
  gap: 1rem;
}

.page-subtitle {
  color: #2c3e50;
  font-size: 1.1rem;
  font-weight: 500;
}

.parent-count {
  background: #e8f5e8;
  color: #88c34e;
  padding: 0.5rem 1rem;
  border-radius: 16px;
  font-size: 0.9rem;
  font-weight: 600;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

/* Search Section */
.search-section {
  background: #ffffff;
  padding: 1.5rem 2rem;
  border-radius: 20px;
  margin-bottom: 2rem;
  box-shadow: 0 4px 20px rgba(136, 195, 78, 0.15);
  border: 2px solid #e0e0e0;
}

.search-container {
  position: relative;
  max-width: 400px;
}

.search-input {
  width: 100%;
  padding: 1rem 1rem 1rem 3rem;
  border: 2px solid #e0e0e0;
  border-radius: 16px;
  font-size: 1rem;
  font-family: "Poppins", sans-serif;
  background: #f5f5f5;
  color: #2c3e50;
  transition: all 0.3s ease;
}

.search-input:focus {
  outline: none;
  border-color: #88c34e;
  background: white;
  box-shadow: 0 0 0 3px rgba(136, 195, 78, 0.1);
}

.search-input::placeholder {
  color: #7f8c8d;
}

.search-icon {
  position: absolute;
  left: 1rem;
  top: 50%;
  transform: translateY(-50%);
  color: #88c34e;
  font-size: 1.1rem;
}

/* Table Container */
.table-container {
  background: #ffffff;
  border-radius: 20px;
  box-shadow: 0 4px 20px rgba(136, 195, 78, 0.15);
  border: 2px solid #e0e0e0;
  overflow: hidden;
}

.table-header {
  background: #88c34e;
  color: white;
  padding: 1.5rem 2rem;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.table-header h3 {
  margin: 0;
  font-size: 1.3rem;
  font-weight: 600;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.parent-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 0.95rem;
}

.parent-table th {
  background: #f6f9f3;
  color: #2c3e50;
  padding: 1.2rem;
  text-align: left;
  font-weight: 600;
  font-size: 0.9rem;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  border-bottom: 2px solid #e0e0e0;
  vertical-align: middle;
}

.parent-table th:nth-child(1) {
  width: 8%;
  text-align: center;
}

.parent-table th:nth-child(5) {
  width: 25%;
  text-align: center;
}

.parent-table td {
  padding: 1.2rem;
  border-bottom: 1px solid #f0f0f0;
  vertical-align: middle;
}

.parent-table td:nth-child(1) {
  text-align: center;
  width: 8%;
}

.parent-table td:nth-child(5) {
  text-align: center;
  width: 25%;
}

.parent-table tr:hover {
  background-color: #fafafa;
}

.parent-table tr:nth-child(even) {
  background-color: #fdfdfd;
}

.row-number {
  font-weight: 600;
  color: #88c34e;
  font-size: 1rem;
}

.parent-name {
  font-weight: 600;
  color: #2c3e50;
  display: flex;
  align-items: center;
  gap: 0.75rem;
}

.parent-name i {
  color: #f491ba;
  font-size: 1.1rem;
  flex-shrink: 0;
}

.phone-number {
  font-family: "Poppins", sans-serif;
  color: #2c3e50;
  font-weight: 500;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.phone-number i {
  color: #88c34e;
  flex-shrink: 0;
}

.child-count {
  text-align: center;
  font-weight: 600;
}

.child-count-badge {
  background: #fce4ec;
  color: #f491ba;
  padding: 0.5rem 1rem;
  border-radius: 12px;
  font-size: 0.9rem;
  font-weight: 700;
  display: inline-block;
  min-width: 40px;
  text-align: center;
}

.action-buttons {
  display: flex;
  gap: 0.75rem;
  justify-content: center;
  align-items: center;
}

.btn {
  padding: 0.75rem 1.5rem;
  border: none;
  border-radius: 12px;
  font-size: 0.85rem;
  font-weight: 600;
  cursor: pointer;
  text-decoration: none;
  transition: all 0.3s ease;
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  font-family: "Poppins", sans-serif;
  white-space: nowrap;
}

.btn-info {
  background: #88c34e;
  color: white;
}

.btn-info:hover {
  background: #76a33e;
  transform: translateY(-2px);
  color: white;
  box-shadow: 0 4px 15px rgba(136, 195, 78, 0.3);
}

.btn-danger {
  background: #e74c3c;
  color: white;
}

.btn-danger:hover {
  background: #c0392b;
  transform: translateY(-2px);
  box-shadow: 0 4px 15px rgba(231, 76, 60, 0.3);
}

/* Empty State */
.empty-state {
  text-align: center;
  padding: 4rem 2rem;
  color: #666;
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
  color: #2c3e50;
  font-size: 1rem;
}

/* Enhanced Delete Modal */
.modal {
  display: none;
  position: fixed;
  z-index: 1000;
  left: 0;
  top: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0,0,0,0.5);
  backdrop-filter: blur(4px);
}

.modal-content {
  background-color: white;
  margin: 10% auto;
  padding: 0;
  border-radius: 20px;
  width: 90%;
  max-width: 500px;
  box-shadow: 0 10px 40px rgba(0,0,0,0.3);
  animation: modalSlideIn 0.3s ease-out;
  overflow: hidden;
}

@keyframes modalSlideIn {
  from {
    transform: translateY(-50px);
    opacity: 0;
  }
  to {
    transform: translateY(0);
    opacity: 1;
  }
}

.modal-header {
  background: #e74c3c;
  color: white;
  padding: 1.5rem 2rem;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.modal-header h3 {
  margin: 0;
  font-size: 1.2rem;
  font-weight: 600;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.close {
  color: white;
  font-size: 1.5rem;
  cursor: pointer;
  padding: 0;
  background: none;
  border: none;
  opacity: 0.8;
  transition: opacity 0.3s ease;
}

.close:hover {
  opacity: 1;
}

.modal-body {
  padding: 2rem;
}

.modal-body p {
  margin: 0 0 1.5rem 0;
  color: #666;
  line-height: 1.6;
}

.modal-body input[type="password"] {
  width: 100%;
  padding: 1rem;
  border: 2px solid #e0e0e0;
  border-radius: 12px;
  font-size: 1rem;
  margin-bottom: 1.5rem;
  box-sizing: border-box;
  font-family: "Poppins", sans-serif;
  transition: border-color 0.3s ease;
}

.modal-body input[type="password"]:focus {
  border-color: #88c34e;
  outline: none;
  box-shadow: 0 0 0 3px rgba(136, 195, 78, 0.1);
}

.modal-actions {
  display: flex;
  gap: 1rem;
  justify-content: flex-end;
}

.modal-actions button {
  padding: 0.75rem 1.5rem;
  border: none;
  border-radius: 12px;
  font-size: 0.9rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  font-family: "Poppins", sans-serif;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.modal-actions button[type="submit"] {
  background: #e74c3c;
  color: white;
}

.modal-actions button[type="submit"]:hover {
  background: #c0392b;
  transform: translateY(-1px);
}

.modal-actions button[type="button"] {
  background: #95a5a6;
  color: white;
}

.modal-actions button[type="button"]:hover {
  background: #7f8c8d;
  transform: translateY(-1px);
}

/* Mobile Responsiveness */
@media (max-width: 768px) {
  .content-wrapper {
    padding: 1rem;
  }

  .page-header {
    flex-direction: column;
    gap: 1rem;
    text-align: center;
  }

  .page-title {
    font-size: 2rem;
  }

  .search-container {
    max-width: 100%;
  }

  .parent-table {
    font-size: 0.8rem;
  }

  .parent-table th,
  .parent-table td {
    padding: 0.8rem 0.5rem;
  }

  .action-buttons {
    flex-direction: column;
    gap: 0.5rem;
  }

  .btn {
    padding: 0.5rem 1rem;
    font-size: 0.75rem;
  }

  .sidebar {
    transform: translateX(-100%);
  }

  .sidebar.show {
    transform: translateX(0);
  }

  .content-wrapper.shifted {
    margin-left: 0;
  }
}
</style>
</head>

<body>

<header>
  <button class="navSidebar" onclick="toggleSidebar()">
    <i class="fa-solid fa-bars"></i>
  </button>
  <div class="navbar">
    <img src="images/LOGO-AL-KAUTHAR-EDUQIDS.png" alt="ALKAUTHAR EDUQIDS Logo" />
  </div>
</header>

<nav class="sidebar" id="sidebar">
  <div class="profile">
    <a href="viewAccount.jsp">
       <img src="PhotoServlet?role=<%= role %>&type=photo&id=<%= id %>" >
    </a>
    <h3><%= adminName %></h3>
    <p>Administrator</p>
  </div>
  <ul class="sidebar-links top-links">
    <li><a href="AdminHomeController"><i class="fas fa-home"></i> Home</a></li>
    <li><a href="ListSubjectController"><i class="fas fa-book"></i> Subject</a></li>
    <li><a href="ListAttendanceController"><i class="fas fa-calendar-check"></i> Attendance</a></li>
    <li><a href="recordProgress.jsp"><i class="fas fa-chart-line"></i> Progress</a></li>
    <li><a href="ListStudentController"><i class="fas fa-user-graduate"></i> Student</a></li>
  </ul>
  <div class="_separator_1e1cy_1"></div>
  <ul class="sidebar-links bottom-links">
    <li><a href="viewAccount.jsp"><i class="fas fa-user-cog"></i> Account</a></li>
    <li><a href="LogoutController"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
  </ul>
</nav>

<div class="content-wrapper" id="content-wrapper">
    <!-- Page Header -->
    <div class="page-header">
        <div>
            <h1 class="page-title">
                <i class="fas fa-users"></i>
                Parent Management
            </h1>
            <p class="page-subtitle">Manage all registered parents and their information</p>
        </div>
        <div class="parent-count">
            <i class="fas fa-users"></i>
            <span id="parentCount">0</span> Parents Registered
        </div>
    </div>

    <!-- Search Section -->
    <div class="search-section">
        <div class="search-container">
            <input type="text" class="search-input" id="searchInput" placeholder="Search parents by name or phone number...">
            <i class="fas fa-search search-icon"></i>
        </div>
    </div>

    <!-- Table Container -->
    <div class="table-container">
        <div class="table-header">
            <h3><i class="fas fa-list"></i> Parent Directory</h3>
            <small>All registered parents and their children</small>
        </div>

        <c:if test="${empty parentList}">
            <div class="empty-state">
                <div class="empty-icon">
                    <i class="fas fa-users"></i>
                </div>
                <h2 class="empty-title">No Parents Found</h2>
                <p class="empty-text">There are currently no parents registered in the system.</p>
            </div>
        </c:if>

        <c:if test="${!empty parentList}">
            <table class="parent-table" id="parentTable">
                <thead>
                    <tr>
                        <th>No.</th>
                        <th>Parent Name</th>
                        <th>Phone Number</th>
                        <th>Children</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="p" items="${parentList}" varStatus="status">
                        <tr class="parent-row">
                            <td class="row-number">${status.index + 1}</td>
                            <td>
                                <div class="parent-name">
                                    <i class="fas fa-user"></i>
                                    <span class="searchable-name"><c:out value="${p.parentName}" /></span>
                                </div>
                            </td>
                            <td>
                                <div class="phone-number">
                                    <i class="fas fa-phone"></i>
                                    <span class="searchable-phone"><c:out value="${p.parentPhone}" /></span>
                                </div>
                            </td>
                            <td>
                                <div class="child-count">
                                    <span class="child-count-badge">
                                        <c:out value="${childCountMap[p.parentId]}" />
                                    </span>
                                </div>
                            </td>
                            <td>
                                <div class="action-buttons">
                                    <a class="btn btn-info" href="ViewParentController?parentId=${p.parentId}">
                                        <i class="fas fa-eye"></i> View
                                    </a>
                                    <a class="btn btn-danger" href="javascript:void(0);" onclick="openDeleteModal(${p.parentId}, 'parent')">
                                        <i class="fas fa-trash"></i> Delete
                                    </a>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:if>
    </div>
</div>

<script>
function toggleSidebar() {
    const sidebar = document.getElementById("sidebar");
    const contentWrapper = document.getElementById("content-wrapper");
    
    sidebar.classList.toggle("show");
    contentWrapper.classList.toggle("shifted");
}

function openDeleteModal(id, role) {
    document.getElementById("deleteId").value = id;
    document.getElementById("deleteRole").value = role;
    document.getElementById("deleteModal").style.display = "block";
}

function closeDeleteModal() {
    document.getElementById("deleteModal").style.display = "none";
}

// Enhanced search functionality
document.getElementById('searchInput').addEventListener('input', function() {
    const searchTerm = this.value.toLowerCase();
    const rows = document.querySelectorAll('.parent-row');
    let visibleCount = 0;
    
    rows.forEach(row => {
        const name = row.querySelector('.searchable-name').textContent.toLowerCase();
        const phone = row.querySelector('.searchable-phone').textContent.toLowerCase();
        
        if (name.includes(searchTerm) || phone.includes(searchTerm)) {
            row.style.display = '';
            visibleCount++;
        } else {
            row.style.display = 'none';
        }
    });
    
    // Update row numbers for visible rows
    let counter = 1;
    rows.forEach(row => {
        if (row.style.display !== 'none') {
            row.querySelector('.row-number').textContent = counter++;
        }
    });
});

// Update parent count
document.addEventListener('DOMContentLoaded', function() {
    const parentRows = document.querySelectorAll('.parent-row');
    document.getElementById('parentCount').textContent = parentRows.length;
});

// Close modal on ESC key
window.addEventListener('keydown', function(e) {
    if (e.key === "Escape") {
        closeDeleteModal();
    }
});

// Close modal when clicking outside
window.addEventListener('click', function(e) {
    const modal = document.getElementById('deleteModal');
    if (e.target === modal) {
        closeDeleteModal();
    }
});

// Close sidebar when clicking outside
document.addEventListener('click', function(e) {
    const sidebar = document.getElementById('sidebar');
    const navButton = document.querySelector('.navSidebar');
    
    if (!sidebar.contains(e.target) && !navButton.contains(e.target) && sidebar.classList.contains('show')) {
        toggleSidebar();
    }
});
</script>

<!-- Enhanced Delete Modal -->
<div id="deleteModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3><i class="fas fa-exclamation-triangle"></i> Confirm Deletion</h3>
            <span class="close" onclick="closeDeleteModal()">&times;</span>
        </div>
        <div class="modal-body">
            <p><strong>Are you sure you want to delete this parent account?</strong></p>
            <p>This action cannot be undone. Please enter your admin password to confirm.</p>
            
            <form id="deleteForm" method="post" action="deleteAccountController">
                <input type="hidden" name="id" id="deleteId">
                <input type="hidden" name="role" id="deleteRole">
                
                <input type="password" name="password" placeholder="Enter admin password" required>
                
                <div class="modal-actions">
                    <button type="button" onclick="closeDeleteModal()">
                        <i class="fas fa-times"></i> Cancel
                    </button>
                    <button type="submit">
                        <i class="fas fa-trash"></i> Delete Account
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>
  
</body>
</html>