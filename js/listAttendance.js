// Initialize
        document.addEventListener('DOMContentLoaded', function() {
            setupSearch();
            setupKeyboardShortcuts();
            animateOnLoad();
        });

        // Sidebar functionality
        function toggleSidebar() {
            const sidebar = document.getElementById('sidebar');
            const overlay = document.getElementById('sidebarOverlay');
            
            sidebar.classList.toggle('open');
            overlay.classList.toggle('open');
        }

        // Search functionality
        function setupSearch() {
            const searchInput = document.getElementById('searchInput');
            const clearBtn = document.getElementById('clearBtn');
            const dateFilter = document.getElementById('dateFilter');
            
            let searchTimeout;
            
            // Name search with debouncing
            searchInput.addEventListener('input', function() {
                clearTimeout(searchTimeout);
                
                // Show/hide clear button if any field has content
                updateClearButton();
                
                // Debounced search (client-side filtering for immediate feedback)
                searchTimeout = setTimeout(() => {
                    performClientSearch();
                }, 300);
            });

            // Date filter change
            dateFilter.addEventListener('change', function() {
                updateClearButton();
                performClientSearch();
            });

            // Focus enhancement
            searchInput.addEventListener('focus', function() {
                this.parentElement.style.transform = 'scale(1.02)';
            });

            searchInput.addEventListener('blur', function() {
                this.parentElement.style.transform = 'scale(1)';
            });

            // Initialize if there are existing filters
            if (searchInput.value || dateFilter.value) {
                updateClearButton();
                performClientSearch();
            }
        }

        function updateClearButton() {
            const searchInput = document.getElementById('searchInput');
            const dateFilter = document.getElementById('dateFilter');
            const clearBtn = document.getElementById('clearBtn');
            
            if (searchInput.value.length > 0 || dateFilter.value) {
                clearBtn.classList.add('show');
            } else {
                clearBtn.classList.remove('show');
            }
        }

		function performClientSearch() {
		    const searchTerm = document.getElementById('searchInput').value.toLowerCase().trim();
		    const selectedDate = document.getElementById('dateFilter').value;
		    const rows = document.querySelectorAll('.table-row');
		    let visibleCount = 0;

		    rows.forEach((row, index) => {
		        const studentName = row.querySelector('.student-name').textContent.toLowerCase();
		        
		        // Guna data-date attribute yang memang dalam format yyyy-MM-dd
		        const dateCell = row.querySelector('.attendance-date');
		        const rowDate = dateCell.getAttribute('data-date'); 

		        // Semak sama ada nama pelajar padan dan tarikh padan
		        const matchesSearch = searchTerm === '' || studentName.includes(searchTerm);
		        const matchesDate = selectedDate === '' || rowDate === selectedDate;

		        if (matchesSearch && matchesDate) {
		            row.style.display = '';
		            row.style.animation = `fadeInUp 0.3s ease-out ${index * 0.05}s both`;
		            visibleCount++;

		            // Highlight nama pelajar
		            if (searchTerm !== '' && matchesSearch) {
		                highlightSearchTerm(row.querySelector('.student-name'), searchTerm);
		            } else {
		                removeHighlight(row.querySelector('.student-name'));
		            }
		        } else {
		            row.style.display = 'none';
		        }
		    });

		    updateSearchResults(visibleCount);
		}

        function applyFilters() {
            // For server-side filtering, submit the form
            document.getElementById('searchForm').submit();
        }

      

        function clearAllFilters() {
            document.getElementById('searchInput').value = '';
            document.getElementById('dateFilter').value = '';
            document.getElementById('clearBtn').classList.remove('show');
            
           
            
            // Show all rows
            document.querySelectorAll('.table-row').forEach(row => {
                row.style.display = '';
                removeHighlight(row.querySelector('.student-name'));
            });
            
            updateSearchResults(document.querySelectorAll('.table-row').length);
            document.getElementById('searchInput').focus();
        }

        function highlightSearchTerm(element, searchTerm) {
            const originalText = element.getAttribute('data-original') || element.textContent;
            element.setAttribute('data-original', originalText);
            
            const regex = new RegExp(`(${searchTerm})`, 'gi');
            const highlightedText = originalText.replace(regex, '<span class="search-highlight">$1</span>');
            element.innerHTML = highlightedText;
        }

        function removeHighlight(element) {
            const originalText = element.getAttribute('data-original');
            if (originalText) {
                element.textContent = originalText;
                element.removeAttribute('data-original');
            }
        }

        function updateSearchResults(count) {
            const searchTerm = document.getElementById('searchInput').value;
            const selectedDate = document.getElementById('dateFilter').value;
            const countElement = document.getElementById('searchResultsCount');
            
            let message = `Found ${count} record${count != 1 ? 's' : ''}`;
            
            if (searchTerm && selectedDate) {
                message += ` for "${searchTerm}" on ${formatDisplayDate(selectedDate)}`;
            } else if (searchTerm) {
                message += ` matching "${searchTerm}"`;
            } else if (selectedDate) {
                message += ` on ${formatDisplayDate(selectedDate)}`;
            } else {
                message = `Showing ${count} attendance record${count != 1 ? 's' : ''}`;
            }
            
            countElement.textContent = message;
        }

        function formatDisplayDate(dateString) {
            if (!dateString) return '';
            const date = new Date(dateString + 'T00:00:00');
            return date.toLocaleDateString('en-US', { 
                year: 'numeric', 
                month: 'short', 
                day: 'numeric' 
            });
        }

        function setupKeyboardShortcuts() {
            document.addEventListener('keydown', function(event) {
                // Ctrl+K to focus search
                if (event.ctrlKey && event.key === 'k') {
                    event.preventDefault();
                    document.getElementById('searchInput').focus();
                }
                
                // Escape to clear search or close sidebar
                if (event.key === 'Escape') {
                    const searchInput = document.getElementById('searchInput');
                    if (searchInput === document.activeElement && searchInput.value) {
                        clearSearch();
                    } else {
                        const sidebar = document.getElementById('sidebar');
                        if (sidebar.classList.contains('open')) {
                            toggleSidebar();
                        }
                    }
                }
            });
        }

        

        function confirmDelete(attendanceId) {
            if (!attendanceId || attendanceId === "undefined") {
                showNotification("Invalid attendance ID", "error");
                return;
            }

            if (confirm("Are you sure you want to delete this attendance record?\n\nThis action cannot be undone.")) {
                const deleteBtn = event.target.closest('.action-btn');
                deleteBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i>';
                deleteBtn.disabled = true;
                
                showNotification("Deleting record...", "info");
                
                setTimeout(() => {
                    location.href = 'DeleteAttendanceController?attendanceId=' + attendanceId;
                }, 500);
            }
        }

        function showNotification(message, type) {
            // Remove existing notifications
            document.querySelectorAll('.notification').forEach(notif => {
                notif.remove();
            });
            
            const notification = document.createElement('div');
            notification.className = 'notification';
            notification.style.cssText = `
                position: fixed;
                top: 2rem;
                right: 2rem;
                padding: 1rem 1.5rem;
                border-radius: var(--border-radius);
                color: white;
                font-weight: 600;
                z-index: 1000;
                transform: translateX(100%);
                transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                box-shadow: var(--shadow-xl);
                backdrop-filter: blur(10px);
            `;
            
            const colors = {
                success: 'linear-gradient(135deg, #10b981 0%, #059669 100%)',
                error: 'linear-gradient(135deg, #ef4444 0%, #dc2626 100%)',
                info: 'linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%)'
            };
            
            notification.style.background = colors[type] || colors.info;
            
            const icons = {
                success: 'fas fa-check-circle',
                error: 'fas fa-exclamation-circle',
                info: 'fas fa-info-circle'
            };
            
            notification.innerHTML = `
                <i class="${icons[type] || icons.info}" style="margin-right: 0.5rem;"></i>
                ${message}
            `;
            
            document.body.appendChild(notification);
            
            setTimeout(() => {
                notification.style.transform = 'translateX(0)';
            }, 100);
            
            setTimeout(() => {
                notification.style.transform = 'translateX(100%)';
                setTimeout(() => {
                    if (notification.parentNode) {
                        notification.parentNode.removeChild(notification);
                    }
                }, 300);
            }, 3000);
        }

        function animateOnLoad() {
            const rows = document.querySelectorAll('.table-row');
            rows.forEach((row, index) => {
                row.style.animation = `fadeInUp 0.3s ease-out ${index * 0.05}s both`;
            });
        }

        // Close sidebar when clicking outside
        document.addEventListener('click', function(event) {
            const sidebar = document.getElementById('sidebar');
            const menuToggle = document.querySelector('.menu-toggle');
            
            if (!sidebar.contains(event.target) && !menuToggle.contains(event.target)) {
                sidebar.classList.remove('open');
                document.getElementById('sidebarOverlay').classList.remove('open');
            }
        });
