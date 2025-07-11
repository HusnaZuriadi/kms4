<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kms.model.student" %>
<%@ page import="kms.dao.studentDAO" %>
<%@ page import="java.util.List" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="kms.model.*" %>
<%@ page session="true" %>
<%
    Object user = session.getAttribute("user");
    String role = (String) session.getAttribute("role");
    
    int id = 0;
    String name = "", email = "", phone = "", roleDisplay = "", teacherType = "";

    if ((role.equalsIgnoreCase("teacher") || role.equalsIgnoreCase("admin")) && user instanceof teacher) {
        teacher t = (teacher) user;
        id = t.getTeacherId();
        name = t.getTeacherName();
        email = t.getTeacherEmail();
        phone = t.getTeacherPhone();
        roleDisplay = role.equals("admin") ? "Administrator" : "Teacher";
        teacherType = t.getTeacherType();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Attendance Management - Al-Kauthar EduQids</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
	<link rel="stylesheet" href="css/listAttendance.css">
	
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

    <!-- Layout Container -->
    <div class="layout">
      <!-- Sidebar -->
      <!-- Inject sidebar automatically -->
<c:choose>

    <c:when test="${sessionScope.role == 'admin'}">
        <jsp:include page="adminSideBar.jsp" />
    </c:when>
    <c:otherwise>
        <jsp:include page="teacherSideBar.jsp" />
    </c:otherwise>
</c:choose>


      <!-- Main Content -->
      <main class="main-content">
        <!-- Page Header -->
        <div class="page-header">
          <h1 class="page-title"><i class="fas fa-clipboard-list"></i> Student Attendance</h1>
          <p class="page-subtitle">View and manage daily attendance records</p>
        </div>


        <div class="nav2">
          <i class="fas fa-home"></i>
          <a href="AdminHomeController">Dashboard</a>
          <i class="fas fa-chevron-right"></i>
          <span>Attendance Records</span>
        </div>

        <!-- Age Selection Notice -->
        <c:if test="${empty param.selectedAge}">
          <div class="age-notice">
            <i class="fas fa-info-circle"></i>
            <span>Please select an age group first to view attendance records</span>
          </div>
        </c:if>

        <!-- Filter Section -->
        <div class="filter-section">
          <div class="filter-title">
            <i class="fas fa-filter"></i>
            Filter Attendance Records
          </div>

          <form id="attendanceForm" action="ListAttendanceController" method="get">
            <div class="filter-grid">
              <!-- Date Filter -->
              <div class="form-group">
                <label class="form-label">Select Date</label>
                <input type="date" 
                       name="filterDate" 
                       id="dateFilter"
                       value="${filterDate}" 
                       class="form-input"
                       onchange="checkAgeThenSubmit()">
              </div>

              <!-- Age Filter -->
              <div class="form-group">
                <label class="form-label">Age Group</label>
                <select name="selectedAge" 
                        id="ageFilter" 
                        class="form-input"
                        onchange="autoSubmitForm()">
                  <option value="">Select Age</option>
                  <c:forEach var="i" begin="4" end="6">
                    <option value="${i}" <c:if test="${param.selectedAge == i}">selected</c:if>>
                      ${i} Years Old
                    </option>
                  </c:forEach>
                </select>
              </div>

              <!-- Name Search -->
              <div class="form-group">
                <label class="form-label">Search Student Name</label>
                <div class="search-input">
                  <input type="text" 
                         name="searchQuery"
                         id="searchInput"
                         value="${searchQuery}"
                         placeholder="Type student name..." 
                         class="form-input"
                         oninput="delayedSubmit(); toggleClearButton()">
                  <i class="fas fa-search search-icon"></i>
                  <i class="fas fa-times clear-search" id="clearSearch" onclick="clearSearch()"></i>
                </div>
              </div>
            </div>
          </form>
        </div>

        <!-- Results Info -->
        <c:if test="${not empty param.selectedAge}">
          <div class="results-info">
            <div class="results-count">
              <c:choose>
                <c:when test="${not empty attendances}">
                  <i class="fas fa-check-circle"></i>
                  Found ${attendances.size()} attendance record${attendances.size() != 1 ? 's' : ''}
                  <c:if test="${not empty param.selectedAge}"> for age ${param.selectedAge}</c:if>
                  <c:if test="${not empty searchQuery}"> matching "${searchQuery}"</c:if>
                  <c:if test="${not empty filterDate}"> on <fmt:formatDate value="${filterDate}" pattern="MMM dd, yyyy"/></c:if>
                </c:when>
                <c:otherwise>
                  <i class="fas fa-info-circle"></i>
                  No attendance records found
                </c:otherwise>
              </c:choose>
            </div>

            <a href="attendanceForm.jsp?age=${param.selectedAge}&filterDate=${filterDate}" class="add-attendance-btn">
              <i class="fas fa-plus"></i>
              Record Attendance
            </a>
          </div>
        </c:if>

        <!-- Attendance Table -->
        <c:choose>
          <c:when test="${not empty attendances}">
            <div class="table-container">
              <div class="table-header">
                <i class="fas fa-list"></i> Attendance Records
              </div>

              <table class="attendance-table">
                <thead>
                  <tr>
                    <th>No.</th>
                    <th>Date</th>
                    <th>Student Name</th>
                    <th>Check In</th>
                    <th>Check Out</th>
                    <th>Status</th>
                    <th>Temperature</th>
                    <th>Actions</th>
                  </tr>
                </thead>
                <tbody>
                  <c:forEach items="${attendances}" var="attendance" varStatus="status">
                    <tr>
                      <td><strong>${status.index + 1}</strong></td>
                      <td>
                        <div class="date-display">
                          <fmt:formatDate value="${attendance.attendanceDate}" pattern="MMM dd, yyyy"/>
                        </div>
                      </td>
                      <td>
                        <div class="student-name">
                          <c:out value="${attendance.studName}"/>
                        </div>
                      </td>
                      <td>
                        <c:choose>
                          <c:when test="${attendance.checkinTime != null}">
                            <div class="time-display">
                              <fmt:formatDate value="${attendance.checkinTime}" pattern="HH:mm"/>
                            </div>
                          </c:when>
                          <c:otherwise>
                            <span style="color: #a0aec0;">—</span>
                          </c:otherwise>
                        </c:choose>
                      </td>
                      <td>
                        <c:choose>
                          <c:when test="${attendance.checkoutTime != null}">
                            <div class="time-display">
                              <fmt:formatDate value="${attendance.checkoutTime}" pattern="HH:mm"/>
                            </div>
                          </c:when>
                          <c:otherwise>
                            <span style="color: #a0aec0;">—</span>
                          </c:otherwise>
                        </c:choose>
                      </td>
                      <td>
                        <div class="status-badge ${attendance.attendanceStatus == 'Present' ? 'status-present' : 'status-absent'}">
                          <c:choose>
                            <c:when test="${attendance.attendanceStatus == 'Present'}">
                              <i class="fas fa-check"></i>
                              Present
                            </c:when>
                            <c:otherwise>
                              <i class="fas fa-times"></i>
                              Absent
                            </c:otherwise>
                          </c:choose>
                        </div>
                      </td>
                      <td>
                        <c:choose>
                          <c:when test="${not empty attendance.checkinTemp && attendance.checkinTemp > 0}">
                            <div class="temperature">
                              <c:out value="${attendance.checkinTemp}"/>°C
                            </div>
                          </c:when>
                          <c:otherwise>
                            <span style="color: #a0aec0;">—</span>
                          </c:otherwise>
                        </c:choose>
                      </td>
                      <td>
                        <div class="actions">
                          <button class="action-btn btn-view" 
                                  onclick="location.href='ViewAttendanceController?attendanceId=${attendance.attendanceId}'"
                                  title="View Details">
                            <i class="fas fa-eye"></i>
                          </button>
                          <button class="action-btn btn-edit" 
                                  onclick="location.href='UpdateAttendanceController?attendanceId=${attendance.attendanceId}&filterDate=${param.filterDate}&filterAge=${param.filterAge}'"
                                  title="Edit Record">
                            <i class="fas fa-edit"></i>
                          </button>
                          <button class="action-btn btn-delete" 
                                  id="<c:out value='${attendance.attendanceId}'/>" 
                                  onclick="confirmDelete(this.id)"
                                  title="Delete Record">
                            <i class="fas fa-trash"></i>
                          </button>
                        </div>
                      </td>
                    </tr>
                  </c:forEach>
                </tbody>
              </table>
            </div>
          </c:when>
          <c:otherwise>
            <c:if test="${not empty param.selectedAge}">
              <div class="empty-state">
                <div class="empty-icon">
                  <c:choose>
                    <c:when test="${empty filterDate and empty searchQuery}">
                      <i class="fas fa-calendar-alt"></i>
                    </c:when>
                    <c:otherwise>
                      <i class="fas fa-search"></i>
                    </c:otherwise>
                  </c:choose>
                </div>
                <h3>
                  <c:choose>
                    <c:when test="${empty filterDate and empty searchQuery}">
                      Ready to View Attendance
                    </c:when>
                    <c:otherwise>
                      No Records Found
                    </c:otherwise>
                  </c:choose>
                </h3>
                <p>
                  <c:choose>
                    <c:when test="${empty filterDate and empty searchQuery}">
                      Select a date to view student attendance records for age ${param.selectedAge}.
                    </c:when>
                    <c:when test="${not empty searchQuery}">
                      No attendance records match your search criteria. Try adjusting your filters.
                    </c:when>
                    <c:otherwise>
                      No attendance records found for the selected date and age group.
                    </c:otherwise>
                  </c:choose>
                </p>
                <a href="attendanceForm.jsp?age=${param.selectedAge}&filterDate=${filterDate}" class="add-attendance-btn">
                  <i class="fas fa-plus"></i>
                  Record New Attendance
                </a>
              </div>
            </c:if>
          </c:otherwise>
        </c:choose>
      </main>
    </div>

    <!-- Mobile Overlay -->
    <div class="overlay" id="overlay" onclick="toggleSidebar()"></div>

    <script>
      // Sidebar toggle
      function toggleSidebar() {
        const sidebar = document.getElementById('sidebar');
        const overlay = document.getElementById('overlay');
        
        sidebar.classList.toggle('open');
        overlay.classList.toggle('active');
      }

      // Auto-submit form when age changes (primary trigger)
      function autoSubmitForm() {
        const ageValue = document.getElementById('ageFilter').value;
        const dateValue = document.getElementById('dateFilter').value;
        
        // Submit if age is selected (date is optional)
        if (ageValue) {
          document.getElementById('attendanceForm').submit();
        }
      }

      // Check age first when date changes
      function checkAgeThenSubmit() {
        const ageValue = document.getElementById('ageFilter').value;
        
        if (!ageValue) {
          alert("Please select an age group first.");
          document.getElementById('ageFilter').focus();
          return;
        }
        
        // If age is selected, then submit
        autoSubmitForm();
      }

      // Delayed submit for search input
      let searchTimeout;
      function delayedSubmit() {
        clearTimeout(searchTimeout);
        searchTimeout = setTimeout(function() {
          const ageValue = document.getElementById('ageFilter').value;
          const dateValue = document.getElementById('dateFilter').value;
          const searchValue = document.getElementById('searchInput').value;
          
          // Submit if age is selected
          if (ageValue) {
            document.getElementById('attendanceForm').submit();
          }
        }, 500);
      }

      // Toggle clear button visibility
      function toggleClearButton() {
        const searchInput = document.getElementById('searchInput');
        const clearButton = document.getElementById('clearSearch');
        
        if (searchInput.value.trim() !== '') {
          clearButton.classList.add('show');
        } else {
          clearButton.classList.remove('show');
        }
      }

      // Clear search input
      function clearSearch() {
        const searchInput = document.getElementById('searchInput');
        const clearButton = document.getElementById('clearSearch');
        
        searchInput.value = '';
        clearButton.classList.remove('show');
        
        // Auto submit if age is selected
        const ageValue = document.getElementById('ageFilter').value;
        if (ageValue) {
          document.getElementById('attendanceForm').submit();
        }
      }

      function confirmDelete(attendanceId){
        console.log("Deleting attendance ID:", attendanceId);
        var r = confirm("Are you sure you want to delete this attendance record?");
        if (r == true) {
          // Get current filter values
          const filterDate = document.getElementById('dateFilter')?.value || '';
          const selectedAge = document.getElementById('ageFilter')?.value || '';
          const searchQuery = document.getElementById('searchInput')?.value || '';
          
          // Build URL with parameters
          let url = 'DeleteAttendanceController?attendanceId=' + attendanceId;
          
          if (filterDate) url += '&filterDate=' + encodeURIComponent(filterDate);
          if (selectedAge) url += '&selectedAge=' + encodeURIComponent(selectedAge);
          if (searchQuery) url += '&searchQuery=' + encodeURIComponent(searchQuery);
          
          console.log("Redirect URL:", url);
          location.href = url;
        } else {
          return false;
        }
      }

      // Auto-focus on page load
      document.addEventListener('DOMContentLoaded', function() {
        const ageInput = document.getElementById('ageFilter');
        if (!ageInput.value) {
          ageInput.focus();
        }
        
        // Show clear button if search has value
        toggleClearButton();
        
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
      });
    </script>
</body>
</html>