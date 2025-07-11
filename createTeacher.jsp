<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %> 
<%@ page import="kms.model.teacher" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Create Teacher Account - Al-Kauthar EduQids</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="stylesheet" href="css/createTeacher.css">
</head>
<body>
    <div class="mainContainer">
        <!-- Left Panel -->
        <div class="leftPanel">
            <div class="leftPanelContent">
                <img src="images/sign up.png" alt="Teachers joining Al-Kauthar EduQids" />
            </div>
        </div>

        <!-- Right Panel -->
        <div class="rightPanel">
            <div class="formHeader">
                <h2>Create Teacher Account</h2>
                <p>Fill in your details to join Al-Kauthar EduQids</p>
            </div>

            <div class="formContainer">
                <!-- Error Message Container -->
                <div id="errorMessage" class="messageContainer errorMessage" role="alert" aria-live="polite"></div>
                
                <!-- Success Message Container -->
                <div id="successMessage" class="messageContainer successMessage" role="alert" aria-live="polite"></div>

                <form id="teacherForm" action="CreateAccTController" method="post" >
                    <!-- Full Name -->
                    <div class="formGroup">
                        <label for="teacherName">
                            Full Name <span class="requiredField">*</span>
                        </label>
                        <input type="text" 
                               id="teacherName" 
                               name="name" 
                               class="inputField"
                               placeholder="Enter your full name" 
                               required 
                               autocomplete="name" 
                               maxlength="100"
                               aria-describedby="nameHelp">
                        <div id="nameHelp" class="sr-only">Enter your full legal name as it appears on official documents</div>
                    </div>

                    <!-- Email -->
                    <div class="formGroup">
                        <label for="teacherEmail">
                            Email Address <span class="requiredField">*</span>
                        </label>
                        <input type="email" 
                               id="teacherEmail" 
                               name="email" 
                               class="inputField"
                               placeholder="your.email@example.com" 
                               required 
                               autocomplete="email" 
                               maxlength="100"
                               aria-describedby="emailHelp">
                        <div id="emailHelp" class="sr-only">Enter a valid email address for account verification</div>
                    </div>

                    <!-- Role and Phone -->
                    <div class="formRow">
                        <div class="formGroup">
                            <label for="teacherRole">
                                Role <span class="requiredField">*</span>
                            </label>
                            <select id="teacherRole" 
                                    name="role" 
                                    class="selectField" 
                                    required
                                    aria-describedby="roleHelp">
                                <option value="">Select your role</option>
                                <option value="Teacher">Teacher</option>
                                <option value="Admin">Admin</option>
                            </select>
                            <div id="roleHelp" class="sr-only">Choose your role within the organization</div>
                        </div>

                        <div class="formGroup">
                            <label for="teacherPhone">
                                Phone Number <span class="requiredField">*</span>
                            </label>
                            <input type="tel" 
                                   id="teacherPhone" 
                                   name="phone" 
                                   class="inputField"
                                   placeholder="011-1234567" 
                                   maxlength="12" 
                                   required 
                                   autocomplete="tel"
                                   aria-describedby="phoneHelp">
                            <div id="phoneHelp" class="sr-only">Enter your phone number in format: 011-1234567</div>
                        </div>
                    </div>

                    <!-- Conditional Fields -->
                    <div class="formRow">
                        <!-- Teacher Type (shows when Teacher is selected) -->
                        <div id="teacherTypeGroup" class="formGroup conditionalField">
                            <label for="teacherType">
                                Teacher Type <span class="requiredField">*</span>
                            </label>
                            <select id="teacherType" 
                                    name="teacherType" 
                                    class="selectField"
                                    aria-describedby="typeHelp">
                                <option value="">Select type</option>
                                <option value="FullTime">Full-Time</option>
                                <option value="PartTime">Part-Time</option>
                            </select>
                            <div id="typeHelp" class="sr-only">Select your employment type</div>
                        </div>

                        <!-- Admin Assignment (optional) -->
                        <div id="adminGroup" class="formGroup conditionalField">
                            <label for="adminAssignment">Admin Assignment</label>
                            <select id="adminAssignment" 
                                    name="adminId" 
                                    class="selectField"
                                    aria-describedby="adminHelp">
                                <option value="">None</option>
                                <c:forEach var="admin" items="${adminList}">
                                    <option value="${admin.teacherId}">${admin.teacherName}</option>
                                </c:forEach>
                            </select>
                            <div id="adminHelp" class="sr-only">Optional: Select an admin to report to</div>
                        </div>
                    </div>

                    <!-- Password -->
                    <div class="formGroup">
                        <label for="teacherPassword">
                            Password <span class="requiredField">*</span>
                        </label>
                        <div class="passwordContainer">
                            <input type="password" 
                                   id="teacherPassword" 
                                   name="password" 
                                   class="inputField"
                                   placeholder="Create a strong password" 
                                   required 
                                   autocomplete="new-password"
                                   aria-describedby="passwordHelp passwordRequirements">
                            <div class="passwordStrengthIndicator">
                                <div id="passwordStrengthBar" class="passwordStrengthBar"></div>
                            </div>
                            <div id="passwordFeedback" class="passwordFeedbackText"></div>
                            <div id="passwordHelp" class="sr-only">Create a strong password with at least 8 characters</div>
                            <div id="passwordRequirements" class="passwordRequirements" aria-label="Password requirements">
                                <span id="reqLength" class="requirementItem">8+ chars</span>
                                <span id="reqUpper" class="requirementItem">Uppercase</span>
                                <span id="reqLower" class="requirementItem">Lowercase</span>
                                <span id="reqNumber" class="requirementItem">Number</span>
                                <span id="reqSymbol" class="requirementItem">Symbol</span>
                            </div>
                        </div>
                    </div>

                    <!-- Confirm Password -->
                    <div class="formGroup">
                        <label for="confirmPassword">
                            Confirm Password <span class="requiredField">*</span>
                        </label>
                        <input type="password" 
                               id="confirmPassword" 
                               name="confirmPassword" 
                               class="inputField"
                               placeholder="Confirm your password" 
                               required 
                               autocomplete="new-password"
                               aria-describedby="confirmHelp">
                        <div id="passwordMatchIndicator" class="passwordMatchIndicator" role="status" aria-live="polite"></div>
                        <div id="confirmHelp" class="sr-only">Re-enter your password to confirm</div>
                    </div>

                    <!-- Submit Button -->
                    <button type="submit" 
                            id="submitBtn" 
                            class="submitButton"
                            aria-describedby="submitHelp">
                        <span id="submitText">Create Account</span>
                    </button>
                    <div id="submitHelp" class="sr-only">Click to create your teacher account</div>

                    <!-- Login Link -->
                    <div class="loginLink">
                        Already have an account? <a href="login.jsp">Sign in here</a>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Success Modal -->
    <div id="successModal" class="modalOverlay" role="dialog" aria-labelledby="modalTitle" aria-describedby="modalDescription">
        <div class="modalContent">
            <div class="modalEmoji">🎉👨‍🏫👩‍🏫✨</div>
            <h2 id="modalTitle">Account Created!</h2>
            <p id="modalDescription">Welcome to Al-Kauthar EduQids 🎈<br>Your teaching journey begins here!</p>
            <button class="modalButton" onclick="closeModal()" aria-label="Close success message">Yay!</button>
        </div>
    </div>

    <!-- Load external JavaScript first -->
    <script src="createAcct.js"></script>
    
    <!-- Then check for success parameter AFTER the functions are loaded -->
    <c:if test="${param.success == 'true'}">
        <script>
            // Wait for the external JS to load completely, then show modal
            document.addEventListener('DOMContentLoaded', function() {
                setTimeout(function() {
                    console.log("Success parameter detected, showing modal");
                    if (typeof showSuccessModal === 'function') {
                        showSuccessModal();
                    } else {
                        console.error("showSuccessModal function not found");
                    }
                }, 100);
            });
        </script>
    </c:if>
</body>
</html>