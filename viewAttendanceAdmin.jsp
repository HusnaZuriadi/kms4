<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Attendance Info</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="container mt-5">

    <div class="mb-4">
        <a href="teacherHomepage.html" class="btn btn-primary">Home</a>
        <a href="attendanceForm.jsp" class="btn btn-success">Add Attendance</a>
        <a href="ListAttendanceController" class="btn btn-secondary">Attendance List</a>
    </div>

    <div class="card p-4 shadow-sm">
        <h1 class="mb-4">Attendance Info</h1>

        <p><strong>Attendance ID:</strong> <c:out value="${attendance.attendanceId}"/></p>
        <p><strong>Date:</strong> <fmt:formatDate value="${attendance.attendanceDate}" pattern="yyyy-MM-dd"/></p>
        <p><strong>Student Name:</strong> <c:out value="${attendance.studName}"/></p>
        <p><strong>Check-in Time:</strong> <fmt:formatDate value="${attendance.checkinTime}" type="both" pattern="yyyy-MM-dd HH:mm:ss"/></p>
        <p><strong>Checkout Time:</strong> <fmt:formatDate value="${attendance.checkoutTime}" type="both" pattern="yyyy-MM-dd HH:mm:ss"/></p>
        <p><strong>Status:</strong> <c:out value="${attendance.attendanceStatus}"/></p>
        <p><strong>Check-in Temperature:</strong> <c:out value="${attendance.checkinTemp}"/> °C</p>

        <a href="ListAttendanceController" class="btn btn-outline-primary mt-3">Back to Attendance List</a>
    </div>

</body>
</html>
