<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Student Progress</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f9f9f9;
            margin: 0;
            padding: 0;
        }
        header {
            background-color: #92cf48;
            padding: 20px;
            color: white;
            text-align: center;
            font-size: 24px;
            font-weight: bold;
        }
        .container {
            padding: 20px 40px;
        }
        h2 {
            text-align: center;
            margin-bottom: 20px;
        }
        .filters {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
            justify-content: center;
        }
        .filters input,
        .filters select {
            padding: 8px;
            font-size: 16px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        .btn-create {
            background-color: #00c0e4;
            border: none;
            padding: 10px 15px;
            color: white;
            font-weight: bold;
            border-radius: 5px;
            cursor: pointer;
            float: right;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background-color: white;
        }
        th, td {
            padding: 10px;
            border: 1px solid #f3c0c0;
            text-align: center;
        }
        th {
            background-color: #f8d7da;
            font-weight: bold;
        }
        .action-icons i {
            margin: 0 5px;
            cursor: pointer;
        }
    </style>
    <script>
        function autoSubmitForm() {
            document.getElementById('filterForm').submit();
        }
    </script>
</head>
<body>
    <header>ALKAUTHAR EDUQIDS - Student Progress</header>

    <div class="container">
        <form id="filterForm" action="listStudentProgressController" method="get">
            <div class="filters">
                <div>
                    <label for="month">Month</label><br>
                    <input type="date" id="month" name="month" value="${selectedMonth}" onchange="autoSubmitForm()" required />
                </div>
                <div>
                    <label for="class">Class</label><br>
                    <select name="ageGroup" id="class" onchange="autoSubmitForm()" required>
                        <option value="">-- Select Class --</option>
                        <option value="4" ${selectedClass == 4 ? 'selected' : ''}>4 Years Old</option>
                        <option value="5" ${selectedClass == 5 ? 'selected' : ''}>5 Years Old</option>
                        <option value="6" ${selectedClass == 6 ? 'selected' : ''}>6 Years Old</option>
                    </select>
                </div>
            </div>
        </form>

        <form action="ProgressController" method="post" style="display: inline;">
    <input type="hidden" name="action" value="selectStudent" />
    <input type="hidden" name="progressMonth" value="${selectedMonth}" />
    <button type="submit" class="btn-create" ${empty selectedMonth ? 'disabled' : ''}>+ Record</button>

</form>


        <h3>Student List</h3>
        <table>
            <thead>
                <tr>
                    <th>No</th>
                    <th>Name</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="student" items="${studentList}" varStatus="loop">
                    <tr>
                        <td>${loop.index + 1}</td>
                        <td>${student.name}</td>
                        <td class="action-icons">
                            <a href="UpdateProgressController?studId=${student.studId}&month=${selectedMonth}"><i class="fas fa-pen-to-square"></i></a>
                            <a href="DeleteProgressController?studId=${student.studId}&month=${selectedMonth}" onclick="return confirm('Are you sure to delete this record?');"><i class="fas fa-trash"></i></a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</body>
</html>
