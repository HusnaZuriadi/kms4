// ADD THIS AT THE TOP OF createAcct.js FILE (outside DOMContentLoaded)
function showSuccessModal() {
    console.log("showSuccessModal() called");
    
    const modal = document.getElementById('successModal');
    console.log("Modal element:", modal);
    
    if (modal) {
        console.log("Adding modalVisible class");
        modal.classList.add('modalVisible');
        
        // REMOVED: document.body.style.overflow = 'hidden'; // ← THIS WAS BLOCKING SCROLL!
        
        const modalButton = modal.querySelector('.modalButton');
        if (modalButton) {
            modalButton.focus();
            console.log("Modal button focused");
        }
        
        console.log("Modal should be visible now - scroll enabled");
    } else {
        console.error("Modal element not found in showSuccessModal()");
    }
}

function closeModal() {
    console.log("closeModal() called");
    const modal = document.getElementById('successModal');
    if (modal) {
        modal.classList.remove('modalVisible');
        
        // Ensure scroll is enabled (just in case)
        document.body.style.overflow = '';
        
        // Small delay for smooth transition
        setTimeout(function() {
            window.location.href = 'login.jsp';
        }, 300);
    }
}

// Debug functions for scroll testing
function testScroll() {
    console.log("=== TESTING SCROLL ===");
    console.log("Current scroll position:", window.scrollY);
    console.log("Page height:", document.documentElement.scrollHeight);
    console.log("Window height:", window.innerHeight);
    console.log("Can scroll:", document.documentElement.scrollHeight > window.innerHeight);
    
    // Try to scroll
    window.scrollTo(0, 300);
    setTimeout(() => {
        console.log("Scroll position after test:", window.scrollY);
        if (window.scrollY === 0 && document.documentElement.scrollHeight > window.innerHeight) {
            console.error("❌ SCROLL IS BLOCKED!");
            forceEnableScroll();
        } else {
            console.log("✅ Scroll is working!");
        }
    }, 100);
}

function forceEnableScroll() {
    console.log("🔧 FORCING SCROLL TO BE ENABLED");
    document.body.style.overflow = 'auto';
    document.body.style.height = 'auto';
    document.documentElement.style.overflow = 'auto';
    console.log("✅ Scroll force-enabled");
}

document.addEventListener('DOMContentLoaded', function() {
    // ========== CHECK FOR SUCCESS PARAMETER FIRST ==========
    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.get('success') === 'true') {
        console.log("🎉 Success parameter detected in URL - will show modal");
        setTimeout(function() {
            showSuccessModal();
        }, 500); // Wait for page to fully load
    }

    // ========== FORCE ENABLE SCROLL ==========
    forceEnableScroll();
    
    // Test scroll capability after page loads
    setTimeout(testScroll, 1000);

    // ========== EXISTING FORM CODE ==========
    const form = document.getElementById('teacherForm');
    const roleSelect = document.getElementById('teacherRole');
    const teacherTypeGroup = document.getElementById('teacherTypeGroup');
    const adminGroup = document.getElementById('adminGroup');
    const passwordInput = document.getElementById('teacherPassword');
    const confirmPasswordInput = document.getElementById('confirmPassword');
    const submitBtn = document.getElementById('submitBtn');
    const submitText = document.getElementById('submitText');

    document.getElementById('teacherName').focus();

    roleSelect.addEventListener('change', function() {
        const isTeacher = this.value === 'Teacher';
        const isAdmin = this.value === 'Admin';
        
        if (isTeacher) {
            teacherTypeGroup.classList.add('fieldVisible');
            adminGroup.classList.add('fieldVisible');
            document.getElementById('teacherType').required = true;
        } else {
            teacherTypeGroup.classList.remove('fieldVisible');
            adminGroup.classList.remove('fieldVisible');
            document.getElementById('teacherType').required = false;
            document.getElementById('teacherType').value = '';
            document.getElementById('adminAssignment').value = '';
        }
    });

    passwordInput.addEventListener('input', function() {
        checkPasswordStrength(this.value);
        validatePasswordMatch();
    });

    confirmPasswordInput.addEventListener('input', validatePasswordMatch);

    document.getElementById('teacherPhone').addEventListener('input', function(e) {
        let value = e.target.value.replace(/\D/g, '');
        if (value.length > 3 && value.length <= 7) {
            value = value.substring(0, 3) + '-' + value.substring(3);
        } else if (value.length > 7) {
            value = value.substring(0, 3) + '-' + value.substring(3, 7) + value.substring(7, 11);
        }
        e.target.value = value;
    });

    document.getElementById('teacherEmail').addEventListener('blur', function() {
        const email = this.value.trim();
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (email && !emailRegex.test(email)) {
            showFieldError(this, 'Please enter a valid email address');
        } else if (email) {
            clearFieldError(this);
        }
    });

    document.getElementById('teacherName').addEventListener('blur', function() {
        const name = this.value.trim();
        if (name && name.length < 2) {
            showFieldError(this, 'Name must be at least 2 characters');
        } else if (name) {
            clearFieldError(this);
        }
    });

    form.addEventListener('submit', function(e) {
        if (!validateForm()) {
            e.preventDefault(); // block submit jika ada error
            console.log("BLOCKED BY VALIDATION");
            return false;
        }

        console.log("SUBMITTING TO SERVER");
        
        // Show loading state
        submitBtn.disabled = true;
        submitText.textContent = 'Creating Account...';
        submitBtn.classList.add('buttonLoading');
    });

    function checkPasswordStrength(password) {
        const requirements = {
            length: password.length >= 8,
            upper: /[A-Z]/.test(password),
            lower: /[a-z]/.test(password),
            number: /\d/.test(password),
            symbol: /[!@#$%^&*(),.?":{}|<>]/.test(password)
        };

        Object.keys(requirements).forEach(req => {
            const element = document.getElementById(`req${req.charAt(0).toUpperCase() + req.slice(1)}`);
            if (element) {
                if (requirements[req]) {
                    element.classList.add('requirementMet');
                } else {
                    element.classList.remove('requirementMet');
                }
            }
        });

        const metRequirements = Object.values(requirements).filter(Boolean).length;
        const strengthBar = document.getElementById('passwordStrengthBar');
        const feedback = document.getElementById('passwordFeedback');

        let strength, message, width;

        if (password.length === 0) {
            strength = '';
            message = '';
            width = '0%';
        } else if (metRequirements < 3) {
            strength = 'Weak';
            message = 'Weak password';
            width = '33%';
        } else if (metRequirements < 5) {
            strength = 'Medium';
            message = 'Good password';
            width = '66%';
        } else {
            strength = 'Strong';
            message = 'Strong password';
            width = '100%';
        }

        if (strengthBar) {
            strengthBar.className = `passwordStrengthBar strength${strength}`;
            strengthBar.style.width = width;
        }

        if (feedback) {
            feedback.textContent = message;
            feedback.style.color = strength === 'Strong' ? '#27ae60' : 
                                  strength === 'Medium' ? '#f39c12' : '#e74c3c';
        }
    }

    function validatePasswordMatch() {
        const password = passwordInput.value;
        const confirmPassword = confirmPasswordInput.value;
        const matchIndicator = document.getElementById('passwordMatchIndicator');

        if (!matchIndicator) return;

        if (confirmPassword) {
            matchIndicator.classList.add('indicatorVisible');
            if (password === confirmPassword) {
                confirmPasswordInput.setCustomValidity('');
                matchIndicator.className = 'passwordMatchIndicator indicatorVisible matchSuccess';
                matchIndicator.innerHTML = '<i class="fas fa-check-circle"></i> Passwords match';
            } else {
                confirmPasswordInput.setCustomValidity('Passwords do not match');
                matchIndicator.className = 'passwordMatchIndicator indicatorVisible matchError';
                matchIndicator.innerHTML = '<i class="fas fa-times-circle"></i> Passwords do not match';
            }
        } else {
            matchIndicator.classList.remove('indicatorVisible');
            matchIndicator.innerHTML = '';
        }
    }

    function validateForm() {
        const requiredFields = form.querySelectorAll('[required]');
        let isValid = true;
        let firstErrorField = null;

        hideError();

        requiredFields.forEach(field => {
            const value = field.value.trim();
            if (!value) {
                isValid = false;
                field.style.borderColor = '#e74c3c';
                showFieldError(field, 'This field is required');
                if (!firstErrorField) firstErrorField = field;
            } else {
                field.style.borderColor = '#27ae60';
                clearFieldError(field);
            }
        });

        const emailField = document.getElementById('teacherEmail');
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (emailField.value && !emailRegex.test(emailField.value)) {
            isValid = false;
            showFieldError(emailField, 'Please enter a valid email address');
            if (!firstErrorField) firstErrorField = emailField;
        }

        const password = passwordInput.value;
        const requirements = {
            length: password.length >= 8,
            upper: /[A-Z]/.test(password),
            lower: /[a-z]/.test(password),
            number: /\d/.test(password),
            symbol: /[!@#$%^&*(),.?":{}|<>]/.test(password)
        };

        const metCount = Object.values(requirements).filter(Boolean).length;
        if (metCount < 4) {
            isValid = false;
            showError('Password does not meet minimum requirements (at least 4 criteria)');
            if (!firstErrorField) firstErrorField = passwordInput;
        }

        if (passwordInput.value !== confirmPasswordInput.value) {
            isValid = false;
            showError('Passwords do not match');
            if (!firstErrorField) firstErrorField = confirmPasswordInput;
        }

        if (!isValid && firstErrorField) {
            firstErrorField.focus();
        }

        return isValid;
    }

    function showFieldError(field, message) {
        clearFieldError(field);
        const errorDiv = document.createElement('div');
        errorDiv.className = 'fieldError';
        errorDiv.textContent = message;
        errorDiv.setAttribute('role', 'alert');
        field.parentNode.insertBefore(errorDiv, field.nextSibling);
        field.style.borderColor = '#e74c3c';
        field.setAttribute('aria-invalid', 'true');
    }

    function clearFieldError(field) {
        const errorDiv = field.parentNode.querySelector('.fieldError');
        if (errorDiv) errorDiv.remove();
        field.style.borderColor = '';
        field.removeAttribute('aria-invalid');
    }

    function showError(message) {
        const errorDiv = document.getElementById('errorMessage');
        if (errorDiv) {
            errorDiv.textContent = message;
            errorDiv.classList.add('messageVisible');
            errorDiv.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
        }
    }

    function hideError() {
        const errorDiv = document.getElementById('errorMessage');
        if (errorDiv) errorDiv.classList.remove('messageVisible');
    }
});

// Additional helper functions that can be called from browser console for debugging
window.debugScroll = function() {
    console.log("=== SCROLL DEBUG INFO ===");
    console.log("Body overflow:", window.getComputedStyle(document.body).overflowY);
    console.log("HTML overflow:", window.getComputedStyle(document.documentElement).overflowY);
    console.log("Current scroll:", window.scrollY);
    console.log("Max scroll:", document.documentElement.scrollHeight - window.innerHeight);
    testScroll();
};

window.forceScroll = forceEnableScroll;