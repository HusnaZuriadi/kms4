<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>  
<%@ page import="kms.model.*" %>
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
    <title>Update Student - Al-Kauthar EduQids</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
   <link rel="stylesheet" href="css/updateStudent.css" />
</head>
<body>
    <header>
        <button class="navSidebar" onclick="toggleSidebar()" aria-label="Toggle navigation menu">
            <i class="fa-solid fa-bars"></i>
        </button>
        <div class="logo">
            <img src="images/LOGO-AL-KAUTHAR-EDUQIDS.png" alt="ALKAUTHAR EDUQIDS Logo">
        </div>
    </header>

    <nav class="sidebar" id="sidebar" role="navigation" aria-label="Main navigation">
        <div class="profile">
            <a href="viewAccount.jsp">
                <img src="PhotoServlet?role=<%= role %>&type=photo&id=<%= id %>" alt="Parent Profile Photo">
            </a>
            <h3><%= parentName %></h3>
            <p>Parent</p>
        </div>
        <ul class="sidebar-links top-links">
            <li><a href="parentHome.jsp" class="active"><i class="fas fa-home"></i> Home</a></li>
            <li><a href="ListChooseSubjectController"><i class="fas fa-book"></i> Subject</a></li>
            <li><a href="#"><i class="fas fa-calendar-check"></i> Attendance</a></li>
            <li><a href="#"><i class="fas fa-chart-line"></i> Progress</a></li>
            <li><a href="ListStudentController"><i class="fas fa-child"></i> Student</a></li>
        </ul>
        <div class="_separator_1e1cy_1"></div>
        <ul class="sidebar-links bottom-links">
            <li><a href="viewAccount.jsp"><i class="fas fa-user-cog"></i> Account</a></li>
            <li><a href="LogoutController"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
        </ul>
    </nav>

    <main class="container">
        <h2><i class="fas fa-edit"></i> Update Student Information</h2>
        
        <!-- Progress Indicator -->
        <div class="form-progress" aria-label="Form completion progress">
            <div class="form-progress-bar" id="progressBar"></div>
        </div>

        <form action="updateStudentController" method="post" enctype="multipart/form-data" 
              id="updateForm" novalidate aria-label="Update student information form">
            
            <input type="hidden" name="studId" value="${student.studId}" />

            <!-- Personal Information Section -->
            <div class="form-row">
                <div class="form-group">
                    <label for="name" class="required">
                        <i class="fas fa-user"></i> Full Name
                    </label>
                    <input type="text" id="name" name="name" value="${student.studName}" 
                           class="form-input" required placeholder="Enter student's full name"
                           aria-describedby="nameError">
                    <div id="nameError" class="validation-message error" role="alert" style="display: none;"></div>
                </div>
                
                <div class="form-group">
                    <label for="gender" class="required">
                        <i class="fas fa-venus-mars"></i> Gender
                    </label>
                    <select id="gender" name="gender" class="form-select" required aria-describedby="genderError">
                        <option value="Male" <c:if test="${student.studGender == 'Male'}">selected</c:if>>Male</option>
                        <option value="Female" <c:if test="${student.studGender == 'Female'}">selected</c:if>>Female</option>
                    </select>
                    <div id="genderError" class="validation-message error" role="alert" style="display: none;"></div>
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="dob" class="required">
                        <i class="fas fa-calendar-alt"></i> Date of Birth
                    </label>
                    <input type="date" id="dob" name="dob" value="${student.studBirthDate}" 
                           class="form-input" required aria-describedby="dobError">
                    <div id="dobError" class="validation-message error" role="alert" style="display: none;"></div>
                </div>
                
                <div class="form-group">
                    <label for="age">
                        <i class="fas fa-birthday-cake"></i> Age (Auto-calculated)
                    </label>
                    <input type="number" id="age" name="age" value="${studAge}" 
                           class="form-input" min="1" max="20" readonly>
                </div>
            </div>
            
            <div class="form-group">
                <label for="address" class="required">
                    <i class="fas fa-map-marker-alt"></i> Home Address
                </label>
                <textarea id="address" name="address" class="form-textarea" required
                          placeholder="Enter complete home address including postal code"
                          aria-describedby="addressError">${student.studAddress}</textarea>
                <div id="addressError" class="validation-message error" role="alert" style="display: none;"></div>
            </div>

            <!-- Photo Upload Section -->
            <div class="form-group">
                <label>
                    <i class="fas fa-camera"></i> Student Photo
                </label>
                
                <c:if test="${not empty student.studPhoto}">
                    <div class="current-file">
                        <div style="color: var(--gray-600); font-size: 0.875rem; margin-bottom: 0.5rem;">Current Photo:</div>
                        <img id="photoPreview" src="PhotoServlet?role=student&id=${student.studId}&type=photo" 
                             alt="Current student photo">
                    </div>
                </c:if>
                
                <div class="file-input-container">
                    <input type="file" id="photoInput" name="photo" class="file-input" 
                           accept="image/*" aria-describedby="photoError">
                    <label for="photoInput" class="file-input-label" id="photoLabel">
                        <i class="fas fa-cloud-upload-alt fa-2x"></i>
                        <div>
                            <p><strong>Click to upload</strong> or drag and drop</p>
                            <small>JPEG, PNG up to 5MB</small>
                        </div>
                    </label>
                    <div class="file-info" id="photoInfo">
                        <div class="file-details">
                            <div class="file-icon">
                                <i class="fas fa-image"></i>
                            </div>
                            <div>
                                <div class="file-name"></div>
                                <div class="file-size"></div>
                            </div>
                        </div>
                        <button type="button" class="remove-file" onclick="removeFile('photo')">
                            <i class="fas fa-times"></i>
                        </button>
                    </div>
                </div>
                <div id="photoError" class="validation-message error" role="alert" style="display: none;"></div>
            </div>
            
            <!-- Birth Certificate Upload Section -->
            <div class="form-group">
                <label>
                    <i class="fas fa-file-alt"></i> Birth Certificate
                </label>
                
                <c:if test="${not empty student.studBirthCert}">
                    <div class="current-file">
                        <div style="color: var(--gray-600); font-size: 0.875rem; margin-bottom: 0.5rem;">Current Certificate:</div>
                        <a href="PhotoServlet?role=student&id=${student.studId}&type=cert" target="_blank">
                            <i class="fas fa-file-alt"></i> View Current Certificate
                        </a>
                    </div>
                </c:if>
                
                <div class="file-input-container">
                    <input type="file" id="birthCertInput" name="birthCert" class="file-input" 
                           accept="application/pdf,image/*" aria-describedby="birthCertError">
                    <label for="birthCertInput" class="file-input-label" id="birthCertLabel">
                        <i class="fas fa-file-upload fa-2x"></i>
                        <div>
                            <p><strong>Click to upload</strong> or drag and drop</p>
                            <small>PDF, JPEG, PNG up to 10MB</small>
                        </div>
                    </label>
                    <div class="file-info" id="birthCertInfo">
                        <div class="file-details">
                            <div class="file-icon">
                                <i class="fas fa-file-alt"></i>
                            </div>
                            <div>
                                <div class="file-name"></div>
                                <div class="file-size"></div>
                            </div>
                        </div>
                        <button type="button" class="remove-file" onclick="removeFile('birthCert')">
                            <i class="fas fa-times"></i>
                        </button>
                    </div>
                </div>
                <div id="birthCertError" class="validation-message error" role="alert" style="display: none;"></div>
            </div>

            <!-- Form Actions -->
            <div class="form-buttons">
                <button type="submit" class="btn" id="submitBtn">
                    <i class="fas fa-save"></i> Update Student
                </button>
                <button type="button" class="btn btn-cancel" onclick="location.href='ListStudentController'">
                    <i class="fas fa-times"></i> Cancel
                </button>
            </div>
        </form>
    </main>
    
    <!-- Changes Indicator -->
    <div class="changes-indicator" id="changesIndicator">
        <i class="fas fa-edit"></i> You have unsaved changes
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.getElementById('updateForm');
            const submitBtn = document.getElementById('submitBtn');
            const changesIndicator = document.getElementById('changesIndicator');
            const progressBar = document.getElementById('form-progress-bar') || document.getElementById('progressBar');
            
            // Store original form data for change detection
            const originalData = new FormData(form);
            let hasChanges = false;
            
            // Form validation
            const requiredFields = ['name', 'gender', 'dob', 'address'];
            let validFields = new Set();
            
            // Initialize validation for existing data
            requiredFields.forEach(fieldName => {
                const field = document.getElementById(fieldName);
                if (field && field.value.trim()) {
                    validFields.add(fieldName);
                }
            });
            updateProgress();
            
            // Real-time validation and change detection
            form.addEventListener('input', function(e) {
                if (requiredFields.includes(e.target.name)) {
                    validateField(e.target);
                }
                detectChanges();
            });
            
            form.addEventListener('change', function(e) {
                if (requiredFields.includes(e.target.name)) {
                    validateField(e.target);
                }
                detectChanges();
            });
            
            // Age calculation from date of birth
            document.getElementById('dob').addEventListener('change', function() {
                const dob = new Date(this.value);
                const today = new Date();
                let age = today.getFullYear() - dob.getFullYear();
                const monthDiff = today.getMonth() - dob.getMonth();
                
                if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < dob.getDate())) {
                    age--;
                }
                
                document.getElementById('age').value = age >= 0 ? age : '';
            });
            
            // File upload setup
            setupFileUpload('photoInput', 'photoLabel', 'photoInfo', 'photoPreview', ['image/jpeg', 'image/png'], 5);
            setupFileUpload('birthCertInput', 'birthCertLabel', 'birthCertInfo', null, ['application/pdf', 'image/jpeg', 'image/png'], 10);
            
            // Form submission with loading state
            form.addEventListener('submit', function(e) {
                if (!validateForm()) {
                    e.preventDefault();
                    return;
                }
                
                submitBtn.classList.add('loading');
                submitBtn.disabled = true;
                submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Updating...';
            });
            
            // Warn about unsaved changes
            form.addEventListener('submit', function(e) {
    if (!validateForm()) {
        e.preventDefault();
        return;
    }

    alert('Student information has been successfully updated.');
});

            
            function validateField(field) {
                const fieldName = field.name;
                const errorElement = document.getElementById(fieldName + 'Error');
                let isValid = true;
                let errorMessage = '';
                
                // Clear previous state
                if (errorElement) {
                    errorElement.style.display = 'none';
                }
                field.classList.remove('error', 'success');
                
                if (field.hasAttribute('required') && !field.value.trim()) {
                    isValid = false;
                    errorMessage = 'This field is required';
                } else {
                    // Field-specific validation
                    switch (fieldName) {
                        case 'name':
                            if (field.value.length < 2) {
                                isValid = false;
                                errorMessage = 'Name must be at least 2 characters long';
                            } else if (!field.value.match(/^[a-zA-Z\s'-]+$/)) {
                                isValid = false;
                                errorMessage = 'Name contains invalid characters';
                            }
                            break;
                        case 'dob':
                            const dob = new Date(field.value);
                            const today = new Date();
                            const age = today.getFullYear() - dob.getFullYear();
                            if (age < 0 || age > 18) {
                                isValid = false;
                                errorMessage = 'Student age must be between 0 and 18 years';
                            }
                            break;
                        case 'address':
                            if (field.value.length < 10) {
                                isValid = false;
                                errorMessage = 'Please provide a complete address';
                            }
                            break;
                    }
                }
                
                if (!isValid) {
                    if (errorElement) {
                        errorElement.textContent = errorMessage;
                        errorElement.style.display = 'flex';
                    }
                    field.classList.add('error');
                    validFields.delete(fieldName);
                } else {
                    field.classList.add('success');
                    validFields.add(fieldName);
                }
                
                updateProgress();
                return isValid;
            }
            
            function validateForm() {
                let isValid = true;
                requiredFields.forEach(fieldName => {
                    const field = document.getElementById(fieldName);
                    if (field && !validateField(field)) {
                        isValid = false;
                    }
                });
                return isValid;
            }
            
            function updateProgress() {
                const progress = (validFields.size / requiredFields.length) * 100;
                if (progressBar) {
                    progressBar.style.width = progress + '%';
                }
            }
            
            function detectChanges() {
                const currentData = new FormData(form);
                hasChanges = false;
                
                // Compare form data
                for (let [key, value] of currentData.entries()) {
                    if (originalData.get(key) !== value) {
                        hasChanges = true;
                        break;
                    }
                }
                
                // Show/hide changes indicator
                if (hasChanges) {
                    changesIndicator.classList.add('show');
                } else {
                    changesIndicator.classList.remove('show');
                }
            }
            
            function setupFileUpload(inputId, labelId, infoId, previewId, allowedTypes, maxSizeMB) {
                const input = document.getElementById(inputId);
                const label = document.getElementById(labelId);
                const info = document.getElementById(infoId);
                const preview = previewId ? document.getElementById(previewId) : null;
                
                // Drag and drop functionality
                label.addEventListener('dragover', (e) => {
                    e.preventDefault();
                    label.classList.add('dragover');
                });
                
                label.addEventListener('dragleave', () => {
                    label.classList.remove('dragover');
                });
                
                label.addEventListener('drop', (e) => {
                    e.preventDefault();
                    label.classList.remove('dragover');
                    const files = e.dataTransfer.files;
                    if (files.length > 0) {
                        input.files = files;
                        handleFileSelection(input, info, preview, allowedTypes, maxSizeMB);
                    }
                });
                
                input.addEventListener('change', () => {
                    handleFileSelection(input, info, preview, allowedTypes, maxSizeMB);
                });
            }
            
            function handleFileSelection(input, info, preview, allowedTypes, maxSizeMB) {
                const file = input.files[0];
                const errorElement = document.getElementById(input.id.replace('Input', 'Error'));
                
                if (!file) {
                    info.classList.remove('show');
                    if (errorElement) {
                        errorElement.style.display = 'none';
                    }
                    return;
                }
                
                // File size validation
                if (file.size > maxSizeMB * 1024 * 1024) {
                    showError(errorElement, `File size must be less than ${maxSizeMB}MB`);
                    input.value = '';
                    info.classList.remove('show');
                    return;
                }
                
                // File type validation
                const isValidType = allowedTypes.some(type => file.type === type);
                if (!isValidType) {
                    showError(errorElement, 'Invalid file type');
                    input.value = '';
                    info.classList.remove('show');
                    return;
                }
                
                // Show file info
                info.querySelector('.file-name').textContent = file.name;
                info.querySelector('.file-size').textContent = formatFileSize(file.size);
                info.classList.add('show');
                
                // Show preview for images
                if (preview && file.type.startsWith('image/')) {
                    const reader = new FileReader();
                    reader.onload = (e) => {
                        preview.src = e.target.result;
                    };
                    reader.readAsDataURL(file);
                }
                
                // Clear any previous errors
                if (errorElement) {
                    errorElement.style.display = 'none';
                }
                
                detectChanges();
            }
            
            function showError(errorElement, message) {
                if (errorElement) {
                    errorElement.textContent = message;
                    errorElement.style.display = 'flex';
                }
            }
            
            function formatFileSize(bytes) {
                if (bytes === 0) return '0 Bytes';
                const k = 1024;
                const sizes = ['Bytes', 'KB', 'MB', 'GB'];
                const i = Math.floor(Math.log(bytes) / Math.log(k));
                return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
            }
        });
        
        function removeFile(type) {
            const input = document.getElementById(type + 'Input');
            const info = document.getElementById(type + 'Info');
            const errorElement = document.getElementById(type + 'Error');
            
            input.value = '';
            info.classList.remove('show');
            if (errorElement) {
                errorElement.style.display = 'none';
            }
        }
        
        function toggleSidebar() {
            document.getElementById("sidebar").classList.toggle("show");
        }
    </script>
</body>
</html>