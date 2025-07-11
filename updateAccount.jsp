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
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Account - Al Kauthar EduQids</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
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

        /* Top Navigation */
        .topNav {
            background: #88c34e;
            padding: 1rem 2rem;
            box-shadow: 0 2px 10px rgba(136, 195, 78, 0.15);
        }

        .backLink {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            color: white;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .backLink:hover {
            color: #f0f0f0;
            transform: translateX(-2px);
        }

        /* Page Container */
        .pageContainer {
            max-width: 800px;
            margin: 2rem auto;
            padding: 0 1rem;
        }

        /* Page Header */
        .pageHeader {
            text-align: center;
            margin-bottom: 3rem;
            background: #ffffff;
            padding: 2rem;
            border-radius: 20px;
            box-shadow: 0 4px 20px rgba(136, 195, 78, 0.15);
            border: 2px solid #fce4ec;
        }

        .headerIcon {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #88c34e 0%, #9dd45e 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1.5rem;
            font-size: 2rem;
            color: white;
            box-shadow: 0 8px 30px rgba(136, 195, 78, 0.3);
        }

        .pageHeader h1 {
            font-size: 2.5rem;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 0.5rem;
        }

        .pageHeader p {
            color: #34495e;
            font-size: 1.1rem;
            font-weight: 500;
        }

        /* Form Card */
        .formCard {
            background: #ffffff;
            border-radius: 20px;
            padding: 3rem;
            box-shadow: 0 4px 20px rgba(136, 195, 78, 0.15);
            border: 2px solid #e0e0e0;
            margin-bottom: 2rem;
        }

        /* Photo Section */
        .photoSection {
            text-align: center;
            margin-bottom: 3rem;
            padding-bottom: 2rem;
            border-bottom: 2px solid #f8f9fa;
        }

        .currentPhoto {
            position: relative;
            display: inline-block;
            margin-bottom: 1.5rem;
        }

        .currentPhoto img {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid #f491ba;
            box-shadow: 0 8px 30px rgba(244, 145, 186, 0.3);
            transition: all 0.3s ease;
        }

        .photoOverlay {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.7);
            border-radius: 50%;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            opacity: 0;
            transition: opacity 0.3s ease;
            cursor: pointer;
            color: white;
        }

        .currentPhoto:hover .photoOverlay {
            opacity: 1;
        }

        .photoOverlay i {
            font-size: 1.5rem;
            margin-bottom: 0.5rem;
        }

        .photoOverlay span {
            font-size: 0.9rem;
            font-weight: 500;
        }

        .photoControls {
            display: flex;
            gap: 1rem;
            justify-content: center;
            margin-bottom: 1rem;
        }

        .photoButton, .removePhotoBtn {
            padding: 0.75rem 1.5rem;
            border-radius: 12px;
            border: none;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            text-decoration: none;
        }

        .photoButton {
            background: #88c34e;
            color: white;
        }

        .photoButton:hover {
            background: #76a33e;
            transform: translateY(-2px);
        }

        .removePhotoBtn {
            background: #dc3545;
            color: white;
        }

        .removePhotoBtn:hover {
            background: #c82333;
            transform: translateY(-2px);
        }

        .photoInfo {
            color: #6c757d;
            font-size: 0.875rem;
        }

        /* Form Sections */
        .formSection {
            margin-bottom: 2rem;
            padding-bottom: 2rem;
            border-bottom: 2px solid #f8f9fa;
        }

        .formSection:last-of-type {
            border-bottom: none;
            margin-bottom: 0;
            padding-bottom: 0;
        }

        .formSection h3 {
            font-size: 1.25rem;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .formSection h3 i {
            color: #88c34e;
            font-size: 1.1rem;
        }

        /* Input Groups */
        .inputGroup {
            margin-bottom: 1.5rem;
        }

        .inputGroup label {
            display: block;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 0.5rem;
            font-size: 1rem;
        }

        .inputGroup input {
            width: 100%;
            padding: 1rem;
            border: 2px solid #e0e0e0;
            border-radius: 12px;
            font-size: 1rem;
            font-family: inherit;
            transition: all 0.3s ease;
            background: #ffffff;
        }

        .inputGroup input:focus {
            outline: none;
            border-color: #88c34e;
            box-shadow: 0 0 0 3px rgba(136, 195, 78, 0.1);
        }

        .inputGroup input:not(:placeholder-shown) {
            border-color: #88c34e;
        }

        .inputHelp {
            color: #6c757d;
            font-size: 0.875rem;
            margin-top: 0.5rem;
            display: block;
        }

        /* Action Buttons */
        .actionButtons {
            display: flex;
            gap: 1rem;
            justify-content: center;
            margin-top: 3rem;
            flex-wrap: wrap;
        }

        .actionButtons button {
            padding: 1rem 2rem;
            border: none;
            border-radius: 12px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.75rem;
            min-width: 140px;
            justify-content: center;
        }

        .cancelBtn {
            background: #6c757d;
            color: white;
        }

        .cancelBtn:hover {
            background: #5a6268;
            transform: translateY(-2px);
        }

        .resetBtn {
            background: #f491ba;
            color: white;
        }

        .resetBtn:hover {
            background: #e67fa3;
            transform: translateY(-2px);
        }

        .saveBtn {
            background: linear-gradient(135deg, #88c34e 0%, #9dd45e 100%);
            color: white;
        }

        .saveBtn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 30px rgba(136, 195, 78, 0.3);
        }

        /* Help Section */
        .helpSection {
            background: #ffffff;
            border-radius: 20px;
            padding: 2rem;
            box-shadow: 0 4px 20px rgba(136, 195, 78, 0.15);
            border: 2px solid #e0e0e0;
        }

        .helpSection h4 {
            font-size: 1.1rem;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .helpSection h4 i {
            color: #88c34e;
        }

        .helpSection ul {
            list-style: none;
            padding-left: 0;
        }

        .helpSection li {
            padding: 0.5rem 0;
            color: #34495e;
            position: relative;
            padding-left: 1.5rem;
        }

        .helpSection li::before {
            content: '•';
            color: #88c34e;
            position: absolute;
            left: 0;
            font-weight: bold;
        }

        /* Modals */
        .loadingOverlay, .modal {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 1000;
        }

        .loadingContent, .modalContent {
            background: white;
            padding: 2rem;
            border-radius: 20px;
            text-align: center;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.3);
            max-width: 400px;
            width: 90%;
        }

        .spinner {
            width: 50px;
            height: 50px;
            border: 4px solid #f3f3f3;
            border-top: 4px solid #88c34e;
            border-radius: 50%;
            animation: spin 1s linear infinite;
            margin: 0 auto 1rem;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        .successIcon {
            width: 80px;
            height: 80px;
            background: #28a745;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1.5rem;
            font-size: 2rem;
            color: white;
        }

        .modalContent h3 {
            font-size: 1.5rem;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 1rem;
        }

        .modalContent p {
            color: #34495e;
            margin-bottom: 2rem;
        }

        .okBtn {
            background: #28a745;
            color: white;
            padding: 1rem 2rem;
            border: none;
            border-radius: 12px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .okBtn:hover {
            background: #218838;
            transform: translateY(-2px);
        }

        /* Mobile Responsiveness */
        @media (max-width: 768px) {
            .pageContainer {
                margin: 1rem auto;
                padding: 0 0.5rem;
            }

            .formCard {
                padding: 2rem 1.5rem;
            }

            .pageHeader {
                padding: 1.5rem;
            }

            .pageHeader h1 {
                font-size: 2rem;
            }

            .headerIcon {
                width: 60px;
                height: 60px;
                font-size: 1.5rem;
            }

            .currentPhoto img {
                width: 120px;
                height: 120px;
            }

            .actionButtons {
                flex-direction: column;
            }

            .actionButtons button {
                min-width: auto;
                width: 100%;
            }

            .photoControls {
                flex-direction: column;
                align-items: center;
            }

            .photoButton, .removePhotoBtn {
                width: 100%;
                max-width: 250px;
                justify-content: center;
            }
        }

        /* Animations */
        .formCard, .helpSection {
            animation: slideUp 0.6s ease forwards;
            opacity: 0;
            transform: translateY(20px);
        }

        .formCard { animation-delay: 0.1s; }
        .helpSection { animation-delay: 0.2s; }

        @keyframes slideUp {
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    </style>
</head>
<body>

    <!-- Back Navigation -->
    <div class="topNav">
        <a href="viewAccount.jsp" class="backLink">
            <i class="fas fa-arrow-left"></i>
            Back to Profile
        </a>
    </div>

    <div class="pageContainer">
        <!-- Page Header -->
        <div class="pageHeader">
            <div class="headerIcon">
                <i class="fas fa-user-edit"></i>
            </div>
            <h1>Update My Account</h1>
            <p>Edit your personal information and profile photo</p>
        </div>

        <!-- Update Form -->
        <div class="formCard">
            <form id="updateForm" action="UpdateAccountController" method="post" enctype="multipart/form-data">
                <input type="hidden" name="role" value="<%= role %>" />
                <input type="hidden" name="id" value="<%= id %>" />

                <!-- Profile Photo -->
                <div class="photoSection">
                    <div class="currentPhoto">
                        <img id="photoPreview" src="PhotoServlet?role=<%= role %>&type=photo&id=<%= id %>" 
                             alt="Current Profile Photo" onerror="this.src='images/default-avatar.png'">
                        <div class="photoOverlay">
                            <i class="fas fa-camera"></i>
                            <span>Click to Change</span>
                        </div>
                    </div>
                    <div class="photoControls">
                        <label for="photoInput" class="photoButton">
                            <i class="fas fa-upload"></i> Choose New Photo
                        </label>
                        <input type="file" id="photoInput" name="photo" accept="image/*" style="display: none;">
                        <button type="button" id="removePhoto" class="removePhotoBtn" style="display: none;">
                            <i class="fas fa-times"></i> Remove Photo
                        </button>
                    </div>
                    <div class="photoInfo">
                        <small><i class="fas fa-info-circle"></i> JPG, PNG, or GIF • Max 16MB</small>
                    </div>
                </div>

                <!-- Personal Info -->
                <div class="formSection">
                    <h3><i class="fas fa-user"></i> Personal Information</h3>
                    <div class="inputGroup">
                        <label for="name">Full Name</label>
                        <input type="text" id="name" name="name" value="<%= name %>" placeholder="Enter your full name">
                        <small class="inputHelp">Leave empty to keep current name</small>
                    </div>
                    <div class="inputGroup">
                        <label for="email">Email Address</label>
                        <input type="email" id="email" name="email" value="<%= email %>" placeholder="Enter your email">
                        <small class="inputHelp">Leave empty to keep current email</small>
                    </div>
                    <div class="inputGroup">
                        <label for="phone">Phone Number</label>
                        <input type="tel" id="phone" name="phone" value="<%= phone %>" placeholder="011-1234567">
                        <small class="inputHelp">Leave empty to keep current phone</small>
                    </div>
                </div>

                <!-- Teacher Fields -->
                <% if ("FullTime".equalsIgnoreCase(teacherType)) { %>
                <div class="formSection">
                    <h3><i class="fas fa-chalkboard-teacher"></i> Employment Details</h3>
                    <div class="inputGroup">
                        <label for="salary">Monthly Salary (RM)</label>
                        <input type="number" id="salary" name="salary" value="<%= salary %>" step="0.01">
                        <small class="inputHelp">Leave empty to keep current salary</small>
                    </div>
                </div>
                <% } else if ("PartTime".equalsIgnoreCase(teacherType)) { %>
                <div class="formSection">
                    <h3><i class="fas fa-chalkboard-teacher"></i> Employment Details</h3>
                    <div class="inputGroup">
                        <label for="contract">Contract Duration (months)</label>
                        <input type="number" id="contract" name="contract" value="<%= contract %>">
                        <small class="inputHelp">Leave empty to keep current contract</small>
                    </div>
                    <div class="inputGroup">
                        <label for="hourlyRate">Hourly Rate (RM)</label>
                        <input type="number" id="hourlyRate" name="hourlyRate" value="<%= hourlyRate %>" step="0.01">
                        <small class="inputHelp">Leave empty to keep current rate</small>
                    </div>
                </div>
                <% } %>

                <!-- Action Buttons -->
                <div class="actionButtons">
                    <button type="button" class="cancelBtn" onclick="window.location.href='viewAccount.jsp'">
                        <i class="fas fa-times"></i> Cancel
                    </button>
                    <button type="reset" class="resetBtn">
                        <i class="fas fa-undo"></i> Reset
                    </button>
                    <button type="submit" class="saveBtn">
                        <i class="fas fa-save"></i> Save
                    </button>
                </div>
            </form>
        </div>

        <!-- Help -->
        <div class="helpSection">
            <h4><i class="fas fa-question-circle"></i> Need Help?</h4>
            <ul>
                <li>Leave a field blank to keep the current value</li>
                <li>Use a professional and clear photo</li>
                <li>Contact admin to update your role/type</li>
            </ul>
        </div>
    </div>

    <!-- Modals + Scripts -->
    <div id="loadingOverlay" class="loadingOverlay" style="display: none;">
        <div class="loadingContent">
            <div class="spinner"></div>
            <p>Updating your account...</p>
        </div>
    </div>

    <div id="successModal" class="modal" style="display: none;">
        <div class="modalContent">
            <div class="successIcon">
                <i class="fas fa-check-circle"></i>
            </div>
            <h3>Account Updated!</h3>
            <p>Your profile has been successfully updated.</p>
            <button onclick="closeSuccessModal()" class="okBtn">
                <i class="fas fa-thumbs-up"></i> Great!
            </button>
        </div>
    </div>

    <script>
        // Photo preview functionality
        document.getElementById('photoInput').addEventListener('change', function(e) {
            const file = e.target.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    document.getElementById('photoPreview').src = e.target.result;
                    document.getElementById('removePhoto').style.display = 'inline-flex';
                };
                reader.readAsDataURL(file);
            }
        });

        // Remove photo functionality
        document.getElementById('removePhoto').addEventListener('click', function() {
            document.getElementById('photoInput').value = '';
            document.getElementById('photoPreview').src = 'PhotoServlet?role=<%= role %>&type=photo&id=<%= id %>';
            this.style.display = 'none';
        });

        // Photo overlay click
        document.querySelector('.photoOverlay').addEventListener('click', function() {
            document.getElementById('photoInput').click();
        });

        // Form submission
        document.getElementById('updateForm').addEventListener('submit', function(e) {
            document.getElementById('loadingOverlay').style.display = 'flex';
        });

        // Success modal
        function closeSuccessModal() {
            document.getElementById('successModal').style.display = 'none';
            window.location.href = 'viewAccount.jsp';
        }

        // Show success modal if update was successful
        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.get('success') === 'true') {
            document.getElementById('successModal').style.display = 'flex';
        }
    </script>
</body>
</html>