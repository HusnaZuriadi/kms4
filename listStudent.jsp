<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, kms.model.*, kms.helper.CalculateAge"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ page session="true"%>

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
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Student List - Al Kauthar EduQids</title>
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
  color: #34495e;
  font-size: 1.1rem;
  font-weight: 500;
}

.add-student-btn {
  background: linear-gradient(135deg, #88c34e 0%, #9dd45e 100%);
  color: white;
  padding: 1rem 2rem;
  border-radius: 16px;
  text-decoration: none;
  font-weight: 600;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  box-shadow: 0 8px 30px rgba(136, 195, 78, 0.3);
  transition: all 0.3s ease;
}

.add-student-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 12px 40px rgba(136, 195, 78, 0.4);
  color: white;
}

/* Students Grid */
.students-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
  gap: 2rem;
  margin-bottom: 2rem;
}

.student-card {
  background: #ffffff;
  border-radius: 20px;
  padding: 2rem;
  box-shadow: 0 4px 20px rgba(136, 195, 78, 0.15);
  border: 2px solid #e0e0e0;
  transition: all 0.3s ease;
  position: relative;
  overflow: hidden;
}

.student-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 4px;
  background: linear-gradient(90deg, #f491ba, #fce4ec);
}

.student-card:hover {
  transform: translateY(-5px) scale(1.02);
  box-shadow: 0 8px 30px rgba(136, 195, 78, 0.2);
  border-color: #88c34e;
}

.student-header {
  display: flex;
  align-items: center;
  gap: 1.5rem;
  margin-bottom: 1.5rem;
}

.student-avatar img{
  width: 80px;
  height: 80px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 2rem;
  color: white;
  font-weight: 700;
  box-shadow: 0 8px 30px rgba(244, 145, 186, 0.3);
  flex-shrink: 0;
}



.student-info h3 {
  font-size: 1.5rem;
  font-weight: 700;
  color: #2c3e50;
  margin-bottom: 0.5rem;
}

.student-id {
  background: #e8f5e8;
  color: #88c34e;
  padding: 0.25rem 0.75rem;
  border-radius: 12px;
  font-size: 0.8rem;
  font-weight: 600;
  display: inline-block;
}

.student-details {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 1rem;
  margin-bottom: 1.5rem;
}

.detail-item {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.75rem;
  background: #f5f5f5;
  border-radius: 12px;
}

.detail-icon {
  width: 30px;
  height: 30px;
  border-radius: 50%;
  background: #88c34e;
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 0.8rem;
  flex-shrink: 0;
}

.detail-text {
  font-size: 0.9rem;
  color: #34495e;
  font-weight: 500;
}

.student-actions {
  display: flex;
  gap: 0.75rem;
  flex-wrap: wrap;
}

.btn {
  padding: 0.75rem 1.5rem;
  border-radius: 12px;
  text-decoration: none;
  font-weight: 600;
  font-size: 0.9rem;
  border: none;
  cursor: pointer;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.btn-info {
  background: #88c34e;
  color: white;
}

.btn-info:hover {
  background: #76a33e;
  transform: translateY(-2px);
  color: white;
}

.btn-warning {
  background: #f491ba;
  color: white;
}

.btn-warning:hover {
  background: #e67fa3;
  transform: translateY(-2px);
  color: white;
}

.btn-danger {
  background: #e74c3c;
  color: white;
}

.btn-danger:hover {
  background: #c0392b;
  transform: translateY(-2px);
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
  margin-bottom: 2rem;
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

  .students-grid {
    grid-template-columns: 1fr;
    gap: 1rem;
  }

  .student-details {
    grid-template-columns: 1fr;
  }

  .student-actions {
    flex-direction: column;
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

/* Animations */
.student-card {
  animation: slideUp 0.6s ease forwards;
  opacity: 0;
  transform: translateY(20px);
}

.student-card:nth-child(1) { animation-delay: 0.1s; }
.student-card:nth-child(2) { animation-delay: 0.2s; }
.student-card:nth-child(3) { animation-delay: 0.3s; }
.student-card:nth-child(4) { animation-delay: 0.4s; }
.student-card:nth-child(5) { animation-delay: 0.5s; }
.student-card:nth-child(6) { animation-delay: 0.6s; }

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
        <img src="PhotoServlet?role=<%= role %>&type=photo&id=<%= id %>">
      </a>
      <h3><%= parentName %></h3>
      <p>Parent</p>
    </div>
    <ul class="sidebar-links top-links">
      <li><a href="parentHome.jsp"><i class="fas fa-home"></i> Home</a></li>
      <li><a href="ListChooseSubjectController"><i class="fas fa-book"></i> Subject</a></li>
      <li><a href="#"><i class="fas fa-calendar-check"></i> Attendance</a></li>
      <li><a href="#"><i class="fas fa-chart-line"></i> Progress</a></li>
      <li><a href="ListStudentController" class="active"><i class="fas fa-child"></i> Student</a></li>
    </ul>
    <div class="_separator_1e1cy_1"></div>
    <ul class="sidebar-links bottom-links">
      <li><a href="#"><i class="fas fa-user-cog"></i> Account</a></li>
      <li><a href="LogoutController"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
    </ul>
  </nav>

  <!-- Main Content -->
  <div class="content-wrapper" id="content-wrapper">
    
    <!-- Page Header -->
    <div class="page-header">
      <div>
        <h1 class="page-title">
          <i class="fas fa-child"></i>
          My Children
        </h1>
        <p class="page-subtitle">Manage your children's information and educational journey</p>
      </div>
      <c:if test="${role == 'parent'}">
        <a href="createStudent.jsp" class="add-student-btn">
          <i class="fas fa-plus"></i>
          Add Child
        </a>
      </c:if>
    </div>

    <!-- Students Grid -->
    <c:choose>
      <c:when test="${empty students}">
        <div class="empty-state">
          <div class="empty-icon">
            <i class="fas fa-child"></i>
          </div>
          <h2 class="empty-title">No Children Found</h2>
          <p class="empty-text">You haven't registered any children yet. Click the button below to add your first child.</p>
          <c:if test="${role == 'parent'}">
            <a href="createStudent.jsp" class="add-student-btn">
              <i class="fas fa-plus"></i>
              Add Your First Child
            </a>
          </c:if>
        </div>
      </c:when>
      <c:otherwise>
        <div class="students-grid">
          <c:forEach var="stud" items="${students}" varStatus="status">
            <div class="student-card">
              <div class="student-header">
                <div class="student-avatar">
                 <img src="PhotoServlet?role=student&type=photo&id=${stud.studId}" />
                </div>
                <div class="student-info">
                  <h3><c:out value="${stud.studName}" /></h3>
                  <span class="student-id">ID: <c:out value="${stud.studId}" /></span>
                </div>
              </div>

              <div class="student-details">
                <div class="detail-item">
                  <div class="detail-icon">
                    <i class="fas fa-venus-mars"></i>
                  </div>
                  <div class="detail-text">
                    <strong>Gender:</strong><br>
                    <c:out value="${stud.studGender}" />
                  </div>
                </div>
                <div class="detail-item">
                  <div class="detail-icon">
                    <i class="fas fa-birthday-cake"></i>
                  </div>
                  <div class="detail-text">
                    <strong>Age:</strong><br>
                    <%
                    kms.model.student currentStudent = (kms.model.student) pageContext.getAttribute("stud");
                    int calculatedAge = 0;
                    if (currentStudent != null && currentStudent.getStudBirthDate() != null) {
                        calculatedAge = CalculateAge.calculateAgeStud(currentStudent.getStudBirthDate());
                    }
                    %>
                    <%= calculatedAge %> years old
                  </div>
                </div>
              </div>

              <div class="student-actions">
                <a class="btn btn-info" href="viewStudentController?studId=${stud.studId}">
                  <i class="fas fa-eye"></i>
                  View
                </a>
                <c:if test="${role == 'parent'}">
                  <a class="btn btn-warning" href="updateStudentController?studId=${stud.studId}">
                    <i class="fas fa-edit"></i>
                    Update
                  </a>
                </c:if>
                <button class="btn btn-danger" onclick="confirmDelete(${stud.studId})">
                  <i class="fas fa-trash"></i>
                  Delete
                </button>
              </div>
            </div>
          </c:forEach>
        </div>
      </c:otherwise>
    </c:choose>
  </div>

  <script>
    function toggleSidebar() {
      const sidebar = document.getElementById("sidebar");
      const contentWrapper = document.getElementById("content-wrapper");
      
      sidebar.classList.toggle("show");
      contentWrapper.classList.toggle("shifted");
    }
    
    function confirmDelete(studId) {
      // Create custom modal
      const modal = document.createElement('div');
      modal.style.cssText = `
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0,0,0,0.5);
        display: flex;
        align-items: center;
        justify-content: center;
        z-index: 1000;
      `;
      
      modal.innerHTML = `
        <div style="
          background: white;
          padding: 2rem;
          border-radius: 20px;
          max-width: 400px;
          text-align: center;
          box-shadow: 0 10px 40px rgba(0,0,0,0.3);
        ">
          <div style="
            width: 60px;
            height: 60px;
            background: #e74c3c;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1rem;
            color: white;
            font-size: 1.5rem;
          ">
            <i class="fas fa-exclamation-triangle"></i>
          </div>
          <h3 style="color: #2c3e50; margin-bottom: 1rem;">Confirm Deletion</h3>
          <p style="color: #34495e; margin-bottom: 2rem;">Are you sure you want to delete this student? This action cannot be undone.</p>
          <div style="display: flex; gap: 1rem; justify-content: center;">
            <button onclick="deleteStudent(${studId})" style="
              background: #e74c3c;
              color: white;
              padding: 0.75rem 1.5rem;
              border: none;
              border-radius: 12px;
              cursor: pointer;
              font-weight: 600;
            ">Delete</button>
            <button onclick="closeModal()" style="
              background: #95a5a6;
              color: white;
              padding: 0.75rem 1.5rem;
              border: none;
              border-radius: 12px;
              cursor: pointer;
              font-weight: 600;
            ">Cancel</button>
          </div>
        </div>
      `;
      
      document.body.appendChild(modal);
      
      window.deleteStudent = function(studId) {
        location.href = 'deleteStudentController?studId=' + studId;
      }
      
      window.closeModal = function() {
        document.body.removeChild(modal);
      }
      
      // Close on backdrop click
      modal.addEventListener('click', function(e) {
        if (e.target === modal) {
          closeModal();
        }
      });
    }

    // Close sidebar when clicking outside
    document.addEventListener('click', function(e) {
      const sidebar = document.getElementById('sidebar');
      const navButton = document.querySelector('.navSidebar');
      
      if (!sidebar.contains(e.target) && !navButton.contains(e.target) && sidebar.classList.contains('show')) {
        toggleSidebar();
      }
    });
  </script>
</body>
</html>