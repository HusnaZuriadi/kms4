<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="kms.model.*" %>
<%
Object user = session.getAttribute("user");
String role = (String) session.getAttribute("role");
String parentName = "";
int id = 0;

if (user instanceof parent) {
    parent p = (parent) user;
    parentName = p.getParentName();
    id = p.getParentId();
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Registration - Al Kauthar EduQids</title>
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

        .sidebar a {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 1rem 1.2rem;
            color: #34495e;
            text-decoration: none;
            border-radius: 16px;
            transition: all 0.3s ease;
            font-weight: 500;
            margin-bottom: 0.5rem;
        }

        .sidebar a:hover {
            background: #f6f9f3;
            color: #2c3e50;
            transform: translateX(5px);
            box-shadow: 0 4px 20px rgba(136, 195, 78, 0.15);
        }

        .sidebar a i {
            font-size: 1.1rem;
            width: 20px;
            text-align: center;
        }

        /* Main Container */
        .container {
            margin-left: 0;
            margin-top: 80px;
            padding: 2rem;
            min-height: calc(100vh - 80px);
            transition: margin-left 0.3s ease;
            max-width: 1200px;
            margin-left: auto;
            margin-right: auto;
        }

        .container.shifted {
            margin-left: 300px;
        }

        .container h2 {
            background: #ffffff;
            padding: 2rem;
            border-radius: 20px;
            margin-bottom: 2rem;
            box-shadow: 0 4px 20px rgba(136, 195, 78, 0.15);
            border: 2px solid #fce4ec;
            font-size: 2.5rem;
            font-weight: 700;
            color: #88c34e;
            display: flex;
            align-items: center;
            text-align: center;
            justify-content: center;
        }

        /* Form Progress */
        .form-progress {
            background: #ffffff;
            border-radius: 16px;
            padding: 1rem;
            margin-bottom: 2rem;
            box-shadow: 0 4px 20px rgba(136, 195, 78, 0.15);
            border: 2px solid #e0e0e0;
        }

        .form-progress-bar {
            height: 8px;
            background: linear-gradient(90deg, #88c34e, #9dd45e);
            border-radius: 8px;
            width: 0%;
            transition: width 0.3s ease;
        }

        /* Form Styles */
        form {
            background: #ffffff;
            border-radius: 20px;
            padding: 2rem;
            box-shadow: 0 4px 20px rgba(136, 195, 78, 0.15);
            border: 2px solid #e0e0e0;
        }

        .form-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
            margin-bottom: 2rem;
        }

        .form-group {
            margin-bottom: 2rem;
        }

        .form-group label {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 0.75rem;
            font-size: 1rem;
        }

        .form-group label.required::after {
            content: '*';
            color: #ef4444;
            margin-left: 0.25rem;
        }

        .form-group label i {
            color: #88c34e;
            font-size: 1.1rem;
        }

        .form-input, .form-select, .form-textarea {
            width: 100%;
            padding: 1rem 1.25rem;
            border: 2px solid #e0e0e0;
            border-radius: 16px;
            font-size: 1rem;
            font-family: inherit;
            transition: all 0.3s ease;
            background: #ffffff;
        }

        .form-input:focus, .form-select:focus, .form-textarea:focus {
            outline: none;
            border-color: #88c34e;
            box-shadow: 0 0 0 3px rgba(136, 195, 78, 0.1);
        }

        .form-input[readonly] {
            background-color: #f8f9fa;
            color: #4b5563;
        }

        /* File Upload Styles */
        .file-input-container {
            position: relative;
        }

        .file-input {
            display: none;
        }

        .file-input-label {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            gap: 1rem;
            padding: 3rem 2rem;
            border: 2px dashed #e0e0e0;
            border-radius: 16px;
            cursor: pointer;
            transition: all 0.3s ease;
            background: #ffffff;
            text-align: center;
        }

        .file-input-label:hover {
            border-color: #88c34e;
            background: rgba(136, 195, 78, 0.05);
        }

        .file-input-label.dragover {
            border-color: #88c34e;
            background: rgba(136, 195, 78, 0.1);
        }

        .file-info {
            display: none;
            align-items: center;
            justify-content: space-between;
            padding: 1rem;
            background: #f8f9fa;
            border-radius: 12px;
            margin-top: 1rem;
        }

        .file-info.show {
            display: flex;
        }

        .file-details {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .file-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: #88c34e;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .file-name {
            font-weight: 600;
            color: #2c3e50;
        }

        .remove-file {
            background: #ef4444;
            color: white;
            border: none;
            width: 32px;
            height: 32px;
            border-radius: 50%;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
        }

        .remove-file:hover {
            background: #dc2626;
            transform: scale(1.1);
        }

        .photo-container {
            display: none;
            margin-top: 1rem;
        }

        .photo-container.show {
            display: block;
        }

        .photo-preview {
            width: 150px;
            height: 150px;
            border-radius: 16px;
            object-fit: cover;
            border: 3px solid #f491ba;
            box-shadow: 0 8px 30px rgba(244, 145, 186, 0.3);
        }

        /* Buttons */
        .form-buttons {
            display: flex;
            gap: 1rem;
            justify-content: center;
            margin-top: 3rem;
            flex-wrap: wrap;
        }

        .btn {
            padding: 1rem 2rem;
            border: none;
            border-radius: 16px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            text-decoration: none;
            font-family: inherit;
        }

        .btn:not(.cancel) {
            background: linear-gradient(135deg, #88c34e 0%, #9dd45e 100%);
            color: white;
            box-shadow: 0 8px 30px rgba(136, 195, 78, 0.3);
        }

        .btn:not(.cancel):hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 40px rgba(136, 195, 78, 0.4);
        }

        .btn.cancel {
            background: #6b7280;
            color: white;
            box-shadow: 0 8px 30px rgba(107, 114, 128, 0.3);
        }

        .btn.cancel:hover {
            background: #4b5563;
            transform: translateY(-2px);
        }

        .btn:disabled {
            opacity: 0.6;
            cursor: not-allowed;
            transform: none !important;
        }

        .btn.loading::after {
            content: '';
            width: 16px;
            height: 16px;
            border: 2px solid transparent;
            border-top: 2px solid currentColor;
            border-radius: 50%;
            animation: spin 1s linear infinite;
            margin-left: 0.5rem;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }

        /* Enhanced validation styles */
        .validation-message.error {
            background: #fef2f2;
            color: #ef4444;
            border: 1px solid #fecaca;
            display: block;
            animation: shake 0.5s ease-in-out;
        }

        .validation-message.success {
            background: #f0fdf4;
            color: #10b981;
            border: 1px solid #bbf7d0;
            display: block;
            animation: slideDown 0.3s ease-out;
        }

        @keyframes shake {
            0%, 20%, 40%, 60%, 80% {
                transform: translateX(0);
            }
            10%, 30%, 50%, 70%, 90% {
                transform: translateX(-5px);
            }
        }

        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Input error states */
        .form-input.error, .form-select.error, .form-textarea.error {
            border-color: #ef4444;
            box-shadow: 0 0 0 3px rgba(239, 68, 68, 0.1);
        }

        .form-input.success, .form-select.success, .form-textarea.success {
            border-color: #10b981;
            box-shadow: 0 0 0 3px rgba(16, 185, 129, 0.1);
        }

        /* Mobile Responsiveness */
        @media (max-width: 768px) {
            .container {
                padding: 1rem;
                margin-left: 0;
            }

            .container.shifted {
                margin-left: 0;
            }

            .form-row {
                grid-template-columns: 1fr;
                gap: 1rem;
            }

            .form-buttons {
                flex-direction: column;
            }

            .container h2 {
                font-size: 2rem;
            }

            .sidebar {
                transform: translateX(-100%);
            }

            .sidebar.show {
                transform: translateX(0);
            }
        }

        /* Form animations */
        .form-group {
            animation: slideUp 0.6s ease forwards;
            opacity: 0;
            transform: translateY(20px);
        }

        .form-group:nth-child(1) { animation-delay: 0.1s; }
        .form-group:nth-child(2) { animation-delay: 0.2s; }
        .form-group:nth-child(3) { animation-delay: 0.3s; }
        .form-group:nth-child(4) { animation-delay: 0.4s; }
        .form-group:nth-child(5) { animation-delay: 0.5s; }
        .form-group:nth-child(6) { animation-delay: 0.6s; }

        @keyframes slideUp {
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    </style>
</head>
<body>
    <header>
        <button class="navSidebar" onclick="toggleSidebar()">
            <i class="fa-solid fa-bars"></i>
        </button>
        <div class="logo">
            <img src="images/LOGO-AL-KAUTHAR-EDUQIDS.png" alt="Al Kauthar EduQids Logo">
        </div>
    </header>

    <nav class="sidebar" id="sidebar">
        <div class="profile">
            <img src="PhotoServlet?role=<%= role %>&type=photo&id=<%= id %>" alt="Parent Profile Photo" onerror="this.src='images/default-avatar.png'">
            <h3><%= parentName %></h3>
            <p>Parent</p>
        </div>
        <a href="parentHome.jsp"><i class="fas fa-home"></i> Dashboard</a>
        <a href="ListChooseSubjectController" style="background: linear-gradient(135deg, rgba(136, 195, 78, 0.1) 0%, rgba(157, 212, 94, 0.1) 100%); color: #88c34e; border-left: 4px solid #88c34e;"><i class="fas fa-user-plus"></i> Student Registration</a>
        <a href="ListChooseSubjectController"><i class="fas fa-book"></i> Subjects</a>
        <a href="ListAttendanceParentController"><i class="fas fa-calendar-check"></i> Attendance</a>
        <a href="viewAccount.jsp"><i class="fas fa-user-cog"></i> Account</a>
        <a href="LogoutController" style="margin-top: 2rem; border-top: 1px solid rgba(0, 0, 0, 0.1); padding-top: 2rem;"><i class="fas fa-sign-out-alt"></i> Logout</a>
    </nav>

    <!-- Main Container -->
    <div class="container" id="container">
        <h2><i class="fas fa-user-plus" style="margin-right: 1rem; color: var(--primary-color);"></i>Register New Student</h2>
        
        <!-- Progress Indicator -->
        <div class="form-progress">
            <div class="form-progress-bar" id="progressBar"></div>
        </div>

        <form action="createStudentController" method="post" enctype="multipart/form-data" id="registrationForm">
            <!-- Personal Information Section -->
            <div class="form-row">
                <div class="form-group">
                    <label for="name" class="required">
                        <i class="fas fa-user"></i>
                        Full Name
                    </label>
                    <input type="text" id="name" name="name" class="form-input" required>
                    <div class="validation-message" id="nameValidation"></div>
                </div>

                <div class="form-group">
                    <label for="gender" class="required">
                        <i class="fas fa-venus-mars"></i>
                        Gender
                    </label>
                    <select id="gender" name="gender" class="form-select" required>
                        <option value="">Select Gender</option>
                        <option value="Male">Male</option>
                        <option value="Female">Female</option>
                    </select>
                    <div class="validation-message" id="genderValidation"></div>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                   <label for="dob" class="required">
                        <i class="fas fa-calendar-alt"></i>
                        Date of Birth
                    </label>
                    <input type="date" id="dob" name="dob" class="form-input" required>
                    <div class="validation-message" id="dobValidation"></div>
                </div>

                <div class="form-group">
                    <label for="age">
                        <i class="fas fa-birthday-cake"></i>
                        Age (Auto-calculated)
                    </label>
                    <input type="number" id="age" name="age" class="form-input" readonly min="4" max="6" placeholder="Select date of birth first">
                    <div class="validation-message" id="ageValidation"></div>
                    <small style="color: #6b7280; font-size: 0.875rem; margin-top: 0.5rem; display: block;">
                        <i class="fas fa-info-circle"></i> Kindergarten accepts children aged 4-6 years only
                    </small>
                </div>
            </div>

            <!-- Address -->
            <div class="form-group">
                <label for="address" class="required">
                    <i class="fas fa-map-marker-alt"></i>
                    Address
                </label>
                <textarea id="address" name="address" rows="3" class="form-textarea" required placeholder="Enter complete address..."></textarea>
                <div class="validation-message" id="addressValidation"></div>
            </div>

            <!-- File Uploads -->
            <div class="form-group">
                <label class="required">
                    <i class="fas fa-camera"></i>
                    Student Photo
                </label>
                <div class="file-input-container">
                    <input type="file" id="photo" name="photo" accept="image/*" required class="file-input">
                    <label for="photo" class="file-input-label">
                        <i class="fas fa-cloud-upload-alt" style="font-size: 2rem; color: var(--gray-400);"></i>
                        <div>
                            <div style="font-weight: 600; margin-bottom: 0.5rem;">Click to upload student photo</div>
                            <div style="font-size: 0.875rem; color: var(--gray-500);">JPEG, PNG up to 5MB</div>
                        </div>
                    </label>
                    <div class="file-info" id="photoInfo">
                        <div class="file-details">
                            <div class="file-icon">
                                <i class="fas fa-image"></i>
                            </div>
                            <div>
                                <div class="file-name" id="photoName"></div>
                                <div style="font-size: 0.875rem; color: var(--gray-500);" id="photoSize"></div>
                            </div>
                        </div>
                        <button type="button" class="remove-file" onclick="removeFile('photo')">
                            <i class="fas fa-times"></i>
                        </button>
                    </div>
                    <div class="photo-container" id="photoContainer">
                        <img id="photoPreview" alt="Photo Preview" class="photo-preview" />
                    </div>
                </div>
                <div class="validation-message" id="photoValidation"></div>
            </div>

            <div class="form-group">
                <label class="required">
                    <i class="fas fa-file-alt"></i>
                    Birth Certificate
                </label>
                <div class="file-input-container">
                    <input type="file" id="birthCert" name="birthCert" accept=".pdf,image/*" required class="file-input">
                    <label for="birthCert" class="file-input-label">
                        <i class="fas fa-file-upload" style="font-size: 2rem; color: var(--gray-400);"></i>
                        <div>
                            <div style="font-weight: 600; margin-bottom: 0.5rem;">Click to upload birth certificate</div>
                            <div style="font-size: 0.875rem; color: var(--gray-500);">PDF or Image files up to 10MB</div>
                        </div>
                    </label>
                    <div class="file-info" id="birthCertInfo">
                        <div class="file-details">
                            <div class="file-icon">
                                <i class="fas fa-file-pdf"></i>
                            </div>
                            <div>
                                <div class="file-name" id="birthCertName"></div>
                                <div style="font-size: 0.875rem; color: var(--gray-500);" id="birthCertSize"></div>
                            </div>
                        </div>
                        <button type="button" class="remove-file" onclick="removeFile('birthCert')">
                            <i class="fas fa-times"></i>
                        </button>
                    </div>
                </div>
                <div class="validation-message" id="birthCertValidation"></div>
            </div>

            <!-- Parent Information -->
            <div class="form-group">
                <label>
                    <i class="fas fa-user-tie"></i>
                    Parent Name
                </label>
                <input type="text" value="<%= parentName %>" readonly class="form-input" style="background-color: #f8f9fa; color: #4b5563;">
            </div>

            <div class="form-buttons">
                <button class="btn" type="submit" id="submitBtn">
                    <i class="fas fa-paper-plane"></i>
                    Register Student
                </button>

                <button type="button" class="btn cancel" onclick="window.location.href='ListStudentController'">
                    <i class="fas fa-times-circle"></i>
                    Cancel
                </button>
            </div>
        </form>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            // Sidebar toggle
            function toggleSidebar() {
                const sidebar = document.getElementById("sidebar");
                const container = document.getElementById("container");
                sidebar.classList.toggle("show");
                container.classList.toggle("shifted");
            }
            window.toggleSidebar = toggleSidebar;

            document.addEventListener('click', function (event) {
                const sidebar = document.getElementById('sidebar');
                const navButton = document.querySelector('.navSidebar');
                const container = document.getElementById('container');
                if (sidebar && navButton && !sidebar.contains(event.target) && !navButton.contains(event.target)) {
                    sidebar.classList.remove('show');
                    container.classList.remove('shifted');
                }
            });

            const form = document.getElementById('registrationForm');
            const progressBar = document.getElementById('progressBar');

            if (!form || !progressBar) return;

            const requiredInputs = form.querySelectorAll('input[required], select[required], textarea[required]');

            function updateProgress() {
                let filled = 0;
                requiredInputs.forEach(input => {
                    if ((input.type === 'file' && input.files.length > 0) || input.value.trim() !== '') {
                        filled++;
                    }
                });
                progressBar.style.width = (filled / requiredInputs.length * 100) + '%';
            }

            document.getElementById("dob").addEventListener("change", function () {
                const dob = new Date(this.value);
                const today = new Date();
                const ageField = document.getElementById("age");
                const dobValidation = document.getElementById("dobValidation");
                const ageValidation = document.getElementById("ageValidation");
                const submitBtn = document.getElementById("submitBtn");

                let age = today.getFullYear() - dob.getFullYear();
                
                // More precise age calculation
                const monthDiff = today.getMonth() - dob.getMonth();
                if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < dob.getDate())) {
                    age--;
                }

                ageField.value = age;

                // Validate age range (4-6 years old)
                if (age < 4 || age > 6) {
                    // Show error messages
                    dobValidation.className = "validation-message error";
                    dobValidation.textContent = `Child must be between 4-6 years old. Current age: ${age} years.`;
                    
                    ageValidation.className = "validation-message error";
                    ageValidation.textContent = "Age must be between 4-6 years for kindergarten enrollment.";
                    
                    // Disable submit button
                    submitBtn.disabled = true;
                    submitBtn.style.opacity = "0.5";
                    submitBtn.style.cursor = "not-allowed";
                    
                    // Add red border to inputs
                    this.style.borderColor = "#ef4444";
                    ageField.style.borderColor = "#ef4444";
                } else {
                    // Clear error messages
                    dobValidation.className = "validation-message";
                    dobValidation.textContent = "";
                    
                    ageValidation.className = "validation-message success";
                    ageValidation.textContent = `✓ Perfect! ${age} years old is eligible for kindergarten.`;
                    
                    // Enable submit button
                    submitBtn.disabled = false;
                    submitBtn.style.opacity = "1";
                    submitBtn.style.cursor = "pointer";
                    
                    // Reset border colors
                    this.style.borderColor = "#10b981";
                    ageField.style.borderColor = "#10b981";
                }
                
                updateProgress();
            });

            function handleFilePreview(inputId, previewId, infoId, nameId, sizeId) {
                const input = document.getElementById(inputId);
                const preview = previewId ? document.getElementById(previewId) : null;
                const info = document.getElementById(infoId);
                const name = document.getElementById(nameId);
                const size = document.getElementById(sizeId);

                if (!input || !info || !name || !size) return;

                input.addEventListener('change', function () {
                    const file = this.files[0];
                    if (file) {
                        name.textContent = file.name;
                        size.textContent = formatFileSize(file.size);
                        info.classList.add('show');

                        if (inputId === 'photo' && preview) {
                            const reader = new FileReader();
                            reader.onload = e => {
                                preview.src = e.target.result;
                                const photoContainer = document.getElementById('photoContainer');
                                if (photoContainer) {
                                    photoContainer.classList.add('show');
                                }
                            };
                            reader.readAsDataURL(file);
                        }
                    }
                    updateProgress();
                });
            }

            handleFilePreview('photo', 'photoPreview', 'photoInfo', 'photoName', 'photoSize');
            handleFilePreview('birthCert', null, 'birthCertInfo', 'birthCertName', 'birthCertSize');

            function removeFile(inputId) {
                const input = document.getElementById(inputId);
                if (!input) return;

                input.value = '';
                const info = document.getElementById(inputId + 'Info');
                if (info) info.classList.remove('show');

                if (inputId === 'photo') {
                    const photoContainer = document.getElementById('photoContainer');
                    if (photoContainer) {
                        photoContainer.classList.remove('show');
                    }
                }
                updateProgress();
            }
            window.removeFile = removeFile;

            function formatFileSize(bytes) {
                const sizes = ['Bytes', 'KB', 'MB', 'GB'];
                const i = Math.floor(Math.log(bytes) / Math.log(1024));
                return parseFloat((bytes / Math.pow(1024, i)).toFixed(2)) + ' ' + sizes[i];
            }

            function setupDrag(inputId) {
                const label = document.querySelector(`label[for="${inputId}"]`);
                if (!label) return;

                ['dragenter', 'dragover', 'dragleave', 'drop'].forEach(evt => {
                    label.addEventListener(evt, e => {
                        e.preventDefault();
                        e.stopPropagation();
                        label.classList.toggle('dragover', evt === 'dragenter' || evt === 'dragover');
                    });
                });

                label.addEventListener('drop', e => {
                    const files = e.dataTransfer.files;
                    if (files.length) {
                        const input = document.getElementById(inputId);
                        input.files = files;
                        input.dispatchEvent(new Event('change'));
                    }
                });
            }

            setupDrag('photo');
            setupDrag('birthCert');

            // Additional validation on form submit
            form.addEventListener('submit', function (e) {
                const age = parseInt(document.getElementById('age').value);
                const submitBtn = document.getElementById('submitBtn');
                
                // Check age range before submitting
                if (age < 4 || age > 6) {
                    e.preventDefault();
                    
                    // Show error modal
                    showAgeErrorModal(age);
                    return false;
                }
                
                // Show loading state
                if (submitBtn) {
                    submitBtn.disabled = true;
                    submitBtn.classList.add('loading');
                    submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Registering Student...';
                }
            });

            // Function to show age error modal
            function showAgeErrorModal(currentAge) {
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
                    z-index: 2000;
                `;
                
                modal.innerHTML = `
                    <div style="
                        background: white;
                        padding: 2rem;
                        border-radius: 20px;
                        max-width: 450px;
                        text-align: center;
                        box-shadow: 0 10px 40px rgba(0,0,0,0.3);
                        border: 3px solid #ef4444;
                    ">
                        <div style="
                            width: 80px;
                            height: 80px;
                            background: #ef4444;
                            border-radius: 50%;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            margin: 0 auto 1.5rem;
                            color: white;
                            font-size: 2rem;
                        ">
                            <i class="fas fa-exclamation-triangle"></i>
                        </div>
                        <h3 style="color: #2c3e50; margin-bottom: 1rem; font-size: 1.5rem;">Age Requirement Not Met</h3>
                        <p style="color: #34495e; margin-bottom: 1rem; font-size: 1.1rem;">
                            Your child is currently <strong>${currentAge} years old</strong>.
                        </p>
                        <p style="color: #34495e; margin-bottom: 2rem; line-height: 1.6;">
                            Al Kauthar EduQids kindergarten program is designed for children aged <strong>4 to 6 years old</strong>. 
                            Please update the date of birth to reflect the correct age.
                        </p>
                        <button onclick="closeAgeModal()" style="
                            background: #88c34e;
                            color: white;
                            padding: 1rem 2rem;
                            border: none;
                            border-radius: 12px;
                            cursor: pointer;
                            font-weight: 600;
                            font-size: 1rem;
                            transition: all 0.3s ease;
                        ">
                            <i class="fas fa-edit" style="margin-right: 0.5rem;"></i>
                            Update Date of Birth
                        </button>
                    </div>
                `;
                
                document.body.appendChild(modal);
                
                window.closeAgeModal = function() {
                    document.body.removeChild(modal);
                    // Focus on date of birth field
                    document.getElementById('dob').focus();
                }
                
                // Close on backdrop click
                modal.addEventListener('click', function(e) {
                    if (e.target === modal) {
                        closeAgeModal();
                    }
                });
            }

            updateProgress();
        });
    </script>
</body>
</html>