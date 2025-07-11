document.addEventListener('DOMContentLoaded', function () {

    // Sidebar toggle
    function toggleSidebar() {
        document.getElementById("sidebar").classList.toggle("show");
    }
    window.toggleSidebar = toggleSidebar;

    document.addEventListener('click', function (event) {
        const sidebar = document.getElementById('sidebar');
        const navButton = document.querySelector('.navSidebar');
        if (sidebar && navButton && !sidebar.contains(event.target) && !navButton.contains(event.target)) {
            sidebar.classList.remove('show');
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

	    let age = today.getFullYear() - dob.getFullYear(); // Kira ikut tahun sahaja

	    document.getElementById("age").value = age;
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

    form.addEventListener('submit', function (e) {
        const submitBtn = document.getElementById('submitBtn');
        if (submitBtn) {
            submitBtn.disabled = true;
            submitBtn.classList.add('loading');
            submitBtn.innerText = 'Registering Student...';
        }
    });

    updateProgress();
});
